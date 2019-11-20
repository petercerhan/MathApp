//
//  FakeConceptDetailGlyphRepository.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeConceptDetailGlyphRepository: ConceptDetailGlyphRepository {

    var glyphStubs = [ConceptDetailGlyph]()

    func list(conceptID: Int) -> [ConceptDetailGlyph] {
        return glyphStubs
    }
    
}
