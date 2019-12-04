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
    
    var list_chapterID_callCount = 0
    
    func list(chapterID: Int) -> [UserConcept] {
        list_chapterID_callCount += 1
        return []
    }
    
    var update_callCount = 0
    
    func update(id: Int, fields: [String: String]) {
        update_callCount += 1
    }
    
}
