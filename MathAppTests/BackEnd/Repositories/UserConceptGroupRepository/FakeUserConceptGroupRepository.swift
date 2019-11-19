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
    
}
