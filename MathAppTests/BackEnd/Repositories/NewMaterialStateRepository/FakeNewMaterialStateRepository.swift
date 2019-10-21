//
//  FakeNewMaterialStateRepository.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeNewMaterialStateRepository: NewMaterialStateRepository {
    
    var stubNewMaterialState = NewMaterialState.createStub()
    
    func get() -> NewMaterialState {
        return stubNewMaterialState
    }
    
    var setFocus_callCount = 0
    var setFocus_concept1ID = [Int]()
    var setFocus_concept2ID = [Int]()
    
    func setFocus(concept1ID: Int, concept2ID: Int) {
        setFocus_callCount += 1
        setFocus_concept1ID.append(concept1ID)
        setFocus_concept2ID.append(concept2ID)
    }
    
    var reset_callCount = 0
    
    func reset() {
        reset_callCount += 1
    }
}
