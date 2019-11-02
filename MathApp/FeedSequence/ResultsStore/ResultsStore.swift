//
//  ResultsStore.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol ResultsStore {
    var progressState: Observable<ProgressState> { get }
    var points: Observable<Int> { get }
    var learningStep: Observable<LearningStep?> { get }
    var practiceConcepts: Observable<[Int]> { get }
    func dispatch(action: ResultsStoreAction)
}

enum ResultsStoreAction {
    case processResult(ExerciseResult)
    case setLearningStep(LearningStep)
    case reset
    case setBenchmarks([ResultBenchmark])
}

extension ResultsStore where Self: ResultsStoreImpl {
    var progressState: Observable<ProgressState> {
        return progressStateSubject.asObservable()
    }
    var learningStep: Observable<LearningStep?> {
        return learningStepSubject.asObservable()
    }
    var points: Observable<Int> {
        return pointsSubject.asObservable()
    }
    var practiceConcepts: Observable<[Int]> {
        return practiceConceptsSubject.asObservable()
    }
}

class ResultsStoreImpl: ResultsStore {
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - State
    
    private var results = [ExerciseResult]()
    private var benchmarks = [ResultBenchmark(conceptID: 0, correctAnswersRequired: 5, correctAnswersOutOf: 7)]
    
    private func resetResults() {
        results = []
    }
    
    //MARK: - ResultsStore Interface
    
    let progressStateSubject = BehaviorSubject<ProgressState>(value: ProgressState(required: 5, correct: 0))
    let pointsSubject = BehaviorSubject<Int>(value: 0)
    let learningStepSubject = BehaviorSubject<LearningStep?>(value: nil)
    let practiceConceptsSubject = BehaviorSubject<[Int]>(value: [])
    
    func dispatch(action: ResultsStoreAction) {
        switch action {
        case .processResult(let result):
            handle_processResult(result)
        case .setLearningStep(let learningStep):
            handle_setLearningStep(learningStep)
        case .reset:
            handle_reset()
        case .setBenchmarks(let benchmarks):
            handle_setBenchmarks(benchmarks)
        }
    }
    
    private func handle_processResult(_ result: ExerciseResult) {
        recordResult(result: result)
        reevaluateProgressState()
        reevaluatePracticeConcepts()
        reevaluatePoints(result: result)
    }
    
    private func recordResult(result: ExerciseResult) {
        results.insert(result, at: 0)
    }
    
    private func reevaluatePoints(result: ExerciseResult) {
        guard let priorCorrectValue = latestValue(of: points, disposeBag: disposeBag) else {
            return
        }
        if result.correct {
            pointsSubject.onNext(priorCorrectValue + 1)
        }
    }
    
    private func handle_setLearningStep(_ learningStep: LearningStep) {
        learningStepSubject.onNext(learningStep)
    }
    
    private func handle_reset() {
        resetResults()
        reevaluateProgressState()
    }
    
    private func handle_setBenchmarks(_ benchmarks: [ResultBenchmark]) {
        self.benchmarks = benchmarks
        resetResults()
        reevaluateProgressState()
        reevaluatePracticeConcepts()
    }
    
    private func reevaluateProgressState() {
        let required = benchmarks.reduce(0) { $0 + $1.correctAnswersRequired }
        
        var correct = 0
        
        for benchmark in benchmarks {
            let sliceLength = benchmark.correctAnswersOutOf
            let resultsForConcept = results.filter { $0.conceptID == benchmark.conceptID }
            let sliceForConcept = resultsForConcept.prefix(sliceLength)
            let correctForConcept = sliceForConcept.reduce(0) { $0 + ($1.correct ? 1 : 0) }
            correct += min(correctForConcept, benchmark.correctAnswersRequired)
        }
        let progressState = ProgressState(required: required, correct: correct)
        
        progressStateSubject.onNext(progressState)
    }
    
    private func reevaluatePracticeConcepts() {
        var practiceConcepts = [Int]()
        for benchmark in benchmarks {
            let sliceLength = benchmark.correctAnswersOutOf
            let resultsForConcept = results.filter { $0.conceptID == benchmark.conceptID }
            let sliceForConcept = resultsForConcept.prefix(sliceLength)
            let correctForConcept = sliceForConcept.reduce(0) { $0 + ($1.correct ? 1 : 0) }
            if correctForConcept < benchmark.correctAnswersRequired {
                practiceConcepts.append(benchmark.conceptID)
            }
        }
        
        practiceConceptsSubject.onNext(practiceConcepts)
    }
    
}

