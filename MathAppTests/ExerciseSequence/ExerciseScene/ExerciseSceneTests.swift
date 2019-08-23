//
//  ExerciseSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import XCTest
@testable import MathApp

class ExerciseSceneTests: XCTestCase {
    
    func test_outlets_shouldBeConnected() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.questionLabel)
        XCTAssertNotNil(vc.questionLatexLabel)
        XCTAssertNotNil(vc.choice1Button)
        XCTAssertNotNil(vc.choice2Button)
        XCTAssertNotNil(vc.choice3Button)
        XCTAssertNotNil(vc.choice3Label)
        
        XCTAssertNotNil(vc.choice1GradeImageView)
        XCTAssertNotNil(vc.choice2GradeImageView)
        XCTAssertNotNil(vc.choice3GradeImageView)
    }
    
    func test_initialState_gradeImagesHidden() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.choice1GradeImageView.isHidden, true)
        XCTAssertEqual(vc.choice2GradeImageView.isHidden, true)
        XCTAssertEqual(vc.choice3GradeImageView.isHidden, true)
    }
    
    func test_exercise1_noAnswerMixing_shouldDisplayExercise1() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.questionLabel.text, "Solve for x")
        XCTAssertEqual(vc.questionLatexLabel.latex, "\\sqrt{x^2}")
        XCTAssertEqual(vc.choice1Label.latex, "x")
        XCTAssertEqual(vc.choice2Label.latex, "y")
        XCTAssertEqual(vc.choice3Label.latex, "z")
    }
    
    func test_firstChoiceSelected_firstChoiceCorrect_showsFirstCorrectImage() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice1Button.sendActions(for: .touchUpInside)
        
        assertFirstChoiceShowsCorrect(true, vc: vc)
    }
    
    func test_secondChoiceSelected_firstChoiceCorrect_showsFirstCorrectAndSecondIncorrect() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice2Button.sendActions(for: .touchUpInside)
        
        assertFirstChoiceShowsCorrect(true, vc: vc)
        assertSecondChoiceShowsCorrect(false, vc: vc)
    }
    
    func test_firstChoiceSelected_secondChoiceCorrect_showsFirstIncorrectAndSecondCorrect() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 2, firstFalseChoice: 1, secondFalseChoice: 3)
        let vc = composeSUT(choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice1Button.sendActions(for: .touchUpInside)
        
        assertFirstChoiceShowsCorrect(false, vc: vc)
        assertSecondChoiceShowsCorrect(true, vc: vc)
    }
    
    //MARK: - Assertions
    
    func assertFirstChoiceShowsCorrect(_ isCorrect: Bool, vc: ExerciseViewController, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(vc.choice1GradeImageView.isHidden, false, file: file, line: line)
        XCTAssertEqual(vc.choice1GradeImageView.isCorrect, isCorrect, file: file, line: line)
    }
    
    func assertSecondChoiceShowsCorrect(_ isCorrect: Bool, vc: ExerciseViewController, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(vc.choice2GradeImageView.isHidden, false, file: file, line: line)
        XCTAssertEqual(vc.choice2GradeImageView.isCorrect, isCorrect, file: file, line: line)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(choiceConfiguration: ExerciseChoiceConfiguration? = nil) -> ExerciseViewController {
        let configuration = choiceConfiguration ?? ExerciseChoiceConfiguration(correctPosition: 1, firstFalseChoice: 1, secondFalseChoice: 2)
        let vm = ExerciseViewModelImpl(exercise: Exercise.exercise1, choiceConfiguration: configuration)
        return ExerciseViewController(viewModel: vm)
    }

}
