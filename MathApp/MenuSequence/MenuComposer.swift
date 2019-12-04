//
//  MenuComposer.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class MenuComposer {
    
    //MARK: - Dependencies
    
    private let globalComposer: GlobalComposer
    
    //MARK: - Initialization
    
    init(globalComposer: GlobalComposer) {
        self.globalComposer = globalComposer
    }
    
    //MARK: - Factories
    
    func composeMenuScene(delegate: MenuViewModelDelegate) -> UIViewController {
        let vm = MenuViewModel(delegate: delegate,
                               databaseService: globalComposer.databaseService)
        return MenuViewController(viewModel: vm)
    }
    
    func composeConceptMapScene(delegate: ConceptMapViewModelDelegate) -> UIViewController {
        let userConceptEDS = UserConceptExternalDataServiceImpl(userConceptController: globalComposer.userConceptController)
        let vm = ConceptMapViewModel(delegate: delegate,
                                     databaseService: globalComposer.databaseService, userConceptEDS: userConceptEDS)
        return ConceptMapViewController(viewModel: vm)
    }
    
    func composeChooseExerciseScene(delegate: ChooseExerciseViewModelDelegate) -> UIViewController {
        let vm = ChooseExerciseViewModel(delegate: delegate)
        return ChooseExerciseViewController(viewModel: vm)
    }
    
}
