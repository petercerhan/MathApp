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
    func getExercises() -> Observable<FeedPackage>
    func getFeedPackage(introducedConceptID: Int) -> Observable<FeedPackage>
    
    func getExercise(id: Int) -> Observable<Exercise>
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
    
    var returnConceptIntroFlag = true
    
    func getExercises() -> Observable<FeedPackage> {
        if returnConceptIntroFlag {
            let conceptIntro = ConceptIntro(concept: Concept.constantRule)
            let feedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3], transitionItem: conceptIntro)
            
            returnConceptIntroFlag = false
            
            return Observable.just(feedPackage)
        } else {
            return getExercises_prior()
        }
    }
    
    func getFeedPackage(introducedConceptID: Int) -> Observable<FeedPackage> {
        //set conceptID seen
        
        
        return getExercises_prior()
    }
    
    func getExercises_prior() -> Observable<FeedPackage> {
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
        
        //randomly choose from arrays filtered by criteria
        var concept1DifficultyIndex = 0
        var concept2DifficultyIndex = 0
        
        var exercises = [Exercise]()
        
        for i in 0...conceptSelections.count - 1 {
            if conceptSelections[i] == 0 {
                //add concept 1 items
                var newExercise: Exercise? = nil
                
                while newExercise == nil {
                    let difficulty = concept1Difficulties[concept1DifficultyIndex]
                    let exercisePool = exercises_concept1.filter { $0.difficulty == difficulty }
                    let exerciseIndex = randomizationService.intFromRange(min: 0, max: exercisePool.count - 1)
                    let exercise = exercisePool[exerciseIndex]
                    if let _ = exercises.first(where: { $0.id == exercise.id }) {
                        continue
                    } else {
                        newExercise = exercise
                    }
                }
                
                exercises.append(newExercise!)
                concept1DifficultyIndex += 1
                
            } else {
                //add concept 2 items
                var newExercise: Exercise? = nil
                
                while newExercise == nil {
                    let difficulty = concept2Difficulties[concept2DifficultyIndex]
                    let exercisePool = exercises_concept2.filter { $0.difficulty == difficulty }
                    let exerciseIndex = randomizationService.intFromRange(min: 0, max: exercisePool.count - 1)
                    let exercise = exercisePool[exerciseIndex]
                    if let _ = exercises.first(where: { $0.id == exercise.id }) {
                        continue
                    } else {
                        newExercise = exercise
                    }
                }
                
                exercises.append(newExercise!)
                concept2DifficultyIndex += 1
            }
        }
    
        let feedPackage = FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
        
        return Observable.just(feedPackage)
    }
    
    func getExercise(id: Int) -> Observable<Exercise> {
        let exercise = databaseService.getExercise(id: id)
        return Observable.just(exercise ?? Exercise.exercise1)
    }
    
}
