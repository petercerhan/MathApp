//
//  ConceptGroup+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension ConceptGroup {
    static func createStub(id: Int = 1) -> ConceptGroup {
        return ConceptGroup(id: id, name: "Stub Concept Group")
    }
}
