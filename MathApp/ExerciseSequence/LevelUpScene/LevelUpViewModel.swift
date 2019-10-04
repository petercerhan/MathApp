//
//  LevelUpViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol LevelUpViewModelDelegate: class {
    func next(_ levelUpViewModel: LevelUpViewModel)
}

enum LevelUpAction {
    case next
}

class LevelUpViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: LevelUpViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: LevelUpViewModelDelegate, levelUpItem: LevelUpItem) {
        self.delegate = delegate
        conceptName = levelUpItem.concept.name
        previousLevel = levelUpItem.previousLevel
        newLevel = levelUpItem.newLevel
    }
    
    //MARK: - LevelUpViewModel Interface
    
    let conceptName: String
    let previousLevel: Int
    let newLevel: Int
    
    //MARK: - LevelUpViewModel Interface
    
    func dispatch(action: LevelUpAction) {
        switch action {
        case .next:
            handle_next()
        }
    }
    
    private func handle_next() {
        delegate?.next(self)
    }
    
}
