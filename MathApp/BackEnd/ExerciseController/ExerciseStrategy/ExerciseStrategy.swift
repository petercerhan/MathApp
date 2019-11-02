//
//  ExerciseStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol ExerciseStrategy {
    func getExercises() -> [Exercise]
    func getExercises(conceptIDs: [Int]) -> [Exercise]
}
