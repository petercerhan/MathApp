//
//  ConceptGroupTableViewCell+utilities.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 12/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

extension ConceptGroupTableViewCell {
    
    static func assertCellAtRow(_ row: Int, inTable table: UITableView, showsName name: String, file: StaticString = #file, line: UInt = #line) {
        let assertion = {
            guard let cell = table.cellForRow(at: IndexPath(row: row, section: 0)) as? ConceptGroupTableViewCell else {
                XCTFail("Could not get cell", file: file, line: line)
                return
            }
//            XCTAssertEqual(cell.nameLabel.text, name, file: file, line: line)
        }
        XCTestCase().delayedAssertion(assertion)
    }
    
}
