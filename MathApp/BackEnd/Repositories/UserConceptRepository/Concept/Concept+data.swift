//
//  Concept+data.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/6/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

extension Concept {
    
    static var constantRule: Concept {
        return Concept(id: 1, name: "Constant Rule",
                       description: "The derivative of a constant is 0",
                       rule: "\\frac{d}{dx}(c) = 0",
                       example: "\\frac{d}{dx}(5) = 0",
                       maxDifficulty: 3,
                       groupID: 1)
    }
    
    static var linearRule: Concept {
        return Concept(id: 2, name: "Linear Rule",
                       description: "The derivative of a linear function is the constant factor",
                       rule: "\\frac{d}{dx}(cx) = c",
                       example: "\\frac{d}{dx}(3x) = 3",
                       maxDifficulty: 3,
                       groupID: 1)
    }
    
    static var powerRule: Concept {
        return Concept(id: 3, name: "Power Rule",
                       description: "The derivative of a power follows this rule:",
                       rule: "\\frac{d}{dx}(cx) = c",
                       example: "\\frac{d}{dx}(3x) = 3",
                       maxDifficulty: 2,
                       groupID: 1)
    }
    
    static var sumRule: Concept {
        return Concept(id: 4, name: "Sum Rule",
                       description: "The derivative of a sum is the sum of the derivatives",
                       rule: "\\frac{d}{dx}(cx) = c",
                       example: "\\frac{d}{dx}(3x) = 3",
                       maxDifficulty: 2,
                       groupID: 1)
    }
    
    static var differenceRule: Concept {
        return Concept(id: 5, name: "Difference Rule",
                       description: "The derivative of a difference is the difference of the derivatives",
                       rule: "\\frac{d}{dx}(cx) = c",
                       example: "\\frac{d}{dx}(3x) = 3",
                       maxDifficulty: 2,
                       groupID: 1)
    }
    
}
