//
//  RootCoordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class RootCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private let compositionRoot: CompositionRoot
    private let containerVC: ContainerViewController
    
    //MARK: - State
    
    private(set) var childCoordinator: Coordinator?
    
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
        let coordinator = compositionRoot.composeExerciseCoordinator()
        containerVC.show(viewController: coordinator.containerViewController, animation: .none)
        coordinator.start()
        childCoordinator = coordinator
    }
}
