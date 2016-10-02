//
//  GameHandler.swift
//  GigaJump
//
//  Created by Stanley Pan on 02/10/2016.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//

import Foundation

class GameHandler {
    var score: Int
    var highScore: Int
    var flowers: Int
    
    var levelData: NSDictionary!
    
    class var sharedInstance: GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        
        return Singleton.instance
    }
    
    init() {
        score = 0
        highScore = 0
        flowers = 0
        
        let userDefaults = UserDefaults.standard
        highScore = userDefaults.integer(forKey: "highScore")
        flowers = userDefaults.integer(forKey: "flowers")
    }
    
    func saveGameStats() {
        highScore = max(score, highScore)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScore, forKey: "highScore")
        userDefaults.set(flowers, forKey: "flowers")
        userDefaults.synchronize()
    }
}
