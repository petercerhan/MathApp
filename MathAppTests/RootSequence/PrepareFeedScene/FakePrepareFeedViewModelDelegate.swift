//
//  FakePrepareFeedViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/2/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakePrepareFeedViewModelDelegate: PrepareFeedViewModelDelegate {
    
    var next_callCount = 0

    func next(_ prepareFeedViewModel: PrepareFeedViewModel) {
        next_callCount += 1
    }
    
}
