//
//  AppDelegate.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var globalComposer: GlobalComposer!
    var rootCoordinator: Coordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        globalComposer = GlobalComposer()
        rootCoordinator = globalComposer.composeRootCoordinator()
        rootCoordinator.start()
        
        window = globalComposer.composeWindow()
        window?.rootViewController = rootCoordinator.containerViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

