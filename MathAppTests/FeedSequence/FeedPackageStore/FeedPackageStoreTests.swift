//
//  ExercisesStoreTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
import XCTest
@testable import MathApp

class FeedPackageStoreTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_updateFeedPackage_requestsNewFeedPackage() {
        let mockExerciseExternalDataService = FakeFeedPackageExternalDataService()
        let feedPackageStore = composeSUT(fakeExerciseExternalDataService: mockExerciseExternalDataService)
        
        feedPackageStore.dispatch(action: .updateFeedPackage)
        
        XCTAssertEqual(mockExerciseExternalDataService.getExercises_callCount, 1)
    }
    
    func test_updateFeedPackage_setsFeedPackageStateLoading() {
        let feedPackageStore = composeSUT()
        let observer: TestableObserver<LoadState<FeedPackage>> = getNewObserver()
        _ = feedPackageStore.feedPackage.subscribe(observer)
        
        feedPackageStore.dispatch(action: .updateFeedPackage)
        
        assertSecondEventIsLoadingState(observer: observer)
    }
    
    func test_updateFeedPackage_externalDataReturnsFeedPackage_shouldEmitFeedPackage() {
        let feedPackageStore = composeSUT(stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        feedPackageStore.dispatch(action: .updateFeedPackage)
        
        guard let feedPackage = latestValue(of: feedPackageStore.feedPackage, disposeBag: disposeBag)?.data else {
            XCTFail("Could not get exercises")
            return
        }
        XCTAssertEqual(feedPackage.exercises.count, 3)
    }
    
    func test_setConceptIntroSeen_shouldSetFeedPackageStateLoading() {
        let feedPackageStore = composeSUT()
        let observer: TestableObserver<LoadState<FeedPackage>> = getNewObserver()
        _ = feedPackageStore.feedPackage.subscribe(observer)
        
        feedPackageStore.dispatch(action: .setConceptIntroSeen(conceptID: 1))
        
        assertSecondEventIsLoadingState(observer: observer)
    }
    
    func test_setConceptIntroSeen_shouldRequestsNewFeedPackageWithIntroducedConceptID() {
        let mockExerciseExternalDataService = FakeFeedPackageExternalDataService()
        let feedPackageStore = composeSUT(fakeExerciseExternalDataService: mockExerciseExternalDataService)
        
        feedPackageStore.dispatch(action: .setConceptIntroSeen(conceptID: 2))
        
        XCTAssertEqual(mockExerciseExternalDataService.getExercises_conceptID_callCount, 1)
        XCTAssertEqual(mockExerciseExternalDataService.getExercises_conceptID_conceptID.first, 2)
    }
    
    func test_setLevelUpSeen_shoulSetFeedPackageStateLoading() {
        let feedPackageStore = composeSUT()
        let observer: TestableObserver<LoadState<FeedPackage>> = getNewObserver()
        _ = feedPackageStore.feedPackage.subscribe(observer)
        
        feedPackageStore.dispatch(action: .setLevelUpSeen(conceptID: 1))
        
        assertSecondEventIsLoadingState(observer: observer)
    }
    
    func test_setLevelUpSeen_shouldRequestNewFeedPackageWithLevelUpConceptID() {
        let mockExerciseExternalDataService = FakeFeedPackageExternalDataService()
        let feedPackageStore = composeSUT(fakeExerciseExternalDataService: mockExerciseExternalDataService)
        
        feedPackageStore.dispatch(action: .setLevelUpSeen(conceptID: 2))
        
        XCTAssertEqual(mockExerciseExternalDataService.getFeedPackage_levelUp_callCount, 1)
        XCTAssertEqual(mockExerciseExternalDataService.getFeedPackage_levelUp_conceptID.first, 2)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeExerciseExternalDataService: FakeFeedPackageExternalDataService? = nil,
                    stubExercises: [Exercise]? = nil,
                    stubFeedPackage: FeedPackage? = nil) -> FeedPackageStore
    {
        let exerciseExternalDataService = fakeExerciseExternalDataService ?? FakeFeedPackageExternalDataService()
        if let stubExercises = stubExercises {
            exerciseExternalDataService.getExercises_stubData = FeedPackage(feedPackageType: .exercises, exercises: stubExercises, transitionItem: nil)
        }
        if let stubFeedPackage = stubFeedPackage {
            exerciseExternalDataService.getExercises_stubData = stubFeedPackage
        }
        return FeedPackageStoreImpl(feedPackageExternalDataService: exerciseExternalDataService)
    }
    
    func assertSecondEventIsLoadingState(observer: TestableObserver<LoadState<FeedPackage>>, file: StaticString = #file, line: UInt = #line) {
        guard observer.events.count > 1, let result = observer.events[1].value.element else {
            XCTFail("could not get second event", file: file, line: line)
            return
        }
        XCTAssert(result.isLoading, "Second event is not .loading", file: file, line: line)
    }
    
}



