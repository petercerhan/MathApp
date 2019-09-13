//
//  FakeExerciseExternalDataService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeExerciseExternalDataService: ExerciseExternalDataService {

    var getExercises_stubData = [Exercise]()
    var getExercises_callCount = 0
    
    func getExercises() -> Observable<[Exercise]> {
        getExercises_callCount += 1
        return Observable<[Exercise]>.just(getExercises_stubData)
    }
}
