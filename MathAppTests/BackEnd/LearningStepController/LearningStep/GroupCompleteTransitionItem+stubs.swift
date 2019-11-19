//
//  GroupCompleteTransitionItem_stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension GroupCompleteTransitionItem {
    static func createStub() -> GroupCompleteTransitionItem {
        let completedConceptGroup = ConceptGroup.createStub(id: 1)
        let nextConceptGroup = ConceptGroup.createStub(id: 2)
        return GroupCompleteTransitionItem(completedConceptGroup: completedConceptGroup, nextConceptGroup: nextConceptGroup)
    }
}
