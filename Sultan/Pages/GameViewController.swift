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
    
    func finishGame(result: Winning) {
        let vc = UIHostingController(rootView: GameOverView(isWin: result))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            scene.scaleMode = .aspectFill
            scene.gameDelegate = self
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

    @IBAction func pause(_ sender: Any) {
        let vc = UIAlertController(title: "EXIT", message: "Are you sure to exit? Game progress will not be saved.", preferredStyle: .alert)
        vc.addAction(.init(title: "Cancel", style: .cancel))
        vc.addAction(.init(title: "Yes", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
            self.timer.invalidate()
        })
        present(vc, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func leftEnd(_ sender: Any) {
        scene.move = .stop
    }
    
    @IBAction func leftStart(_ sender: Any) {
        scene.move = .left
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func rightEnd(_ sender: Any) {
        scene.move = .stop
    }
    
    @IBAction func rightStart(_ sender: Any) {
        scene.move = .right
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func jump(_ sender: Any) {
        scene.jump()
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func jump2(_ sender: Any) {
        scene.jump2()
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func leftEnd2(_ sender: Any) {
        scene.move2 = .stop
    }
    
    @IBAction func leftStart2(_ sender: Any) {
        scene.move2 = .left
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }

    @IBAction func rightEnd2(_ sender: Any) {
        scene.move2 = .stop
    }
    
    @IBAction func rightStart2(_ sender: Any) {
        scene.move2 = .right
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func snow2(_ sender: Any) {
        scene.shotShow2()
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func snow(_ sender: Any) {
        scene.shotShow()
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func snowStart(_ sender: Any) {
        scene.showPointer1()
    }
    
    @IBAction func snow2Start(_ sender: Any) {
        scene.showPointer2()
    }
    
    @IBAction func bomb2(_ sender: Any) {
        scene.createBomb2()
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func bombStart(_ sender: Any) {
        scene.showPointer1()
    }
    
    @IBAction func bomb(_ sender: Any) {
        scene.createBomb()
        SoundPlayer.shared.playClick()
        ImpactFeedback.shared.makeImpackFeedback(.medium)
    }
    
    @IBAction func bomb2Start(_ sender: Any) {
        scene.showPointer2()
    }
}
