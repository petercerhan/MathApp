//
//  FakeExerciseExternalDataService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeExerciseExternalDataService: ExerciseExternalDataService {
    
    var stub_exercises = [Exercise]()
    
    var getNext_callCount = 0
    var getNext_conceptIDs = [[Int]]()

    func getNext(conceptIDs: [Int]) -> Observable<[Exercise]> {
        getNext_callCount += 1
        getNext_conceptIDs.append(conceptIDs)
        return Observable.just(stub_exercises)
    }
    
    var stubExercise: Exercise? = nil
    var get_callCount = 0
    
    func get(id: Int) -> Observable<Exercise?> {
        get_callCount += 1
        return Observable.just(stubExercise)
    }
    

    
}
