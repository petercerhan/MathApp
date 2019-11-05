//
//  RootCoordinatorComposer.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

protocol RootCoordinatorComposer {
    func composePrepareFeedScene(delegate: PrepareFeedViewModelDelegate) -> UIViewController
}

extension GlobalComposer: RootCoordinatorComposer {
    
}
