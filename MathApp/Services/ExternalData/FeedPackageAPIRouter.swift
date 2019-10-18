//
//  FeedPackageAPIRouter.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/17/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class FeedPackageAPIRouter {
    
    //MARK: - Dependencies
    
    private let feedPackageCalculator: FeedPackageCalculator
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(feedPackageCalculator: FeedPackageCalculator, databaseService: DatabaseService) {
        self.feedPackageCalculator = feedPackageCalculator
        self.databaseService = databaseService
    }
    
    //MARK: - API Interface
    
    func getNextFeedPackage() -> FeedPackage {
        return feedPackageCalculator.getNextFeedPackage()
    }
    
    func getFeedPackage(introducedConceptID: Int) -> FeedPackage {
        return feedPackageCalculator.getFeedPackage(introducedConceptID: introducedConceptID)
    }
    
    func getFeedPackage(levelUpConceptID: Int) -> FeedPackage {
        return feedPackageCalculator.getFeedPackage(levelUpConceptID: levelUpConceptID)
    }
    
    func getExercise(id: Int) -> Exercise {
        let exercise = databaseService.getExercise(id: id)
        return exercise ?? Exercise.exercise1
    }
    
}
