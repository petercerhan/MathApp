//
//  MenuCoordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift

protocol MenuCoordinatorDelegate: class {
    func quit(_ menuCoordinator: MenuCoordinator)
    func loadExercise(_ menuCoordinator: MenuCoordinator, withID id: Int)
}

class MenuCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private weak var delegate: MenuCoordinatorDelegate?
    private let containerVC: ContainerViewController
    private let composer: MenuComposer
    
    //MARK: - Initialization
    
    init(delegate: MenuCoordinatorDelegate,
         containerVC: ContainerViewController,
         composer: MenuComposer)
    {
        self.delegate = delegate
        self.containerVC = containerVC
        self.composer = composer
        
        if let quitableContainer = containerVC as? QuitableContainerViewController {
            quitableContainer.viewModel.setDelegate(self)
        }
    }
    
    //MARK: - Coordinator Interface
    
    var containerViewController: UIViewController {
        return containerVC
    }
    
    func start() {
        containerVC.loadViewIfNeeded()
        let vc = composer.composeMenuScene(delegate: self)
        containerVC.show(viewController: vc, animation: .none)
    }
    
}

//MARK: - QuitableContainerViewModelDelegate

extension MenuCoordinator: QuitableContainerViewModelDelegate {
    func quit(_ quitableContainerViewModel: QuitableContainerViewModel) {
        delegate?.quit(self)
    }
}

//MARK: - MenuViewModelDelegate

extension MenuCoordinator: MenuViewModelDelegate {
    func conceptMap(_ menuViewModel: MenuViewModel) {
        let vc = composer.composeConceptMapScene(delegate: self)
        containerVC.show(viewController: vc, animation: .slideFromRight)
    }
    
    func chooseExercise(_ menuViewModel: MenuViewModel) {
        let vc = composer.composeChooseExerciseScene(delegate: self)
        containerVC.show(viewController: vc, animation: .slideFromRight)
    }
}

//MARK: - ConceptMapViewModelDelegate

extension MenuCoordinator: ConceptMapViewModelDelegate {
    func back(_ conceptMapViewModel: ConceptMapViewModel) {
        let vc = composer.composeMenuScene(delegate: self)
        containerVC.show(viewController: vc, animation: .slideFromLeft)
    }
}

//MARK: - ChooseExerciseViewModelDelegate

extension MenuCoordinator: ChooseExerciseViewModelDelegate {
    func back(_ chooseExerciseViewModel: ChooseExerciseViewModel) {
        let vc = composer.composeMenuScene(delegate: self)
        containerVC.show(viewController: vc, animation: .slideFromLeft)
    }
    
    func loadExercise(_ chooseExerciseViewModel: ChooseExerciseViewModel, withID id: Int) {
        delegate?.loadExercise(self, withID: id)
    }
}
