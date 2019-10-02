//
//  PrepareFeedViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class PrepareFeedViewModel {
    
    //MARK: - Dependencies
    
    private let feedPackageStore: FeedPackageStore
    
    //MARK: - Initialization
    
    init(feedPackageStore: FeedPackageStore) {
        self.feedPackageStore = feedPackageStore
        feedPackageStore.dispatch(action: .updateFeedPackage)
    }
    
}
