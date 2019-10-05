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
    
    private(set) lazy var points: Observable<Int> = {
        resultsStore.correct
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

