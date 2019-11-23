//
//  DiagramExerciseViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol DiagramExerciseViewModel {
    var diagramCode: String { get }
}

class DiagramExerciseViewModelImpl: ExerciseViewModelImpl, DiagramExerciseViewModel {
    
    //MARK: - Initialization
    
    init(delegate: ExerciseViewModelDelegate,
         resultsStore: ResultsStore,
         exercise: Exercise,
         diagram: String,
         choiceConfiguration: ExerciseChoiceConfiguration)
    {
        diagramCode = diagram
        super.init(delegate: delegate,
                   resultsStore: resultsStore,
                   exercise: exercise,
                   choiceConfiguration: choiceConfiguration)
    }
    
    //MARK: - DiagramExerciseViewModel
    
    let diagramCode: String
    
}
