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
        
        XCTAssertEqual(vc.questionLabel.text, "Find the derivative:")
        XCTAssertEqual(vc.questionLatexLabel.latex, "\\frac{d}{dx}(1)")
        XCTAssertEqual(vc.choice1Label.latex, "0")
        XCTAssertEqual(vc.choice2Label.latex, "x")
        XCTAssertEqual(vc.choice3Label.latex, "1")
    }
    
    func test_firstChoiceSelected_firstChoiceCorrect_shouldDispatchCorrectResult() {
        let mockStore = FakeResultsStore()
        let vc = composeSUT(fakeStore: mockStore)
        
        vc.loadViewIfNeeded()
        vc.choice1Button.sendActions(for: .touchUpInside)
        
        mockStore.verifyProcessResultDispatched(correct: true)
    }
    
    func test_firstChoiceSelected_firstChoiceIncorrect_shouldDispatchIncorrectResult() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 2, firstFalseChoice: 1, secondFalseChoice: 3)
        let mockStore = FakeResultsStore()
        let vc = composeSUT(fakeStore: mockStore, choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice1Button.sendActions(for: .touchUpInside)
        
        mockStore.verifyProcessResultDispatched(correct: false)
    }
    
    func test_secondChoiceSelected_secondChoiceCorrect_shouldDispatchCorrectResult() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 2, firstFalseChoice: 1, secondFalseChoice: 3)
        let mockStore = FakeResultsStore()
        let vc = composeSUT(fakeStore: mockStore, choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice2Button.sendActions(for: .touchUpInside)
        
        mockStore.verifyProcessResultDispatched(correct: true)
    }
    
    func test_secondChoiceSelected_secondChoiceIncorrect_shouldDispatchIncorrectResult() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 1, firstFalseChoice: 1, secondFalseChoice: 3)
        let mockStore = FakeResultsStore()
        let vc = composeSUT(fakeStore: mockStore, choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice2Button.sendActions(for: .touchUpInside)
        
        mockStore.verifyProcessResultDispatched(correct: false)
    }
    
    func test_thirdChoiceSelected_thirdChoiceCorrect_shouldDispatchCorrectResult() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 3, firstFalseChoice: 1, secondFalseChoice: 3)
        let mockStore = FakeResultsStore()
        let vc = composeSUT(fakeStore: mockStore, choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice3Button.sendActions(for: .touchUpInside)
        
        mockStore.verifyProcessResultDispatched(correct: true)
    }
    
    func test_thirdChoiceSelected_thirdChoiceIncorrect_shouldDispatchIncorrectResult() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 2, firstFalseChoice: 1, secondFalseChoice: 3)
        let mockStore = FakeResultsStore()
        let vc = composeSUT(fakeStore: mockStore, choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice3Button.sendActions(for: .touchUpInside)
        
        mockStore.verifyProcessResultDispatched(correct: false)
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
    
    func test_secondChoiceSelected_secondChoiceCorrect_showsSecondCorrect() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 2, firstFalseChoice: 1, secondFalseChoice: 3)
        let vc = composeSUT(choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice2Button.sendActions(for: .touchUpInside)
        
        assertSecondChoiceShowsCorrect(true, vc: vc)
    }
    
    func test_thirdChoiceSelected_firstChoiceCorrect_showsFirstCorrectThirdIncorrect() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 1, firstFalseChoice: 1, secondFalseChoice: 3)
        let vc = composeSUT(choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice3Button.sendActions(for: .touchUpInside)
        
        assertFirstChoiceShowsCorrect(true, vc: vc)
        assertThirdChoiceShowsCorrect(false, vc: vc)
    }
    
    func test_thirdChoiceSelected_thirdChoiceCorrect_showsThirdCorrect() {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: 3, firstFalseChoice: 1, secondFalseChoice: 3)
        let vc = composeSUT(choiceConfiguration: choiceConfiguration)
        
        vc.loadViewIfNeeded()
        vc.choice3Button.sendActions(for: .touchUpInside)
        
        assertThirdChoiceShowsCorrect(true, vc: vc)
    }
    
    func test_choice1Selected_allChoicesDisabled() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice1Button.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(vc.choice1Button.isEnabled)
        XCTAssertFalse(vc.choice2Button.isEnabled)
        XCTAssertFalse(vc.choice3Button.isEnabled)
    }
    
    func test_choice2Selected_allChoicesDisabled() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice2Button.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(vc.choice1Button.isEnabled)
        XCTAssertFalse(vc.choice2Button.isEnabled)
        XCTAssertFalse(vc.choice3Button.isEnabled)
    }
    
    func test_choice3Selected_allChoicesDisabled() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice3Button.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(vc.choice1Button.isEnabled)
        XCTAssertFalse(vc.choice2Button.isEnabled)
        XCTAssertFalse(vc.choice3Button.isEnabled)
    }
    
    func test_choice1Selected_entersAnswerState() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice1Button.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(vc.displayState, .answer)
    }
    
    func test_choice2Selected_entersAnswerState() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice2Button.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(vc.displayState, .answer)
    }
    
    func test_choice3Selected_entersAnswerState() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        vc.choice3Button.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(vc.displayState, .answer)
    }
    
    func test_next_requestsNext() {
        let mockDelegate = FakeExerciseViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.nextButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.next_callCount, 1)
    }
    
    func test_infoButton_requestsInfoScene() {
        let mockDelegate = FakeExerciseViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.infoButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.info_callCount, 1)
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
    
    func assertThirdChoiceShowsCorrect(_ isCorrect: Bool, vc: ExerciseViewController, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(vc.choice3GradeImageView.isHidden, false, file: file, line: line)
        XCTAssertEqual(vc.choice3GradeImageView.isCorrect, isCorrect, file: file, line: line)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: FakeExerciseViewModelDelegate? = nil,
                    fakeStore: ResultsStore? = nil,
                    choiceConfiguration: ExerciseChoiceConfiguration? = nil) -> ExerciseViewController {
        let configuration = choiceConfiguration ?? ExerciseChoiceConfiguration(correctPosition: 1, firstFalseChoice: 1, secondFalseChoice: 2)
        let delegate = fakeDelegate ?? FakeExerciseViewModelDelegate()
        let resultsStore = fakeStore ?? FakeResultsStore()
        let vm = ExerciseViewModelImpl(delegate:delegate, resultsStore: resultsStore, exercise: Exercise.exercise1, choiceConfiguration: configuration)
        return ExerciseViewController(viewModel: vm)
    }

}
