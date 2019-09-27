//
//  ConceptIntro.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct ConceptIntro: FeedItem {
    let concept: Concept
    let exercises: [Exercise]
    
    init(concept: Concept, exercises: [Exercise]) {
        self.concept = concept
        self.exercises = exercises
    }
    
}
