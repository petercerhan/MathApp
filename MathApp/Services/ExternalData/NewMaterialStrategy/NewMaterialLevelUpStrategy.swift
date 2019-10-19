//
//  NewMaterialLevelUpStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class NewMaterialLevelUpStrategy {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    
    //MARK: - Config
    
    private let levelUpUserConcept: EnrichedUserConcept
    private var levelUpConceptID: Int {
        return levelUpUserConcept.userConcept.concept.id
    }
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService, levelUpUserConcept: EnrichedUserConcept) {
        self.databaseService = databaseService
        self.levelUpUserConcept = levelUpUserConcept
    }
    
    //MARK: - NewMaterialLevelUpStrategy Interface
    
    func getFeedPackage() -> FeedPackage {
        databaseService.incrementStrengthForUserConcept(conceptID: levelUpConceptID)
        if levelUpUserConcept.userConcept.strength == 0 {
            databaseService.setUserConceptStatus(EnrichedUserConcept.Status.introductionComplete.rawValue, forConceptID: levelUpConceptID)
        }
        
        return FeedPackage(feedPackageType: .exercises, exercises: [], transitionItem: nil)
    }
    
    
    
}
