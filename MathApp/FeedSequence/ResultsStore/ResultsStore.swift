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
    func dispatch(action: ResultsStoreAction)
}

enum ResultsStoreAction {
    case processResult(ExerciseResult)
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
}

class ResultsStoreImpl: ResultsStore {
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - State
    
    private var results = [ExerciseResult]()
    
    //MARK: - ResultsStore Interface
    
    let progressStateSubject = BehaviorSubject<ProgressState>(value: ProgressState(required: 5, correct: 0))
    let pointsSubject = BehaviorSubject<Int>(value: 0)
    let learningStepSubject = BehaviorSubject<LearningStep?>(value: nil)
    
    func dispatch(action: ResultsStoreAction) {
        switch action {
        case .processResult(let result):
            handle_processResult(result)
        }
    }
    
    private func handle_processResult(_ result: ExerciseResult) {
        reevaluateProgressState(result: result)
        reevaluatePoints(result: result)
    }
    
    private func reevaluateProgressState(result: ExerciseResult) {
        results.insert(result, at: 0)
        let recentResults = Array(results.prefix(7))
        var correct = recentResults.reduce(0) { $0 + ($1.correct ? 1 : 0) }
        correct = min(correct, 5)
        let progressState = ProgressState(required: 5, correct: correct)
        progressStateSubject.onNext(progressState)
    }
    
    private func reevaluatePoints(result: ExerciseResult) {
        guard let priorCorrectValue = latestValue(of: points, disposeBag: disposeBag) else {
            return
        }
        if result.correct {
            pointsSubject.onNext(priorCorrectValue + 1)
        }
    }
    
}

