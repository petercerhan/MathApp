//
//  FakeInfoViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeInfoViewModelDelegate: InfoViewModelDelegate {
    
    var quit_callCount = 0
    func quit(_ infoViewModel: InfoViewModelImpl) {
        quit_callCount += 1
    }
    
}
