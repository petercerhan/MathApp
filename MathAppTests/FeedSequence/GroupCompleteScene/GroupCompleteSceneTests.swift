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
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.messageLabel.text, "You've completed: Stub Concept Group")
        XCTAssertEqual(vc.nextGroupButton.titleLabel?.text, "Next: Stub Concept Group")
    }
    
    func test_nextGroup_requestsNextGroup() {
        let mockDelegate = FakeGroupCompleteViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.nextGroupButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.nextGroup_callCount, 1)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: FakeGroupCompleteViewModelDelegate? = nil) -> GroupCompleteViewController {
        let delegate = fakeDelegate ?? FakeGroupCompleteViewModelDelegate()
        let vm = GroupCompleteViewModel(delegate: delegate, groupCompleteItem: GroupCompleteTransitionItem.createStub())
        return GroupCompleteViewController(viewModel: vm)
    }
}
