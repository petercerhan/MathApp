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
        return ExerciseCoordinator(compositionRoot: self, containerVC: ContainerViewController())
    }
    
    func composeExerciseScene(delegate: ExerciseViewModelDelegate, choiceConfiguration: ExerciseChoiceConfiguration) -> UIViewController {
        let vm = ExerciseViewModelImpl(delegate: delegate, exercise: Exercise.exercise1, choiceConfiguration: choiceConfiguration)
        return ExerciseViewController(viewModel: vm)
    }
    
}
