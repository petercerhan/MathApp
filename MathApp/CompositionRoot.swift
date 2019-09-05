//
//  CompositionRoot.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class CompositionRoot {
    
    func composeRootCoordinator() -> Coordinator {
        return RootCoordinator(compositionRoot: self, containerVC: ContainerViewController())
    }
    
    func composeWindow() -> UIWindow {
        return UIWindow(frame: UIScreen.main.bounds)
    }
    
    //MARK: - Exercise sequence
    
    func composeExerciseCoordinator() -> ExerciseCoordinator {
        let resultsStore = ResultsStoreImpl()
        let containerVM = FeedContainerViewModel(resultsStore: resultsStore)
        return ExerciseCoordinator(compositionRoot: self,
                                   containerVC: FeedContainerViewController(viewModel: containerVM),
                                   randomizationService: RandomizationServiceImpl(),
                                   resultsStore: resultsStore)
    }
    
    func composeExerciseScene(delegate: ExerciseViewModelDelegate, resultsStore: ResultsStore, choiceConfiguration: ExerciseChoiceConfiguration) -> UIViewController {
        let vm = ExerciseViewModelImpl(delegate: delegate,
                                       resultsStore: resultsStore,
                                       exercise: Exercise.exercise1,
                                       choiceConfiguration: choiceConfiguration)
        return ExerciseViewController(viewModel: vm)
    }
    
}
