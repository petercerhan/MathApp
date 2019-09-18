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
    
    var stubExercises = [[Exercise]()]
    var stubIndex = 0
    
    func setStubExercises(_ exercises: [[Exercise]]) {
        stubIndex = 0
        stubExercises = exercises
        nextStubExercise()
    }
    
    private func nextStubExercise() {
        print("will show exercises at index \(stubIndex)")
        let exercises = stubExercises[stubIndex]
        exercisesSubject.onNext(exercises)
        stubIndex = (stubIndex + 1) % stubExercises.count
    }
    
    var updateExercises_callCount = 0
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateExercises:
            nextStubExercise()
            updateExercises_callCount += 1
        }
    }
    
}
