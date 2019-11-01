//
//  ResultsStoreTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import MathApp

class ResultsStoreTests: XCTestCase {
    
    func test_correct_initialState_shouldBe0() {
        let store = composeSUT()
        
        let correct = latestValue(of: store.points) ?? -1
        XCTAssertEqual(correct, 0)
    }
    
    func test_correctResult_shouldIncrementCorrectCount() {
        let store = composeSUT()
        
        let result = ExerciseResult(correct: true, conceptID: 1)
        store.dispatch(action: .processResult(result))
        
        let correct = latestValue(of: store.points) ?? -1
        XCTAssertEqual(correct, 1)
    }
    
    func test_incorrectResult_shouldNotIncrementCorrectCount() {
        let store = composeSUT()
        
        let result = ExerciseResult(correct: false, conceptID: 1)
        store.dispatch(action: .processResult(result))
        
        let correct = latestValue(of: store.points) ?? -1
        XCTAssertEqual(correct, 0)
    }
    
    func test_learningStep_initialState_shouldBeNil() {
        let store = composeSUT()
        
        guard let learningStep = latestValue(of: store.learningStep) else {
            XCTFail("Could not get learning step value")
            return
        }
        XCTAssertNil(learningStep)
    }
    
    func test_setLearningStep_shouldSetLearningStep() {
        let store = composeSUT()
        
        store.dispatch(action: .setLearningStep(ConceptIntroLearningStep.createStub()))
        
        guard let learningStep = latestValue(of: store.learningStep) else {
            XCTFail("Could not get learning step value")
            return
        }
        XCTAssertNotNil(learningStep)
    }
    
    //MARK: - Benchmark Tests
    
    func test_setBenchmarks_oneBenchmark_shouldUpdateProgressState() {
        let store = composeSUT()
        
        store.dispatch(action: .setBenchmarks([ResultBenchmark(conceptID: 1, correctAnswersRequired: 4, correctAnswersOutOf: 6)]))
        
        assertProgressStateIs(correct: 0, required: 4, complete: false, store: store)
    }
    
    func test_setBenchmarks_twoBenchmarks_shouldUpdateProgressState() {
        let store = composeSUT()
        
        store.dispatch(action: .setBenchmarks([ResultBenchmark(conceptID: 1, correctAnswersRequired: 4, correctAnswersOutOf: 6),
                                               ResultBenchmark(conceptID: 2, correctAnswersRequired: 5, correctAnswersOutOf: 7)]))
        
        assertProgressStateIs(correct: 0, required: 9, complete: false, store: store)
    }
    
    func test_setBenchmarks_oneBenchmark_shouldClearCorrectInProgressState() {
        let store = composeSUT()
        
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .setBenchmarks([ResultBenchmark(conceptID: 1, correctAnswersRequired: 4, correctAnswersOutOf: 6)]))
        
        assertProgressStateIs(correct: 1, required: 4, complete: false, store: store)
    }
    
    func test_setBenchmarks_oneBenchmark_shouldUpdatePracticeConcepts() {
        let store = composeSUT()
        
        store.dispatch(action: .setBenchmarks([ResultBenchmark(conceptID: 1, correctAnswersRequired: 4, correctAnswersOutOf: 6)]))
        
        XCTAssertEqual(latestValue(of: store.practiceConcepts), [1])
    }
    
    func test_setBenchmarks_twoBenchmarks_shouldUpdatePracticeConcepts() {
        let store = composeSUT()
        
        store.dispatch(action: .setBenchmarks([ResultBenchmark(conceptID: 1, correctAnswersRequired: 4, correctAnswersOutOf: 6),
                                               ResultBenchmark(conceptID: 2, correctAnswersRequired: 5, correctAnswersOutOf: 7)]))
        
        XCTAssertEqual(latestValue(of: store.practiceConcepts), [1, 2])
    }
    
    //MARK: - Progress Indicator Tests
    
    func test_initialState_shouldShow0Of5() {
        let store = composeSUT()
        
        assertProgressStateIs(correct: 0, required: 5, complete: false, store: store)
    }
    
    //MARK: - Single Benchmark
    
    func test_5of7_scenario1_shouldShow0of5() {
        let store = composeSUT()
        
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        
        assertProgressStateIs(correct: 0, required: 5, complete: false, store: store)
    }
    
    func test_5of7_scenario2_shouldShow10f5() {
        let store = composeSUT()
        
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        
        assertProgressStateIs(correct: 1, required: 5, complete: false, store: store)
    }
    
    func test_5of7_scenario3_shouldShow3Of5() {
        let store = composeSUT()
        
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        
        assertProgressStateIs(correct: 3, required: 5, complete: false, store: store)
    }
    
    func test_5of7_scenario4_shouldShow5of5() {
        let store = composeSUT()
        
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        
        assertProgressStateIs(correct: 5, required: 5, complete: true, store: store)
    }
    
    func test_5of7_scenario5_shouldShow4of5() {
        let store = composeSUT()
        
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        
        assertProgressStateIs(correct: 4, required: 5, complete: false, store: store)
    }
    
    func test_5of7_scenario6_shouldShow5of5() {
        let store = composeSUT()
        
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        
        assertProgressStateIs(correct: 5, required: 5, complete: true, store: store)
    }
    
    //MARK: - Other Actions
    
    func test_reset_shouldSetCorrectTo0() {
        let store = composeSUT()
        
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .reset)
        
        assertProgressStateIs(correct: 0, required: 5, complete: false, store: store)
    }
    
    //MARK: - Compose SUT
    
    func composeSUT(fakeDatabaseService: DatabaseService? = nil) -> ResultsStore {
        return ResultsStoreImpl()
    }
    
    //MARK: - Assertions
    
    func assertProgressStateIs(correct: Int, required: Int, complete: Bool, store: ResultsStore, file: StaticString = #file, line: UInt = #line) {
        guard let progressState = latestValue(of: store.progressState) else {
            XCTFail("could not get progress state", file: file, line: line)
            return
        }
        XCTAssertEqual(progressState.correct, correct, file: file, line: line)
        XCTAssertEqual(progressState.required, required, file: file, line: line)
        XCTAssertEqual(progressState.complete, complete, file: file, line: line)
    }
    
}
