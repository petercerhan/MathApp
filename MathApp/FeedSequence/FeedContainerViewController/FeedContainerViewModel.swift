//
//  FeedContainerViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol FeedContainerViewModelDelegate: class {
    func menu(_ feedContainerViewModel: FeedContainerViewModel)
}

enum FeedContainerAction {
    case menu
}

class FeedContainerViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: FeedContainerViewModelDelegate?
    private let resultsStore: ResultsStore
    
    //MARK: - Initialization
    
    init(delegate: FeedContainerViewModelDelegate?, resultsStore: ResultsStore) {
        self.delegate = delegate
        self.resultsStore = resultsStore
    }
    
    //MARK: - FeedContainerViewModel Interface
    
    private(set) lazy var progressRatio: Observable<Double> = {
        resultsStore.progressState
            .map { progressState -> Double in
                if progressState.required == 0 {
                    return 0
                } else {
                    return Double(progressState.correct) / Double(progressState.required)
                }
            }
            .share(replay: 1)
    }()
    
    private(set) lazy var points: Observable<Int> = {
        resultsStore.points
            .share(replay: 1)
    }()
    
    func setDelegate(_ delegate: FeedContainerViewModelDelegate) {
        self.delegate = delegate
    }
    
    func dispatch(action: FeedContainerAction) {
        switch action {
        case .menu:
            handle_menu()
        }
    }
    
    private func handle_menu() {
        delegate?.menu(self)
    }
    
}

