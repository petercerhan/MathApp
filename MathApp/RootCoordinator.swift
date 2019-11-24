//
//  RootCoordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import SQLite

class RootCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private let globalComposer: GlobalComposer
    private let rootCoordinatorComposer: RootCoordinatorComposer
    private let containerVC: ContainerViewController
    private let databaseService: DatabaseService
    
    //MARK: - State
    
    private(set) var childCoordinator: Coordinator?
    
    //MARK: - Initialization
    
    init(globalComposer: GlobalComposer,
         rootCoordinatorComposer: RootCoordinatorComposer,
         containerVC: ContainerViewController,
         databaseService: DatabaseService)
    {
        self.globalComposer = globalComposer
        self.rootCoordinatorComposer = rootCoordinatorComposer
        self.containerVC = containerVC
        self.databaseService = databaseService
    }
    
    //MARK: - Coordinator Interface

    var containerViewController: UIViewController {
        return containerVC
    }
    
    func start() {
//        databaseService.reset()
        databaseService.setup()

        let vc = rootCoordinatorComposer.composePrepareFeedScene(delegate: self)
        containerVC.show(viewController: vc, animation: .none)
    }
    
}

//MARK: - PrepareFeedViewModelDelegate

extension RootCoordinator: PrepareFeedViewModelDelegate {
    func next(_ prepareFeedViewModel: PrepareFeedViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.transitionToFeedSquence()
        }
    }
    
    private func transitionToFeedSquence() {
        let coordinator = globalComposer.composeExerciseCoordinator()
        containerVC.show(viewController: coordinator.containerViewController, animation: .none)
        coordinator.start()
        childCoordinator = coordinator
    }
}

