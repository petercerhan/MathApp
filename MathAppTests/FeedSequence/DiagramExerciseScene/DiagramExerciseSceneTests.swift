//
//  DiagramExerciseSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class DiagramExerciseSceneTests: XCTestCase {
    
    func test_superclassViews_shouldBeRemovedFromViewHeirarchy() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertFalse(vc.equationLabel.isDescendant(of: vc.view))
    }
    
    func test_diagramView_shouldBeAddedToViewHeirarchy() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssert(vc.imageView.isDescendant(of: vc.view))
    }
    
    
    
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: FakeExerciseViewModelDelegate? = nil,
                    fakeStore: ResultsStore? = nil,
                    choiceConfiguration: ExerciseChoiceConfiguration? = nil) -> DiagramExerciseViewController
    {
        let configuration = choiceConfiguration ?? ExerciseChoiceConfiguration(correctPosition: 1, firstFalseChoice: 1, secondFalseChoice: 2)
        let delegate = fakeDelegate ?? FakeExerciseViewModelDelegate()
        let resultsStore = fakeStore ?? FakeResultsStore()
        let vm = DiagramExerciseViewModelImpl(delegate:delegate,
                                              resultsStore: resultsStore,
                                              exercise: Exercise.exercise1,
                                              diagram: "Test diagram",
                                              choiceConfiguration: configuration)
        
        return DiagramExerciseViewController(viewModel: vm)
    }
    
    
}
