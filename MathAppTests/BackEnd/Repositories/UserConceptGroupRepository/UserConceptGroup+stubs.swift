//
//  UserConceptGroup+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension UserConceptGroup {
    static func createStub(id: Int = 1, conceptGroupID: Int = 1, completed: Bool = false) -> UserConceptGroup {
        return UserConceptGroup(id: id, completed: completed, conceptGroup: ConceptGroup.createStub(id: conceptGroupID))
    }
}
