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
    private let feedPackageStore: FeedPackageStore
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(delegate: PrepareFeedViewModelDelegate, feedPackageStore: FeedPackageStore) {
        self.delegate = delegate
        self.feedPackageStore = feedPackageStore
        bindFeedPackageLoad()
        feedPackageStore.dispatch(action: .updateFeedPackage)
    }
    
    private func bindFeedPackageLoad() {
        feedPackageStore.feedPackage
            .observeOn(MainScheduler.instance)
            .filter { $0.isLoaded }
            .take(1)
            .subscribe(onNext: { [unowned self] loadState in
                self.delegate?.next(self)
            })
            .disposed(by: disposeBag)
    }
    
}
