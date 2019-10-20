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

    func list() -> [UserConcept] {
        return list_stubUserConcepts
    }
}
