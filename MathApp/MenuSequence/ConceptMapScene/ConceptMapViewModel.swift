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
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(delegate: ConceptMapViewModelDelegate, databaseService: DatabaseService) {
        self.delegate = delegate
        self.databaseService = databaseService
    }
    
    //MARK: - ConceptMapViewModel Interface
    
    private(set) lazy var conceptMapElements: Observable<[ConceptMapElement]> = {
        let userConcepts = databaseService.getUserConcepts()
        let elements = userConcepts.map { ConceptMapElement(name: $0.concept.name, strength: $0.strength) }
        return Observable.just(elements)
    }()
    
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
