//
//  LearningStepExternalDataService.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol LearningStepExternalDataService {
    func getNext() -> Observable<LearningStep>
}

class LearningStepExternalDataServiceImpl: LearningStepExternalDataService {
    
    //MARK: - Dependencies
    
    private let learningStepController: LearningStepController
    
    //MARK: - Initialization
    
    init(learningStepController: LearningStepController) {
        self.learningStepController = learningStepController
    }
    
    //MARK: - LearningStepExternalDataService Interface
    
    func getNext() -> Observable<LearningStep> {
        let learningStep = learningStepController.nextLearningStep()
        return Observable.just(learningStep)
    }
    
}
