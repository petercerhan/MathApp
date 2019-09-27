//
//  FeedPackage.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct FeedPackage {

    let feedPackageType: FeedPackageType
    let exercises: [Exercise]
    let transitionItem: FeedItem?
    
    enum FeedPackageType: Int {
        case exercises = 1
        case conceptIntro = 2
        case levelUp = 3
    }
    
}
