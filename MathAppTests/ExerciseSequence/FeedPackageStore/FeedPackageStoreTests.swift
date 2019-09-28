//
//  ExercisesStoreTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
import XCTest
@testable import MathApp

class FeedPackageStoreTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_updateExercises_requestsNewExercises() {
        let mockExerciseExternalDataService = FakeExerciseExternalDataService()
        let feedPackageStore = composeSUT(fakeExerciseExternalDataService: mockExerciseExternalDataService)
        
        feedPackageStore.dispatch(action: .updateFeedPackage)
        
        XCTAssertEqual(mockExerciseExternalDataService.getExercises_callCount, 1)
    }
    
    func test_updateExercises_externalDataReturnsThreeExercises_shouldEmitThreeExercises() {
        let feedPackageStore = composeSUT(stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        feedPackageStore.dispatch(action: .updateFeedPackage)
        
        guard let feedPackage = latestValue(of: feedPackageStore.feedPackage, disposeBag: disposeBag)?.data else {
            XCTFail("Could not get exercises")
            return
        }
        XCTAssertEqual(feedPackage.exercises.count, 3)
    }
    
    func test_updateExercises_receivesConceptIntroPackage_shouldEmitExercises() {
        let conceptIntroItem = ConceptIntro(concept: Concept.constantRule)
        let stubFeedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3], transitionItem: conceptIntroItem)
        let feedPackageStore = composeSUT(stubFeedPackage: stubFeedPackage)
        
        feedPackageStore.dispatch(action: .updateFeedPackage)
        
        guard let exercises = latestValue(of: feedPackageStore.feedPackage, disposeBag: disposeBag)?.data?.exercises else {
            XCTFail("Could not get exercises")
            return
        }
        XCTAssertEqual(exercises.count, 3)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeExerciseExternalDataService: FakeExerciseExternalDataService? = nil,
                    stubExercises: [Exercise]? = nil,
                    stubFeedPackage: FeedPackage? = nil) -> FeedPackageStore
    {
        let exerciseExternalDataService = fakeExerciseExternalDataService ?? FakeExerciseExternalDataService()
        if let stubExercises = stubExercises {
            exerciseExternalDataService.getExercises_stubData = FeedPackage(feedPackageType: .exercises, exercises: stubExercises, transitionItem: nil)
        }
        if let stubFeedPackage = stubFeedPackage {
            exerciseExternalDataService.getExercises_stubData = stubFeedPackage
        }
        return FeedPackageStoreImpl(exerciseExternalDataService: exerciseExternalDataService)
    }
    
}



