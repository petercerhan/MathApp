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
        let userConcept1 = UserConcept(id: 1, concept: Concept.constantRule, strength: 1)
        let userConcept2 = UserConcept(id: 2, concept: Concept.linearRule, strength: 1)
        let userConcept3 = UserConcept(id: 3, concept: Concept.powerRule, strength: 1)
        let userConcept4 = UserConcept(id: 4, concept: Concept.sumRule, strength: 1)
        let userConcept5 = UserConcept(id: 5, concept: Concept.differenceRule, strength: 1)
        
        
        let concepts = [userConcept1, userConcept2, userConcept3, userConcept4, userConcept5]
        return concepts
    }
    
    
}
