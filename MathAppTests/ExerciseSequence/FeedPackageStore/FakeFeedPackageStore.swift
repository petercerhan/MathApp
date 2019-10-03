//
//  FakeExercisesStore.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeFeedPackageStore: FeedPackageStore {
    
    var feedPackage: Observable<LoadState<FeedPackage>> {
        return feedPackageSubject.asObservable()
    }
    private let feedPackageSubject = BehaviorSubject<LoadState<FeedPackage>>(value: .noData)
    
    var stubFeedPackages = [FeedPackage]()
    
    var feedPackageStubIndex = 0
    
    private func nextPackage() {
        guard feedPackageStubIndex < stubFeedPackages.count else {
            return
        }
        let feedPackage = stubFeedPackages[feedPackageStubIndex]
        feedPackageSubject.onNext(.loaded(feedPackage))
        feedPackageStubIndex = (feedPackageStubIndex + 1) % stubFeedPackages.count
    }
    
    func setStubFeedPackage(_ feedPackage: FeedPackage) {
        stubFeedPackages = [feedPackage]
        feedPackageStubIndex = 0
        nextPackage()
    }
    
    func setStubFeedPackage_doNotEmit(_ feedPackage: FeedPackage) {
        stubFeedPackages = [feedPackage]
        feedPackageStubIndex = 0
    }
    
    func setStubFeedPackages(_ feedPackages: [FeedPackage]) {
        stubFeedPackages = feedPackages
        feedPackageStubIndex = 0
        nextPackage()
    }
    
    
    func setStubFeedPackageLoadState(_ loadState: LoadState<FeedPackage>) {
        feedPackageSubject.onNext(loadState)
    }
    
    var updateFeedPackage_callCount = 0
    var setTransitionItemSeen_callCount = 0
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateFeedPackage:
            updateFeedPackage_callCount += 1
            nextPackage()
        case .setConceptIntroSeen:
            setTransitionItemSeen_callCount += 1
            nextPackage()
        }
    }
    
}
