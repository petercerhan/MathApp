//
//  ExerciseExternalDataService.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol ExerciseExternalDataService {
    func getNext(conceptIDs: [Int]) -> Observable<[Exercise]>
    func get(id: Int) -> Observable<Exercise?>
}

class ExerciseExternalDataServiceImpl: ExerciseExternalDataService {
    
    //MARK: - Dependencies
    
    private let exerciseController: ExerciseController
    
    //MARK: - Initialization
    
    init(exerciseController: ExerciseController) {
        self.exerciseController = exerciseController
    }
    
    //MARK: - ExerciseExternalDataService Interface

    func getNext(conceptIDs: [Int]) -> Observable<[Exercise]> {
        let exercises = exerciseController.getExercises(conceptIDs: conceptIDs)
        return Observable.just(exercises)
    }
    
    func get(id: Int) -> Observable<Exercise?> {
        let exercise = exerciseController.getExercise(id: id)
        return Observable.just(exercise)
    }

}
