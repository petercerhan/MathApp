//
//  FakeGroupCompleteViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeGroupCompleteViewModelDelegate: GroupCompleteViewModelDelegate {
    
    var nextGroup_callCount = 0
    
    func nextGroup(_ groupCompleteViewModel: GroupCompleteViewModel) {
        nextGroup_callCount += 1
    }
}
