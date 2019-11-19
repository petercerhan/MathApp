//
//  GroupCompleteSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import MathApp

class GroupCompleteSceneTests: XCTestCase {
    
    func test_group1to2_shouldShowGroup1and2() {
        let vm = GroupCompleteViewModel(groupCompleteItem: GroupCompleteTransitionItem.createStub())
        let vc = GroupCompleteViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.messageLabel.text, "You've completed: Stub Concept Group")
        XCTAssertEqual(vc.nextGroupButton.titleLabel?.text, "Next: Stub Concept Group")
    }
    
    
}
