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
    private let userConceptEDS: UserConceptExternalDataService
    
    //MARK: - Initialization
    
    init(delegate: ConceptMapViewModelDelegate, databaseService: DatabaseService, userConceptEDS: UserConceptExternalDataService) {
        self.delegate = delegate
        self.databaseService = databaseService
        self.userConceptEDS = userConceptEDS
    }
    
    //MARK: - ConceptMapViewModel Interface
    
    private(set) lazy var conceptMapElements: Observable<[ConceptMapElement]> = {
//        let userConcepts = databaseService.getUserConcepts()
        userConceptEDS.list(chapterID: 2)
            .map { $0.map { ConceptMapElement(name: $0.concept.name, strength: $0.strength) } }
            .share(replay: 1)

//        let elements = userConcepts.map { ConceptMapElement(name: $0.concept.name, strength: $0.strength) }
//        return Observable.just(elements)
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
