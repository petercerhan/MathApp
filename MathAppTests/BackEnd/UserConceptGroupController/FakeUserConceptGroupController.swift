//
//  FakeUserConceptGroupController.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 12/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeUserConceptGroupController: UserConceptGroupController {
    
    
    var listByChapter_callCount = 0
    
    func list(chapterID: Int) -> [UserConceptGroup] {
        listByChapter_callCount += 1
        return []
    }
    
    
}
