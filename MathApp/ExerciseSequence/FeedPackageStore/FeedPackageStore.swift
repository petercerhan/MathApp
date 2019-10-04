//
//  ExercisesStore.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol FeedPackageStore {
    var feedPackage: Observable<LoadState<FeedPackage>> { get }
    func dispatch(action: ExercisesStoreAction)
}

enum ExercisesStoreAction {
    case updateFeedPackage
    case setConceptIntroSeen(conceptID: Int)
    case setLevelUpSeen(conceptID: Int)
}

extension FeedPackageStore where Self: FeedPackageStoreImpl {
    var feedPackage: Observable<LoadState<FeedPackage>> {
        return feedPackageSubject.asObservable()
    }
}

class FeedPackageStoreImpl: FeedPackageStore {
    
    //MARK: - Dependencies
    
    private let exerciseExternalDataService: ExerciseExternalDataService
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(exerciseExternalDataService: ExerciseExternalDataService) {
        self.exerciseExternalDataService = exerciseExternalDataService
    }
    
    //MARK: - ExercisesStore Interface
    
    let feedPackageSubject = BehaviorSubject<LoadState<FeedPackage>>(value: .noData)
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateFeedPackage:
            handle_updateFeedPackage()
        case .setConceptIntroSeen(let conceptID):
            handle_setConceptIntroSeen(conceptID: conceptID)
        case .setLevelUpSeen(let conceptID):
            handle_setLevelUpSeen(conceptID: conceptID)
        }
    }
    
    private func handle_updateFeedPackage() {
        feedPackageSubject.onNext(.loading)
        
        exerciseExternalDataService.getNextFeedPackage()
            .subscribe(onNext: { [unowned self] feedPackage in
                self.feedPackageSubject.onNext(.loaded(feedPackage))
            })
            .disposed(by: disposeBag)
    }
    
    private func handle_setConceptIntroSeen(conceptID: Int) {
        feedPackageSubject.onNext(.loading)
        
        exerciseExternalDataService.getFeedPackage(introducedConceptID: conceptID)
            .subscribe(onNext: { [unowned self] feedPackage in
                self.feedPackageSubject.onNext(.loaded(feedPackage))
            })
            .disposed(by: disposeBag)
    }
    
    private func handle_setLevelUpSeen(conceptID: Int) {
        feedPackageSubject.onNext(.loading)
        
        exerciseExternalDataService.getFeedPackage(levelUpConceptID: conceptID)
            .subscribe(onNext: { [unowned self] feedPackage in
                self.feedPackageSubject.onNext(.loaded(feedPackage))
            })
            .disposed(by: disposeBag)
    }
    
}


