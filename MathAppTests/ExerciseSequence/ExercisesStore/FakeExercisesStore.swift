//
//  FakeExercisesStore.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeExercisesStore: ExercisesStore {
    
    var exercises: Observable<[Exercise]> {
        return exercisesSubject.asObservable()
    }
    private var exercisesSubject = BehaviorSubject<[Exercise]>(value: [])
    
    func setStubExercises(_ exercises: [Exercise]) {
        exercisesSubject.onNext(exercises)
    }
    
    
    var setStubExercises_callCount = 0
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateExercises:
            setStubExercises([Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
            setStubExercises_callCount += 1
        }
    }
    
}
