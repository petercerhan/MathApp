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
        let composer = MenuComposer(globalComposer: GlobalComposer())
        super.init(delegate: FakeMenuCoordinatorDelegate(),
                   containerVC: FakeContainerViewController(),
                   composer: composer)
    }
}
