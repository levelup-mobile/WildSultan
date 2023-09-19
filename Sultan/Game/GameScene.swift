
import SpriteKit
import SwiftUI


enum Movement {
    case left, right, stop
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let joystickBase = SKSpriteNode(imageNamed: "joystickBase")
    let joystickKnob = SKSpriteNode(imageNamed: "joystickKnob")
    
    let maxHeroSpeed: CGFloat = 5.0
    var buildings = 0
    
    var touch: UITouch?
    
    var angle: CGFloat? = .pi
    
    var gameDelegate: GameViewController?
    
    func startWalkingAnimation() {
        guard let hero = childNode(contains: "hero") else { return }
        if !hero.hasActions() {
            let heroNum = UserSavingsService.shared.hero
            let walkFrames: [SKTexture] = [
                .init(imageNamed: "hero-\(heroNum)-1"),
                .init(imageNamed: "hero-\(heroNum)-2"),
                .init(imageNamed: "hero-\(heroNum)-3"),
                .init(imageNamed: "hero-\(heroNum)-4")
            ]
            hero.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.1, resize: false, restore: true)))
        }
    }
    
    func stopWalkingAnimation() {
        guard let hero = childNode(contains: "hero") else { return }
        hero.removeAllActions()
    }
    
    let padding: CGFloat = 10.0
    
    var buildPhysicsBody: SKPhysicsBody? = nil
    
    let enemyCategory: UInt32 = 5
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        isPaused = true
        joystickBase.size = CGSize(width: 120, height: 120)
        joystickKnob.size = .init(width: 50, height: 50)
        joystickBase.position = CGPoint(x: -frame.width / 2 + 150, y: -frame.height / 2 + 150)
        joystickKnob.position = joystickBase.position
        joystickKnob.zPosition = 100
        joystickBase.zPosition = 100
        camera?.addChild(joystickBase)
        camera?.addChild(joystickKnob)
        
        guard let hero = childNode(contains: "hero") as? SKSpriteNode else { return }
        hero.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero)-1")
        
        let arr = children.filter { $0.name == "castle-enemy"}.shuffled()
        let ph = childNode(withName: "castle")?.physicsBody
        arr.filter { $0.name == "castle-enemy"}.shuffled().compactMap { i -> SKSpriteNode? in
            i.isHidden = true
            guard let node = i as? SKSpriteNode, let texture = node.texture, let ph = ph else { return nil }
            node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
            node.physicsBody?.categoryBitMask = ph.categoryBitMask
            node.physicsBody?.collisionBitMask = ph.collisionBitMask
            node.physicsBody?.contactTestBitMask = ph.contactTestBitMask
            node.physicsBody?.affectedByGravity = ph.affectedByGravity
            node.physicsBody?.allowsRotation = ph.allowsRotation
            node.physicsBody?.isDynamic = ph.isDynamic
            node.physicsBody?.pinned = ph.pinned
            return node
        }.prefix(3).forEach {
            $0.isHidden = false
        }
        
        let castle = childNode(withName: "castle")
        castle?.children.filter { $0.name == "build"}.forEach {
            buildPhysicsBody = $0.physicsBody
            $0.isHidden = true
            $0.physicsBody = nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let camera = camera else { return }
        let locationInScene = touches.first!.location(in: self)
        let location = camera.convert(locationInScene, from: self)
        
        if joystickBase.frame.contains(location) {
            touch = touches.first
        }
        
        nodes(at: locationInScene).first {
            $0.name == "buttonSuperspell"
        }.flatMap { node in
            createSuperspell()
            node.run(.sequence([.fadeAlpha(to: 0.5, duration: 0.1), .fadeAlpha(to: 1.0, duration: 0.1)]))
        }
        nodes(at: locationInScene).first {
            $0.name == "buttonBomb"
        }.flatMap { node in
            createBomb()
            node.run(.sequence([.fadeAlpha(to: 0.5, duration: 0.1), .fadeAlpha(to: 1.0, duration: 0.1)]))
        }
    }
    
    func createSuperspell() {
        if let bombs = gameDelegate?.shopViewModel.bombs, bombs > 0 {
            print("superspell")
            gameDelegate?.shopViewModel.bombs -= 1
            let bomb = SKSpriteNode(imageNamed: "superspell")
            bomb.size = .init(width: 35, height: 35)
            bomb.name = "superspell"
            makeBomb(bomb: bomb)
        }
    }
    
    let bombCategory: UInt32 = 7
    func createBomb() {
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.size = .init(width: 35, height: 35)
        bomb.name = "bomb"
        makeBomb(bomb: bomb)
    }
    
    func makeBomb(bomb: SKSpriteNode) {
        guard let angle = angle, let hero = childNode(withName: "hero") else { return }
        bomb.size = .init(width: 35, height: 35)
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width / 2)
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = obstacleCategory
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.collisionBitMask = 0
        bomb.physicsBody?.linearDamping = 1.0
        bomb.position = hero.position
        let speed: CGFloat = 800
        let xVelocity = speed * cos(angle)
        let yVelocity = speed * sin(angle)
        bomb.physicsBody?.velocity = CGVector(dx: xVelocity, dy: yVelocity)
        
        addChild(bomb)
      
        let delay = SKAction.wait(forDuration: 1.2)
        bomb.run(delay) {
            self.explose(bomb: bomb)
        }
    }
    
    func explose(bomb: SKSpriteNode) {
        bomb.physicsBody = nil
        bomb.removeFromParent()
        let particleEmitter = SKEmitterNode(fileNamed: "Fire")
        particleEmitter?.position = bomb.position
        guard let particleEmitter = particleEmitter else { return }
        self.addChild(particleEmitter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            particleEmitter.removeFromParent()
        }
    }
    
    func showBuildings(buildings: Int) {
        guard let castle = childNode(withName: "castle") as? Castle else { return }
        castle.children.filter { $0.name == "build" }.compactMap { $0 as? SKSpriteNode }.reversed().enumerated().forEach {
            $0.element.physicsBody = nil
            if $0.offset < buildings {
                $0.element.isHidden = false
                createPhysicsBodyForBuild(build: $0.element)
            }
        }
        castle.hp = 100 + buildings * 10
    }
    
    func createPhysicsBodyForBuild(build: SKSpriteNode) {
        guard let ph = buildPhysicsBody else { return }
        build.physicsBody = SKPhysicsBody(rectangleOf: build.size)
        build.physicsBody?.categoryBitMask = ph.categoryBitMask
        build.physicsBody?.collisionBitMask = ph.collisionBitMask
        build.physicsBody?.contactTestBitMask = ph.contactTestBitMask
        build.physicsBody?.affectedByGravity = ph.affectedByGravity
        build.physicsBody?.allowsRotation = ph.allowsRotation
    }
    
    func showHP(hp: Int) {
        guard let castle = childNode(withName: "castle") as? Castle else { return }
        castle.hp = hp
        
        guard let hpBar = castle.childNode(withName: "hp") as? SKSpriteNode else { return }
        let healthPercentage = Double(hp) / Double(castle.maxHealth)
        let newWidth = hpBar.size.width * healthPercentage
        print(hp, healthPercentage)
        hpBar.size = CGSize(width: newWidth, height: hpBar.size.height)
    }
    
    func showSuperspells(spells: Int) {
        guard let label = camera?.childNode(withName: "superspellLabel") as? SKLabelNode else { return }
        label.text = "x\(spells)"
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touch, let camera = camera else {
            return
        }
        
        let locationInScene = touch.location(in: self)
        let position = camera.convert(locationInScene, from: self)
        
        let distance = joystickBase.position.distance(to: position)
        angle = joystickBase.position.angle(to: position)
        
        if distance < joystickBase.size.width / 2 {
            joystickKnob.position = position
        } else {
            guard let angle = angle else { return }
            joystickKnob.position = CGPoint(x: cos(angle) * (joystickBase.size.width / 2) + joystickBase.position.x,
                                            y: sin(angle) * (joystickBase.size.width / 2) + joystickBase.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touch == touches.first {
            stopMovement()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let dx = joystickKnob.position.x - joystickBase.position.x
        let dy = joystickKnob.position.y - joystickBase.position.y
        
        let angle = atan2(dy, dx)
        
        let aliveCastles = children.compactMap({ $0 as? CastleEnemy }).filter({ $0.name == "castle-enemy" && $0.texture != nil && $0.isHidden == false })
        
        aliveCastles.forEach {
            $0.update(currentTime)
        }
        
        guard let hero = childNode(withName: "hero"), touch != nil else {
            stopWalkingAnimation()
            return
        }
        
        startWalkingAnimation()
        let distance = sqrt(dx*dx + dy*dy)
        let distanceRatio = min(distance / (joystickBase.size.width * 0.5), 1.0)
        
        let potentialNewPosition = CGPoint(x: hero.position.x + cos(angle) * maxHeroSpeed * distanceRatio, y: hero.position.y + sin(angle) * maxHeroSpeed * distanceRatio)
        
        guard let map = childNode(withName: "map") as? SKSpriteNode, let camera = camera else { return }
        if map.contains(potentialNewPosition) {
            hero.position = potentialNewPosition
        }
        
        camera.position = hero.position
        let clampedX = min(max(camera.position.x, map.frame.minX + size.width/2), map.frame.maxX - size.width/2)
        let clampedY = min(max(camera.position.y, map.frame.minY + size.height/2), map.frame.maxY - size.height/2)
        camera.position = CGPoint(x: clampedX, y: clampedY)
        
        if aliveCastles.count <= 0 {
            gameDelegate?.finishGame(isWin: .win)
        }
    }
    
    let heroCategory: UInt32 = 3
    let obstacleCategory: UInt32 = 1
    
    func stopMovement() {
        joystickKnob.run(SKAction.move(to: joystickBase.position, duration: 0.2))
        touch = nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        print(bodyA.node?.name, bodyB.node?.name)
        if bodyA.categoryBitMask == heroCategory || bodyB.categoryBitMask == heroCategory {
            if bodyB.categoryBitMask == obstacleCategory || bodyA.categoryBitMask == obstacleCategory {
                stopMovement()
                print("stop")
            }
            if bodyA.categoryBitMask == bombCategory || bodyB.categoryBitMask == bombCategory {
                let node = bodyA.categoryBitMask == bombCategory ? bodyA.node : bodyB.node
                let hero = (bodyA.categoryBitMask == heroCategory ? bodyA.node : bodyB.node) as? Hero
                guard let bomb = node as? SKSpriteNode, let hero = hero else { return }
                if node?.name == "bomb-enemy" {
                    explose(bomb: bomb)
                    hero.hp -= 10
                    guard let hpBar = hero.childNode(withName: "hp") as? SKSpriteNode, let hpBarBackground = hero.childNode(withName: "background") as? SKSpriteNode else { return }
                    let healthPercentage = Double(hero.hp) / Double(100)
                    let newWidth = max(0, hpBarBackground.size.width * healthPercentage)
                    hpBar.size = CGSize(width: newWidth, height: hpBar.size.height)
                }
            }
        }
        if bodyA.categoryBitMask == obstacleCategory || bodyB.categoryBitMask == obstacleCategory {
            if bodyB.categoryBitMask == bombCategory || bodyB.categoryBitMask == bombCategory {
                let node = bodyA.categoryBitMask == bombCategory ? bodyA.node : bodyB.node
                let castle = bodyA.categoryBitMask == obstacleCategory ? bodyA.node : bodyB.node
                guard let bomb = node as? SKSpriteNode, let castle = castle as? Castle else { return }
                
                if castle.name == "castle-enemy" && bomb.name == "bomb" {
                    explose(bomb: bomb)
                    castle.hp -= bomb.name == "bomb" ? 20 : 51
                    guard let hpBar = castle.childNode(withName: "hp") as? SKSpriteNode, let hpBarBackground = castle.childNode(withName: "background") as? SKSpriteNode else { return }
                    let healthPercentage = Double(castle.hp) / Double(castle.maxHealth)
                    print(healthPercentage)
                    let newWidth = max(0, hpBarBackground.size.width * healthPercentage)
                    hpBar.size = CGSize(width: newWidth, height: hpBar.size.height)
                }
                if castle.name == "castle" && bomb.name == "bomb-enemy" {
                    explose(bomb: bomb)
                    castle.hp -= 10
                    guard let hpBar = castle.childNode(withName: "hp") as? SKSpriteNode, let hpBarBackground = castle.childNode(withName: "background") as? SKSpriteNode else { return }
                    let healthPercentage = Double(castle.hp) / Double(castle.maxHealth)
                    print(healthPercentage)
                    let newWidth = max(0, hpBarBackground.size.width * healthPercentage)
                    hpBar.size = CGSize(width: newWidth, height: hpBar.size.height)
                }
            }
        }
        if bodyB.categoryBitMask == bombCategory || bodyB.categoryBitMask == bombCategory {
            if bodyA.categoryBitMask == enemyCategory || bodyB.categoryBitMask == enemyCategory {
                let node = bodyA.categoryBitMask == bombCategory ? bodyA.node : bodyB.node
                let enemy = bodyA.categoryBitMask == enemyCategory ? bodyA.node : bodyB.node
                if node?.name == "bomb" {
                    guard let bomb = node as? SKSpriteNode, let enemy = enemy as? SKSpriteNode else { return }
                    explose(bomb: bomb)
                    enemy.removeFromParent()
                }
            }
        }
    }
}

extension CGPoint {
    func angle(to point: CGPoint) -> CGFloat {
        return atan2(point.y - y, point.x - x)
    }
    
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}

extension CGVector {
    func length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
}

extension SKNode {
    func childNode(contains: String) -> SKNode? {
        return children.first {
            $0.name?.contains(contains) ?? false
        }
    }
}
