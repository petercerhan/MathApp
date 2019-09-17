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
    func dispatch(action: ExercisesStoreAction)
}

enum ExercisesStoreAction {
    case updateExercises
}

extension ExercisesStore where Self: ExercisesStoreImpl {
    var exercises: Observable<[Exercise]> {
        return exercisesSubject.asObservable()
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
    
    let exercisesSubject = BehaviorSubject<[Exercise]>(value: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
    
    func dispatch(action: ExercisesStoreAction) {
        switch action {
        case .updateExercises:
            handle_updateExercises()
        }
    }
    
    private func handle_updateExercises() {
        exerciseExternalDataService.getExercises()
            .subscribe(onNext: { [unowned self] exercises in
                self.exercisesSubject.onNext(exercises)
            })
            .disposed(by: disposeBag)
    }
    
}
