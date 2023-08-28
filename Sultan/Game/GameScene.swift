
import SpriteKit
import SwiftUI


enum Movement {
    case left, right, stop
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cooldownJump = false
    var cooldownJump2 = false
    
    var cooldownSnow = false
    var cooldownSnow2 = false
    
    var cooldownBomb = false
    var cooldownBomb2 = false
    
    var block = false
    var block2 = false
    
    weak var gameDelegate: GameViewController?
    
    var move: Movement = .stop {
        didSet {
            if block {
                return
            }
            guard let player = childNode(withName: "player1") as? SKSpriteNode else { return }
            guard move != .stop, !block else {
                player.removeAllActions()
                player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero)-1")
                return
            }
            player.xScale = move == .left ? -1 : 1
            runAnimation1(player)
        }
    }
    var move2: Movement = .stop {
        didSet {
            if block2 {
                return
            }
            guard let player = childNode(withName: "player2") as? SKSpriteNode else { return }
            guard move2 != .stop, !block2 else {
                player.removeAllActions()
                player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero2)-1")
                return
            }
            player.xScale = move2 == .left ? -1 : 1
            runAnimation2(player)
        }
    }
    
    func runAnimation1(_ player: SKSpriteNode) {
        let textures: [SKTexture] = [
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero)-1"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero)-2"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero)-3"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero)-4"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero)-5"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero)-6")
        ]
        let action = SKAction.animate(with: textures, timePerFrame: 0.1)
        player.run(.repeatForever(action))
    }
    
    func runAnimation2(_ player: SKSpriteNode) {
        let textures: [SKTexture] = [
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero2)-1"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero2)-2"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero2)-3"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero2)-4"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero2)-5"),
            .init(imageNamed: "hero-\(UserSavingsService.shared.hero2)-6")
        ]
        let action = SKAction.animate(with: textures, timePerFrame: 0.1)
        player.run(.repeatForever(action))
    }
    
    override func didMove(to view: SKView) {
        guard let player1 = childNode(withName: "player1") as? SKSpriteNode else { return }
        player1.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero)-1")
        guard let player2 = childNode(withName: "player2") as? SKSpriteNode else { return }
        player2.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero2)-1")
        player2.xScale = -1
        physicsWorld.contactDelegate = self
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        print(nodeA?.name, nodeB?.name)
        
        if nodeA?.name == "tramp" && nodeB?.name?.contains("player") ?? false {
            print("up")
            if contact.contactNormal.dy < 0 {
                switch move {
                case .left:
                    nodeB?.physicsBody?.applyImpulse(.init(dx: -40, dy: 100))
                case .right:
                    nodeB?.physicsBody?.applyImpulse(.init(dx: 40, dy: 100))
                case .stop:
                    nodeB?.physicsBody?.applyImpulse(.init(dx: 0, dy: 100))
                }
            }
        }
        if nodeB?.name == "tramp" && nodeA?.name?.contains("player") ?? false {
            print("up")
            if contact.contactNormal.dy < 0 {
                switch move {
                case .left:
                    nodeA?.physicsBody?.applyImpulse(.init(dx: -40, dy: 100))
                case .right:
                    nodeA?.physicsBody?.applyImpulse(.init(dx: 40, dy: 100))
                case .stop:
                    nodeA?.physicsBody?.applyImpulse(.init(dx: 0, dy: 100))
                }
            }
        }
        
        if nodeA?.name?.contains("ladder") ?? false && nodeB?.name?.contains("player") ?? false {
            guard let ladder = nodeA as? SKSpriteNode, let player = nodeB as? SKSpriteNode else { return }
            handleLadder(player: player, ladder: ladder)
        } else if nodeB?.name?.contains("ladder") ?? false && nodeA?.name?.contains("player") ?? false {
            guard let ladder = nodeB as? SKSpriteNode, let player = nodeA as? SKSpriteNode else { return }
            handleLadder(player: player, ladder: ladder)
        }

        switch (nodeA?.name, nodeB?.name) {
        case ("snow-player2", "player1"), ("player1", "snow-player2"):
            if let player = nodeB as? SKSpriteNode, player.name == "player1" {
                block = true
                nodeA?.removeFromParent()
                player.removeAllActions()
                player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero)-froze")
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.block = false
                    player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero)-1")
                }
            }
            if let player = nodeA as? SKSpriteNode, player.name == "player1" {
                block = true
                nodeB?.removeFromParent()
                player.removeAllActions()
                player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero)-froze")
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.block = false
                    player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero)-1")
                }
            }
        case ("snow-player1", "player2"), ("player2", "snow-player1"):
            if let player = nodeB as? SKSpriteNode, player.name == "player2" {
                block2 = true
                nodeA?.removeFromParent()
                player.removeAllActions()
                player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero2)-froze")
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.block2 = false
                    player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero2)-1")
                }
            }
            if let player = nodeA as? SKSpriteNode, player.name == "player2" {
                block2 = true
                nodeB?.removeFromParent()
                player.removeAllActions()
                player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero2)-froze")
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.block2 = false
                    player.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero2)-1")
                }
            }
        case ("bomb-player2", "player1"), ("player1", "bomb-player2"):
            if let player = nodeB as? SKSpriteNode, player.name == "player1" {
                nodeA?.removeFromParent()
                player.physicsBody?.collisionBitMask = 0
                player.physicsBody?.velocity = .zero
            }
            if let player = nodeA as? SKSpriteNode, player.name == "player1" {
                nodeB?.removeFromParent()
                player.physicsBody?.collisionBitMask = 0
                player.physicsBody?.velocity = .zero
            }
        case ("bomb-player1", "player2"), ("player2", "bomb-player1"):
            if let player = nodeB as? SKSpriteNode, player.name == "player2" {
                nodeA?.removeFromParent()
                player.physicsBody?.collisionBitMask = 0
                player.physicsBody?.velocity = .zero
            }
            if let player = nodeA as? SKSpriteNode, player.name == "player2" {
                nodeB?.removeFromParent()
                player.physicsBody?.collisionBitMask = 0
                player.physicsBody?.velocity = .zero
            }
        case ("flag", "player1"), ("player1", "flag"):
            if nodeB?.name == "flag" {
                nodeB?.removeFromParent()
            } else if nodeA?.name == "flag" {
                nodeA?.removeFromParent()
            }
            block = true
            block2 = true
            cooldownBomb = true
            cooldownBomb2 = true
            cooldownJump = true
            cooldownJump2 = true
            cooldownSnow = true
            cooldownSnow2 = true
            nodeA?.removeAllActions()
            nodeB?.removeAllActions()
            guard let player2 = childNode(withName: "player2") else { return }
            player2.physicsBody?.collisionBitMask = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isPaused = true
                self.gameDelegate?.finishGame(result: .first)
            }
        case ("flag", "player2"), ("player2", "flag"):
            if nodeB?.name == "flag" {
                nodeB?.removeFromParent()
            } else if nodeA?.name == "flag" {
                nodeA?.removeFromParent()
            }
            block = true
            block2 = true
            cooldownBomb = true
            cooldownBomb2 = true
            cooldownJump = true
            cooldownJump2 = true
            cooldownSnow = true
            cooldownSnow2 = true
            nodeA?.removeAllActions()
            nodeB?.removeAllActions()
            guard let player = childNode(withName: "player1") else { return }
            player.physicsBody?.collisionBitMask = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isPaused = true
                self.gameDelegate?.finishGame(result: .second)
            }
        default: break
        }
    }
    
    func createBomb() {
        guard let player = childNode(withName: "player1") as? SKSpriteNode, !cooldownBomb, let pointer = player.childNode(withName: "pointer") else { return }
        pointer.alpha = 0
        cooldownBomb = true
        let bullet = SKSpriteNode(texture: SKTexture(imageNamed: "bomb"))
        bullet.name = "bomb-\(player.name ?? "player2")"
        bullet.size = .init(width: 30, height: 40)
        bullet.position = player.position
        bullet.position.x += player.xScale == 1 ? 20 : -20
        bullet.zPosition = 10
        addChild(bullet)
        bullet.physicsBody = .init(circleOfRadius: 3)
        bullet.physicsBody?.affectedByGravity = true
        bullet.physicsBody?.categoryBitMask = 3
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.contactTestBitMask = 100
        bullet.physicsBody?.velocity = .zero
        bullet.physicsBody?.applyForce(.init(dx: player.xScale == 1 ? 35 : -35, dy: 35))
        let particleEmitter = SKEmitterNode(fileNamed: "bomb")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.cooldownBomb = false
            bullet.physicsBody = nil
            particleEmitter?.position = bullet.position
            particleEmitter?.zPosition = 20
            self.addChild(particleEmitter!)
            bullet.removeFromParent()
        }
    }
    
    func handleLadder(player: SKSpriteNode, ladder: SKSpriteNode) {
        print(block, block2)
        if player.name == "player2" && block2 {
            return
        }
        if player.name == "player1" && block {
            return
        }
        if player.name == "player1" {
            move = .stop
            block = true
        }
        if player.name == "player2" {
            move2 = .stop
            block2 = true
        }
        
        let isUp = player.position.y <= ladder.position.y
        let up = isUp ? 330.0 : -330.0

        player.physicsBody?.velocity = .zero
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.collisionBitMask = 0
        
        player.run(.sequence([.moveTo(x: ladder.position.x, duration: 0.2), .move(by: .init(dx: 0, dy: up), duration: 2.0)])) {
            player.physicsBody?.affectedByGravity = true
            player.physicsBody?.collisionBitMask = 80
            player.position.x += player.xScale == 1 ? 70 : -70
            if player.name == "player2" {
                self.block2 = false
            } else {
                self.block = false
            }
        }
    }
    
    func createBomb2() {
        guard let player = childNode(withName: "player2") as? SKSpriteNode, !cooldownBomb2, let pointer = player.childNode(withName: "pointer") else { return }
        pointer.alpha = 0
        cooldownBomb2 = true
        let bullet = SKSpriteNode(texture: SKTexture(imageNamed: "bomb"))
        bullet.name = "bomb-\(player.name ?? "player2")"
        bullet.size = .init(width: 30, height: 40)
        bullet.position = player.position
        bullet.position.x += player.xScale == 1 ? 20 : -20
        bullet.zPosition = 10
        addChild(bullet)
        bullet.physicsBody = .init(circleOfRadius: 3)
        bullet.physicsBody?.affectedByGravity = true
        bullet.physicsBody?.categoryBitMask = 3
        bullet.physicsBody?.contactTestBitMask = 100
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.velocity = .zero
        bullet.physicsBody?.applyForce(.init(dx: player.xScale == 1 ? 35 : -35, dy: 35))
        let particleEmitter = SKEmitterNode(fileNamed: "bomb")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.cooldownBomb2 = false
            bullet.physicsBody = nil
            particleEmitter?.position = bullet.position
            particleEmitter?.zPosition = 20
            self.addChild(particleEmitter!)
            bullet.removeFromParent()
        }
    }
    
    func shotShow() {
        guard let player = childNode(withName: "player1") as? SKSpriteNode, let pointer = player.childNode(withName: "pointer") else { return }
        pointer.alpha = 0
        createSnow(player, cooldown: cooldownSnow, velocityX: 35) {
            self.cooldownSnow = $0
        }
    }
    
    func shotShow2() {
        guard let player = childNode(withName: "player2") as? SKSpriteNode, let pointer = player.childNode(withName: "pointer") else { return }
        pointer.alpha = 0
        createSnow(player, cooldown: cooldownSnow2, velocityX: 35) {
            self.cooldownSnow2 = $0
        }
    }
    
    func createSnow(_ player: SKSpriteNode, cooldown: Bool, velocityX: CGFloat, handler: @escaping (Bool) -> Void) {
        guard !cooldown, player.childNode(withName: "ball") == nil else { return }
        handler(true)
        let bullet = SKSpriteNode(texture: SKTexture(imageNamed: "snow"))
        bullet.name = "snow-\(player.name ?? "player1")"
        bullet.size = .init(width: 30, height: 30)
        bullet.position = player.position
        bullet.position.x += player.xScale == 1 ? 20 : -20
        bullet.zPosition = 10
        addChild(bullet)
        bullet.physicsBody = .init(circleOfRadius: 3)
        bullet.physicsBody?.affectedByGravity = true
        bullet.physicsBody?.categoryBitMask = 3
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.contactTestBitMask = 100
        bullet.physicsBody?.velocity = .zero
        bullet.physicsBody?.applyForce(.init(dx: player.xScale == 1 ? velocityX : -velocityX, dy: 40))
        let particleEmitter = SKEmitterNode(fileNamed: "snow")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            bullet.physicsBody = nil
            particleEmitter?.position = bullet.position
            particleEmitter?.zPosition = 20
            self.addChild(particleEmitter!)
            bullet.removeFromParent()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            handler(false)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let player = childNode(withName: "player1"), let player2 = childNode(withName: "player2") else { return }
        if !block2 && !block {
            
            camera?.position.y = player.position.y > player2.position.y ? player2.position.y + 120 : player.position.y + 120
        }
        if !block {
            switch move {
            case .left:
                player.position.x -= 2
            case .right:
                player.position.x += 2
            case .stop: break
            }
        }
        
        if !block2 {
            switch move2 {
            case .left:
                player2.position.x -= 2
            case .right:
                player2.position.x += 2
            case .stop: break
            }
        }
        
        if player.physicsBody?.velocity.dy ?? 0 < -1500 {
            player.position = .init(x: -618.242, y: -179.317)
            player.physicsBody?.velocity = .zero
            player.physicsBody?.collisionBitMask = 80
        }
        if player2.physicsBody?.velocity.dy ?? 0 < -1500 {
            player2.position = .init(x: 711.173, y: 228.954)
            player2.physicsBody?.velocity = .zero
            player2.physicsBody?.collisionBitMask = 80
        }
    }
    
    func jump() {
        guard let player = childNode(withName: "player1"), !cooldownJump, !block else { return }
        if player.physicsBody?.velocity.dy ?? 0 < 10 {
            cooldownJump.toggle()
            switch move {
            case .left:
                player.physicsBody?.applyImpulse(.init(dx: -100, dy: 300))
            case .right:
                player.physicsBody?.applyImpulse(.init(dx: 100, dy: 300))
            case .stop:
                player.physicsBody?.applyImpulse(.init(dx: 0, dy: 300))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.cooldownJump.toggle()
            }
        }
    }
    
    func jump2() {
        guard let player = childNode(withName: "player2"), !cooldownJump2, !block2 else { return }
        if player.physicsBody?.velocity.dy ?? 0 < 10 {
            cooldownJump2.toggle()
            switch move2 {
            case .left:
                player.physicsBody?.applyImpulse(.init(dx: -100, dy: 300))
            case .right:
                player.physicsBody?.applyImpulse(.init(dx: 100, dy: 300))
            case .stop:
                player.physicsBody?.applyImpulse(.init(dx: 0, dy: 300))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.cooldownJump2.toggle()
            }
        }
    }
    
    func showPointer1() {
        guard let player = childNode(withName: "player1"), let pointer = player.childNode(withName: "pointer") else { return }
        pointer.alpha = 1
    }
    
    func showPointer2() {
        guard let player = childNode(withName: "player2"), let pointer = player.childNode(withName: "pointer") else { return }
        pointer.alpha = 1
    }
}

extension CGPoint {
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
