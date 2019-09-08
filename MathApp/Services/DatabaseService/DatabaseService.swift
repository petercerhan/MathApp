//
//  DatabaseService.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol DatabaseService {
    func getUserConcepts() -> [UserConcept]
}

class DatabaseServiceImpl: DatabaseService {
    
    func getUserConcepts() -> [UserConcept] {
        let concepts = [UserConcept(id: 1, concept: Concept.constantRule, strength: 1)]
        return concepts
    }
    
    
}
