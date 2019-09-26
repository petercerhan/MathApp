//
//  CompositionRoot.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class CompositionRoot {
    
    func composeRootCoordinator() -> Coordinator {
        return RootCoordinator(compositionRoot: self,
                               containerVC: ContainerViewController(),
                               databaseService: databaseService)
    }
    
    func composeWindow() -> UIWindow {
        return UIWindow(frame: UIScreen.main.bounds)
    }
    
    //MARK: - Exercise sequence
    
    func composeExerciseCoordinator() -> ExerciseCoordinator {
        let resultsStore = ResultsStoreImpl(databaseService: databaseService)
        let exercisesStore = ExercisesStoreImpl(exerciseExternalDataService: exercisesExternalDataService)
        let containerVM = FeedContainerViewModel(delegate: nil, resultsStore: resultsStore)
        return ExerciseCoordinator(compositionRoot: self,
                                   containerVC: FeedContainerViewController(viewModel: containerVM),
                                   randomizationService: RandomizationServiceImpl(),
                                   resultsStore: resultsStore,
                                   exercisesStore: exercisesStore)
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
    
    func composeInfoScene(delegate: InfoViewModelDelegate, concept: Concept) -> UIViewController {
        let vm = InfoViewModelImpl(delegate: delegate, concept: concept)
        return InfoViewController(viewModel: vm)
    }
    
    func composeLoadExercisesScene(delegate: LoadExercisesViewModelDelegate, exercisesStore: ExercisesStore) -> UIViewController {
        let vm = LoadExercisesViewModel(delegate: delegate, exercisesStore: exercisesStore)
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
    
    private lazy var exercisesExternalDataService: ExerciseExternalDataService =  {
        ExerciseExternalDataServiceImpl(databaseService: databaseService, randomizationService: RandomizationServiceImpl())
    }()
    
}
