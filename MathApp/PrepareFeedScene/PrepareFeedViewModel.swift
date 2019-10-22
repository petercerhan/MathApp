//
//  PrepareFeedViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol PrepareFeedViewModelDelegate: class {
    func next(_ prepareFeedViewModel: PrepareFeedViewModel)
}

class PrepareFeedViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: PrepareFeedViewModelDelegate?
    private let learningStepStore: LearningStepStore
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(delegate: PrepareFeedViewModelDelegate, learningStepStore: LearningStepStore) {
        self.delegate = delegate
        self.learningStepStore = learningStepStore
        bindFeedPackageLoad()
        learningStepStore.dispatch(action: .next)
    }
    
    private func bindFeedPackageLoad() {
        learningStepStore.learningStep
            .observeOn(MainScheduler.instance)
            .filter { $0.isLoaded }
            .take(1)
            .subscribe(onNext: { [unowned self] loadState in
                self.delegate?.next(self)
            })
            .disposed(by: disposeBag)
    }
    
}
