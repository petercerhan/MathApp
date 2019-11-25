//
//  LearningStepStore.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol LearningStepStore {
    var learningStep: Observable<LoadState<LearningStep>> { get }
    func dispatch(action: LearningStepStoreAction)
}

enum LearningStepStoreAction {
    case next
}

extension LearningStepStore where Self: LearningStepStoreImpl {
    var learningStep: Observable<LoadState<LearningStep>> {
        return learningStepSubject.asObservable()
    }
}

class LearningStepStoreImpl: LearningStepStore {
    
    //MARK: - Dependencies
    
    private let learningStepExternalDataService: LearningStepExternalDataService
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(learningStepExternalDataService: LearningStepExternalDataService) {
        self.learningStepExternalDataService = learningStepExternalDataService
        
        learningStep
            .compactMap { $0.data }
            .subscribe(onNext: { [unowned self] learningStep in
                print("next learning step:\n\(learningStep)")
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - LearningStepStore Interface
    
    let learningStepSubject = BehaviorSubject<LoadState<LearningStep>>(value: .noData)
    
    func dispatch(action: LearningStepStoreAction) {
        switch action {
        case .next:
            handle_next()
        }
    }
    
    private func handle_next() {
        learningStepSubject.onNext(.loading)
        learningStepExternalDataService.getNext()
            .subscribe(onNext: { [unowned self] learningStep in
                self.learningStepSubject.onNext(.loaded(learningStep))
            })
            .disposed(by: disposeBag)
    }
    
}
