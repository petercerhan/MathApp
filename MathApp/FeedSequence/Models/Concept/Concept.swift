//
//  Concept.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/6/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct Concept: Codable {
    let id: Int
    let name: String
    let description: String
    let rule: String
    let example: String
    let maxDifficulty: Int
}
