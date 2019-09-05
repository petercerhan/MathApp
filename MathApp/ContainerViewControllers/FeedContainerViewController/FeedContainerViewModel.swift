//
//  FeedContainerViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

class FeedContainerViewModel {
    
    //MARK: - Dependencies
    
    private let resultsStore: ResultsStore
    
    //MARK: - Initialization
    
    init(resultsStore: ResultsStore) {
        self.resultsStore = resultsStore
    }
    
    //MARK: - FeedContainerViewModel Interface
    
    private(set) lazy var points: Observable<Int> = {
        resultsStore.correct
            .share(replay: 1)
    }()
    
}
