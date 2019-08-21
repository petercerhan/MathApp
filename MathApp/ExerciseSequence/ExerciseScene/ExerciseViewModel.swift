//
//  ExerciseViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

enum ExerciseAction {
    case choice1
}

protocol ExerciseViewModel {
    var question: Observable<String> { get }
    var questionLatex: Observable<String> { get }
    var choice1: Observable<String> { get }
    var choice2: Observable<String> { get }
    var choice3: Observable<String> { get }
    var choice1Correct: Observable<Bool> { get }
    
    func dispatch(action: ExerciseAction)
}

extension ExerciseViewModel where Self: ExerciseViewModelImpl {
    var choice1Correct: Observable<Bool> {
        return choice1CorrectSubject.asObservable()
    }
}

class ExerciseViewModelImpl: ExerciseViewModel {
    
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
    
    let choice1CorrectSubject = PublishSubject<Bool>()
    
    //MARK: - ExerciseViewModel Interface
    
    func dispatch(action: ExerciseAction) {
        switch action {
        case .choice1:
            handle_choice1()
        }
    }
    
    private func handle_choice1() {
        choice1CorrectSubject.onNext(true)
    }
    
}
