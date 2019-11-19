//
//  TransitionLearningStep+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension TransitionLearningStep {
    static func createStub(transitionItems: [TransitionItem] = []) -> TransitionLearningStep {
        return TransitionLearningStep(transitionItems: transitionItems)
    }
    
    static var transitionGroup1To2: TransitionLearningStep {
        let groupCompleteItem = GroupCompleteTransitionItem.createStub()
        return TransitionLearningStep.createStub(transitionItems: [groupCompleteItem])
    }
    
}
