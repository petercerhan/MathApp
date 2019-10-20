//
//  UserConcept+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension UserConcept {
    static func createStub(id: Int = 1, concept: Concept = Concept.constantRule, strength: Int = 0) -> UserConcept {
        return UserConcept(id: id, concept: concept, strength: strength)
    }
}
