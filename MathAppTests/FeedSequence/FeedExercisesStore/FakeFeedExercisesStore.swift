//
//  FakeFeedExercisesStore.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeFeedExercisesStore: FeedExercisesStore {
    
    var exercises = Observable<LoadState<[Exercise]>>.just(.noData)
    
    var refresh_callCount = 0
    var refresh_conceptIDs = [[Int]]()
    
    func dispatch(action: FeedExerciseStoreAction) {
        switch action {
        case .refresh(let conceptIDs):
            refresh_callCount += 1
            refresh_conceptIDs.append(conceptIDs)
        }
    }
    
    
}
