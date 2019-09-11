//
//  UserConcept+data.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

extension UserConcept {
    
    static var constantRule: UserConcept {
        let concept = Concept.constantRule
        return UserConcept(id: concept.id, concept: concept, strength: 0)
    }
    
    static var linearRule: UserConcept {
        let concept = Concept.linearRule
        return UserConcept(id: concept.id, concept: concept, strength: 0)
    }
    
    static var powerRule: UserConcept {
        let concept = Concept.powerRule
        return UserConcept(id: concept.id, concept: concept, strength: 0)
    }
    
    static var sumRule: UserConcept {
        let concept = Concept.sumRule
        return UserConcept(id: concept.id, concept: concept, strength: 1)
    }
    
    static var differenceRule: UserConcept {
        let concept = Concept.differenceRule
        return UserConcept(id: concept.id, concept: concept, strength: 2)
    }
    
}
