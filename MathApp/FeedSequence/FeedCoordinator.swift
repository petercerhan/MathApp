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
    private let resultsStore: ResultsStore
    private let learningStepStore: LearningStepStore
    private let exercisesStore: FeedExercisesStore
    private let userConceptEDS: UserConceptExternalDataService
    
    //MARK: - State
    
    private var childCoordinator: Coordinator?
    private var exerciseQueue = Queue<Exercise>()
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot,
         containerVC: ContainerViewController,
         randomizationService: RandomizationService,
         resultsStore: ResultsStore,
         learningStepStore: LearningStepStore,
         exercisesStore: FeedExercisesStore,
         userConceptEDS: UserConceptExternalDataService)
    {
        self.compositionRoot = compositionRoot
        self.containerVC = containerVC
        self.randomizationService = randomizationService
        self.resultsStore = resultsStore
        self.learningStepStore = learningStepStore
        self.exercisesStore = exercisesStore
        self.userConceptEDS = userConceptEDS
        
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
        resultsStore.dispatch(action: .setLearningStep(learningStep))
        if let conceptIntroStep = learningStep as? ConceptIntroLearningStep {
            showConceptIntroScene(conceptIntro: conceptIntroStep)
        }
        else if let _ = learningStep as? PracticeTwoConceptsLearningStep {
            showPracticeIntroScene()
        }
        else {
            print("did not recognize learning step type \(learningStep)")
        }
    }
    
    private func showConceptIntroScene(conceptIntro: ConceptIntroLearningStep) {
        let vc = compositionRoot.composeConceptIntroScene(delegate: self, conceptIntro: conceptIntro)
        containerVC.show(viewController: vc, animation: .fadeIn)
        exerciseQueue = Queue<Exercise>()
        exercisesStore.dispatch(action: .refresh)
    }
    
    private func showPracticeIntroScene() {
        let vc = compositionRoot.composePracticeIntroScene(delegate: self)
        containerVC.show(viewController: vc, animation: .fadeIn)
        exerciseQueue = Queue<Exercise>()
        exercisesStore.dispatch(action: .refresh)
    }
    
    private func showNextFeedScene(animation: TransitionAnimation) {
        guard let progressState = latestValue(of: resultsStore.progressState, disposeBag: disposeBag) else {
            return
        }
        
        if progressState.complete {
            showLevelUpScene()
        } else {
            showNextExerciseScene(animation: animation)
        }
    }
    
    private func showLevelUpScene() {
        
        guard let learningStep = latestValue(of: resultsStore.learningStep, disposeBag: disposeBag) else {
            return
        }
        
        if let conceptIntroStep = learningStep as? ConceptIntroLearningStep {
            let concept = conceptIntroStep.userConcept.concept
            let levelUpItem = LevelUpItem(concept: concept, previousLevel: 0, newLevel: 1)
            let vc = compositionRoot.composeLevelUpScene(delegate: self, levelUpItem: levelUpItem)
            containerVC.show(viewController: vc, animation: .fadeIn)

            exerciseQueue = Queue<Exercise>()
            resultsStore.dispatch(action: .reset)
            updateUserConceptLevel(id: concept.id, newStrength: 1)

        } else {
            
            //Fall through
            
            let levelUpItem = LevelUpItem(concept: Concept.linearRule, previousLevel: 1, newLevel: 2)
            let vc = compositionRoot.composeLevelUpScene(delegate: self, levelUpItem: levelUpItem)
            containerVC.show(viewController: vc, animation: .fadeIn)
            exerciseQueue = Queue<Exercise>()
        }
        
        learningStepStore.dispatch(action: .next)
        
    }
    
    private func updateUserConceptLevel(id: Int, newStrength: Int) {
        let fields = ["strength": "\(newStrength)"]
        userConceptEDS.update(id: id, fields: fields)
    }
    
    private func showNextExerciseScene(animation: TransitionAnimation) {
        if let exercise = exerciseQueue.dequeue()  {
            showExerciseScene(exercise, animation: animation)
        } else {
            updateExerciseQueue(animation: animation)
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
//        feedPackageExternalDataService.getExercise(id: id)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] exercise in
//                self.containerVC.dismissModal()
//                self.showExerciseScene(exercise, animation: .fadeIn)
//            })
//            .disposed(by: disposeBag)
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
        showNextLearningStepScene()
    }
}

//MARK: - PracticeIntroViewModelDelegate

extension FeedCoordinator: PracticeIntroViewModelDelegate {
    func next(_ practiceIntroViewModel: PracticeIntroViewModel) {
        showNextFeedScene(animation: .fadeIn)
    }
}
