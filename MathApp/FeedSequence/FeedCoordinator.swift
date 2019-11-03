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
        beginNextLearningStep()
    }
    
    func beginNextLearningStep() {
        guard let learningStep = latestValue(of: learningStepStore.learningStep, disposeBag: disposeBag)?.data else {
            //load learning step scene
            return
        }
        resultsStore.dispatch(action: .setLearningStep(learningStep))
        if let conceptIntroStep = learningStep as? ConceptIntroLearningStep {
            beginConceptIntroStep(conceptIntro: conceptIntroStep)
        }
        else if let learningStep = learningStep as? PracticeTwoConceptsLearningStep {
            beginPracticeTwoConceptsStep(learningStep: learningStep)
        }
        else {
            print("did not recognize learning step type \(learningStep)")
        }
    }
    
    private func beginConceptIntroStep(conceptIntro: ConceptIntroLearningStep) {
        let vc = compositionRoot.composeConceptIntroScene(delegate: self, conceptIntro: conceptIntro)
        containerVC.show(viewController: vc, animation: .fadeIn)
        
        let benchmark = ResultBenchmark(conceptID: conceptIntro.userConcept.conceptID, correctAnswersRequired: 5, correctAnswersOutOf: 7)
        resultsStore.dispatch(action: .setBenchmarks([benchmark]))
        
        exerciseQueue = Queue<Exercise>()
        exercisesStore.dispatch(action: .refresh(conceptIDs: [conceptIntro.userConcept.conceptID]))
    }
    
    private func beginPracticeTwoConceptsStep(learningStep: PracticeTwoConceptsLearningStep) {
        let vc = compositionRoot.composePracticeIntroScene(delegate: self)
        containerVC.show(viewController: vc, animation: .fadeIn)
        
        let benchmark1 = ResultBenchmark(conceptID: learningStep.userConcept1.conceptID, correctAnswersRequired: 4, correctAnswersOutOf: 6)
        let benchmark2 = ResultBenchmark(conceptID: learningStep.userConcept2.conceptID, correctAnswersRequired: 4, correctAnswersOutOf: 6)
        resultsStore.dispatch(action: .setBenchmarks([benchmark1, benchmark2]))
        
        exerciseQueue = Queue<Exercise>()
        exercisesStore.dispatch(action: .refresh(conceptIDs: [learningStep.userConcept1.conceptID, learningStep.userConcept2.conceptID]))
    }
    
    private func showNextFeedScene(animation: TransitionAnimation) {
        guard let progressState = latestValue(of: resultsStore.progressState, disposeBag: disposeBag) else {
            return
        }
        
        if progressState.complete {
            showLearningStepCompleteScene()
        } else {
            showNextExerciseScene(animation: animation)
        }
    }
    
    private func showLearningStepCompleteScene() {
        guard let currentLearningStep = latestValue(of: resultsStore.learningStep) as? LearningStep else {
            return
        }
        if currentLearningStep is ConceptIntroLearningStep {
           showLevelUpScene()
        }
        else if let doublePracticeStep = currentLearningStep as? PracticeTwoConceptsLearningStep {
            showDoubleLevelUpScene(learningStep: doublePracticeStep)
        }
        
    }
    
    private func showLevelUpScene() {
        guard let learningStep = latestValue(of: resultsStore.learningStep) else {
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
        }
        
        learningStepStore.dispatch(action: .next)
        
    }
    
    private func showDoubleLevelUpScene(learningStep: PracticeTwoConceptsLearningStep) {
        let userConcept1 = learningStep.userConcept1
        let userConcept2 = learningStep.userConcept2
        let levelUpItem1 = LevelUpItem(concept: userConcept1.concept, previousLevel: userConcept1.strength, newLevel: userConcept1.strength + 1)
        let levelUpItem2 = LevelUpItem(concept: userConcept2.concept, previousLevel: userConcept2.strength, newLevel: userConcept2.strength + 1)
        
        let vc = compositionRoot.composeDoubleLevelUpScene(levelUpItem1: levelUpItem1, levelUpItem2: levelUpItem2)
        containerVC.show(viewController: vc, animation: .fadeIn)
        
        updateUserConceptLevel(id: learningStep.userConcept1.conceptID, newStrength: learningStep.userConcept1.strength + 1)
        updateUserConceptLevel(id: learningStep.userConcept2.conceptID, newStrength: learningStep.userConcept2.strength + 1)
    }
    
    private func updateUserConceptLevel(id: Int, newStrength: Int) {
        let fields = ["strength": "\(newStrength)"]
        userConceptEDS.update(id: id, fields: fields)
    }
    
    private func showNextExerciseScene(animation: TransitionAnimation) {
        if let exercise = exerciseQueue.dequeue()  {
            showExerciseScene(exercise, animation: animation)
        } else {
            reloadExerciseQueueAndAdvanceFeed(animation: animation)
        }
    }
    
    private func showExerciseScene(_ exercise: Exercise, animation: TransitionAnimation) {
        let vc = composeExerciseScene(forExercise: exercise)
        containerVC.show(viewController: vc, animation: animation)
        reloadExerciseQueueIfNeeded()
    }
    
    private func reloadExerciseQueueIfNeeded() {
        if exerciseQueue.count == 0,
            let exercises = latestValue(of: exercisesStore.exercises)?.data,
            let conceptIDs = latestValue(of: resultsStore.practiceConcepts)
        {
            exerciseQueue.enqueue(elements: exercises)
            exercisesStore.dispatch(action: .refresh(conceptIDs: conceptIDs))
        }
    }
    
    private func reloadExerciseQueueAndAdvanceFeed(animation: TransitionAnimation) {
        guard let exercises = latestValue(of: exercisesStore.exercises)?.data,
            exercises.count > 0
        else {
            loadNewExercisesScene()
            return
        }
        guard let conceptIDs = latestValue(of: resultsStore.practiceConcepts) else {
            return
        }
        exerciseQueue.enqueue(elements: exercises)
        exercisesStore.dispatch(action: .refresh(conceptIDs: conceptIDs))
        showNextFeedScene(animation: animation)
    }
    
    private func composeExerciseScene(forExercise exercise: Exercise) -> UIViewController {
        let choiceConfiguration = randomizationService.randomizedExerciseChoiceConfiguration()
        
        return compositionRoot.composeExerciseScene(delegate: self,
                                                    resultsStore: resultsStore,
                                                    exercise: exercise,
                                                    choiceConfiguration: choiceConfiguration)
    }
    
    private func loadNewExercisesScene() {
        //relevant once getting exercises over network
        
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
        beginNextLearningStep()
    }
}

//MARK: - PracticeIntroViewModelDelegate

extension FeedCoordinator: PracticeIntroViewModelDelegate {
    func next(_ practiceIntroViewModel: PracticeIntroViewModel) {
        showNextFeedScene(animation: .fadeIn)
    }
}
