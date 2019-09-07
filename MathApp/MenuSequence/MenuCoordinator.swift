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
}

class MenuCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private weak var delegate: MenuCoordinatorDelegate?
    private let containerVC: ContainerViewController
    private let compositionRoot: CompositionRoot
    
    //MARK: - Initialization
    
    init(delegate: MenuCoordinatorDelegate,
         containerVC: ContainerViewController,
         compositionRoot: CompositionRoot)
    {
        self.delegate = delegate
        self.containerVC = containerVC
        self.compositionRoot = compositionRoot
        
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
        let vc = compositionRoot.composeMenuScene(delegate: self)
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
        let vc = compositionRoot.composeConceptMapScene()
        containerVC.show(viewController: vc, animation: .slideFromRight)
    }
}

