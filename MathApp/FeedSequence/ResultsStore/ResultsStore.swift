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
    var points: Observable<Int> { get }
    func dispatch(action: ResultsStoreAction)
}

enum ResultsStoreAction {
    case processResult(ExerciseResult)
}

extension ResultsStore where Self: ResultsStoreImpl {
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
    
    let pointsSubject = BehaviorSubject<Int>(value: 0)
    
    func dispatch(action: ResultsStoreAction) {
        switch action {
        case .processResult(let result):
            handle_processResult(result)
        }
    }
    
    private func handle_processResult(_ result: ExerciseResult) {
        results.append(result)
        reevaluatePoints(result: result)
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
