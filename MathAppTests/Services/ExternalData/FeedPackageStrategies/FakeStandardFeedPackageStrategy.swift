//
//  FakeStandardFeedPackageStrategy.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/8/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeStandardFeedPackageStrategy: StandardFeedPackageStrategy {
    func getFeedPackage() -> FeedPackage {
        return FeedPackage.exercisesPackage
    }
}
