//
//  ConceptMapViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol ConceptMapViewModelDelegate: class {
    func back(_ conceptMapViewModel: ConceptMapViewModel)
}

enum ConceptMapAction {
    case back
}

class ConceptMapViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: ConceptMapViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: ConceptMapViewModelDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - ConceptMapViewModel Interface
    
    let conceptMapElements = Observable<[ConceptMapElement]>.just([ConceptMapElement(name: "concept 1", strength: 2)])
    
    func dispatch(action: ConceptMapAction) {
        switch action {
        case .back:
            handle_back()
        }
    }
    
    private func handle_back() {
        delegate?.back(self)
    }
    
}
