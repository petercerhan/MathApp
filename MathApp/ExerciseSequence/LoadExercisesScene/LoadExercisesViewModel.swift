//
//  LoadExercisesViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class LoadExercisesViewModel {
    
    //MARK: - Dependencies
    
    private let exercisesStore: ExercisesStore
    
    //MARK: - Initialization
    
    init(exercisesStore: ExercisesStore) {
        self.exercisesStore = exercisesStore
        
        exercisesStore.dispatch(action: .updateExercises)
    }
    
}
