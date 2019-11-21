//
//  ConceptDetailTextTableViewCell+utilities.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

extension ConceptDetailTextTableViewCell {
    static func assertCellAtRow(_ row: Int, inTable table: UITableView, containsText text: String, file: StaticString = #file, line: UInt = #line) {
        let assertion = {
            guard let cell = table.cellForRow(at: IndexPath(row: row, section: 0)) as? ConceptDetailTextTableViewCell else {
                XCTFail("Could not get cell or is not text cell", file: file, line: line)
                return
            }
            XCTAssertEqual(cell.customTextLabel?.text, text, file: file, line: line)
        }
        XCTestCase().delayedAssertion(assertion)
    }
}
