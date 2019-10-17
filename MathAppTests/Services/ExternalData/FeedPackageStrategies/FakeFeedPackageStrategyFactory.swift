//
//  FakeFeedPackageStrategyFactory.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/8/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeFeedPackageStrategyFactory: FeedPackageStrategyFactory {

    var createOneFocusStrategy_callCount = 0
    var createOneFocusStrategy_concept1 = [EnrichedUserConcept]()
    var createOneFocusStrategy_concept2 = [EnrichedUserConcept?]()
    
    func createOneFocusStrategy(exerciseSetCalculator: ExerciseSetCalculator, concept1: EnrichedUserConcept, concept2: EnrichedUserConcept?) -> OneFocusStrategy {
        createOneFocusStrategy_callCount += 1
        createOneFocusStrategy_concept1.append(concept1)
        createOneFocusStrategy_concept2.append(concept2)
        
        return FakeOneFocusStrategy()
    }
    
    var createTwoFocusStrategy_callCount = 0
    var createTwoFocusStrategy_concept1 = [EnrichedUserConcept]()
    var createTwoFocusStrategy_concept2 = [EnrichedUserConcept?]()
    
    func createTwoFocusStrategy(exerciseSetCalculator: ExerciseSetCalculator, concept1: EnrichedUserConcept, concept2: EnrichedUserConcept) -> TwoFocusStrategy {
        createTwoFocusStrategy_callCount += 1
        createTwoFocusStrategy_concept1.append(concept1)
        createTwoFocusStrategy_concept2.append(concept2)
        
        return FakeTwoFocusStrategy()
    }
    
}

