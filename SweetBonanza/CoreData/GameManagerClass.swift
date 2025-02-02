//
//  GameManagerClass.swift
//  SweetBonanza
//
//  Created by 1 on 31/01/25.
//

import Foundation

class GameManagerClass {
    static let shared  = GameManagerClass()
    
    let coins = "coins"
    let level = "level"
    let availableBackground = "availableBackground"
    let selectedBackgroud = "selectedBackgroud"
    let achievements = "achievements"
    let unbeatenMoves = "unbeatedMoves"
    let soundVolume = "soundVolume"
    let musicVolume = "musicVolume"
    let defaults = UserDefaults.standard
    
    func initializeUserInformation() {
        if defaults.value(forKey: coins) == nil {
            defaults.setValue(60, forKey: coins)
        }
        if defaults.value(forKey: availableBackground) == nil {
            defaults.setValue([0], forKey: availableBackground)
        }
        if defaults.value(forKey: selectedBackgroud) == nil {
            defaults.setValue(0, forKey: selectedBackgroud)
        }
        if defaults.value(forKey: level) == nil {
            defaults.setValue(0, forKey: level)
        }
        if defaults.value(forKey: achievements) == nil {
            defaults.setValue([0], forKey: achievements)
        }
        if defaults.value(forKey: soundVolume) == nil {
            defaults.setValue(Double(1.0), forKey: soundVolume)
        }
        if defaults.value(forKey: musicVolume) == nil {
            defaults.setValue(Double(1.0), forKey: musicVolume)
        }
        if defaults.value(forKey: unbeatenMoves) == nil {
            defaults.setValue(0, forKey: unbeatenMoves)
        }
    }
    
    func updateValues(key: String, value: Any) {
        defaults.setValue(value, forKey: key)
    }
    
    func getValueOfKey(key: String) -> Any {
        return defaults.value(forKey: key) as Any
    }
    
    func getCoins() -> Int {
        return defaults.value(forKey: coins) as! Int
    }
}
