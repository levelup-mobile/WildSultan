import Combine
import Foundation
import UIKit

class UserSavingsService {
    static var shared = UserSavingsService()
    
    var money: Int {
        get {
            return UserDefaults.standard.integer(forKey: "money")
        }
        set {
            guard newValue >= 0 else { return }
            UserDefaults.standard.set(newValue, forKey: "money")
        }
    }
    
    var sound: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "sound")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "sound")
            if newValue {
                SoundPlayer.shared.player?.setVolume(0.3, fadeDuration: 0.5)
            } else {
                SoundPlayer.shared.player?.setVolume(0.0, fadeDuration: 0.5)
            }
        }
    }
    
    var music: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "music")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "music")
            if newValue {
                SoundPlayer.shared.player?.setVolume(0.3, fadeDuration: 0.5)
            } else {
                SoundPlayer.shared.player?.setVolume(0.0, fadeDuration: 0.5)
            }
        }
    }
    
    var vibrations: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "vibrations")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "vibrations")
        }
    }
    
    var lastTimeGetBonus: Date? {
        get {
            return UserDefaults.standard.object(forKey: "lastTimeGetBonus") as? Date
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "lastTimeGetBonus")
        }
    }
    
    var canGetBonus: Bool {
        guard let lastTimeGetBonus = lastTimeGetBonus else { return true }
        
        if let timeToGetBonus = Calendar.current.date(byAdding: .day, value: 1, to: lastTimeGetBonus) {
            return Date() >= timeToGetBonus
        }
        
        return false
    }
    
    var hero: Int {
        get {
            return UserDefaults.standard.integer(forKey: "hero")
        }
        
        set {
            guard newValue >= 1 else { return }
            UserDefaults.standard.set(newValue, forKey: "hero")
        }
    }
    
    var hero2: Int {
        get {
            return UserDefaults.standard.integer(forKey: "hero2")
        }
        
        set {
            guard newValue >= 1 else { return }
            UserDefaults.standard.set(newValue, forKey: "hero2")
        }
    }
    
    var item: Int {
        get {
            return UserDefaults.standard.integer(forKey: "item")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "item")
        }
    }
    
    var gate: Int {
        get {
            return UserDefaults.standard.integer(forKey: "gate")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "gate")
        }
    }
    
    var boughtItems: [Bool] {
        get {
            return UserDefaults.standard.array(forKey: "boughtItems") as? [Bool] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "boughtItems")
        }
    }
    
    var boughtGates: [Bool] {
        get {
            return UserDefaults.standard.array(forKey: "boughtGates") as? [Bool] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "boughtGates")
        }
    }
    
    init () {
        UserDefaults.standard.register(defaults: ["money": 100])
        UserDefaults.standard.register(defaults: ["sound": false])
        UserDefaults.standard.register(defaults: ["music": false])
        UserDefaults.standard.register(defaults: ["vibrations": false])
        UserDefaults.standard.register(defaults: ["lastTimeGetBonus": Date(timeIntervalSince1970: 0)])
        UserDefaults.standard.register(defaults: ["item": 1])
        UserDefaults.standard.register(defaults: ["gate": 1])
        UserDefaults.standard.register(defaults: ["boughtItems": [true, false, false, false]])
        UserDefaults.standard.register(defaults: ["hero": 1])
        UserDefaults.standard.register(defaults: ["hero2": 1])
    }
}
