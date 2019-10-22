//
//  Concept+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/22/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension Concept {
    static func createStub(id: Int = 1) -> Concept {
        return Concept(id: id,
                       name: "Stub rule",
                       description: "This is the default rule",
                       rule: "x + y = z",
                       example: "1 + 2 = 3")
    }
}
