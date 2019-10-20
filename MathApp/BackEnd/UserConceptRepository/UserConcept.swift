//
//  UserConcept.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct UserConcept {
    let id: Int
    let concept: Concept
    let strength: Int
    
    var conceptID: Int {
        return concept.id
    }
}
