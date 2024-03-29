//
//  NewMaterialState+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

extension NewMaterialState {
    static let table = Table("NewMaterialStates")
    
    static let column_id = Expression<Int64>("id")
    static let column_userID = Expression<Int64>("user_id")
    static let column_conceptGroupID = Expression<Int64>("concept_group_id")
    static let column_focusConcept1 = Expression<Int64>("focus_concept_1")
    static let column_focusConcept2 = Expression<Int64>("focus_concept_2")
    
    static func createFromQueryResult(_ row: Row) -> NewMaterialState {
        let id = Int(row[NewMaterialState.column_id])
        let userID = Int(row[NewMaterialState.column_userID])
        let conceptGroupID = Int(row[NewMaterialState.column_conceptGroupID])
        let focusConcept1 = Int(row[NewMaterialState.column_focusConcept1])
        let focusConcept2 = Int(row[NewMaterialState.column_focusConcept2])
        
        return NewMaterialState(id: id,
                                userID: userID,
                                conceptGroupID: conceptGroupID,
                                focusConcept1ID: focusConcept1,
                                focusConcept2ID: focusConcept2)
    }
}
