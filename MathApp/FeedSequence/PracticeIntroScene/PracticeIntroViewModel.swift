//
//  PracticeIntroViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol PracticeIntroViewModelDelegate: class {
    func next(_ practiceIntroViewModel: PracticeIntroViewModel)
}

enum PracticeIntroAction {
    case next
}

class PracticeIntroViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: PracticeIntroViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: PracticeIntroViewModelDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - PracticeIntroViewModel Interface
    
    func dispatch(action: PracticeIntroAction) {
        switch action {
        case .next:
            handle_next()
        }
    }
    
    private func handle_next() {
        delegate?.next(self)
    }
    
}
