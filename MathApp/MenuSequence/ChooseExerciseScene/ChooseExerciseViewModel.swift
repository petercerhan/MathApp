//
//  ChooseExerciseViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/24/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol ChooseExerciseViewModelDelegate: class {
    func back(_ chooseExerciseViewModel: ChooseExerciseViewModel)
}

enum ChooseExerciseAction {
    case back
}

class ChooseExerciseViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: ChooseExerciseViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: ChooseExerciseViewModelDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - ChooseExerciseViewModel Interface
    
    func dispatch(action: ChooseExerciseAction) {
        switch action {
        case .back:
            handle_back()
        }
    }
    
    private func handle_back() {
        delegate?.back(self)
    }
    
}
