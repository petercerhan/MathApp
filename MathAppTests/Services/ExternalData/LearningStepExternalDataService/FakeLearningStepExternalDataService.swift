//
//  FakeLearningStepExternalDataService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeLearningStepExternalDataService: LearningStepExternalDataService {

    var stubLearningStep = ConceptIntroLearningStep(conceptID: 1)
    var getNext_callCount = 0
    
    func getNext() -> Observable<LearningStep> {
        getNext_callCount += 1
        return Observable.just(stubLearningStep)
    }

}
