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
        let query = NewMaterialState.table.filter(NewMaterialState.column_id == 1)
        
        guard let row = try? databaseService.db.pluck(query) else {
            return NewMaterialState(id: 1, userID: 1, focusConcept1ID: 0, focusConcept2ID: 0)
        }
        
        return NewMaterialState.createFromQueryResult(row)
    }
    
    func setFocus(concept1ID: Int, concept2ID: Int) {
        let query = NewMaterialState.table.filter(NewMaterialState.column_userID == Int64(1))
        _ = try? databaseService.db.run(query.update(NewMaterialState.column_focusConcept1 <- Int64(concept1ID),
                                     NewMaterialState.column_focusConcept2 <- Int64(concept2ID)))
    }
    
}
