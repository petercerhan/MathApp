//
//  ExerciseCoordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift

class ExerciseCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private let compositionRoot: CompositionRoot
    private let containerVC: ContainerViewController
    private let exerciseService: ExerciseService
    private let randomizationService: RandomizationService
    private let resultsStore: ResultsStore
    private let exercisesStore: ExercisesStore
    
    //MARK: - State
    
    private var childCoordinator: Coordinator?
    var exerciseQueue = Queue<Exercise>()
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot,
         containerVC: ContainerViewController,
         exerciseService: ExerciseService,
         randomizationService: RandomizationService,
         resultsStore: ResultsStore,
         exercisesStore: ExercisesStore)
    {
        self.compositionRoot = compositionRoot
        self.containerVC = containerVC
        self.exerciseService = exerciseService
        self.randomizationService = randomizationService
        self.resultsStore = resultsStore
        self.exercisesStore = exercisesStore
        
        if let feedContainer = containerVC as? FeedContainerViewController {
            feedContainer.viewModel.setDelegate(self)
        }
    }
    
    //MARK: - Coordinator Interface
    
    var containerViewController: UIViewController {
        return containerVC
    }
    
    func start() {
        containerVC.loadViewIfNeeded()
        showNextFeedScene(animation: .none)
    }
    
    private func showNextFeedScene(animation: TransitionAnimation) {
        if exerciseQueue.count > 0 {
            showNextExerciseScene(animation: animation)
        } else {
            updateExerciseQueue(animation: animation)
        }
    }
    
    private func showNextExerciseScene(animation: TransitionAnimation) {
        if let exercise = exerciseQueue.dequeue() {
            let vc = composeExerciseScene(forExercise: exercise)
            containerVC.show(viewController: vc, animation: animation)
            loadExercisesIfNeeded()
        }
    }
    
    private func loadExercisesIfNeeded() {
        if exerciseQueue.count == 0 {
            exercisesStore.dispatch(action: .updateExercises)
        }
    }
    
    private func updateExerciseQueue(animation: TransitionAnimation) {
        guard let exercises = latestValue(of: exercisesStore.exercises, disposeBag: disposeBag),
            exercises.count > 0
        else {
            loadNewExercises()
            return
        }
        exerciseQueue.enqueue(elements: exercises)
        showNextFeedScene(animation: animation)
    }
    
    private func composeExerciseScene(forExercise exercise: Exercise) -> UIViewController {
        let choiceConfiguration = randomizationService.randomizedExerciseChoiceConfiguration()
        
        return compositionRoot.composeExerciseScene(delegate: self,
                                                    resultsStore: resultsStore,
                                                    exercise: exercise,
                                                    choiceConfiguration: choiceConfiguration)
    }
    
    private func loadNewExercises() {
        let vc = compositionRoot.composeLoadExercisesScene(delegate: self, exercisesStore: exercisesStore)
        containerVC.show(viewController: vc, animation: .none)
    }

}

//MARK: - FeedContainerViewModelDelegate

extension ExerciseCoordinator: FeedContainerViewModelDelegate {
    func menu(_ feedContainerViewModel: FeedContainerViewModel) {
        let coordinator = compositionRoot.composeMenuCoordinator(delegate: self)
        containerVC.presentModal(viewController: coordinator.containerViewController)
        coordinator.start()
        childCoordinator = coordinator
    }
}

//MARK: - ExerciseViewModelDelegate

extension ExerciseCoordinator: ExerciseViewModelDelegate {
    func next(_ exerciseViewModel: ExerciseViewModel) {
        showNextFeedScene(animation: .fadeIn)
    }
    
    func info(_ exerciseViewModel: ExerciseViewModel, concept: Concept) {
        let vc = compositionRoot.composeInfoScene(delegate: self, concept: concept)
        containerVC.presentModal(viewController: vc, animation: .fadeIn)
    }
}

//MARK: - InfoViewModelDelegate

extension ExerciseCoordinator: InfoViewModelDelegate {
    func quit(_ infoViewModel: InfoViewModelImpl) {
        containerVC.dismissModal(animation: .uncoverFade)
    }
}

//MARK: - MenuCoordinatorDelegate

extension ExerciseCoordinator: MenuCoordinatorDelegate {
    func quit(_ menuCoordinator: MenuCoordinator) {
        containerVC.dismissModal()
    }
}

//MARK: - LoadExercisesViewModelDelegate

extension ExerciseCoordinator: LoadExercisesViewModelDelegate {
    func next(_ loadExercisesViewModel: LoadExercisesViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) { [weak self] in
            self?.showNextFeedScene(animation: .fadeIn)
        }
    }
}
