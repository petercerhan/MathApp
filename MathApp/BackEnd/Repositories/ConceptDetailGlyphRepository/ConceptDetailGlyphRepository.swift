//
//  ConceptDetailGlyphRepository.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

protocol ConceptDetailGlyphRepository {
    func list(conceptID: Int) -> [ConceptDetailGlyph]
}

class ConceptDetailGlyphRepositoryImpl: ConceptDetailGlyphRepository {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - ConceptDetailGlyphRepository Interface
    
    func list(conceptID: Int) -> [ConceptDetailGlyph] {
        let query = table.filter(column_conceptID == Int64(conceptID))
        let rows = try? databaseService.db.prepare(query).compactMap { conceptDetailGlyph(fromRow: $0) }
        return rows ?? []
    }
    
    private func conceptDetailGlyph(fromRow row: Row) -> ConceptDetailGlyph? {
        guard let type = ConceptDetailGlyphType(rawValue: Int(row[column_type])) else {
            return nil
        }
        switch type {
        case .text:
            return nil
        case .formula:
            return formulaGlyph(fromRow: row)
        case .diagram:
            return nil
        }
    }
    
    private func formulaGlyph(fromRow row: Row) -> ConceptDetailGlyph? {
        guard let latex = row[column_latex] else {
            return nil
        }
        let sequence = Int(row[column_sequence])
        let displayGroup = Int(row[column_displayGroup])
        return FormulaConceptDetailGlyph(latex: latex, sequence: sequence, displayGroup: displayGroup)
    }
    
    //MARK: - SQLite Constants
    
    private let column_conceptID = Expression<Int64>("concept_id")
    private let column_type = Expression<Int64>("concept_detail_glyph_type")
    private let column_text = Expression<String?>("text")
    private let column_latex = Expression<String?>("latex")
    private let column_diagram = Expression<String?>("diagram")
    private let column_sequence = Expression<Int64>("sequence")
    private let column_displayGroup = Expression<Int64>("display_group")
    private let table = Table("concept_detail_glyphs")
}
