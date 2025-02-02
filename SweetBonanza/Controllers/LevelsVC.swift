//
//  LevelsVC.swift
//  SweetBonanza
//
//  Created by 1 on 31/01/25.
//

import UIKit

class LevelsVC: UIViewController {
    @IBOutlet var levelButtons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defineUserAppearance()
    }
    
    @IBAction func levelTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainGameVC") as! MainGameVC
        vc.level = sender.tag
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func defineUserAppearance() {
        let level = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.level) as! Int
        for levelButton in levelButtons {
            if levelButton.tag <= level {
                levelButton.isUserInteractionEnabled = true
                levelButton.setTitleColor(.white, for: .normal)
                levelButton.setTitleShadowColor(UIColor(red: 153/255, green: 0, blue: 150/255, alpha: 1), for: .normal)
            } else {
                levelButton.isUserInteractionEnabled = false
                levelButton.setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
                levelButton.setTitleShadowColor(UIColor(red: 153/255, green: 0, blue: 150/255, alpha: 0.4), for: .normal)
            }
        }
    }
}
