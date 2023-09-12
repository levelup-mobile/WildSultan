
import SpriteKit
import SwiftUI


enum Movement {
    case left, right, stop
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let joystickBase = SKSpriteNode(imageNamed: "joystickBase")
    let joystickKnob = SKSpriteNode(imageNamed: "joystickKnob")
    
    let maxHeroSpeed: CGFloat = 5.0
    
    var touch: UITouch?
    
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
    
    override func didMove(to view: SKView) {
        isPaused = true
        joystickBase.size = CGSize(width: 120, height: 120)
        joystickKnob.size = .init(width: 50, height: 50)
        joystickBase.position = CGPoint(x: -frame.width / 2 + 150, y: -frame.height / 2 + 150)
        joystickKnob.position = joystickBase.position
        addChild(joystickBase)
        addChild(joystickKnob)
        
        guard let hero = childNode(contains: "hero") as? SKSpriteNode else { return }
        hero.texture = SKTexture(imageNamed: "hero-\(UserSavingsService.shared.hero)-1")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if joystickBase.frame.contains(location) {
            touch = touches.first
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touch else {
            return
        }
        
        let position = touch.location(in: self)
        let distance = joystickBase.position.distance(to: position)
        let angle = joystickBase.position.angle(to: position)
        
        if distance < joystickBase.size.width / 2 {
            joystickKnob.position = position
        } else {
            joystickKnob.position = CGPoint(x: cos(angle) * (joystickBase.size.width / 2) + joystickBase.position.x,
                                            y: sin(angle) * (joystickBase.size.width / 2) + joystickBase.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touch == touches.first {
            joystickKnob.run(SKAction.move(to: joystickBase.position, duration: 0.2))
            touch = nil
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
        
        hero.position.x += cos(angle) * maxHeroSpeed * distanceRatio
        hero.position.y += sin(angle) * maxHeroSpeed * distanceRatio
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
