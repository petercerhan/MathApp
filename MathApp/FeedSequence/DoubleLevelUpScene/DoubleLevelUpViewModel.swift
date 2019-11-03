//
//  DoubleLevelUpViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol DoubleLevelUpViewModelDelegate: class {
    
}

class DoubleLevelUpViewModel {
    
    //MARK: - Initialization
    
    init(levelUpItem1: LevelUpItem, levelUpItem2: LevelUpItem) {
        concept1PriorLevel = levelUpItem1.previousLevel
        concept1NewLevel = levelUpItem1.newLevel
        concept1Name = levelUpItem1.concept.name
        concept2PriorLevel = levelUpItem2.previousLevel
        concept2NewLevel = levelUpItem2.newLevel
        concept2Name = levelUpItem2.concept.name
    }
    
    //MARK: - DoubleLevelUpViewModel Interface
    
    let concept1PriorLevel: Int
    let concept1NewLevel: Int
    let concept1Name: String
    let concept2PriorLevel: Int
    let concept2NewLevel: Int
    let concept2Name: String
    
}
