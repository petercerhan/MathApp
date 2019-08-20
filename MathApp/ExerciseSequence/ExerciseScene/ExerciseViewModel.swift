//
//  ExerciseViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

class ExerciseViewModel {
    
    //MARK: - Config
    
    private let exercise: Exercise
    
    //MARK: - Initialization
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    private(set) lazy var question: Observable<String> = {
        Observable.just(exercise.questionText ?? "")
    }()
    
    private(set) lazy var questionLatex: Observable<String> = {
        Observable.just(exercise.questionLatex)
    }()
    
    private(set) lazy var choice1: Observable<String> = {
        Observable.just(exercise.answer)
    }()
    
    private(set) lazy var choice2: Observable<String> = {
        Observable.just(exercise.falseAnswer1)
    }()
    
    private(set) lazy var choice3: Observable<String> = {
        Observable.just(exercise.falseAnswer2)
    }()
    
}
