//
//  FakeUserConceptGroupRepository.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeUserConceptGroupRepository: UserConceptGroupRepository {
    
    var list_stubs = [UserConceptGroup]()

    func list() -> [UserConceptGroup] {
        return list_stubs
    }
    
    var set_callCount = 0
    var set_id = [Int]()
    var set_fields = [[String: String]]()
    
    func set(id: Int, fields: [String: String]) {
        set_callCount += 1
        set_id.append(id)
        set_fields.append(fields)
    }
    
}
