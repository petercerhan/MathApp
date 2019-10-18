//
//  ExerciseExternalDataService.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol FeedPackageExternalDataService {
    func getNextFeedPackage() -> Observable<FeedPackage>
    func getFeedPackage(introducedConceptID: Int) -> Observable<FeedPackage>
    func getFeedPackage(levelUpConceptID: Int) -> Observable<FeedPackage>
    
    func getExercise(id: Int) -> Observable<Exercise>
}

class FeedPackageExternalDataServiceImpl: FeedPackageExternalDataService {

    //MARK: - Dependencies
    
    private let feedPackageAPIRouter: FeedPackageAPIRouter
    private let randomizationService: RandomizationService
    
    //MARK: - Initialization
    
    init(feedPackageAPIRouter: FeedPackageAPIRouter, randomizationService: RandomizationService) {
        self.feedPackageAPIRouter = feedPackageAPIRouter
        self.randomizationService = randomizationService
    }
    
    //MARK: - FeedPackageExternalDataService Interface
    
    func getNextFeedPackage() -> Observable<FeedPackage> {
        let feedPackage = feedPackageAPIRouter.getNextFeedPackage()
        return Observable.just(feedPackage)
    }
    
    func getFeedPackage(introducedConceptID: Int) -> Observable<FeedPackage> {
        let feedPackage = feedPackageAPIRouter.getFeedPackage(introducedConceptID: introducedConceptID)
        return Observable.just(feedPackage)
    }

    func getFeedPackage(levelUpConceptID: Int) -> Observable<FeedPackage> {
        let feedPackage = feedPackageAPIRouter.getFeedPackage(levelUpConceptID: levelUpConceptID)
        return Observable.just(feedPackage)
    }
    
    func getExercise(id: Int) -> Observable<Exercise> {
        let exercise = feedPackageAPIRouter.getExercise(id: id)
        return Observable.just(exercise)
    }
    
    
}
