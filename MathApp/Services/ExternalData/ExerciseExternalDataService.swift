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
    func getNext() -> Observable<[Exercise]>
}

class ExerciseExternalDataServiceImpl: ExerciseExternalDataService {
    
    //MARK: - Dependencies
    
    private let exerciseController: ExerciseController
    
    //MARK: - Initialization
    
    init(exerciseController: ExerciseController) {
        self.exerciseController = exerciseController
    }
    
    //MARK: - ExerciseExternalDataService Interface

    func getNext() -> Observable<[Exercise]> {
        let exercises = exerciseController.getExercises()
        return Observable.just(exercises)
    }

}
