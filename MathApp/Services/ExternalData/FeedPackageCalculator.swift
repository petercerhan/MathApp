//
//  FeedPackageCalculator.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol FeedPackageCalculator {
    func getNextFeedPackage() -> FeedPackage
    func getFeedPackage(introducedConceptID: Int) -> FeedPackage
    func getFeedPackage(levelUpConceptID: Int) -> FeedPackage
}
