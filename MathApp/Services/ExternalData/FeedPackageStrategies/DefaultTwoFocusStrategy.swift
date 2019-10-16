//
//  DefaultTwoFocusStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/15/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class DefaultTwoFocusStrategy: TwoFocusStrategy {
    func getFeedPackage() -> FeedPackage {
        return FeedPackage(feedPackageType: .exercises, exercises: [], transitionItem: nil)
    }
}
