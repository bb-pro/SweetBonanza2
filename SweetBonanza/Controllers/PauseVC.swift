//
//  PauseVC.swift
//  SweetBonanza
//  
//  Created by 1 on 31/01/25.
//

import UIKit

class PauseVC: UIViewController {
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var particleImageView: UIImageView!
    
    var level: Int?
    var infoText: String?
    var particleImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        declareUserAppearance()
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restartTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainGameVC") as! MainGameVC
        vc.level = level
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backToMenuTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        navigationController?.popToRootViewController(animated: true)
    }
}
private extension PauseVC {
    private func declareUserAppearance() {
        if let level = level, let infoText = infoText, let particleImage = particleImage {
            levelLabel.text = "LVL \(level + 1)"
            infoLabel.text = infoText
            particleImageView.image = particleImage
        }
    }
}
