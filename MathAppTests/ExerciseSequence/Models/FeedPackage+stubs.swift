//
//  FeedPackage+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/28/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension FeedPackage {

    static func createExercisesStub(exercises: [Exercise]) -> FeedPackage {
        return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
    }
    
    
    static var exercisesPackage: FeedPackage {
        let exercises = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
    }
    
    static var constantRuleIntro: FeedPackage {
        let exercises = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        let transitionItem = ConceptIntro(concept: Concept.constantRule)
        return FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: transitionItem)
    }

}