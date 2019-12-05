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
    private let userConceptEDS: UserConceptExternalDataService
    private let userConceptGroupEDS: UserConceptGroupExternalDataService
    
    //MARK: - Initialization
    
    init(delegate: ConceptMapViewModelDelegate,
         userConceptEDS: UserConceptExternalDataService,
         userConceptGroupEDS: UserConceptGroupExternalDataService)
    {
        self.delegate = delegate
        self.userConceptEDS = userConceptEDS
        self.userConceptGroupEDS = userConceptGroupEDS
    }
    
    //MARK: - ConceptMapViewModel Interface
    
    private(set) lazy var mapElements: Observable<[ConceptMapElement]> = {
        conceptMapBridgeItems
            .map { $0.map { $0.mapElement } }
            .share(replay: 1)
    }()
    
    private lazy var conceptMapBridgeItems: Observable<[MapBridgeItem]> = {
        Observable.combineLatest(concepts, conceptGroups) { ($0, $1) }
            .map { [weak self] concepts, conceptGroups -> [MapBridgeItem] in
                guard let self = self else {
                    return []
                }
                
                return self.conceptMapElementsFrom(userConcepts: concepts, userConceptGroups: conceptGroups)
            }
            .share(replay: 1)
    }()
    
    private func conceptMapElementsFrom(userConcepts: [UserConcept], userConceptGroups: [UserConceptGroup]) -> [MapBridgeItem] {
        var sectionedResult = [(group: MapBridgeItem, concepts: [MapBridgeItem])]()
        
        for userConceptGroup in userConceptGroups {
            let mapElement = GroupConceptMapElement(name: userConceptGroup.conceptGroup.name)
            let bridgeItem = MapBridgeItem(mapElement: mapElement, userConceptGroup: userConceptGroup)
            sectionedResult.append( (group: bridgeItem, concepts: []) )
        }
        
        for userConcept in userConcepts {
            let mapElement = ContentConceptMapElement(name: userConcept.concept.name)
            let bridgeItem = MapBridgeItem(mapElement: mapElement, userConcept: userConcept)
            if let sectionIndex = sectionedResult.firstIndex(where: { ($0.group.userConceptGroup?.conceptGroup.id ?? 0) == userConcept.concept.groupID} ) {
                sectionedResult[sectionIndex].concepts.append(bridgeItem)
            }
        }
        
        var result = [MapBridgeItem]()
        for section in sectionedResult {
            result.append(section.group)
            result += section.concepts
        }
        
        return result
    }
    
    private lazy var concepts: Observable<[UserConcept]> = {
        userConceptEDS.list(chapterID: 2)
            .share(replay: 1)
    }()

    private lazy var conceptGroups: Observable<[UserConceptGroup]> = {
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
    
    //MARK: - Utilities
    
    struct MapBridgeItem {
        let mapElement: ConceptMapElement
        let userConcept: UserConcept?
        let userConceptGroup: UserConceptGroup?
        
        init(mapElement: ConceptMapElement, userConcept: UserConcept) {
            self.mapElement = mapElement
            self.userConcept = userConcept
            self.userConceptGroup = nil
        }
        
        init(mapElement: ConceptMapElement, userConceptGroup: UserConceptGroup) {
            self.mapElement = mapElement
            self.userConceptGroup = userConceptGroup
            self.userConcept = nil
        }
        
    }
    
}
