//
//  ViewController.swift
//  SweetBonanza
//
//  Created by 1 on 30/01/25.
//

import UIKit

class StartingVC: UIViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    var loadingTestChoices = ["Loading", "Loading.", "Loading..", "Loading..."]
    var currentLoadingIndex = 0
    var loadingTimer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        kickOffLoadingAnimation()
    }
    
    private func kickOffLoadingAnimation() {
        loadingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshLoadingText), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.loadingTimer?.invalidate()
            self?.loadingTimer = nil
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainNavBar")
            vc?.modalPresentationStyle = .fullScreen
            self?.present(vc!, animated: true)
        }
    }

    @objc private func refreshLoadingText() {
        currentLoadingIndex = (currentLoadingIndex + 1) % loadingTestChoices.count
        loadingLabel.text = loadingTestChoices[currentLoadingIndex]
    }
}

