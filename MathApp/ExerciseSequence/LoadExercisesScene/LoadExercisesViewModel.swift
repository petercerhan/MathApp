//
//  LoadExercisesViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol LoadExercisesViewModelDelegate: class {
    func next(_ loadExercisesViewModel: LoadExercisesViewModel)
}

class LoadExercisesViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: LoadExercisesViewModelDelegate?
    private let exercisesStore: ExercisesStore
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(delegate: LoadExercisesViewModelDelegate, exercisesStore: ExercisesStore) {
        self.delegate = delegate
        self.exercisesStore = exercisesStore
        
        bindExercisesUpdate()
        exercisesStore.dispatch(action: .updateExercises)
    }
    
    private func bindExercisesUpdate() {
//        exercisesStore.exercises
//            .skip(1)
//            .take(1)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] _ in
//                self.delegate?.next(self)
//            })
//            .disposed(by: disposeBag)
        
        exercisesStore.feedPackage
            .compactMap { $0.data }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.delegate?.next(self)
            })
            .disposed(by: disposeBag)
    }
    
}
