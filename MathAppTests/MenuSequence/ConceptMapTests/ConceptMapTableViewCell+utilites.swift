//
//  ConceptMapTableViewCell+utilites.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

extension ConceptMapTableViewCell {
    
    static func assertCellAtRow(_ row: Int, inTable table: UITableView, containsConceptNamed name: String, strength: Int, file: StaticString = #file, line: UInt = #line) {
        let assertion = {
            guard let cell = table.cellForRow(at: IndexPath(row: row, section: 0)) as? ConceptMapTableViewCell else {
                XCTFail("Could not get cell", file: file, line: line)
                return
            }
            XCTAssertEqual(cell.nameLabel.text, name, file: file, line: line)
            XCTAssertEqual(cell.strengthLabel.text, "\(strength)/3", file: file, line: line)
        }
        XCTestCase().delayedAssertion(assertion)
    }
    
}
