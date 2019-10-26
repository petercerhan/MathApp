//
//  FakeUserConceptController.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeUserConceptController: UserConceptController {
    
    var update_callCount = 0
    
    func update(id: Int, fields: [String: String]) {
        update_callCount += 1
    }
    
}
