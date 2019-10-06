//
//  FakeConceptIntroViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeConceptIntroViewModelDelegate: ConceptIntroViewModelDelegate {
    
    var next_callCount = 0
    
    func next(_ conceptIntroViewModel: ConceptIntroViewModel) {
        next_callCount += 1
    }

}
