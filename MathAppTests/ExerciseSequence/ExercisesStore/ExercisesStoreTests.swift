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

class ExercisesStoreTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_updateExercises_reqeustsNewExercises() {
        let mockExerciseExternalDataService = FakeExerciseExternalDataService()
        let exerciseStore = composeSUT(fakeExerciseExternalDataService: mockExerciseExternalDataService)
        
        exerciseStore.dispatch(action: .updateExercises)
        
        XCTAssertEqual(mockExerciseExternalDataService.getExercises_callCount, 1)
    }
    
    func test_updateExercises_externalDataReturnsThreeExercises_shouldEmitThreeExercises() {
        let exerciseStore = composeSUT(stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        exerciseStore.dispatch(action: .updateExercises)
        
        guard let exercises = latestValue(of: exerciseStore.exercises, disposeBag: disposeBag) else {
            XCTFail("Could not get exercises")
            return
        }
        XCTAssertEqual(exercises.count, 3)
    }
    
    func test_updateExercises_receivesExercisesPackage_shouldSetTransitionItemNil() {
        let exerciseStore = composeSUT(stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        exerciseStore.dispatch(action: .updateExercises)
        
        guard let transitionItem = latestValue(of: exerciseStore.transitionItem, disposeBag: disposeBag) else {
            XCTFail("Could not get transition item")
            return
        }
        XCTAssertNil(transitionItem)
    }
    
    func test_updateExercises_receivesConceptIntroPackage_shouldEmitConceptIntro() {
        let conceptIntroItem = ConceptIntro(concept: Concept.constantRule, exercises: [Exercise.exercise1])
        let stubFeedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3], transitionItem: conceptIntroItem)
        let exerciseStore = composeSUT(stubFeedPackage: stubFeedPackage)
        
        exerciseStore.dispatch(action: .updateExercises)
        
        guard let transitionItem = latestValue(of: exerciseStore.transitionItem, disposeBag: disposeBag) as? ConceptIntro else {
            XCTFail("No conceptIntro item")
            return
        }
        XCTAssertEqual(transitionItem.concept.id, 1)
    }
    
    func test_updateExercises_receivesConceptIntroPackage_shouldEmitExercises() {
        let conceptIntroItem = ConceptIntro(concept: Concept.constantRule, exercises: [Exercise.exercise1])
        let stubFeedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3], transitionItem: conceptIntroItem)
        let exerciseStore = composeSUT(stubFeedPackage: stubFeedPackage)
        
        exerciseStore.dispatch(action: .updateExercises)
        
        guard let exercises = latestValue(of: exerciseStore.exercises, disposeBag: disposeBag) else {
            XCTFail("Could not get exercises")
            return
        }
        XCTAssertEqual(exercises.count, 3)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeExerciseExternalDataService: FakeExerciseExternalDataService? = nil,
                    stubExercises: [Exercise]? = nil,
                    stubFeedPackage: FeedPackage? = nil) -> ExercisesStore
    {
        let exerciseExternalDataService = fakeExerciseExternalDataService ?? FakeExerciseExternalDataService()
        if let stubExercises = stubExercises {
            exerciseExternalDataService.getExercises_stubData = FeedPackage(feedPackageType: .exercises, exercises: stubExercises, transitionItem: nil)
        }
        if let stubFeedPackage = stubFeedPackage {
            exerciseExternalDataService.getExercises_stubData = stubFeedPackage
        }
        return ExercisesStoreImpl(exerciseExternalDataService: exerciseExternalDataService)
    }
    
}



