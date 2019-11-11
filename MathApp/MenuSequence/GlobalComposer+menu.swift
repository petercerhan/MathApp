//
//  GlobalComposer+menu.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

extension GlobalComposer {
    
    func composeMenuCoordinator(delegate: MenuCoordinatorDelegate) -> MenuCoordinator {
        let quitableContainerVM = QuitableContainerViewModelImpl(delegate: nil)
        let quitableContainer = QuitableContainerViewController(viewModel: quitableContainerVM)
        let composer = MenuComposer(globalComposer: self)
        return MenuCoordinator(delegate: delegate,
                               containerVC: quitableContainer,
                               composer: composer)
    }
    
}
