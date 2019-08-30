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
    
    func composeExerciseScene(delegate: ExerciseViewModelDelegate) -> UIViewController {
        let vm = ExerciseViewModelImpl(delegate: delegate, exercise: Exercise.exercise1, choiceConfiguration: ExerciseChoiceConfiguration(correctPosition: 1, firstFalseChoice: 1, secondFalseChoice: 2))
        return ExerciseViewController(viewModel: vm)
    }
    
    func composeHomeScene() -> UIViewController {
        return HomeViewController()
    }
    
}
