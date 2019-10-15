//
//  FeedPackageStrategyFactory.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/8/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol FeedPackageStrategyFactory {
    func createOneFocusStrategy(exerciseSetCalculator: ExerciseSetCalculator, concept1: EnrichedUserConcept, concept2: EnrichedUserConcept?) -> OneFocusStrategy
}
