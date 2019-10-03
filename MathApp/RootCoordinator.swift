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
    
    private let compositionRoot: CompositionRoot
    private let containerVC: ContainerViewController
    private let databaseService: DatabaseService
    private let feedPackageStore: FeedPackageStore
    
    //MARK: - State
    
    private(set) var childCoordinator: Coordinator?
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot, containerVC: ContainerViewController, databaseService: DatabaseService, feedPackageStore: FeedPackageStore) {
        self.compositionRoot = compositionRoot
        self.containerVC = containerVC
        self.databaseService = databaseService
        self.feedPackageStore = feedPackageStore
    }
    
    //MARK: - Coordinator Interface

    var containerViewController: UIViewController {
        return containerVC
    }
    
    func start() {
        databaseService.setup()

        let vc = compositionRoot.composePrepareFeedScene(delegate: self, feedPackageStore: feedPackageStore)
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
        let coordinator = compositionRoot.composeExerciseCoordinator(feedPackageStore: feedPackageStore)
        containerVC.show(viewController: coordinator.containerViewController, animation: .none)
        coordinator.start()
        childCoordinator = coordinator
    }
}
