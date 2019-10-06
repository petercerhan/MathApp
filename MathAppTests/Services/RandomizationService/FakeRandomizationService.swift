//
//  FakeRandomizationService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeRandomizationService: RandomizationService {
    
    func randomizedExerciseChoiceConfiguration() -> ExerciseChoiceConfiguration {
        return ExerciseChoiceConfiguration(correctPosition: 1, firstFalseChoice: 1, secondFalseChoice: 2)
    }
    
    //MARK: - intFromRange(min: max: )
    
    var intFromRange_stubSequence = [0, 1, 2]
    private var intFromRangeSelection = 0
    func intFromRange(min: Int, max: Int) -> Int {
        let result = intFromRange_stubSequence[intFromRangeSelection]
        intFromRangeSelection = (intFromRangeSelection + 1) % intFromRange_stubSequence.count
        return result
    }
    
    //MARK: - setFromRange(min: max: selectionCount: )
    
    var setFromRange_stub : [Int]?
    func setFromRange(min: Int, max: Int, selectionCount: Int) -> [Int] {
        let defaultStub = Array<Int>(repeating: min, count: selectionCount)
        let stub = setFromRange_stub ?? defaultStub
        return stub
    }
    
    //MARK: - setFromRange(min: max: selectionCount: weightTable: )
    
    func setFromRange(min: Int, max: Int, selectionCount: Int, weightTable: [Double]) -> [Int] {
        return Array<Int>(repeating: min, count: selectionCount)
    }
    
    //MARK: - nonRepeatingSetFromRange(min: max: selectionCount: )
    
    func nonRepeatingSetFromRange(min: Int, max: Int, selectionCount: Int) -> [Int] {
        var result = [Int]()
        for i in 1...selectionCount {
            result.append(min + i - 1)
        }
        
        return result
    }
    
}

