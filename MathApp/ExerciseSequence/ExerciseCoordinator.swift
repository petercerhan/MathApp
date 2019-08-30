//
//  ExerciseCoordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift

class ExerciseCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private let compositionRoot: CompositionRoot
    private let containerVC: ContainerViewController
    private let randomizationService: RandomizationService
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot,
         containerVC: ContainerViewController,
         randomizationService: RandomizationService)
    {
        self.compositionRoot = compositionRoot
        self.containerVC = containerVC
        self.randomizationService = randomizationService
    }
    
    //MARK: - Coordinator Interface
    
    var containerViewController: UIViewController {
        return containerVC
    }
    
    func start() {
        let vc = getNextExerciseScene()
        containerVC.show(viewController: vc, animation: .none)
    }
    
    private func getNextExerciseScene() -> UIViewController {
        let choiceConfiguration = randomizationService.randomizedExerciseChoiceConfiguration()
        return compositionRoot.composeExerciseScene(delegate: self, choiceConfiguration: choiceConfiguration)
    }

}

//MARK: - ExerciseViewModelDelegate

extension ExerciseCoordinator: ExerciseViewModelDelegate {
    func next(_ exerciseViewModel: ExerciseViewModel) {
        let vc = getNextExerciseScene()
        containerVC.show(viewController: vc, animation: .fadeIn)
    }
}
