//
//  main.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/9/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self
UIApplicationMain( CommandLine.argc,
                   CommandLine.unsafeArgv,
                   nil,
                   NSStringFromClass(appDelegateClass) )
