//
//  UserRepository.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

protocol UserRepository {
    func get() -> User?
    func setLearningStrategy(_ strategy: LearningStrategy)
}

class UserRepositoryImpl: UserRepository {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - UserRepository Interface
    
    func get() -> User? {
        let query = User.table.filter(User.column_id == 1)
        
        guard let userRow = try? databaseService.db.pluck(query) else {
            return nil
        }
        
        let id = Int(userRow[User.column_id])
        let learningStrategyID = Int(userRow[User.column_learningStrategyID])
        
        return User(id: id, learningStrategyID: learningStrategyID)
    }
    
    func setLearningStrategy(_ strategy: LearningStrategy) {
        let query = User.table.filter(User.column_id == Int64(1))
        _ = try? databaseService.db.run(query.update(User.column_learningStrategyID <- Int64(strategy.rawValue)))
    }
}
