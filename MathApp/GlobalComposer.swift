//
//  CompositionRoot.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class GlobalComposer {
    
    //MARK: - Back End
    
    private(set) lazy var learningStepController: LearningStepController = {
        let userConceptRepository = UserConceptRepositoryImpl(databaseService: databaseService)
        let newMaterialStateRepository = NewMaterialStateRepositoryImpl(databaseService: databaseService)
        let userRepository = UserRepositoryImpl(databaseService: databaseService)
        
        return LearningStepControllerImpl(learningStepStrategyFactory: LearningStepStrategyFactoryImpl(userConceptRepository: userConceptRepository,
                                                                                                       newMaterialStateRepository: newMaterialStateRepository,
                                                                                                       userRepository: userRepository))
    }()
    
    private(set) lazy var exerciseController: ExerciseController = {
        let userRepository = UserRepositoryImpl(databaseService: databaseService)
        let userConceptRepository = UserConceptRepositoryImpl(databaseService: databaseService)
        let newMaterialStateRepository = NewMaterialStateRepositoryImpl(databaseService: databaseService)
        let exerciseRepository = ExerciseRepositoryImpl(databaseService: databaseService)
        let exerciseSetCalculator = ExerciseSetCalculatorImpl(randomizationService: RandomizationServiceImpl(),
                                                              userConceptRepository: userConceptRepository,
                                                              exerciseRepository: exerciseRepository)
        
        let exerciseStrategyFactory = ExerciseStrategyFactoryImpl(exerciseSetCalculator: exerciseSetCalculator, newMaterialStateRepository: newMaterialStateRepository)
        return ExerciseControllerImpl(userRepository: userRepository, exerciseStrategyFactory: exerciseStrategyFactory)
    }()
    
    private(set) lazy var userConceptController: UserConceptController = {
        let userConceptRepository = UserConceptRepositoryImpl(databaseService: databaseService)
        return UserConceptControllerImpl(userConceptRepository: userConceptRepository)
    }()
    
    private(set) lazy var learningStepStore: LearningStepStore = {
        let learningStepEDS = LearningStepExternalDataServiceImpl(learningStepController: learningStepController)
        return LearningStepStoreImpl(learningStepExternalDataService: learningStepEDS)
    }()
    
    
    //MARK: - Application Base
    
    func composeRootCoordinator() -> Coordinator {
        return RootCoordinator(globalComposer: self,
                               rootCoordinatorComposer: self,
                               containerVC: ContainerViewController(),
                               databaseService: databaseService)
    }
    
    func composeWindow() -> UIWindow {
        return UIWindow(frame: UIScreen.main.bounds)
    }
    
    func composePrepareFeedScene(delegate: PrepareFeedViewModelDelegate) -> UIViewController {
        let vm = PrepareFeedViewModel(delegate: delegate, learningStepStore: learningStepStore)
        return PrepareFeedViewController(viewModel: vm)
    }
    
    //MARK: - Menu sequence
    
    //MARK: - Services
    
    lazy var databaseService: DatabaseService = {
        DatabaseServiceImpl()
    }()
    
}



