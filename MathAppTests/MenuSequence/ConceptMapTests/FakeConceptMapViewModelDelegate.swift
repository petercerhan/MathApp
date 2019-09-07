//
//  FakeConceptMapViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeConceptMapViewModelDelegate: ConceptMapViewModelDelegate {
    
    var back_callCount = 0
    
    func back(_ conceptMapViewModel: ConceptMapViewModel) {
        back_callCount += 1
    }
}
