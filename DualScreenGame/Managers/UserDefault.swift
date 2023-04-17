//
//  Managers.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 12.04.2023.
//

import Foundation

class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    let defaults = UserDefaults.standard
    
    private let musicEffectsKey = "musicEffects"
    private let bestScoreForLevel1Key = "bestScoreForLevel1"
    private let bestScoreForLevel2Key = "bestScoreForLevel2"
    private let bestScoreForLevel3Key = "bestScoreForLevel3"
    private let bestScoreForLevel4Key = "bestScoreForLevel4"
    
    private init() {
        defaults.register(defaults: [
            musicEffectsKey : true,
            bestScoreForLevel1Key: 0,
            bestScoreForLevel2Key: 0,
            bestScoreForLevel3Key: 0,
            bestScoreForLevel4Key: 0
        ])
    }
    
    
    var musicEffectsIsOn: Bool {
        get {
            defaults.bool(forKey: musicEffectsKey)
        }
        set {
            defaults.set(newValue, forKey: musicEffectsKey)
        }
    }

}
