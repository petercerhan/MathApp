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
    func intFromRange(min: Int, max: Int) -> Int
    func setFromRange(min: Int, max: Int, selectionCount: Int) -> [Int]
    func setFromRange(min: Int, max: Int, selectionCount: Int, weightTable: [Double]) -> [Int]
    func nonRepeatingSetFromRange(min: Int, max: Int, selectionCount: Int) -> [Int]
}

class RandomizationServiceImpl: RandomizationService {
    
    func randomizedExerciseChoiceConfiguration() -> ExerciseChoiceConfiguration {
        let correctPosition = Int.random(in: 1...3)
        let firstFalseChoice = Int.random(in: 1...3)
        
        var secondFalseChoice = Int.random(in: 1...3)
        while secondFalseChoice == firstFalseChoice {
            secondFalseChoice = Int.random(in: 1...3)
        }
        
        return ExerciseChoiceConfiguration(correctPosition: correctPosition,
                                           firstFalseChoice: firstFalseChoice,
                                           secondFalseChoice: secondFalseChoice)
    }
    
    func intFromRange(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }
    
    func setFromRange(min: Int, max: Int, selectionCount: Int) -> [Int] {
        guard selectionCount > 0 else {
            return [Int]()
        }
        var result = [Int]()
        for _ in 1...selectionCount {
            let selection = Int.random(in: min...max)
            result.append(selection)
        }
        return result
    }
    
    func setFromRange(min: Int, max: Int, selectionCount: Int, weightTable: [Double]) -> [Int] {
        guard (max - min + 1) == weightTable.count, selectionCount > 0 else {
            return [Int]()
        }
        
        var cumulativeWeightTable = weightTable
        if weightTable.count > 1 {
            for i in 1..<cumulativeWeightTable.count {
                cumulativeWeightTable[i] += cumulativeWeightTable[i-1]
            }
        }
        
        var result = [Int]()
        
        for _ in 1...selectionCount {
            let random = Double.random(in: 0...1)
            var i = 0
            while random > cumulativeWeightTable[i] {
                i += 1
            }
            result.append(i + min)
        }
        
        return result
    }
    
    func nonRepeatingSetFromRange(min: Int, max: Int, selectionCount: Int) -> [Int] {
        guard (max - min + 1) >= selectionCount else {
            return [Int]()
        }
        
        var result = [Int]()
        
        while result.count < selectionCount {
            let selection = Int.random(in: min...max)
            if result.first(where: { $0 == selection }) == nil {
                result.append(selection)
            }
        }
        
        return result
    }
    
}
