//
//  FakeMenuViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeMenuViewModelDelegate: MenuViewModelDelegate {
    
    var conceptMap_callCount = 0
    
    func conceptMap(_ menuViewModel: MenuViewModel) {
        conceptMap_callCount += 1
    }
    
}
