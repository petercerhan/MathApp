//
//  FakeQuitableContainerViewModel.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp


class FakeQuitableContainerViewModel: QuitableContainerViewModel {
    var dispatch_callCount = 0
    func dispatch(action: QuitableContainerAction) {
        dispatch_callCount += 1
    }
    
    var setDelegate_callCount = 0
    func setDelegate(_ delegate: QuitableContainerViewModelDelegate?) {
        setDelegate_callCount += 1
    }
}


