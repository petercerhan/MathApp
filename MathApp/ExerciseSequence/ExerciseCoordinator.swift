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
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot, containerVC: ContainerViewController) {
        self.compositionRoot = compositionRoot
        self.containerVC = containerVC
    }
    
    //MARK: - Coordinator Interface
    
    var containerViewController: UIViewController {
        return containerVC
    }
    
    func start() {
        let vc = getNextExerciseScene()
        containerVC.show(viewController: vc, animation: .none)
    }
    
    private var correctPositionIndex = 0
    
    private func getNextExerciseScene() -> UIViewController {
        let choiceConfiguration = ExerciseChoiceConfiguration(correctPosition: correctPositionIndex + 1, firstFalseChoice: 1, secondFalseChoice: 2)
        
        correctPositionIndex = (correctPositionIndex + 1) % 3
        
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
