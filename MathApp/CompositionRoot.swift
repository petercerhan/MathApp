//
//  CompositionRoot.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class CompositionRoot {
    
    func composeRootCoordinator() -> Coordinator {
        return RootCoordinator(compositionRoot: self)
    }
    
    func composeWindow() -> UIWindow {
        return UIWindow(frame: UIScreen.main.bounds)
    }
    
    func composeHomeScene() -> UIViewController {
        return HomeViewController()
    }
    
}
