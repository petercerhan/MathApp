//
//  ConceptMapSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class ConceptMapSceneTests: XCTestCase {
    
    func test_backPressed_shouldRequestBack() {
        let mockDelegate = FakeConceptMapViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.backButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.back_callCount, 1)
    }
    
    func test_tableViewDelegates_shouldBeSet() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.tableView.dataSource)
    }
    
    func test_oneConcept_shouldDisplayOneConcept() {
        //stub data
        
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        
        XCTAssertEqual(vc.tableView.dataSource?.tableView(vc.tableView, numberOfRowsInSection: 0), 1)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: ConceptMapViewModelDelegate? = nil) -> ConceptMapViewController {
        let delegate = fakeDelegate ?? FakeConceptMapViewModelDelegate()
        let vm = ConceptMapViewModel(delegate: delegate)
        return ConceptMapViewController(viewModel: vm)
    }
    
}
