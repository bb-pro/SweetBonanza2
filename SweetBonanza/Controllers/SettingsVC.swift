//
//  SettingsVC.swift
//  SweetBonanza
//
//  Created by 1 on 31/01/25.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet weak var soundProgressView: UIProgressView!
    @IBOutlet weak var musicProgressView: UIProgressView!
    
    var soundVolume = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.soundVolume) as! Double
    var musicVolume = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.musicVolume) as! Double
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundProgressView.layer.masksToBounds = true
        musicProgressView.layer.masksToBounds = true
        soundProgressView.layer.borderWidth = 2.5
        musicProgressView.layer.borderWidth = 2.5
        soundProgressView.layer.borderColor = UIColor.white.cgColor
        musicProgressView.layer.borderColor = UIColor.white.cgColor
        setupUserAppearance()
    }
    
    @IBAction func soundMinusTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if soundVolume >= Double(0.1) {
            soundVolume -= Double(0.1)
            setupUserAppearance()
        }
    }
    
    @IBAction func soundPlusTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if soundVolume <= Double(0.9) {
            soundVolume += 0.1
            setupUserAppearance()
        }
    }
    
    @IBAction func musicMinusTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if musicVolume >= Double(0.1) {
            musicVolume -= Double(0.1)
            setupUserAppearance()
        }
    }
    
    @IBAction func musicPlusTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if musicVolume <= Double(0.9) {
            musicVolume += 0.1
            setupUserAppearance()
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupUserAppearance() {
        if soundVolume >= Double(0.0) && soundVolume <= Double(1.0) && musicVolume >= Double(0.0) && musicVolume <= Double(1.0) {
            soundProgressView.progress = Float(soundVolume)
            musicProgressView.progress = Float(musicVolume)
            SoundManager.shared.setMusicVolume(Float(musicVolume))
            SoundManager.shared.setSoundVolume(Float(soundVolume))
            GameManagerClass.shared.updateValues(key: GameManagerClass.shared.soundVolume, value: soundVolume)
            GameManagerClass.shared.updateValues(key: GameManagerClass.shared.musicVolume, value: musicVolume)
        }
    }
}
