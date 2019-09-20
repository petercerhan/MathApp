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
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - ExerciseExternalDataService Interface
    
    func getExercises() -> Observable<[Exercise]> {
        let concept1 = Concept.constantRule
        let concept2 = Concept.linearRule
        
        let exercises_concept1 = databaseService.getExercises(forConceptID: concept1.id)
        let exercises_concept2 = databaseService.getExercises(forConceptID: concept2.id)
        
        print("count exercises: \(exercises_concept1.count)")
        
        return Observable<[Exercise]>.just([Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
    }
    
    
}
