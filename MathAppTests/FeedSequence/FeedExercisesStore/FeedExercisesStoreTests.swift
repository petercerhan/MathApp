//
//  FeedExercisesStoreTest.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxTest
@testable import MathApp

class FeedExercisesStoreTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    func test_initialState_shouldBeNoData() {
        let store = composeSUT()
        let observer: TestableObserver<LoadState<[Exercise]>> = getNewObserver()
        _ = store.exercises.subscribe(observer)
        
        XCTAssertEqual(observer.events[0].value.element?.isNoData, true)
    }
    
    func test_refresh_shouldRequestNewExercises() {
        let mockExerciseEDS = FakeExerciseExternalDataService()
        let store = composeSUT(fakeExerciseEDS: mockExerciseEDS)
        
        store.dispatch(action: .refresh)
        
        XCTAssertEqual(mockExerciseEDS.getNext_callCount, 1)
    }
    
    func test_refresh_shouldSetStateLoading() {
        let store = composeSUT()
        let observer: TestableObserver<LoadState<[Exercise]>> = getNewObserver()
        _ = store.exercises.subscribe(observer)
        
        store.dispatch(action: .refresh)
        
        assertSecondEventIsLoadingState(observer: observer)
    }
    
    func test_refresh_shouldEmitExercises() {
        let stubExerciseEDS = FakeExerciseExternalDataService()
        stubExerciseEDS.stub_exercises = [Exercise.exercise1, Exercise.exercise2]
        let store = composeSUT(fakeExerciseEDS: stubExerciseEDS)
        
        store.dispatch(action: .refresh)
        
        guard let exercises = latestValue(of: store.exercises, disposeBag: disposeBag)?.data else {
            XCTFail("could not get exercises")
            return
        }
        XCTAssertEqual(exercises.count, 2)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeExerciseEDS: FakeExerciseExternalDataService? = nil) -> FeedExercisesStoreImpl {
        let exerciseEDS = fakeExerciseEDS ?? FakeExerciseExternalDataService()
        return FeedExercisesStoreImpl(exerciseExternalDataService: exerciseEDS)
    }
    
    //MARK: - Assertions
    
    func assertSecondEventIsLoadingState(observer: TestableObserver<LoadState<[Exercise]>>, file: StaticString = #file, line: UInt = #line) {
        guard observer.events.count > 1, let result = observer.events[1].value.element else {
            XCTFail("could not get second event", file: file, line: line)
            return
        }
        XCTAssert(result.isLoading, "Second event is not .loading", file: file, line: line)
    }
    
}
