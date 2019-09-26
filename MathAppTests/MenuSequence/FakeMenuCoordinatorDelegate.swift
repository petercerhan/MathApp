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
    
    var loadExercise_count = 0
    var loadExercise_id = [Int]()
    
    func loadExercise(_ menuCoordinator: MenuCoordinator, withID id: Int) {
        loadExercise_count += 1
        loadExercise_id.append(id)
    }
}
