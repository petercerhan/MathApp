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
    case choice2
    case choice3
}

protocol ExerciseViewModel {
    var question: Observable<String> { get }
    var questionLatex: Observable<String> { get }
    var choice1: Observable<String> { get }
    var choice2: Observable<String> { get }
    var choice3: Observable<String> { get }
    var choice1Correct: Observable<Bool> { get }
    var choice2Correct: Observable<Bool> { get }
    var choice3Correct: Observable<Bool> { get }
    var displayState: Observable<ExerciseVCDisplayState> { get }
    
    func dispatch(action: ExerciseAction)
}

extension ExerciseViewModel where Self: ExerciseViewModelImpl {
    var choice1Correct: Observable<Bool> {
        return choice1CorrectSubject.asObservable()
    }
    var choice2Correct: Observable<Bool> {
        return choice2CorrectSubject.asObservable()
    }
    var choice3Correct: Observable<Bool> {
        return choice3CorrectSubject.asObservable()
    }
    var displayState: Observable<ExerciseVCDisplayState> {
        return displayStateSubject.asObservable()
    }
}

class ExerciseViewModelImpl: ExerciseViewModel {
    
    //MARK: - Config
    
    private let exercise: Exercise
    private let choiceConfiguration: ExerciseChoiceConfiguration
    private let choices: [String]
    
    //MARK: - Initialization
    
    init(exercise: Exercise, choiceConfiguration: ExerciseChoiceConfiguration) {
        self.exercise = exercise
        self.choiceConfiguration = choiceConfiguration
        
        let falseChoices = [exercise.falseAnswer1, exercise.falseAnswer2, exercise.falseAnswer3]
        let correctAnswer = exercise.answer
        
        var choices = [falseChoices[choiceConfiguration.firstFalseChoice - 1], falseChoices[choiceConfiguration.secondFalseChoice - 1]]
        switch choiceConfiguration.correctPosition {
        case 1:
            choices.insert(correctAnswer, at: 0)
        case 2:
            choices.insert(correctAnswer, at: 1)
        default:
            choices.insert(correctAnswer, at: 2)
        }
        
        self.choices = choices
    }
    
    private(set) lazy var question: Observable<String> = {
        Observable.just(exercise.questionText ?? "")
    }()
    
    private(set) lazy var questionLatex: Observable<String> = {
        Observable.just(exercise.questionLatex)
    }()
    
    private(set) lazy var choice1: Observable<String> = {
        Observable.just(choices[0])
    }()
    
    private(set) lazy var choice2: Observable<String> = {
        Observable.just(choices[1])
    }()
    
    private(set) lazy var choice3: Observable<String> = {
        Observable.just(choices[2])
    }()
    
    let choice1CorrectSubject = PublishSubject<Bool>()
    let choice2CorrectSubject = PublishSubject<Bool>()
    let choice3CorrectSubject = PublishSubject<Bool>()
    let displayStateSubject = BehaviorSubject<ExerciseVCDisplayState>(value: .question)
    
    //MARK: - ExerciseViewModel Interface
    
    func dispatch(action: ExerciseAction) {
        switch action {
        case .choice1:
            handle_choice1()
        case .choice2:
            handle_choice2()
        case .choice3:
            handle_choice3()
        }
    }
    
    private func handle_choice1() {
        showCorrectAnswer()
        if choiceConfiguration.correctPosition != 1 {
            choice1CorrectSubject.onNext(false)
        }
        displayStateSubject.onNext(.answer)
    }
    
    private func handle_choice2() {
        showCorrectAnswer()
        if choiceConfiguration.correctPosition != 2 {
            choice2CorrectSubject.onNext(false)
        }
        displayStateSubject.onNext(.answer)
    }
    
    private func handle_choice3() {
        showCorrectAnswer()
        if choiceConfiguration.correctPosition != 3 {
            choice3CorrectSubject.onNext(false)
        }
        displayStateSubject.onNext(.answer)
    }
    
    private func showCorrectAnswer() {
        if choiceConfiguration.correctPosition == 1 {
            choice1CorrectSubject.onNext(true)
        } else if choiceConfiguration.correctPosition == 2 {
            choice2CorrectSubject.onNext(true)
        } else {
            choice3CorrectSubject.onNext(true)
        }
    }
    
}
