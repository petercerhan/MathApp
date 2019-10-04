//
//  FakeLevelUpViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeLevelUpViewModelDelegate: LevelUpViewModelDelegate {
    var next_callCount = 0
    func next(_ levelUpViewModel: LevelUpViewModel) {
        next_callCount += 1
    }
}
