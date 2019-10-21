//
//  User+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

extension User {
    static let table = Table("users")
    
    static let column_id = Expression<Int64>("id")
    static let column_learningStrategyID = Expression<Int64>("learning_strategy_id")
}
