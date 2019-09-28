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

class FakeExercisesStore: ExercisesStore {
    
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
    
    func setStubFeedPackageLoadState(_ loadState: LoadState<FeedPackage>) {
        feedPackageSubject.onNext(loadState)
    }
    
    var exercises: Observable<[Exercise]> {
        return exercisesSubject.asObservable()
    }
    private let exercisesSubject = BehaviorSubject<[Exercise]>(value: [])
    
    var stubExercises = [[Exercise]()]
    var stubIndex = 0
    
    func setStubExercises(_ exercises: [[Exercise]]) {
        stubIndex = 0
        stubExercises = exercises
        nextStubExercise()
    }
    
    private func nextStubExercise() {
        let exercises = stubExercises[stubIndex]
        exercisesSubject.onNext(exercises)
        stubIndex = (stubIndex + 1) % stubExercises.count
    }
    
    
    var transitionItem: Observable<FeedItem?> {
        return transitionItemSubject.asObservable()
    }
    
    private let transitionItemSubject = BehaviorSubject<FeedItem?>(value: nil)
    
    func setStubTransitionItem(_ item: FeedItem?) {
        transitionItemSubject.onNext(item)
    }
    
    
    
    var updateExercises_callCount = 0
    var resetTransitionItem_callCount = 0
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateExercises:
            nextStubExercise()
            updateExercises_callCount += 1
        case .resetTransitionItem:
            transitionItemSubject.onNext(nil)
            resetTransitionItem_callCount += 1
        }
    }
    
}
