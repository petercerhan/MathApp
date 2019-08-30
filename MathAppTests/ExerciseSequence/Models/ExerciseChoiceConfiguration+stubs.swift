//
//  ExerciseChoiceConfiguration+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension ExerciseChoiceConfiguration {
    static func buildStub() -> ExerciseChoiceConfiguration {
        return ExerciseChoiceConfiguration(correctPosition: 1, firstFalseChoice: 1, secondFalseChoice: 2)
    }
}
