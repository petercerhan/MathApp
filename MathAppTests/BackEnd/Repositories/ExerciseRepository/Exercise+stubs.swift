//
//  Exercise+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension Exercise {
    
    static func createStub(diagram: String? = nil) -> Exercise {
        return Exercise(id: 1,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(1)",
                        answer: "0",
                        falseAnswer1: "x",
                        falseAnswer2: "1",
                        falseAnswer3: "dx",
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: diagram)
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
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var exercise2: Exercise {
        return Exercise(id: 2,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(2)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "2",
                        falseAnswer3: "x",
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var exercise3: Exercise {
        return Exercise(id: 3,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(3)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "3",
                        falseAnswer3: "x",
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var exercise4: Exercise {
        return Exercise(id: 4,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(10)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "10",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var exercise5: Exercise {
        return Exercise(id: 5,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(-1)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "dx",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var exercise6: Exercise {
        return Exercise(id: 6,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(1.5)",
                        answer: "0",
                        falseAnswer1: "1",
                        falseAnswer2: "1.5",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var exercise7: Exercise {
        return Exercise(id: 7,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(y)",
                        answer: "0",
                        falseAnswer1: "y",
                        falseAnswer2: "1",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var exercise8: Exercise {
        return Exercise(id: 8,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(z)",
                        answer: "0",
                        falseAnswer1: "z",
                        falseAnswer2: "1",
                        falseAnswer3: "-1",
                        concept: Concept.constantRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    //MARK: - Linear Rule
    
    static var linearRule_exercise1: Exercise {
        return Exercise(id: 9,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(2x)",
                        answer: "2",
                        falseAnswer1: "1",
                        falseAnswer2: "2x",
                        falseAnswer3: "x",
                        concept: Concept.linearRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var linearRule_exercise2: Exercise {
        return Exercise(id: 10,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(3x)",
                        answer: "3",
                        falseAnswer1: "3x",
                        falseAnswer2: "0",
                        falseAnswer3: "x",
                        concept: Concept.linearRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var linearRule_exercise3: Exercise {
        return Exercise(id: 11,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(ax)",
                        answer: "a",
                        falseAnswer1: "1",
                        falseAnswer2: "0",
                        falseAnswer3: "x",
                        concept: Concept.linearRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var linearRule_exercise4: Exercise {
        return Exercise(id: 12,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(yx)",
                        answer: "y",
                        falseAnswer1: "yx",
                        falseAnswer2: "\\frac{1}{2}x",
                        falseAnswer3: "x",
                        concept: Concept.linearRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var linearRule_exercise5: Exercise {
        return Exercise(id: 13,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(-2x)",
                        answer: "-2",
                        falseAnswer1: "-1",
                        falseAnswer2: "-2x",
                        falseAnswer3: "\\frac{1}{2}x^2",
                        concept: Concept.linearRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var linearRule_exercise6: Exercise {
        return Exercise(id: 14,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(y^3x)",
                        answer: "y^3",
                        falseAnswer1: "\\frac{1}{2}y^2",
                        falseAnswer2: "3x",
                        falseAnswer3: "0",
                        concept: Concept.linearRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var linearRule_exercise7: Exercise {
        return Exercise(id: 15,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(-a^2x)",
                        answer: "-a^2",
                        falseAnswer1: "a",
                        falseAnswer2: "a^2",
                        falseAnswer3: "1",
                        concept: Concept.linearRule,
                        difficulty: 1,
                        diagram: nil)
    }
    
    static var linearRule_exercise8: Exercise {
        return Exercise(id: 16,
                        questionText: "Find the derivative:",
                        questionLatex: "\\frac{d}{dx}(-ax)",
                        answer: "-a",
                        falseAnswer1: "1",
                        falseAnswer2: "0",
                        falseAnswer3: "x",
                        concept: Concept.linearRule,
                        difficulty: 1,
                        diagram: nil)
    }
}




