import AVFoundation

class SoundPlayer {
    static var shared = SoundPlayer()
    
    var player = AVAudioPlayer()
    
    func playClick() {
        guard
            UserSavingsService.shared.sound
        else { return }
        
        AudioServicesPlaySystemSound(1306)
    }
    
    func playLock() {
        guard
            UserSavingsService.shared.sound
        else { return }
        
        AudioServicesPlaySystemSound(1305)
    }
    
    func playHit() {
        guard
            UserSavingsService.shared.sound, let url = Bundle.main.url(forResource: "hit", withExtension: "mp3")
        else { return }
        
        do {
            
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player.setVolume(0.3, fadeDuration: 0.5)
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playWin() {
        guard
            UserSavingsService.shared.sound, let url = Bundle.main.url(forResource: "win", withExtension: "mp3")
        else { return }
        
        do {
            
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player.setVolume(0.6, fadeDuration: 0.5)
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playLose() {
        guard
            UserSavingsService.shared.sound, let url = Bundle.main.url(forResource: "lose", withExtension: "mp3")
        else { return }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player.setVolume(0.6, fadeDuration: 0.5)
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playMovement() {
        func playClick() {
            guard
                UserSavingsService.shared.sound
            else { return }
            
            AudioServicesPlaySystemSound(1307)
        }
    }
    
    func playThrow() {
        guard
            UserSavingsService.shared.sound, let url = Bundle.main.url(forResource: "throw", withExtension: "wav")
        else { return }
        do {
            
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player.setVolume(0.6, fadeDuration: 0.5)
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playStart() {
        guard
            UserSavingsService.shared.sound, let url = Bundle.main.url(forResource: "start", withExtension: "wav")
        else { return }
        do {
            
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player.setVolume(0.6, fadeDuration: 0.5)
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playCheers() {
        guard
            UserSavingsService.shared.sound, let url = Bundle.main.url(forResource: "cheers", withExtension: "mp3")
        else { return }
        do {
            
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player.setVolume(0.6, fadeDuration: 0.5)
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playBackgroundMusic() {
        guard
            UserSavingsService.shared.music,
            let url = Bundle.main.url(forResource: "background", withExtension: "mp3")
        else {
            player.setVolume(0.0, fadeDuration: 0.5)
            return }
        do {
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player.setVolume(0.4, fadeDuration: 0.5)
            player.numberOfLoops = -1
            player.play()
    
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
