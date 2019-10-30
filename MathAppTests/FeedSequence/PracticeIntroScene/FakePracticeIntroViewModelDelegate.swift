//
//  FakePracticeIntroViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakePracticeIntroViewModelDelegate: PracticeIntroViewModelDelegate {
    
    var next_callCount = 0
    
    func next(_ practiceIntroViewModel: PracticeIntroViewModel) {
        next_callCount += 1
    }
}
