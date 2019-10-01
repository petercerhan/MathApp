//
//  UserConcept+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

extension UserConcept {
    static let table = Table("user_concepts")
    
    static let column_id = Expression<Int64>("id")
    static let column_conceptID = Expression<Int64>("concept_id")
    static let column_strength = Expression<Int64>("strength")
    static let column_status = Expression<Int64>("status")
    static let column_exercise_result_0 = Expression<Int64>("exercise_result_0")
    static let column_exercise_result_1 = Expression<Int64>("exercise_result_1")
    static let column_exercise_result_2 = Expression<Int64>("exercise_result_2")
    static let column_exercise_result_3 = Expression<Int64>("exercise_result_3")
    static let column_exercise_result_4 = Expression<Int64>("exercise_result_4")
    static let column_exercise_result_5 = Expression<Int64>("exercise_result_5")
    static let column_exercise_result_6 = Expression<Int64>("exercise_result_6")
    static let column_latest_result_index = Expression<Int64>("latest_result_index")
    
    static func createFromQueryResult(_ row: Row) -> UserConcept? {
        let tableName = UserConcept.table
        let id = Int(row[tableName[UserConcept.column_id]])
        let strength = Int(row[tableName[UserConcept.column_strength]])
        
        guard let concept = Concept.createFromQueryResult(row) else {
            return nil
        }
        
        return UserConcept(id: id, concept: concept, strength: strength)
    }
    
    var insertStatement: Insert {
        return UserConcept.table.insert(UserConcept.column_id <- Int64(id),
                                    UserConcept.column_conceptID <- Int64(concept.id),
                                    UserConcept.column_strength <- Int64(strength))
    }
}
