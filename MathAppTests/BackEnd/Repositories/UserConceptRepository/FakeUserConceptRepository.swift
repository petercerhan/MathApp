//
//  FakeUserConceptRepository.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeUserConceptRepository: UserConceptRepository {

    var list_stubUserConcepts = [UserConcept]()

    func list(conceptGroupID: Int) -> [UserConcept] {
        return list_stubUserConcepts
    }
    
    var list_chapterID_callCount = 0
    
    func list(chapterID: Int) -> [UserConcept] {
        list_chapterID_callCount += 1
        return list_stubUserConcepts
    }
    
    
    func get(conceptID: Int) -> UserConcept? {
        return nil
    }
    
    
    var set_callCount = 0
    var set_fields = [[String: String]]()
    
    func set(id: Int, fields: [String: String]) {
        set_callCount += 1
        set_fields.append(fields)
    }
    
}
