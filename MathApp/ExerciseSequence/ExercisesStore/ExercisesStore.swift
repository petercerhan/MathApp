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
    var exercises: Observable<[Exercise]> { get }
    var transitionItem: Observable<FeedItem?> { get }
    func dispatch(action: ExercisesStoreAction)
}

enum ExercisesStoreAction {
    case updateExercises
}

extension ExercisesStore where Self: ExercisesStoreImpl {
    var exercises: Observable<[Exercise]> {
        return exercisesSubject.asObservable()
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
    
    let exercisesSubject = BehaviorSubject<[Exercise]>(value: [])
    let transitionItemSubject = BehaviorSubject<FeedItem?>(value: nil)
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateExercises:
            handle_updateExercises()
        }
    }
    
    private func handle_updateExercises() {
        exerciseExternalDataService.getExercises()
            .subscribe(onNext: { [unowned self] feedPackage in
                self.exercisesSubject.onNext(feedPackage.exercises)
                
                if let transitionItem = feedPackage.transitionItem {
                    self.transitionItemSubject.onNext(transitionItem)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
}
