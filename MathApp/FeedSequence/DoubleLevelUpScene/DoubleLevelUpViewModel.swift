//
//  DoubleLevelUpViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol DoubleLevelUpViewModelDelegate: class {
    func next(_ doubleLevelUpViewModel: DoubleLevelUpViewModel)
}

enum DoubleLevelUpAction {
    case next
}

class DoubleLevelUpViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: DoubleLevelUpViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: DoubleLevelUpViewModelDelegate, levelUpItem1: LevelUpItem, levelUpItem2: LevelUpItem) {
        self.delegate = delegate
        concept1PriorLevel = levelUpItem1.previousLevel
        concept1NewLevel = levelUpItem1.newLevel
        concept1Name = levelUpItem1.concept.name
        concept1Icon = levelUpItem1.concept.icon
        
        concept2PriorLevel = levelUpItem2.previousLevel
        concept2NewLevel = levelUpItem2.newLevel
        concept2Name = levelUpItem2.concept.name
        concept2Icon = levelUpItem2.concept.icon
    }
    
    //MARK: - DoubleLevelUpViewModel Interface
    
    let concept1PriorLevel: Int
    let concept1NewLevel: Int
    let concept1Name: String
    let concept1Icon: String

    let concept2PriorLevel: Int
    let concept2NewLevel: Int
    let concept2Name: String
    let concept2Icon: String
    
    func dispatch(action: DoubleLevelUpAction) {
        switch action {
        case .next:
            handle_next()
        }
    }
    
    private func handle_next() {
        delegate?.next(self)
    }
    
}


