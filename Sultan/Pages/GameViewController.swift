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
import Combine

class GameViewController: UIViewController {
    let scene: GameScene = SKScene(fileNamed: "GameScene") as? GameScene ?? GameScene()
    var timer = Timer()
    
    var shopViewModel = ShopViewModel(buildings: 0, hp: 100, bombs: 0)
    
    var money = UserSavingsService.shared.money {
        didSet {
            moneyLabel.text = money.withAbbreviation
            UserSavingsService.shared.money = money
        }
    }
    
    var store = Set<AnyCancellable>()
    
    var time = 0 {
        didSet {
            if time % 5 == 0 {
                money += 1
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startTimer()
        money = UserSavingsService.shared.money
        scene.isPaused = false
        moneyLabel.text = money.withAbbreviation
        scene.showBuildings(buildings: shopViewModel.buildings)
        scene.showSuperspells(spells: shopViewModel.bombs)
        scene.showHP(hp: shopViewModel.hp)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            scene.scaleMode = .aspectFill
            scene.gameDelegate = self
            view.presentScene(scene)
        }
        
        shopViewModel.$bombs
            .sink { value in
                self.scene.showSuperspells(spells: value)
            }
            .store(in: &store)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                self?.timer.invalidate()
                return
            }
            self.time += 1
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @IBAction func openShop(_ sender: Any) {
        scene.isPaused = true
        timer.invalidate()
        let view = PlayerShopView(viewModel: self.shopViewModel)
        let vc = UIHostingController(rootView: view)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
