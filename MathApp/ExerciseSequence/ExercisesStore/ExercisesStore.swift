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
    func dispatch(action: ExercisesStoreAction)
}

enum ExercisesStoreAction {
    case updateExercises
    case setTransitionItemSeen
}

extension ExercisesStore where Self: ExercisesStoreImpl {
    var feedPackage: Observable<LoadState<FeedPackage>> {
        return feedPackageSubject.asObservable()
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
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateExercises:
            handle_updateExercises()
        case .setTransitionItemSeen:
            handle_setTransitionItemSeen()
        }
    }
    
    private func handle_updateExercises() {
        exerciseExternalDataService.getExercises()
            .subscribe(onNext: { [unowned self] feedPackage in
                self.feedPackageSubject.onNext(.loaded(feedPackage))
            })
            .disposed(by: disposeBag)
    }
    
    private func handle_setTransitionItemSeen() {
        
    }
    
}
