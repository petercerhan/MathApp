//
//  LearningStepStore.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxTest
@testable import MathApp

class LearningStepStoreTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_next_shouldRequestNextLearningStep() {
        let mockLearningStepEDS = FakeLearningStepExternalDataService()
        let learningStepStore = composeSUT(fakeLearningStepEDS: mockLearningStepEDS)
        
        learningStepStore.dispatch(action: .next)
        
        XCTAssertEqual(mockLearningStepEDS.getNext_callCount, 1)
    }
    
    func test_learningStepInitialState_shouldBeNoData() {
        let learningStepStore = composeSUT()
        let observer: TestableObserver<LoadState<LearningStep>> = getNewObserver()
        _ = learningStepStore.learningStep.subscribe(observer)
        
        XCTAssertEqual(observer.events[0].value.element?.isNoData, true)
    }
    
    func test_next_shouldSetLearningStepLoading() {
        let learningStepStore = composeSUT()
        let observer: TestableObserver<LoadState<LearningStep>> = getNewObserver()
        _ = learningStepStore.learningStep.subscribe(observer)
        
        learningStepStore.dispatch(action: .next)
        
        assertSecondEventIsLoadingState(observer: observer)
    }
    
    func test_next_shouldEmitLearningStep() {
        let stubLearningStepEDS = FakeLearningStepExternalDataService()
        stubLearningStepEDS.stubLearningStep = ConceptIntroLearningStep(conceptID: 2)
        let learningStepStore = composeSUT(fakeLearningStepEDS: stubLearningStepEDS)
        
        learningStepStore.dispatch(action: .next)
        
        guard let conceptIntro = latestValue(of: learningStepStore.learningStep, disposeBag: disposeBag)?.data as? ConceptIntroLearningStep else {
            XCTFail("Latest value is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntro.conceptID, 2)
    }
    
    //MARK: - SUT Composition
    
    private func composeSUT(fakeLearningStepEDS: FakeLearningStepExternalDataService? = nil) -> LearningStepStore {
        let learningStepEDS = fakeLearningStepEDS ?? FakeLearningStepExternalDataService()
        return LearningStepStoreImpl(learningStepExternalDataService: learningStepEDS)
    }
    
    //MARK: - Assertions
    
    func assertSecondEventIsLoadingState(observer: TestableObserver<LoadState<LearningStep>>, file: StaticString = #file, line: UInt = #line) {
        guard observer.events.count > 1, let result = observer.events[1].value.element else {
            XCTFail("could not get second event", file: file, line: line)
            return
        }
        XCTAssert(result.isLoading, "Second event is not .loading", file: file, line: line)
    }
    
}
