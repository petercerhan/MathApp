//
//  Exercise+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

extension Exercise {
    static let table = Table("exercises")
    
    static let column_id = Expression<Int64>("id")
    static let column_questionText = Expression<String>("question_text")
    static let column_questionLatex = Expression<String>("question_latex")
    static let column_answer = Expression<String>("answer")
    static let column_falseAnswer1 = Expression<String>("false_answer_1")
    static let column_falseAnswer2 = Expression<String>("false_answer_2")
    static let column_falseAnswer3 = Expression<String>("false_answer_3")
    static let column_conceptID = Expression<Int64>("concept_id")
    
    static func createFromQueryResult(_ row: Row) -> Exercise? {
        let tableName = Exercise.table
        let id = Int(row[tableName[Exercise.column_id]])
        let questionText = row[tableName[Exercise.column_questionText]]
        let questionLatex = row[tableName[Exercise.column_questionLatex]]
        let answer = row[tableName[Exercise.column_answer]]
        let falseAnswer1 = row[tableName[Exercise.column_falseAnswer1]]
        let falseAnswer2 = row[tableName[Exercise.column_falseAnswer2]]
        let falseAnswer3 = row[tableName[Exercise.column_falseAnswer3]]
        
        guard let concept = Concept.createFromQueryResult(row) else {
            return nil
        }
        
        return Exercise(id: id,
                        questionText: questionText,
                        questionLatex: questionLatex,
                        answer: answer,
                        falseAnswer1: falseAnswer1,
                        falseAnswer2: falseAnswer2,
                        falseAnswer3: falseAnswer3,
                        concept: concept)
    }
    
    
    
}
