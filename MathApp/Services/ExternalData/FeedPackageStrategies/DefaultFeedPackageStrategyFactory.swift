//
//  StandardFeedPackageStrategyFactory.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/8/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class DefaultFeedPackageStrategyFactory: FeedPackageStrategyFactory {
    func createStandardFeedPackageStrategy(exerciseSetCalculator: ExerciseSetCalculator, concept1: EnrichedUserConcept, concept2: EnrichedUserConcept?) -> StandardFeedPackageStrategy {
        
        if concept2 == nil {
            // this will return two concept standard strategy
        }
        else {
        }
        
        return DefaultStandardFeedPackageStrategy(exerciseSetCalculator: exerciseSetCalculator, enrichedUserConcept: concept1)
    }
}
