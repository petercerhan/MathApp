//
//  ChooseExerciseSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/24/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class ChooseExerciseSceneTests: XCTestCase {
    
    func test_back_shouldRequestBack() {
        let mockDelegate = FakeChooseExerciseViewModelDelegate()
        let vm = ChooseExerciseViewModel(delegate: mockDelegate)
        let vc = ChooseExerciseViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.backButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.back_callCount, 1)
    }
    
    func test_submit_textFieldValue1_shouldrequestExerciseWithID1() {
        let mockDelegate = FakeChooseExerciseViewModelDelegate()
        let vm = ChooseExerciseViewModel(delegate: mockDelegate)
        let vc = ChooseExerciseViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.textField.text = "1"
        vc.submitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.loadExercise_callCount, 1)
        XCTAssertEqual(mockDelegate.loadExercise_id.first, 1)
    }
    
    func test_submit_textFieldValue99_shouldrequestExerciseWithID99() {
        let mockDelegate = FakeChooseExerciseViewModelDelegate()
        let vm = ChooseExerciseViewModel(delegate: mockDelegate)
        let vc = ChooseExerciseViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.textField.text = "99"
        vc.submitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.loadExercise_callCount, 1)
        XCTAssertEqual(mockDelegate.loadExercise_id.first, 99)
    }
    
    func test_submit_textFieldNoValue_shouldNotRequestExercise() {
        let mockDelegate = FakeChooseExerciseViewModelDelegate()
        let vm = ChooseExerciseViewModel(delegate: mockDelegate)
        let vc = ChooseExerciseViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.submitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.loadExercise_callCount, 0)
    }
    
    func test_submit_textFieldNonIntegerValue_shouldNotRequestExercise() {
        let mockDelegate = FakeChooseExerciseViewModelDelegate()
        let vm = ChooseExerciseViewModel(delegate: mockDelegate)
        let vc = ChooseExerciseViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.textField.text = "lsjkdf"
        vc.submitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.loadExercise_callCount, 0)
    }
    
    
}
