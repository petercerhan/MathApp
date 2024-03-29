//
//  FeedExercisesStore.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol FeedExercisesStore {
    var exercises: Observable<LoadState<[Exercise]>> { get }
    func dispatch(action: FeedExerciseStoreAction)
}

enum FeedExerciseStoreAction {
    case refresh(conceptIDs: [Int])
}

extension FeedExercisesStore where Self: FeedExercisesStoreImpl {
    var exercises: Observable<LoadState<[Exercise]>> {
        exercisesSubject.asObservable()
    }
}

class FeedExercisesStoreImpl: FeedExercisesStore {
    
    //MARK: - Dependencies
    
    private let exerciseExternalDataService: ExerciseExternalDataService
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(exerciseExternalDataService: ExerciseExternalDataService) {
        self.exerciseExternalDataService = exerciseExternalDataService
    }
    
    //MARK: - FeedExercisesStore Interface
    
    let exercisesSubject = BehaviorSubject<LoadState<[Exercise]>>(value: .noData)
    
    func dispatch(action: FeedExerciseStoreAction) {
        switch action {
        case .refresh(let conceptIDs):
            handle_refresh(conceptIDs: conceptIDs)
        }
    }
    
    private func handle_refresh(conceptIDs: [Int]) {
        exercisesSubject.onNext(.loading)
        exerciseExternalDataService.getNext(conceptIDs: conceptIDs)
            .subscribe(onNext: { [unowned self] exercises in
                self.exercisesSubject.onNext(.loaded(exercises))
            })
            .disposed(by: disposeBag)
    }
    
}
