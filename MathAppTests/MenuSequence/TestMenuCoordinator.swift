//
//  TestMenuCoordinator.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class TestMenuCoordinator: MenuCoordinator {
    init() {
        super.init(delegate: FakeMenuCoordinatorDelegate(), containerVC: FakeContainerViewController(), compositionRoot: GlobalComposer())
    }
}
