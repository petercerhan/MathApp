//
//  FakeUserConceptExternalDataService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeUserConceptExternalDataService: UserConceptExternalDataService {

    var update_callCount = 0
    var update_id = [Int]()
    var update_fields = [[String: String]]()
    
    func update(id: Int, fields: [String: String]) {
        update_callCount += 1
        update_id.append(id)
        update_fields.append(fields)
    }
    
}
