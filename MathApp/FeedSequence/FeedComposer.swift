//
//  FeedComposer.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class FeedComposer {
    
    //MARK: - Factories
    
    func composeExerciseScene(delegate: ExerciseViewModelDelegate,
                              resultsStore: ResultsStore,
                              exercise: Exercise,
                              choiceConfiguration: ExerciseChoiceConfiguration) -> UIViewController {
        let vm = ExerciseViewModelImpl(delegate: delegate,
                                       resultsStore: resultsStore,
                                       exercise: exercise,
                                       choiceConfiguration: choiceConfiguration)
        return ExerciseViewController(viewModel: vm)
    }
    
    func composeConceptIntroScene(delegate: ConceptIntroViewModelDelegate, conceptIntro: ConceptIntroLearningStep) -> UIViewController {
        let vm = ConceptIntroViewModel(delegate: delegate, conceptIntro: conceptIntro)
        return ConceptIntroViewController(viewModel: vm)
    }
    
    func composePracticeIntroScene(delegate: PracticeIntroViewModelDelegate) -> UIViewController {
        let vm = PracticeIntroViewModel(delegate: delegate)
        return PracticeIntroViewController(viewModel: vm)
    }
    
    func composeLevelUpScene(delegate: LevelUpViewModelDelegate, levelUpItem: LevelUpItem) -> UIViewController {
        let vm = LevelUpViewModel(delegate: delegate, levelUpItem: levelUpItem)
        return LevelUpViewController(viewModel: vm)
    }
    
    func composeDoubleLevelUpScene(levelUpItem1: LevelUpItem, levelUpItem2: LevelUpItem) -> UIViewController {
        let viewModel = DoubleLevelUpViewModel(levelUpItem1: levelUpItem1, levelUpItem2: levelUpItem2)
        return DoubleLevelUpViewController(viewModel: viewModel)
    }
    
    func composeInfoScene(delegate: InfoViewModelDelegate, concept: Concept) -> UIViewController {
        let vm = InfoViewModelImpl(delegate: delegate, concept: concept)
        return InfoViewController(viewModel: vm)
    }
    
    func composeLoadExercisesScene(delegate: LoadExercisesViewModelDelegate) -> UIViewController {
        let vm = LoadExercisesViewModel(delegate: delegate)
        return LoadExercisesViewController(viewModel: vm)
    }
    
}
