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
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot) {
        self.compositionRoot = compositionRoot
    }
    
    //MARK: - Coordinator Interface

    var containerViewController: UIViewController {
        return compositionRoot.composeHomeScene()
    }
    
    func start() {
        
    }
}
