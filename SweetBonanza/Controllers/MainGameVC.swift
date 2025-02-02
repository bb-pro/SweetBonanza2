//
//  MainGameVC.swift
//  SweetBonanza
//
//  Created by 1 on 31/01/25.
//

import UIKit

class MainGameVC: UIViewController {
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var gameInstructionLabel: UILabel!
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerBackView: UIView!
    
    let instructionText: [String] = [
    """
Divide the chocolate
into 2 parts
""", """
Divide the chocolate
into 4 parts
""", """
Divide the chocolate
into 4 parts
""", """
Divide the chocolate
into 8 parts
""", """
Cut strawberries
into particles
""", """
Cut out a circle
for the
strawberries
""", """
Cut a square in
marshmallows

""", """
cut out a star in
the marshmallow

""", """
Cut a heart out
of chocolate

""", """
Cut out elements
from white
chocolate

"""]
    var level: Int?
    var currentPath: UIBezierPath!
    var drawnPathLayer: CAShapeLayer!
    var startingPoint: CGPoint?
    var closedShapeNumbers: Int = 0
    let shapeValidator = ShapeValidator()
    var timer: Timer?
    var remainingTime: Int = 60
    var isPaused: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let level = level {
            if level >= 6 {
                timerBackView.isHidden = false
                resumeTimer()
            } else {
                timerBackView.isHidden = true
            }
        }
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        SoundManager.shared.playClickSound()
        pauseTimer()
        let vc = storyboard?.instantiateViewController(withIdentifier: "PauseVC") as! PauseVC
        vc.infoText = gameInstructionLabel.text
        vc.level = level
        vc.particleImage = fruitImageView.image
        navigationController?.pushViewController(vc, animated: true)
    }
}
private extension MainGameVC {
    private func setupUI() {
        let selectedBackground = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.selectedBackgroud) as! Int
        if selectedBackground == 0 || selectedBackground == 2 {
            backgroundImageView.image = UIImage(named: "selectableBackImage0")
        } else {
            backgroundImageView.image = UIImage(named: "selectableBackImage1")
        }
        
        if let level = level {
            if level >= 6 {
                timerBackView.isHidden = false
                startTimer()
            } else {
                timerBackView.isHidden = true
            }
            levelLabel.text = "LVL \(level + 1)"
            fruitImageView.image = UIImage(named: "particle\(level)")
            gameInstructionLabel.text = instructionText[level]
            
        }
        gameView.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gameView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let currentPoint = gesture.location(in: gameView)

        switch gesture.state {
        case .began:
            startDrawing(at: currentPoint)
        case .changed:
            continueDrawing(to: currentPoint)
        case .ended:
            finishDrawing()
        default:
            break
        }
    }
    
    func startDrawing(at point: CGPoint) {
        currentPath = UIBezierPath()
        currentPath.move(to: point)
        startingPoint = point

        drawnPathLayer = CAShapeLayer()
        drawnPathLayer.path = currentPath.cgPath
        drawnPathLayer.strokeColor = UIColor.white.cgColor
        drawnPathLayer.lineWidth = 4.0
        drawnPathLayer.fillColor = UIColor.clear.cgColor
        gameView.layer.addSublayer(drawnPathLayer)
    }

    func continueDrawing(to point: CGPoint) {
        currentPath.addLine(to: point)
        drawnPathLayer.path = currentPath.cgPath
    }

    func finishDrawing() {
        guard let startingPoint = startingPoint else { return }
        
        if currentPath.contains(startingPoint) {
            print("Closed shape detected!")
            closedShapeNumbers += 1
        } else {
            print("Open path detected!")
        }
        
        if level == 0 || level == 5 || level == 6 || level == 7 || level == 8 {
            if closedShapeNumbers == 1 {
                let isValid = shapeValidator.validatePath(for: level!, drawnPath: currentPath, referenceFrame: gameView.bounds)
                checkOutcome(to: isValid)
            }
        } else if level == 1 || level == 8 {
            if closedShapeNumbers == 2 {
                let isValid = shapeValidator.validatePath(for: level!, drawnPath: currentPath, referenceFrame: gameView.bounds)
                checkOutcome(to: isValid)
            }
        } else if level == 2 || level == 9 {
            if closedShapeNumbers == 3 {
                let isValid = shapeValidator.validatePath(for: level!, drawnPath: currentPath, referenceFrame: gameView.bounds)
                checkOutcome(to: isValid)
            }
        } else if level == 3 {
            if closedShapeNumbers == 4 {
                let isValid = shapeValidator.validatePath(for: level!, drawnPath: currentPath, referenceFrame: gameView.bounds)
                checkOutcome(to: isValid)
            }
        } else if level == 4 {
            if closedShapeNumbers == 6 {
                let isValid = shapeValidator.validatePath(for: level!, drawnPath: currentPath, referenceFrame: gameView.bounds)
                checkOutcome(to: isValid)
            }
        } else if level == 7 {
            if closedShapeNumbers <= 10 {
                let isValid = shapeValidator.validatePath(for: level!, drawnPath: currentPath, referenceFrame: gameView.bounds)
                checkOutcome(to: isValid)
            }
        } else {
            print("Unclarified yet:(")
        }
    }
    
    func checkOutcome(to shape: Bool) {
        timer?.invalidate()
        var unbeatenMatches = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.unbeatenMoves) as! Int
        if shape {
            var achievements = GameManagerClass.shared.getValueOfKey(key: GameManagerClass.shared.achievements) as! [Int]
            unbeatenMatches += 1
            GameManagerClass.shared.updateValues(key: GameManagerClass.shared.unbeatenMoves,
                                                 value: unbeatenMatches)
            if level! == 0 {
                if !achievements.contains(1) {
                    achievements.append(1)
                    GameManagerClass.shared.updateValues(key: GameManagerClass.shared.achievements,
                                                         value: achievements)
                }
            }
            

            if unbeatenMatches == 2 && !achievements.contains(2) {
                achievements.append(2)
                GameManagerClass.shared.updateValues(key: GameManagerClass.shared.achievements,
                                                     value: achievements)
            }
            if unbeatenMatches == 5 && !achievements.contains(5) {
                achievements.append(5)
                GameManagerClass.shared.updateValues(key: GameManagerClass.shared.achievements,
                                                     value: achievements)
            }
            
            if level! > 4 && !achievements.contains(6) {
                achievements.append(6)
                GameManagerClass.shared.updateValues(key: GameManagerClass.shared.achievements,
                                                     value: achievements)
            }
            
            if level! == 5 && !achievements.contains(4) {
                achievements.append(4)
                GameManagerClass.shared.updateValues(key: GameManagerClass.shared.achievements,
                                                     value: achievements)
            }
            
            if remainingTime >= 55 && level! > 6 {
                achievements.append(3)
                GameManagerClass.shared.updateValues(key: GameManagerClass.shared.achievements,
                                                     value: achievements)
            }
            
            print("success")
            SoundManager.shared.playWinSound()
            let vc = storyboard?.instantiateViewController(withIdentifier: "CompletionStatusVC") as! CompletionStatusVC
            vc.isWon = true
            vc.level = level
            vc.particleImage = fruitImageView.image
            vc.instructionText = gameInstructionLabel.text
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("failure")
            unbeatenMatches = 0
            GameManagerClass.shared.updateValues(key: GameManagerClass.shared.unbeatenMoves,
                                                 value: unbeatenMatches)
            SoundManager.shared.playLoseSound()
            let vc = storyboard?.instantiateViewController(withIdentifier: "CompletionStatusVC") as! CompletionStatusVC
            vc.isWon = false
            vc.level = level
            vc.particleImage = fruitImageView.image
            vc.instructionText = gameInstructionLabel.text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
private extension MainGameVC {
    func startTimer() {
        timer?.invalidate()
        isPaused = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    // Pause the Timer
    func pauseTimer() {
        guard let timer = timer else { return }
        timer.invalidate()
        isPaused = true
    }
    
    // Resume the Timer
    func resumeTimer() {
        guard isPaused else { return }
        isPaused = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateTimerLabel()
        } else {
            timer?.invalidate() // Stop when reaching 0
            timerLabel.text = "0:00" // Final display
            print("Time is up!")
            checkOutcome(to: false) // You can trigger game over or any action here
        }
    }
    private func updateTimerLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        timerLabel.text = String(format: "%d:%02d", minutes, seconds)
    }
}
