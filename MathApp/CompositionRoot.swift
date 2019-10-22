//
//  CompositionRoot.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class CompositionRoot {
    
    //MARK: - Back End
    
    private(set) lazy var learningStepController: LearningStepController = {
        let userConceptRepository = UserConceptRepositoryImpl(databaseService: databaseService)
        let newMaterialStateRepository = NewMaterialStateRepositoryImpl(databaseService: databaseService)
        let userRepository = UserRepositoryImpl(databaseService: databaseService)
        
        return LearningStepControllerImpl(learningStepStrategyFactory: LearningStepStrategyFactoryImpl(userConceptRepository: userConceptRepository,
                                                                                                       newMaterialStateRepository: newMaterialStateRepository,
                                                                                                       userRepository: userRepository))
    }()
    
    private(set) lazy var learningStepStore: LearningStepStore = {
        let learningStepEDS = LearningStepExternalDataServiceImpl(learningStepController: learningStepController)
        return LearningStepStoreImpl(learningStepExternalDataService: learningStepEDS)
    }()
    
    
    //MARK: - Application Base
    
    func composeRootCoordinator() -> Coordinator {
        let feedPackageStore = FeedPackageStoreImpl(feedPackageExternalDataService: feedPackageExternalDataService)
        return RootCoordinator(compositionRoot: self,
                               containerVC: ContainerViewController(),
                               databaseService: databaseService,
                               feedPackageStore: feedPackageStore)
    }
    
    func composeWindow() -> UIWindow {
        return UIWindow(frame: UIScreen.main.bounds)
    }
    
    func composePrepareFeedScene(delegate: PrepareFeedViewModelDelegate, feedPackageStore: FeedPackageStore) -> UIViewController {
        let vm = PrepareFeedViewModel(delegate: delegate, learningStepStore: learningStepStore)
        return PrepareFeedViewController(viewModel: vm)
    }
    
    //MARK: - Exercise sequence
    
    func composeExerciseCoordinator(feedPackageStore: FeedPackageStore) -> ExerciseCoordinator {
        let resultsStore = ResultsStoreImpl(databaseService: databaseService)
        let containerVM = FeedContainerViewModel(delegate: nil, resultsStore: resultsStore)
        return ExerciseCoordinator(compositionRoot: self,
                                   containerVC: FeedContainerViewController(viewModel: containerVM),
                                   randomizationService: RandomizationServiceImpl(),
                                   feedPackageExternalDataService: feedPackageExternalDataService,
                                   resultsStore: resultsStore,
                                   feedPackageStore: feedPackageStore)
    }
    
    func composeExerciseScene(delegate: ExerciseViewModelDelegate,
                              resultsStore: ResultsStore,
                              exercise: Exercise,
                              choiceConfiguration: ExerciseChoiceConfiguration) -> UIViewController {
        let vm = ExerciseViewModelImpl(delegate: delegate,
                                       resultsStore: resultsStore,
                                       exercise: exercise,
                                       choiceConfiguration: choiceConfiguration)
        return ExerciseViewController(viewModel: vm)
    }
    
    func composeConceptIntroScene(delegate: ConceptIntroViewModelDelegate, conceptIntro: ConceptIntro) -> UIViewController {
        let vm = ConceptIntroViewModel(delegate: delegate, conceptIntro: conceptIntro)
        return ConceptIntroViewController(viewModel: vm)
    }
    
    func composeLevelUpScene(delegate: LevelUpViewModelDelegate, levelUpItem: LevelUpItem) -> UIViewController {
        let vm = LevelUpViewModel(delegate: delegate, levelUpItem: levelUpItem)
        return LevelUpViewController(viewModel: vm)
    }
    
    func composeInfoScene(delegate: InfoViewModelDelegate, concept: Concept) -> UIViewController {
        let vm = InfoViewModelImpl(delegate: delegate, concept: concept)
        return InfoViewController(viewModel: vm)
    }
    
    func composeLoadExercisesScene(delegate: LoadExercisesViewModelDelegate, feedPackageStore: FeedPackageStore) -> UIViewController {
        let vm = LoadExercisesViewModel(delegate: delegate, feedPackageStore: feedPackageStore)
        return LoadExercisesViewController(viewModel: vm)
    }
    
    //MARK: - Menu sequence
    
    func composeMenuCoordinator(delegate: MenuCoordinatorDelegate) -> MenuCoordinator {
        let quitableContainerVM = QuitableContainerViewModelImpl(delegate: nil)
        let quitableContainer = QuitableContainerViewController(viewModel: quitableContainerVM)
        return MenuCoordinator(delegate: delegate, containerVC: quitableContainer, compositionRoot: self)
    }
    
    func composeMenuScene(delegate: MenuViewModelDelegate) -> UIViewController {
        let vm = MenuViewModel(delegate: delegate, databaseService: databaseService)
        return MenuViewController(viewModel: vm)
    }
    
    func composeConceptMapScene(delegate: ConceptMapViewModelDelegate) -> UIViewController {
        let vm = ConceptMapViewModel(delegate: delegate, databaseService: databaseService)
        return ConceptMapViewController(viewModel: vm)
    }
    
    func composeChooseExerciseScene(delegate: ChooseExerciseViewModelDelegate) -> UIViewController {
        let vm = ChooseExerciseViewModel(delegate: delegate)
        return ChooseExerciseViewController(viewModel: vm)
    }
    
    //MARK: - Services
    
    private lazy var databaseService: DatabaseService = {
        DatabaseServiceImpl()
    }()
    
    private lazy var feedPackageExternalDataService: FeedPackageExternalDataService = {
        let exerciseSetCalculator = ExerciseSetCalculatorImpl(databaseService: databaseService, randomizationService: RandomizationServiceImpl())
        let feedPackageCalculator = NewMaterialStandardCalculator(databaseService: databaseService, exerciseSetCalculator: exerciseSetCalculator)
        
        let feedPackageAPIRouter = FeedPackageAPIRouter(feedPackageCalculator: feedPackageCalculator, databaseService: databaseService)
        
        return FeedPackageExternalDataServiceImpl(feedPackageAPIRouter: feedPackageAPIRouter,
                                                   randomizationService: RandomizationServiceImpl())
    }()
    
}



