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
}
