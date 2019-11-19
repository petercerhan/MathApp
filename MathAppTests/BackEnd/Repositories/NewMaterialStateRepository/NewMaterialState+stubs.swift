//
//  NewMaterialState+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension NewMaterialState {
    static func createStub(conceptGroupID: Int = 1, focusConcept1ID: Int = 0, focusConcept2ID: Int = 0) -> NewMaterialState {
        return NewMaterialState(id: 1, userID: 1, conceptGroupID: conceptGroupID, focusConcept1ID: focusConcept1ID, focusConcept2ID: focusConcept2ID)
    }
}
