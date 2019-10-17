//
//  StandardFeedPackageStrategyFactory.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/8/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class DefaultFeedPackageStrategyFactory: FeedPackageStrategyFactory {
    func createOneFocusStrategy(exerciseSetCalculator: ExerciseSetCalculator, concept1: EnrichedUserConcept, concept2: EnrichedUserConcept?) -> OneFocusStrategy {
        return DefaultOneFocusStrategy(exerciseSetCalculator: exerciseSetCalculator, enrichedUserConcept: concept1)
    }
    
    func createTwoFocusStrategy(exerciseSetCalculator: ExerciseSetCalculator, concept1: EnrichedUserConcept, concept2: EnrichedUserConcept) -> TwoFocusStrategy {
        return DefaultTwoFocusStrategy(exerciseSetCalculator: exerciseSetCalculator, enrichedUserConcept1: concept1, enrichedUserConcept2: concept2)
    }
    
}
