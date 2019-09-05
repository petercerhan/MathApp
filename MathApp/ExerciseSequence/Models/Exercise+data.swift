//
//  Exercise+data.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

extension Exercise {
    
    static func getByID(_ id: Int) -> Exercise {
        switch id {
        case 1:
            return exercise1
        case 2:
            return exercise2
            
        default:
            return exercise1
        }
    }
    
    static var exercise1: Exercise {
        return Exercise(id: 1,
                        questionText: "Solve for x",
                        questionLatex: "\\sqrt{x^2}",
                        answer: "x",
                        falseAnswer1: "y",
                        falseAnswer2: "z",
                        falseAnswer3: "j")
    }
    
    static var exercise2: Exercise {
        return Exercise(id: 2,
                        questionText: "Solve for y",
                        questionLatex: "\\sqrt{y^2}",
                        answer: "y",
                        falseAnswer1: "x",
                        falseAnswer2: "z",
                        falseAnswer3: "j")
    }
}



