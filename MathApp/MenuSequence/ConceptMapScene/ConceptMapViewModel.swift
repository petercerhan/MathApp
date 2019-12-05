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
    private let userConceptGroupEDS: UserConceptGroupExternalDataService
    
    //MARK: - Initialization
    
    init(delegate: ConceptMapViewModelDelegate,
         databaseService: DatabaseService,
         userConceptEDS: UserConceptExternalDataService,
         userConceptGroupEDS: UserConceptGroupExternalDataService)
    {
        self.delegate = delegate
        self.databaseService = databaseService
        self.userConceptEDS = userConceptEDS
        self.userConceptGroupEDS = userConceptGroupEDS
    }
    
    //MARK: - ConceptMapViewModel Interface
    
    private(set) lazy var conceptMapElements: Observable<[ConceptMapElement]> = {
        userConceptEDS.list(chapterID: 2)
            .map { $0.map { ConceptMapElement(name: $0.concept.name, strength: $0.strength) } }
            .share(replay: 1)
    }()
    
    private(set) lazy var conceptGroups: Observable<[UserConceptGroup]> = {
        userConceptGroupEDS.list(chapterID: 2)
            .share(replay: 1)
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
