//
//  ConceptDetailFormulaTableViewCell+utilities.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

extension ConceptDetailFormulaTableViewCell {
    static func assertCellAtRow(_ row: Int, inTable table: UITableView, containsFormula formula: String, file: StaticString = #file, line: UInt = #line) {
        let assertion = {
            guard let cell = table.cellForRow(at: IndexPath(row: row, section: 0)) as? ConceptDetailFormulaTableViewCell else {
                XCTFail("Could not get cell", file: file, line: line)
                return
            }
            XCTAssertEqual(cell.formulaLabel.latex, formula, file: file, line: line)
        }
        XCTestCase().delayedAssertion(assertion)
        
    }
    
}
