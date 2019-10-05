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
    var correct: Observable<Int> { get }
    func dispatch(action: ResultsStoreAction)
}

enum ResultsStoreAction {
    case processResult(ExerciseResult)
}

extension ResultsStore where Self: ResultsStoreImpl {
    var correct: Observable<Int> {
        return correctSubject.asObservable()
    }
}

class ResultsStoreImpl: ResultsStore {
    
    //MARK: - DatabaseService
    
    private let databaseService: DatabaseService
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - ResultsStore Interface
    
    let correctSubject = BehaviorSubject<Int>(value: 0)
    
    func dispatch(action: ResultsStoreAction) {
        switch action {
        case .processResult(let result):
            handle_processResult(result)
        }
    }
    
    private func handle_processResult(_ result: ExerciseResult) {
        databaseService.recordResult(concept_id: result.conceptID, correct: result.correct)
        reevaluatePoints(result: result)
    }
    
    private func reevaluatePoints(result: ExerciseResult) {
        guard let priorCorrectValue = latestValue(of: correct, disposeBag: disposeBag) else {
            return
        }
        if result.correct {
            correctSubject.onNext(priorCorrectValue + 1)
        }
    }
    
}
