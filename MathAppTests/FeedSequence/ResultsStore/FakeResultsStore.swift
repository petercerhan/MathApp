//
//  FakeResultsStore.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import MathApp

class FakeResultsStore: ResultsStore {
    
    var practiceConcepts = Observable<[Int]>.just([])
    
    var learningStep = Observable<LearningStep?>.just(nil)
    
    var progressState = Observable<ProgressState>.just(ProgressState(required: 5, correct: 0))

    var points = Observable<Int>.just(0)
    
    
    var setLearningStep_callCount = 0
    
    var processResult_callCount = 0
    var processResult_result = [ExerciseResult]()
    
    var reset_callCount = 0
    
    var setBenchmarks_callCount = 0
    var setBenchmarks_benchmarks = [[ResultBenchmark]]()
    
    func dispatch(action: ResultsStoreAction) {
        switch action {
        case .setLearningStep:
            setLearningStep_callCount += 1
        case .processResult(let exerciseResult):
            processResult_callCount += 1
            processResult_result.append(exerciseResult)
        case .reset:
            reset_callCount += 1
        case .setBenchmarks(let benchmarks):
            setBenchmarks_callCount += 1
            setBenchmarks_benchmarks.append(benchmarks)
        }
    }
    
}
