//
//  MenuCoordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift

class MenuCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private let containerVC: ContainerViewController
    private let compositionRoot: CompositionRoot
    
    //MARK: - Initialization
    
    init(containerVC: ContainerViewController, compositionRoot: CompositionRoot) {
        self.containerVC = containerVC
        self.compositionRoot = compositionRoot
    }
    
    //MARK: - Coordinator Interface
    
    var containerViewController: UIViewController {
        return containerVC
    }
    
    func start() {
        let vc = compositionRoot.composeMenuScene()
        containerVC.show(viewController: vc, animation: .none)
    }
    
}
