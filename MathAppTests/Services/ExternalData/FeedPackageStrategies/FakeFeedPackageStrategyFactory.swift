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

    var createStandardFeedPackageStrategy_callCount = 0
    var createStandardFeedPackageStrategy_concept1 = [EnrichedUserConcept]()
    var createStandardFeedPackageStrategy_concept2 = [EnrichedUserConcept?]()
    func createStandardFeedPackageStrategy(exerciseSetCalculator: ExerciseSetCalculator, concept1: EnrichedUserConcept, concept2: EnrichedUserConcept?) -> StandardFeedPackageStrategy {
        createStandardFeedPackageStrategy_callCount += 1
        createStandardFeedPackageStrategy_concept1.append(concept1)
        createStandardFeedPackageStrategy_concept2.append(concept2)
        
        return FakeStandardFeedPackageStrategy()
    }
    
}
