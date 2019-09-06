//
//  InfoViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol InfoViewModelDelegate: class {
    func quit(_ infoViewModel: InfoViewModel)
}

enum InfoAction {
    case quit
}

class InfoViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: InfoViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: InfoViewModelDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - InfoViewModel Interface
    
    func dispatch(action: InfoAction) {
        switch action {
        case .quit:
            handle_quit()
        }
    }
    
    private func handle_quit() {
        delegate?.quit(self)
    }

}

