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
    
    private var progressMap = [String: ProgressRecord]()
    struct ProgressRecord {
        var evaluated = 0
        var correct = 0
    }
    
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
//        reevaluateStrengths(result: result)
    }
    
    private func reevaluatePoints(result: ExerciseResult) {
        guard let priorCorrectValue = latestValue(of: correct, disposeBag: disposeBag) else {
            return
        }
        if result.correct {
            correctSubject.onNext(priorCorrectValue + 1)
        }
    }
    
    private func reevaluateStrengths(result: ExerciseResult) {
        var progressRecord = progressMap["\(result.conceptID)"] ?? ProgressRecord()
        
        progressRecord.evaluated += 1
        if result.correct {
            progressRecord.correct += 1
        }
        if progressRecord.evaluated == 5 {
            incrementStrengthIfNeeded(progressRecord: progressRecord, conceptID: result.conceptID)
            decrementStrengthIfNeeded(progressRecord: progressRecord, conceptID: result.conceptID)
            progressRecord.evaluated = 0
            progressRecord.correct = 0
        }
        
        progressMap["\(result.conceptID)"] = progressRecord
    }
    
    private func incrementStrengthIfNeeded(progressRecord: ProgressRecord, conceptID: Int) {
        if progressRecord.correct >= 4 {
            databaseService.incrementStrengthForUserConcept(withID: conceptID)
        }
    }
    
    private func decrementStrengthIfNeeded(progressRecord: ProgressRecord, conceptID: Int) {
        if progressRecord.correct <= 2 {
            databaseService.decrementStrengthForUserConcept(withID: conceptID)
        }
    }
    
}
