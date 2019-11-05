//
//  DoubleLevelUpSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class DoubleLevelUpSceneTests: XCTestCase {
    
    func test_next_shouldRequestNext() {
        let mockDelegate = FakeDoubleLevelUpViewModelDelegate()
        let vm = DoubleLevelUpViewModel(delegate: mockDelegate, levelUpItem1: LevelUpItem.constantRuleItem, levelUpItem2: LevelUpItem.constantRuleItem)
        let vc = DoubleLevelUpViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.nextButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.next_callCount, 1)
    }
    
}
