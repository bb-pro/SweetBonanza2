//
//  ShopVC.swift
//  SweetBonanza
//
//  Created by 1 on 31/01/25.
//

import UIKit

class ShopVC: UIViewController {
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var selectedBackImageView: UIImageView!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    
    var availableBackgrounds = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.availableBackground) as! [Int]
    var selectedBackgroud = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.selectedBackgroud) as! Int
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftButton.layer.masksToBounds = false
        leftButton.clipsToBounds = false
        
        setupUI()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func leftTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if index > 0 {
            index -= 1
            setupUI()
        }
    }
    
    @IBAction func rightTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if index < 2 {
            index += 1
            setupUI()
        }
    }
    
    @IBAction func buyTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        if index >= 0 && index <= 2 {
            if availableBackgrounds.contains(index) {
                GameManagerClass.shared.updateValues(key: GameManagerClass.shared.selectedBackgroud, value: index)
                selectedBackgroud = index
            } else {
                if GameManagerClass.shared.getCoins() >= 150 {
                    GameManagerClass.shared.updateValues(key: GameManagerClass.shared.coins, value: GameManagerClass.shared.getCoins() - 150)
                    availableBackgrounds.append(index)
                    GameManagerClass.shared.updateValues(key: GameManagerClass.shared.availableBackground, value: availableBackgrounds)
                }
            }
            setupUI()
        }
    }
    
    func setupUI() {
        if index >= 0 && index <= 2 {
            selectedBackImageView.image = UIImage(named: "bg\(index)")
            if availableBackgrounds.contains(index) {
                priceLabel.text = ""
                coinImage.image = UIImage(named: "unselectedAchievement")
            } else {
                priceLabel.text = "150"
                coinImage.image = UIImage(named: "coinImage")
            }
            if index == selectedBackgroud {
                priceLabel.text = ""
                coinImage.image = UIImage(named: "selectedAchievement")
            }
        }
        coinLabel.text = "\(GameManagerClass.shared.getCoins())"
    }
}
