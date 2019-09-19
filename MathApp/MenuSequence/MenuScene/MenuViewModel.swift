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
    case resetDB
}

class MenuViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: MenuViewModelDelegate?
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(delegate: MenuViewModelDelegate, databaseService: DatabaseService) {
        self.delegate = delegate
        self.databaseService = databaseService
    }
    
    //MARK: - MenuViewModel Interface
    
    func dispatch(action: MenuAction) {
        switch action {
        case .conceptMap:
            handle_conceptMap()
        case .resetDB:
            handle_resetDB()
        }
    }
    
    private func handle_conceptMap() {
        delegate?.conceptMap(self)
    }
    
    private func handle_resetDB() {
        databaseService.reset()
    }
    
}
