//
//  FakeFeedContainerViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeFeedContainerViewModelDelegate: FeedContainerViewModelDelegate {
    
    var menu_callCount = 0
    
    func menu(_ feedContainerViewModel: FeedContainerViewModel) {
        menu_callCount += 1
    }
    
}
