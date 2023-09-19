//
//  Castle.swift
//  Sultan
//
//  Created by Pfriedrix on 14.09.2023.
//

import SpriteKit

class Castle: SKSpriteNode {
    var hp = 100 {
        didSet {
            if hp < 0 {
                texture = nil
                color = .clear
                physicsBody = nil
                children.filter { $0.name == "background" || $0.name == "fill" || $0.name == "defender" }.forEach { $0.removeFromParent() }
                if name == "castle" {
                    let scene = scene as? GameScene
                    scene?.isPaused = true
                    scene?.gameDelegate?.finishGame(isWin: .lose)
                }
            }
        }
    }
    
    var maxHealth: Int {
        children.filter { $0.name == "build" && $0.isHidden == false }.count * 10 + 100
    }
}

class CastleEnemy: Castle {
    var defenders = [SKSpriteNode]()
    var attackers = [SKSpriteNode]()
    
    let enemyCategory: UInt32 = 5
    func generateDefender() {
        let activeDefenders = children.filter { $0.name == "defender" }.compactMap { $0 as? SKSpriteNode }
        guard activeDefenders.count < UserSavingsService.shared.level, defenders.count < 10 else { return }
        let defender = SKSpriteNode(texture: SKTexture(imageNamed: "defender-1"), size: .init(width: 80, height: 115))
        defender.setScale(0.1)
        addChild(defender)
        defender.name = "defender"
        makeAnimation(node: defender)
        let angle = Double.random(in: 0...CGFloat.pi * 2)
        let distance = 200.0
        let xComponent = cos(angle) * distance
        let yComponent = sin(angle) * distance
        let randomDirection = CGVector(dx: xComponent, dy: yComponent)
        
        defender.physicsBody = SKPhysicsBody(rectangleOf: defender.size)
        defender.physicsBody?.categoryBitMask = enemyCategory
        defender.physicsBody?.contactTestBitMask = bombCategory
        defender.physicsBody?.affectedByGravity = false
        defender.physicsBody?.allowsRotation = false
        defender.physicsBody?.isDynamic = false

        defender.run(.group([.move(by: randomDirection, duration: 0.4), .scale(to: 1.0, duration: 0.4)])) {
            let radius: CGFloat = 200
            let duration: TimeInterval = 10.0
            let angularSpeed: CGFloat = .pi * 2.0 / duration
            
            let circularMotionAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in

                let angle = angularSpeed * elapsedTime
    
                let x = radius * cos(angle)
                let y = radius * sin(angle)
                
                node.position = CGPoint(x: x, y: y)
            }
            
            defender.run(.repeatForever(circularMotionAction))
        }
        
        defenders.append(defender)
    }
    
    func generateAttacker() {
        guard let scene = scene else { return }
        let activeAttackrs = children.filter { $0.name == "attacker" }.compactMap { $0 as? SKSpriteNode }
        guard activeAttackrs.count < UserSavingsService.shared.level, attackers.count < 10, let castle = scene.childNode(withName: "castle") else { return }
        let attacker = SKSpriteNode(texture: SKTexture(imageNamed: "attacker-1"), size: .init(width: 80, height: 115))
        attacker.setScale(0.1)
        addChild(attacker)
        attacker.name = "attacker"
        makeAnimation(node: attacker)
        attacker.physicsBody = SKPhysicsBody(rectangleOf: attacker.size)
        attacker.physicsBody?.categoryBitMask = enemyCategory
        attacker.physicsBody?.contactTestBitMask = bombCategory
        attacker.physicsBody?.affectedByGravity = false
        attacker.physicsBody?.allowsRotation = false
        attacker.physicsBody?.isDynamic = false
        let dx = castle.position.x - position.x
        let dy = castle.position.y - position.y
        let distance = sqrt(dx*dx + dy*dy)
        let angle = atan2(dy, dx)
        var xVelocity = distance * cos(angle)
        var yVelocity = distance * sin(angle)
        let cutLength: CGFloat = 200.0
        if distance > cutLength {
            let scaleFactor = (distance - cutLength) / distance
            xVelocity *= scaleFactor
            yVelocity *= scaleFactor
        }
        let speed = 120.0
        let duration = distance / speed
        attacker.run(.group([.move(by: .init(dx: xVelocity, dy: yVelocity), duration: duration), .scale(to: 1.0, duration: 0.4)])) {
        }
        attackers.append(attacker)
    }
    
    private func makeAnimation(node: SKSpriteNode) {
        guard let name = node.name else { return }
        print(name)
        let walkFrames: [SKTexture] = [
            .init(imageNamed: "\(name)-1"),
            .init(imageNamed: "\(name)-2"),
            .init(imageNamed: "\(name)-3"),
        ]
        node.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.2, resize: false, restore: true)))
    }
    
    func update(_ currentTime: TimeInterval) {
        generateDefender()
        generateAttacker()
        if currentTime.truncatingRemainder(dividingBy: 2) <= 0.01 {
            checkCanBomb()
        }
        if currentTime.truncatingRemainder(dividingBy: 4) <= 0.01 {
            guard let scene = scene, let castle = scene.childNode(withName: "castle") as? SKSpriteNode else { return }
            let activeAttackers = children.filter { $0.name == "attacker" }.compactMap { $0 as? SKSpriteNode }
            activeAttackers.forEach { att in
                let position = convert(att.position, to: scene)
                let dx = castle.position.x - position.x
                let dy = castle.position.y - position.y
                let distance = sqrt(dx*dx + dy*dy)
                if distance <= 250 {
                    let angle = atan2(dy, dx)
                    createBomb(from: position, by: angle)
                }
            }
        }
    }
    
    func checkCanBomb() {
        guard let scene = scene, let hero = scene.childNode(withName: "hero") else { return }
        let activeDefenders = children.filter { $0.name == "defender" }.compactMap { $0 as? SKSpriteNode }
        activeDefenders.forEach { def in
            let position = convert(def.position, to: scene)
            let dx = hero.position.x - position.x
            let dy = hero.position.y - position.y
            let distance = sqrt(dx*dx + dy*dy)
            if distance <= 350 {
                let angle = atan2(dy, dx)
                createBomb(from: position, by: angle)
            }
        }
    }
    
    let heroCategory: UInt32 = 3
    let bombCategory: UInt32 = 7
    
    func createBomb(from pos: CGPoint, by angle: CGFloat) {
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.size = .init(width: 35, height: 35)
        bomb.name = "bomb-enemy"
        makeBomb(from: pos, bomb: bomb, by: angle)
    }
    
    func makeBomb(from pos: CGPoint, bomb: SKSpriteNode, by angle: CGFloat) {
        bomb.size = .init(width: 35, height: 35)
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width / 2)
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = heroCategory
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.collisionBitMask = 0
        bomb.physicsBody?.linearDamping = 1.0
        bomb.position = pos
        let speed: CGFloat = 800
        let xVelocity = speed * cos(angle)
        let yVelocity = speed * sin(angle)
        bomb.physicsBody?.velocity = CGVector(dx: xVelocity, dy: yVelocity)
        
        scene?.addChild(bomb)
        
        let delay = SKAction.wait(forDuration: 1.2)
        bomb.run(delay) {
            self.explose(bomb: bomb)
        }
    }
    
    func explose(bomb: SKSpriteNode) {
        guard let scene = scene else { return }
        bomb.physicsBody = nil
        bomb.removeFromParent()
        let particleEmitter = SKEmitterNode(fileNamed: "Fire")
        particleEmitter?.position = bomb.position
        guard let particleEmitter = particleEmitter else { return }
        scene.addChild(particleEmitter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            particleEmitter.removeFromParent()
        }
    }
}

