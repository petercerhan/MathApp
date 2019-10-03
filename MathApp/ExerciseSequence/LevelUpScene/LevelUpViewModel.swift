//
//  LevelUpViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class LevelUpViewModel {
    
    //MARK: - Initialization
    
    init(levelUpItem: LevelUpItem) {
        conceptName = levelUpItem.concept.name
        previousLevel = levelUpItem.previousLevel
        newLevel = levelUpItem.newLevel
    }
    
    //MARK: - LevelUpViewModel Interface
    
    let conceptName: String
    let previousLevel: Int
    let newLevel: Int
    
    
}
