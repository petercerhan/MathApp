//
//  User.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let learningStrategy: LearningStrategy
    
    init?(id: Int, learningStrategyID: Int) {
        guard let learningStrategy = LearningStrategy(rawValue: learningStrategyID) else {
            return nil
        }
        self.id = id
        self.learningStrategy = learningStrategy
    }
}

enum LearningStrategy: Int {
    case newMaterial = 1
    case practiceFamily = 2
    case practiceConcept = 3
}

