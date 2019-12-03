//
//  GlobalComposer+feed.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/3/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

extension GlobalComposer {
    
    func composeExerciseCoordinator() -> FeedCoordinator {
        let resultsStore = ResultsStoreImpl()
        let exercisesStore = FeedExercisesStoreImpl(exerciseExternalDataService: ExerciseExternalDataServiceImpl(exerciseController: exerciseController))
        let containerVM = FeedContainerViewModel(delegate: nil, resultsStore: resultsStore)
        let userConceptEDS = UserConceptExternalDataServiceImpl(userConceptController: userConceptController)
        let exerciseEDS = ExerciseExternalDataServiceImpl(exerciseController: exerciseController)
        
        let composer = FeedComposer(resultsStore: resultsStore)
        return FeedCoordinator(composer: composer,
                               globalComposer: self,
                               containerVC: FeedContainerViewController(viewModel: containerVM),
                               randomizationService: RandomizationServiceImpl(),
                               resultsStore: resultsStore,
                               learningStepStore: learningStepStore,
                               exercisesStore: exercisesStore,
                               userConceptEDS: userConceptEDS,
                               exerciseEDS: exerciseEDS)
    }
    
}

protocol GlobalComposer_FeedCoordinator {
    func composeExerciseCoordinator() -> FeedCoordinator
    func composeMenuCoordinator(delegate: MenuCoordinatorDelegate) -> MenuCoordinator
}

extension GlobalComposer: GlobalComposer_FeedCoordinator {
    
}
