//
//  FakeMenuCoordinatorDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
@testable import MathApp

class FakeMenuCoordinatorDelegate: MenuCoordinatorDelegate {

    var quit_callCount = 0
    
    func quit(_ menuCoordinator: MenuCoordinator) {
        quit_callCount += 1
    }
}
