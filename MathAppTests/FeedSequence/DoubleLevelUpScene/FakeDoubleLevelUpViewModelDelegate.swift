//
//  FakeDoubleLevelUpViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeDoubleLevelUpViewModelDelegate: DoubleLevelUpViewModelDelegate {
    var next_callCount = 0
    func next(_ doubleLevelUpViewModel: DoubleLevelUpViewModel) {
        next_callCount += 1
    }
}
