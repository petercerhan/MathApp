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
    
    func test_firstChoicePressed_firstChoiceCorrect_showsFirstCorrectImage() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice1Button.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(vc.choice1GradeImageView.isHidden, false)
        XCTAssertEqual(vc.choice1GradeImageView.isCorrect, true)
    }
    
    
    
    //MARK: - SUT Composition
    
    func composeSUT() -> ExerciseViewController {
        let vm = ExerciseViewModelImpl(exercise: Exercise.exercise1)
        return ExerciseViewController(viewModel: vm)
    }

}
