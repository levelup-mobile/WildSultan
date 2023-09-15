
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
        let removeBomb = SKAction.removeFromParent()
        let sequence = SKAction.sequence([delay, removeBomb])
        bomb.run(sequence)
    }
    
    func showBuildings(buildings: Int) {
        guard let castle = childNode(withName: "castle") as? Castle else { return }
        castle.children.filter { $0.name == "build" }.reversed().enumerated().forEach {
            if $0.offset < buildings {
                $0.element.alpha = 1
            }
        }
        castle.hp = 100 + buildings * 10
    }
    
    func showHP(hp: Int) {
        guard let castle = childNode(withName: "castle") as? Castle else { return }
        castle.hp = hp
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
    }
    
    let heroCategory: UInt32 = 3
    let obstacleCategory: UInt32 = 1
    
    func stopMovement() {
        joystickKnob.run(SKAction.move(to: joystickBase.position, duration: 0.2))
        touch = nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact)
        if contact.bodyA.categoryBitMask == heroCategory || contact.bodyB.categoryBitMask == heroCategory {
            print("here")
            stopMovement()
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
