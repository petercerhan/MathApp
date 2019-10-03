//
//  LevelUpSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class LevelUpSceneTests: XCTestCase {
    
    func test_level0To1_shouldShow0to1Transition() {
        let stubLevelUpItem = LevelUpItem(concept: Concept.constantRule, previousLevel: 0, newLevel: 1)
        let viewModel = LevelUpViewModel(levelUpItem: stubLevelUpItem)
        let vc = LevelUpViewController(viewModel: viewModel)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.levelUpLabel.text, "Level *0* to level *1*")
    }
    
    func test_constantRule_shouldShowConstantRuleInTitle() {
        let stubLevelUpItem = LevelUpItem(concept: Concept.constantRule, previousLevel: 0, newLevel: 1)
        let viewModel = LevelUpViewModel(levelUpItem: stubLevelUpItem)
        let vc = LevelUpViewController(viewModel: viewModel)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.conceptLabel.text, Concept.constantRule.name)
    }
    
}
