//
//  ProgressState.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/24/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct ProgressState {
    var required: Int
    var correct: Int
    var complete: Bool {
        return correct == required
    }
}
