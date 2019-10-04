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
    private let randomizationService: RandomizationService
    private let exerciseExternalDataService: ExerciseExternalDataService
    private let resultsStore: ResultsStore
    private let feedPackageStore: FeedPackageStore
    
    //MARK: - State
    
    private var childCoordinator: Coordinator?
    private var exerciseQueue = Queue<Exercise>()
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot,
         containerVC: ContainerViewController,
         randomizationService: RandomizationService,
         exerciseExternalDataService: ExerciseExternalDataService,
         resultsStore: ResultsStore,
         feedPackageStore: FeedPackageStore)
    {
        self.compositionRoot = compositionRoot
        self.containerVC = containerVC
        self.randomizationService = randomizationService
        self.exerciseExternalDataService = exerciseExternalDataService
        self.resultsStore = resultsStore
        self.feedPackageStore = feedPackageStore
        
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
        showNextFeedScene(animation: .none, canTransition: true)
    }
    
    private func showNextFeedScene(animation: TransitionAnimation, canTransition: Bool) {
        if canTransition,
            let feedPackage = latestValue(of: feedPackageStore.feedPackage, disposeBag: disposeBag)?.data,
            let transitionItem = feedPackage.transitionItem
        {
            showTransitionItem(transitionItem)
            return
        }
        
        if exerciseQueue.count > 0 {
            showNextExerciseScene(animation: animation)
        } else {
            updateExerciseQueue(animation: animation)
        }
    }
    
    private func showTransitionItem(_ transitionItem: FeedItem) {
        if let conceptIntro = transitionItem as? ConceptIntro {
            showConceptIntroScene(conceptIntro: conceptIntro)
        } else if let levelUpItem = transitionItem as? LevelUpItem  {
            showLevelUpScene(levelUpItem: levelUpItem)
        }
    }
    
    private func showConceptIntroScene(conceptIntro: ConceptIntro) {
        let vc = compositionRoot.composeConceptIntroScene(delegate: self, conceptIntro: conceptIntro)
        containerVC.show(viewController: vc, animation: .fadeIn)
        feedPackageStore.dispatch(action: .setConceptIntroSeen(conceptID: conceptIntro.concept.id))
        exerciseQueue = Queue<Exercise>()
    }
    
    private func showLevelUpScene(levelUpItem: LevelUpItem) {
        let vc = compositionRoot.composeLevelUpScene(delegate: self, levelUpItem: levelUpItem)
        containerVC.show(viewController: vc, animation: .fadeIn)
        feedPackageStore.dispatch(action: .setLevelUpSeen(conceptID: levelUpItem.concept.id))
        exerciseQueue = Queue<Exercise>()
    }
    
    private func showNextExerciseScene(animation: TransitionAnimation) {
        if let exercise = exerciseQueue.dequeue() {
            showExerciseScene(exercise, animation: animation)
        }
    }
    
    private func showExerciseScene(_ exercise: Exercise, animation: TransitionAnimation) {
        let vc = composeExerciseScene(forExercise: exercise)
        containerVC.show(viewController: vc, animation: animation)
        refreshFeedPackageIfNeeded()
    }
    
    private func refreshFeedPackageIfNeeded() {
        
        if exerciseQueue.count == 0, !transitionItemQueued() {
            feedPackageStore.dispatch(action: .updateFeedPackage)
        }
    }
    
    private func transitionItemQueued() -> Bool {
        guard let feedPackage = latestValue(of: feedPackageStore.feedPackage, disposeBag: disposeBag)?.data else {
            return false
        }
        
        return (feedPackage.transitionItem != nil)
    }
    
    private func updateExerciseQueue(animation: TransitionAnimation) {
        guard let exercises = latestValue(of: feedPackageStore.feedPackage, disposeBag: disposeBag)?.data?.exercises,
            exercises.count > 0
        else {
            loadNewExercises()
            return
        }
        
        exerciseQueue.enqueue(elements: exercises)
        showNextFeedScene(animation: animation, canTransition: false)
    }
    
    private func composeExerciseScene(forExercise exercise: Exercise) -> UIViewController {
        let choiceConfiguration = randomizationService.randomizedExerciseChoiceConfiguration()
        
        return compositionRoot.composeExerciseScene(delegate: self,
                                                    resultsStore: resultsStore,
                                                    exercise: exercise,
                                                    choiceConfiguration: choiceConfiguration)
    }
    
    private func loadNewExercises() {
        let vc = compositionRoot.composeLoadExercisesScene(delegate: self, feedPackageStore: feedPackageStore)
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
    func next(_ exerciseViewModel: ExerciseViewModel, correctAnswer: Bool) {
        showNextFeedScene(animation: .fadeIn, canTransition: correctAnswer)
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
    
    func loadExercise(_ menuCoordinator: MenuCoordinator, withID id: Int) {
        exerciseExternalDataService.getExercise(id: id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] exercise in
                self.containerVC.dismissModal()
                self.showExerciseScene(exercise, animation: .fadeIn)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - LoadExercisesViewModelDelegate

extension ExerciseCoordinator: LoadExercisesViewModelDelegate {
    func next(_ loadExercisesViewModel: LoadExercisesViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) { [weak self] in
            self?.showNextFeedScene(animation: .fadeIn, canTransition: false)
        }
    }
}

//MARK: - ConceptIntroViewModelDelegate

extension ExerciseCoordinator: ConceptIntroViewModelDelegate {
    func next(_ conceptIntroViewModel: ConceptIntroViewModel) {
        showNextFeedScene(animation: .fadeIn, canTransition: false)
    }
}

//MARK: - LevelUpViewModelDelegate

extension ExerciseCoordinator: LevelUpViewModelDelegate {
    func next(_ levelUpViewModel: LevelUpViewModel) {
        showNextFeedScene(animation: .fadeIn, canTransition: false)
    }
}
