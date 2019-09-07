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
        case 3:
            return exercise3
        case 4:
            return exercise4
        case 5:
            return exercise5
        case 6:
            return exercise6
        case 7:
            return exercise7
        case 8:
            return exercise8
            
        default:
            return exercise1
        }
    }
    
    //MARK: - Constant rule
    
    static var exercise1: Exercise {
        return Exercise(id: 1,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(1)",
                        answer: "0",
                        falseAnswer1: "x",
                        falseAnswer2: "1",
                        falseAnswer3: "dx",
                        concept: Concept.constantRule)
    }
    
    static var exercise2: Exercise {
        return Exercise(id: 2,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(1)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "2",
                        falseAnswer3: "x",
                        concept: Concept.constantRule)
    }
    
    static var exercise3: Exercise {
        return Exercise(id: 3,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(3)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "3",
                        falseAnswer3: "x",
                        concept: Concept.constantRule)
    }
    
    static var exercise4: Exercise {
        return Exercise(id: 4,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(10)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "10",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule)
    }
    
    static var exercise5: Exercise {
        return Exercise(id: 5,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(-1)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "dx",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule)
    }
    
    static var exercise6: Exercise {
        return Exercise(id: 6,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(1.5)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "1.5",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule)
    }
    
    static var exercise7: Exercise {
        return Exercise(id: 7,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(y)",
                        answer: "0",
                        falseAnswer1: "y",
                        falseAnswer2: "1",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule)
    }
    
    static var exercise8: Exercise {
        return Exercise(id: 8,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(z)",
                        answer: "0",
                        falseAnswer1: "z",
                        falseAnswer2: "1",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule)
    }
}



