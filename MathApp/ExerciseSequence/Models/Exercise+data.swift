//
//  Exercise+data.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

extension Exercise {
    static var exercise1: Exercise {
        return Exercise(id: 1,
                        questionText: "Solve for x",
                        questionLatex: "sqrt{x}",
                        answer: "x",
                        falseAnswer1: "y",
                        falseAnswer2: "z",
                        falseAnswer3: "j")
    }
}



