//
//  SoundManager.swift
//  SweetBonanza
//
//  Created by 1 on 01/02/25.
//

import UIKit
import AVFoundation
class SoundManager {
    static let shared = SoundManager()
    
    var backgroundPlayer: AVAudioPlayer?
    var losePlayer: AVAudioPlayer?
    var clickPlayer: AVAudioPlayer?
    var winPlayer: AVAudioPlayer?
    
    private init() {
        var soundVolume: Float = 1.0  // Default value
        var musicVolume: Float = 1.0  // Default value

        if let soundStatus = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.soundVolume) as? NSNumber {
            soundVolume = soundStatus.floatValue
        }

        if let musicStatus = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.musicVolume) as? NSNumber {
            musicVolume = musicStatus.floatValue
        }

        if let bgUrl = Bundle.main.url(forResource: "bg", withExtension: "mp3") {
            backgroundPlayer = try? AVAudioPlayer(contentsOf: bgUrl)
            backgroundPlayer?.numberOfLoops = -1
            backgroundPlayer?.volume = musicVolume  
            backgroundPlayer?.prepareToPlay()
        }

        if let loseURL = Bundle.main.url(forResource: "lose", withExtension: "mp3") {
            losePlayer = try? AVAudioPlayer(contentsOf: loseURL)
            losePlayer?.volume = musicVolume
            losePlayer?.prepareToPlay()
        }

        if let winURL = Bundle.main.url(forResource: "win", withExtension: "mp3") {
            winPlayer = try? AVAudioPlayer(contentsOf: winURL)
            winPlayer?.volume = musicVolume
            winPlayer?.prepareToPlay()
        }

        if let clickURL = Bundle.main.url(forResource: "click", withExtension: "mp3") {
            clickPlayer = try? AVAudioPlayer(contentsOf: clickURL)
            clickPlayer?.volume = soundVolume
            clickPlayer?.prepareToPlay()
        }
    }

    
    func playBackgroundMusic() {
        backgroundPlayer?.play()
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }
    
    func playClickSound() {
        clickPlayer?.play()
    }

    func playLoseSound() {
        losePlayer?.play()
    }
    
    func playWinSound() {
        winPlayer?.play()
    }
    
    func setMusicVolume(_ volume: Float) {
        backgroundPlayer?.volume = volume
        losePlayer?.volume = volume
        winPlayer?.volume = volume
    }
    
    func setSoundVolume(_ volume: Float) {
        clickPlayer?.volume = volume
    }
}
