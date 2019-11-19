//
//  UserConceptGroup.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct UserConceptGroup {
    let id: Int
    let completed: Bool
    let conceptGroup: ConceptGroup
    
    var conceptGroupID: Int {
        return conceptGroup.id
    }
}
