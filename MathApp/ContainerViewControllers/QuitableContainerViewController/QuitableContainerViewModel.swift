//
//  QuitableContainerViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol QuitableContainerViewModel {
    func setDelegate(_ delegate: QuitableContainerViewModelDelegate?)
    func dispatch(action: QuitableContainerAction)
}

protocol QuitableContainerViewModelDelegate: class {
    func quit(_ quitableContainerViewModel: QuitableContainerViewModel)
}

enum QuitableContainerAction {
    case quit
}

class QuitableContainerViewModelImpl: QuitableContainerViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: QuitableContainerViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: QuitableContainerViewModelDelegate?) {
        self.delegate = delegate
    }
    
    //MARK: - QuitableWorldViewModel Interface
    
    func setDelegate(_ delegate: QuitableContainerViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func dispatch(action: QuitableContainerAction) {
        switch action {
        case .quit:
            handle_quit()
        }
    }
    
    private func handle_quit() {
        delegate?.quit(self)
    }
}
