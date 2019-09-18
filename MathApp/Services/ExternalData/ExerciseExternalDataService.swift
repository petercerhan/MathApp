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
    
    //MARK: - ExerciseExternalDataService Interface
    
    func getExercises() -> Observable<[Exercise]> {
        return Observable<[Exercise]>.just([Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
    }
    
    
    
    
    
    
    
    
}
