//
//  Hero.swift
//  Sultan
//
//  Created by Pfriedrix on 19.09.2023.
//

import SpriteKit

class Hero: SKSpriteNode {
    var hp = 100 {
        didSet {
            if hp <= 0 {
                texture = nil
                color = .clear
                scene?.isPaused = true
                let scene = scene as? GameScene
                scene?.gameDelegate?.finishGame(isWin: .lose)
            }
        }
    }
}
