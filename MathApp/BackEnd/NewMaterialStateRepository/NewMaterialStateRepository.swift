//
//  NewMaterialStateRepository.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

protocol NewMaterialStateRepository {
    func get() -> NewMaterialState
    func setFocus(concept1ID: Int, concept2ID: Int)
}

class NewMaterialStateRepositoryImpl: NewMaterialStateRepository {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - NewMaterialStateRepository Interface
    
    func get() -> NewMaterialState {
        return NewMaterialState(id: 1, userID: 1, focusConcept1ID: 0, focusConcept2ID: 0)
    }
    
    func setFocus(concept1ID: Int, concept2ID: Int) {
        
    }
    
}
