//
//  ExerciseCoordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift

class FeedCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private let compositionRoot: CompositionRoot
    private let containerVC: ContainerViewController
    private let randomizationService: RandomizationService
    private let feedPackageExternalDataService: FeedPackageExternalDataService
    private let resultsStore: ResultsStore
    private let learningStepStore: LearningStepStore
    private let exercisesStore: FeedExercisesStore
    
    //MARK: - State
    
    private var childCoordinator: Coordinator?
    private var exerciseQueue = Queue<Exercise>()
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot,
         containerVC: ContainerViewController,
         randomizationService: RandomizationService,
         feedPackageExternalDataService: FeedPackageExternalDataService,
         resultsStore: ResultsStore,
         learningStepStore: LearningStepStore,
         exercisesStore: FeedExercisesStore)
    {
        self.compositionRoot = compositionRoot
        self.containerVC = containerVC
        self.randomizationService = randomizationService
        self.feedPackageExternalDataService = feedPackageExternalDataService
        self.resultsStore = resultsStore
        self.learningStepStore = learningStepStore
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
        
        showNextLearningStepScene()
    }
    
    func showNextLearningStepScene() {
        guard let learningStep = latestValue(of: learningStepStore.learningStep, disposeBag: disposeBag)?.data else {
            //load learning step scene
            return
        }
        if let conceptIntroStep = learningStep as? ConceptIntroLearningStep {
            showConceptIntroScene(conceptIntro: conceptIntroStep.conceptIntro)
        }
    }
    
    private func showConceptIntroScene(conceptIntro: ConceptIntro) {
        let vc = compositionRoot.composeConceptIntroScene(delegate: self, conceptIntro: conceptIntro)
        containerVC.show(viewController: vc, animation: .fadeIn)
        exerciseQueue = Queue<Exercise>()
    }
    
    private func showNextFeedScene(animation: TransitionAnimation) {
        //if show exercises condition
        if exerciseQueue.count > 0 {
            showNextExerciseScene(animation: animation)
        } else {
            updateExerciseQueue(animation: animation)
        }
        
        //else if step complete condition, show step complete feed item
        
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
        
    }
    
    private func updateExerciseQueue(animation: TransitionAnimation) {
        guard let exercises = latestValue(of: exercisesStore.exercises, disposeBag: disposeBag)?.data,
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
//        let vc = compositionRoot.composeLoadExercisesScene(delegate: self, feedPackageStore: feedPackageStore)
//        containerVC.show(viewController: vc, animation: .none)
    }
    
    
    
    
    
    private func showLevelUpScene(levelUpItem: LevelUpItem) {
        let vc = compositionRoot.composeLevelUpScene(delegate: self, levelUpItem: levelUpItem)
        containerVC.show(viewController: vc, animation: .fadeIn)
        exerciseQueue = Queue<Exercise>()
    }

    
}

//MARK: - FeedContainerViewModelDelegate

extension FeedCoordinator: FeedContainerViewModelDelegate {
    func menu(_ feedContainerViewModel: FeedContainerViewModel) {
        let coordinator = compositionRoot.composeMenuCoordinator(delegate: self)
        containerVC.presentModal(viewController: coordinator.containerViewController)
        coordinator.start()
        childCoordinator = coordinator
    }
}

//MARK: - ExerciseViewModelDelegate

extension FeedCoordinator: ExerciseViewModelDelegate {
    func next(_ exerciseViewModel: ExerciseViewModel, correctAnswer: Bool) {
        showNextFeedScene(animation: .fadeIn)
    }
    
    func info(_ exerciseViewModel: ExerciseViewModel, concept: Concept) {
        let vc = compositionRoot.composeInfoScene(delegate: self, concept: concept)
        containerVC.presentModal(viewController: vc, animation: .fadeIn)
    }
}

//MARK: - InfoViewModelDelegate

extension FeedCoordinator: InfoViewModelDelegate {
    func quit(_ infoViewModel: InfoViewModelImpl) {
        containerVC.dismissModal(animation: .uncoverFade)
    }
}

//MARK: - MenuCoordinatorDelegate

extension FeedCoordinator: MenuCoordinatorDelegate {
    func quit(_ menuCoordinator: MenuCoordinator) {
        containerVC.dismissModal()
    }
    
    func loadExercise(_ menuCoordinator: MenuCoordinator, withID id: Int) {
        feedPackageExternalDataService.getExercise(id: id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] exercise in
                self.containerVC.dismissModal()
                self.showExerciseScene(exercise, animation: .fadeIn)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - LoadExercisesViewModelDelegate

extension FeedCoordinator: LoadExercisesViewModelDelegate {
    func next(_ loadExercisesViewModel: LoadExercisesViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) { [weak self] in
            self?.showNextFeedScene(animation: .fadeIn)
        }
    }
}

//MARK: - ConceptIntroViewModelDelegate

extension FeedCoordinator: ConceptIntroViewModelDelegate {
    func next(_ conceptIntroViewModel: ConceptIntroViewModel) {
        showNextFeedScene(animation: .fadeIn)
    }
}

//MARK: - LevelUpViewModelDelegate

extension FeedCoordinator: LevelUpViewModelDelegate {
    func next(_ levelUpViewModel: LevelUpViewModel) {
        showNextFeedScene(animation: .fadeIn)
    }
}
