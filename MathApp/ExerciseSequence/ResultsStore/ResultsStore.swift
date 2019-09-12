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
    
    //MARK: - State
    
    private var evaluated = 0
    private var correct = 0
    
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
        guard let priorCorrectValue = latestValue(of: correct, disposeBag: disposeBag) else {
            return
        }
        evaluated += 1
        if result.correct {
            correct += 1
            correctSubject.onNext(priorCorrectValue + 1)
        }
        if evaluated == 5 {
            incrementStrengthIfNeeded(conceptID: result.conceptID)
            evaluated = 0
            correct = 0
        }
    }
    
    private func incrementStrengthIfNeeded(conceptID: Int) {
        if correct >= 4 {
            databaseService.incrementStrengthForUserConcept(withID: conceptID)
        }
    }
    
}
