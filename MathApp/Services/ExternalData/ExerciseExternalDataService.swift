//
//  ExerciseExternalDataService.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol ExerciseExternalDataService {
    func getExercises() -> Observable<[Exercise]>
}

class ExerciseExternalDataServiceImpl: ExerciseExternalDataService {

    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    private let randomizationService: RandomizationService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService, randomizationService: RandomizationService) {
        self.databaseService = databaseService
        self.randomizationService = randomizationService
    }
    
    //MARK: - ExerciseExternalDataService Interface
    
    func getExercises() -> Observable<[Exercise]> {
        let concept1 = Concept.constantRule
        let concept2 = Concept.linearRule
        
        let exercises_concept1 = databaseService.getExercises(forConceptID: concept1.id)
        let exercises_concept2 = databaseService.getExercises(forConceptID: concept2.id)
        
        //randomly select which concept to choose from
        let conceptSelections = randomizationService.setFromRange(min: 0, max: 1, selectionCount: 3)
        let concept1Count = conceptSelections.reduce(0) { $0 + ($1 == 0 ? 1 : 0) }
        let concept2Count = conceptSelections.reduce(0) { $0 + ($1 == 1 ? 1 : 0)}
        
        //use weighted selection to choose difficulties
        let concept1Difficulties = randomizationService.setFromRange(min: 1, max: 3, selectionCount: concept1Count, weightTable: [0.2, 0.6, 0.2])
        let concept2Difficulties = randomizationService.setFromRange(min: 1, max: 3, selectionCount: concept2Count, weightTable: [0.2, 0.6, 0.2])
        
        print("1 diff: \(concept1Difficulties)")
        print("2 diff: \(concept2Difficulties)")
        
        //randomly choose from arrays filtered by criteria
        
        
        
        
        
        return Observable<[Exercise]>.just([Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
    }
    
    
}
