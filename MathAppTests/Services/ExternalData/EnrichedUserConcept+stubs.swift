//
//  EnrichedUserConcept+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/8/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension EnrichedUserConcept {
    static func createStub(conceptID: Int = 1, status: Status = .introductionComplete) -> EnrichedUserConcept {
        let concept = Concept(id: conceptID, name: "", description: "", rule: "", example: "")
        let userConcept = UserConcept(id: 1, concept: concept, strength: 1)
        return EnrichedUserConcept(userConcept: userConcept, statusCode: status.rawValue, currentScore: 0)!
    }
}
