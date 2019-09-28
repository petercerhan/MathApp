//
//  ExercisesStore.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol ExercisesStore {
    var feedPackage: Observable<LoadState<FeedPackage>> { get }
//    var exercises: Observable<[Exercise]> { get }
    var transitionItem: Observable<FeedItem?> { get }
    func dispatch(action: ExercisesStoreAction)
}

enum ExercisesStoreAction {
    case updateExercises
    case resetTransitionItem
}

extension ExercisesStore where Self: ExercisesStoreImpl {
    var feedPackage: Observable<LoadState<FeedPackage>> {
        return feedPackageSubject.asObservable()
    }
    
    var transitionItem: Observable<FeedItem?> {
        return transitionItemSubject.asObservable()
    }
}

class ExercisesStoreImpl: ExercisesStore {
    
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
    let transitionItemSubject = BehaviorSubject<FeedItem?>(value: nil)
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateExercises:
            handle_updateExercises()
        case .resetTransitionItem:
            handle_resetTransitionItem()
        }
    }
    
    private func handle_updateExercises() {
        exerciseExternalDataService.getExercises()
            .subscribe(onNext: { [unowned self] feedPackage in
                self.processFeedPackage(feedPackage)
                self.feedPackageSubject.onNext(.loaded(feedPackage))
            })
            .disposed(by: disposeBag)
    }
    
    private func processFeedPackage(_ feedPackage: FeedPackage) {
        if let transitionItem = feedPackage.transitionItem {
            transitionItemSubject.onNext(transitionItem)
        }
    }
    
    private func handle_resetTransitionItem() {
        transitionItemSubject.onNext(nil)
    }
    
}
