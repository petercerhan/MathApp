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
        let vc = compositionRoot.composeExerciseScene(delegate: self)
        containerVC.show(viewController: vc, animation: .none)
    }

}

//MARK: - ExerciseViewModelDelegate

extension ExerciseCoordinator: ExerciseViewModelDelegate {
    func next(_ exerciseViewModel: ExerciseViewModel) {
        
    }
}
