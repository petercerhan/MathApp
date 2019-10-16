//
//  FakeTwoFocusStrategy.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/15/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeTwoFocusStrategy: TwoFocusStrategy {
    func getFeedPackage() -> FeedPackage {
        return FeedPackage.exercisesPackage
    }
}
