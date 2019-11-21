//
//  ConceptDetailDiagramTableViewCell.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

extension ConceptDetailDiagramTableViewCell {
    static func assertCellAtRowIsDiagram(_ row: Int, inTable table: UITableView, file: StaticString = #file, line: UInt = #line) {
        let assertion = {
            guard let _ = table.cellForRow(at: IndexPath(row: row, section: 0)) as? ConceptDetailDiagramTableViewCell else {
                XCTFail("Could not get cell or cell is not diagram", file: file, line: line)
                return
            }
        }
        XCTestCase().delayedAssertion(assertion)
    }
}
