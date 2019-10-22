//
//  PrepareFeedSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import MathApp

class PrepareFeedSceneTests: XCTestCase {
    
    func test_onLoad_shouldRequestLearningStep() {
        let mockLearningStepStore = FakeLearningStepStore()
        let vm = PrepareFeedViewModel(delegate: FakePrepareFeedViewModelDelegate(), learningStepStore: mockLearningStepStore)
        let vc = PrepareFeedViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockLearningStepStore.next_callCount, 1)
    }
    
    func test_learningStepLoaded_shouldRequestNextScene() {
        let mockDelegate = FakePrepareFeedViewModelDelegate()
        let stubLearningStepStore = FakeLearningStepStore()
        stubLearningStepStore.learningStep = Observable.just(.loaded(ConceptIntroLearningStep(conceptID: 1)))
        let vm = PrepareFeedViewModel(delegate: mockDelegate, learningStepStore: stubLearningStepStore)
        let vc = PrepareFeedViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockDelegate.next_callCount, 1)
    }
    
}

