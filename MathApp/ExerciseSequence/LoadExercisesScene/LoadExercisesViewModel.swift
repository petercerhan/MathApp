//
//  LoadExercisesViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol LoadExercisesViewModelDelegate: class {
    func next(_ loadExercisesViewModel: LoadExercisesViewModel)
}

class LoadExercisesViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: LoadExercisesViewModelDelegate?
    private let feedPackageStore: FeedPackageStore
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(delegate: LoadExercisesViewModelDelegate, feedPackageStore: FeedPackageStore) {
        self.delegate = delegate
        self.feedPackageStore = feedPackageStore
        
        bindExercisesUpdate()
        feedPackageStore.dispatch(action: .updateFeedPackage)
    }
    
    private func bindExercisesUpdate() {
        feedPackageStore.feedPackage
            .compactMap { $0.data }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.delegate?.next(self)
            })
            .disposed(by: disposeBag)
    }
    
}
