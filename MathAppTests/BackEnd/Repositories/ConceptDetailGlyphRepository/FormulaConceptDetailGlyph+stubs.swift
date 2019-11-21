//
//  FormulaConceptDetailGlyph+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension FormulaConceptDetailGlyph {
    static func createStub() -> FormulaConceptDetailGlyph {
        return FormulaConceptDetailGlyph(latex: "x + y = z", sequence: 1, displayGroup: 1)
    }
}
