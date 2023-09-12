//
//  GameViewController.swift
//  Doradobet
//
//  Created by Pfriedrix on 20.07.2023.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftUI

class GameViewController: UIViewController {
    let scene: GameScene = SKScene(fileNamed: "GameScene") as? GameScene ?? GameScene()
    
    var timer = Timer()
    
    var time = 150 {
        didSet {
            timerLabel.text = "\(time)"
            guard time < 1 else { return }
            let vc = UIHostingController(rootView: GameOverView(isWin: .draw))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
        scene.isPaused = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, self.time > 0 else {
                self?.timer.invalidate()
                return
            }
            self.time -= 1
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
