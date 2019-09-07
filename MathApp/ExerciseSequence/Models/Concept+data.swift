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
                       example: "\\frac{d}{dx}(5) = 0")
    }
    
}
