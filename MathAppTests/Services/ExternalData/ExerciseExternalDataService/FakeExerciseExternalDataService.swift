//
//  FakeExerciseExternalDataService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeExerciseExternalDataService: FeedPackageExternalDataService {
    
    //MARK: - getNextFeedPackage()

    var getExercises_stubData = FeedPackage(feedPackageType: .exercises, exercises: [Exercise](), transitionItem: nil)
    var getExercises_callCount = 0
    
    func getNextFeedPackage() -> Observable<FeedPackage> {
        getExercises_callCount += 1
        return Observable<FeedPackage>.just(getExercises_stubData)
    }
    
    //MARK: - getFeedPackage(introducedConceptID: )
    
    var getExercises_conceptID_callCount = 0
    var getExercises_conceptID_conceptID = [Int]()
    
    func getFeedPackage(introducedConceptID: Int) -> Observable<FeedPackage>  {
        getExercises_conceptID_callCount += 1
        getExercises_conceptID_conceptID.append(introducedConceptID)
        return Observable<FeedPackage>.just(getExercises_stubData)
    }
    
    //MARK: - getFeedPackage(levelUpConceptID: )
    
    var getFeedPackage_levelUp_callCount = 0
    var getFeedPackage_levelUp_conceptID = [Int]()
    
    func getFeedPackage(levelUpConceptID: Int) -> Observable<FeedPackage> {
        getFeedPackage_levelUp_callCount += 1
        getFeedPackage_levelUp_conceptID.append(levelUpConceptID)
        
        return Observable<FeedPackage>.just(getExercises_stubData)
    }
    
    //MARK: - getExercise(id: )
    
    var getExercise_stubData = Exercise.exercise1
    var getExercise_callCount = 0
    var getExercise_id = [Int]()
    
    func getExercise(id: Int) -> Observable<Exercise> {
        getExercise_callCount += 1
        getExercise_id.append(id)
        
        return Observable.just(getExercise_stubData)
    }
}
