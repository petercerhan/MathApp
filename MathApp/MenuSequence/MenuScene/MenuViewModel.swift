//
//  MenuViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol MenuViewModelDelegate: class {
    func conceptMap(_ menuViewModel: MenuViewModel)
}

enum MenuAction {
    case conceptMap
}

class MenuViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: MenuViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: MenuViewModelDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - MenuViewModel Interface
    
    func dispatch(action: MenuAction) {
        switch action {
        case .conceptMap:
            handle_conceptMap()
        }
    }
    
    private func handle_conceptMap() {
        delegate?.conceptMap(self)
    }
    
}
