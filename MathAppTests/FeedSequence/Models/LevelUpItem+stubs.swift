//
//  LevelUpItem+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension LevelUpItem {
    static var constantRuleItem: LevelUpItem {
        return LevelUpItem(concept: Concept.constantRule, previousLevel: 0, newLevel: 1)
    }
}
