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
    
    func dispatch(action: ExercisesStoreAction) {
        
    }
    
}
