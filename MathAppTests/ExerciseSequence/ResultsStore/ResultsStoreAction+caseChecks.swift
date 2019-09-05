//
//  ResultsStoreAction+caseChecks.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension ResultsStoreAction {
    var isincrementCorrectCase: Bool {
        if case .incrementCorrect = self {
            return true
        } else {
            return false
        }
    }
}
