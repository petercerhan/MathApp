//
//  User+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

struct User {
    static let table = Table("users")
    
    static let column_id = Expression<Int64>("id")
    static let column_focus_concept_1 = Expression<Int64>("focus_concept_1")
    static let column_focus_concept_2 = Expression<Int64>("focus_concept_2")
}
