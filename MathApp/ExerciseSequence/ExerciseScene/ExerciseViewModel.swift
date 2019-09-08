//
//  ExerciseViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol ExerciseViewModel {
    var question: Observable<String> { get }
    var questionLatex: Observable<String> { get }
    var choice1: Observable<String> { get }
    var choice2: Observable<String> { get }
    var choice3: Observable<String> { get }
    var choice1Correct: Observable<Bool> { get }
    var choice2Correct: Observable<Bool> { get }
    var choice3Correct: Observable<Bool> { get }
    var correctChoice: Int { get }
    var displayState: Observable<ExerciseVCDisplayState> { get }
    
    func dispatch(action: ExerciseAction)
}

protocol ExerciseViewModelDelegate: class {
    func next(_ exerciseViewModel: ExerciseViewModel)
    func info(_ exerciseViewModel: ExerciseViewModel, concept: Concept)
}

enum ExerciseAction {
    case choice1
    case choice2
    case choice3
    case next
    case info
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
    
    //MARK: - Dependencies
    
    private weak var delegate: ExerciseViewModelDelegate?
    private let resultsStore: ResultsStore
    
    //MARK: - Config
    
    private let exercise: Exercise
    private let choiceConfiguration: ExerciseChoiceConfiguration
    private let choices: [String]
    
    //MARK: - Initialization
    
    init(delegate: ExerciseViewModelDelegate,
         resultsStore: ResultsStore,
         exercise: Exercise,
         choiceConfiguration: ExerciseChoiceConfiguration)
    {
        self.delegate = delegate
        self.resultsStore = resultsStore
        self.exercise = exercise
        self.choiceConfiguration = choiceConfiguration
        correctChoice = choiceConfiguration.correctPosition
        
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
    
    let correctChoice: Int
    
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
        case .next:
            handle_next()
        case .info:
            handle_info()
        }
    }
    
    private func handle_choice1() {
        showCorrectAnswer()
        submitResult(correct: choice1Correct)
        if !choice1Correct {
            choice1CorrectSubject.onNext(false)
        }
        displayStateSubject.onNext(.answer)
    }
    
    private func submitResult(correct: Bool) {
        let result = ExerciseResult(correct: correct, conceptID: exercise.concept.id)
        resultsStore.dispatch(action: .processResult(result))
    }
    
    private func handle_choice2() {
        showCorrectAnswer()
        submitResult(correct: choice2Correct)
        if !choice2Correct {
            choice2CorrectSubject.onNext(false)
        }
        displayStateSubject.onNext(.answer)
    }
    
    private func handle_choice3() {
        showCorrectAnswer()
        submitResult(correct: choice3Correct)
        if !choice3Correct {
            choice3CorrectSubject.onNext(false)
        }
        displayStateSubject.onNext(.answer)
    }
    
    private func showCorrectAnswer() {
        if choice1Correct {
            choice1CorrectSubject.onNext(true)
        } else if choice2Correct {
            choice2CorrectSubject.onNext(true)
        } else {
            choice3CorrectSubject.onNext(true)
        }
    }
    
    private var choice1Correct: Bool {
        return choiceConfiguration.correctPosition == 1
    }
    
    private var choice2Correct: Bool {
        return choiceConfiguration.correctPosition == 2
    }
    
    private var choice3Correct: Bool {
        return choiceConfiguration.correctPosition == 3
    }
    
    private func handle_next() {
        delegate?.next(self)
    }
    
    private func handle_info() {
        delegate?.info(self, concept: exercise.concept)
    }
    
}
