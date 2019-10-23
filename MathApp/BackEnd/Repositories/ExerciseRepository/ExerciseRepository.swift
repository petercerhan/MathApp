//
//  ExerciseRepository.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/22/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

protocol ExerciseRepository {
    func list(conceptID: Int) -> [Exercise]
    func get(id: Int) -> Exercise?
}

class ExerciseRepositoryImpl: ExerciseRepository {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - ExerciseRepository Interface
    
    func list(conceptID: Int) -> [Exercise] {
        let query = Exercise.table.join(Concept.table, on: Concept.table[Concept.column_id] == Exercise.table[Exercise.column_conceptID])
                    .filter(Exercise.column_conceptID == Int64(conceptID))

        let result: [Exercise]? = try? databaseService.db.prepare(query).compactMap { row -> Exercise? in
            return Exercise.createFromQueryResult(row)
        }

        return result ?? [Exercise]()
    }
       
   func get(id: Int) -> Exercise? {
        let query = Exercise.table.join(Concept.table, on: Concept.table[Concept.column_id] == Exercise.table[Exercise.column_conceptID])
           .filter(Exercise.table[Exercise.column_id] == Int64(id))

        guard let exerciseRow = try? databaseService.db.pluck(query) else {
           return nil
       }
       
       return Exercise.createFromQueryResult(exerciseRow)
   }
    
}
