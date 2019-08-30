//
//  RandomizationService.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol RandomizationService {
    func randomizedExerciseChoiceConfiguration() -> ExerciseChoiceConfiguration
}

class RandomizationServiceImpl: RandomizationService {
    
    func randomizedExerciseChoiceConfiguration() -> ExerciseChoiceConfiguration {
        let correctPosition = Int.random(in: 1...3)
        let firstFalseChoice = Int.random(in: 1...3)
        
        var secondFalseChoice = Int.random(in: 1...3)
        while secondFalseChoice == firstFalseChoice {
            secondFalseChoice = Int.random(in: 1...3)
        }
        
        return ExerciseChoiceConfiguration(correctPosition: correctPosition, firstFalseChoice: firstFalseChoice, secondFalseChoice: secondFalseChoice)
    }
    
}
