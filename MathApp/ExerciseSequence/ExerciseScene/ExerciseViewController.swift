//
//  ExerciseViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import iosMath
import RxSwift
import RxCocoa

enum ExerciseVCDisplayState {
    case question
    case answer
}

class ExerciseViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: ExerciseViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var questionLabel: UILabel!
    @IBOutlet private(set) var questionLatexLabel: MTMathUILabel!
    
    @IBOutlet private(set) var choice1Button: UIButton!
    @IBOutlet private(set) var choice1Label: MTMathUILabel!
    @IBOutlet private(set) var choice1GradeImageView: CheckmarkImageView!
    
    @IBOutlet private(set) var choice2Button: UIButton!
    @IBOutlet private(set) var choice2Label: MTMathUILabel!
    @IBOutlet private(set) var choice2GradeImageView: CheckmarkImageView!
    
    @IBOutlet private(set) var choice3Button: UIButton!
    @IBOutlet private(set) var choice3Label: MTMathUILabel!
    @IBOutlet private(set) var choice3GradeImageView: CheckmarkImageView!
    
    @IBOutlet private(set) var correctFrame: UIView!
    
    @IBOutlet private(set) var nextButton: UIButton!
    
    @IBOutlet private var nextButtonCenter: NSLayoutConstraint!
    @IBOutlet private var correctFrameBottomSpace: NSLayoutConstraint!
    @IBOutlet private var choice1BottomSpace: NSLayoutConstraint!
    @IBOutlet private var choice2BottomSpace: NSLayoutConstraint!
    @IBOutlet private var choice3BottomSpace: NSLayoutConstraint!
    
    private var choice1ButtonIndependentYPositionConstraint: NSLayoutConstraint?
    private var choice2ButtonIndependentYPositionConstraint: NSLayoutConstraint?
    private var choice3ButtonIndependentYPositionConstraint: NSLayoutConstraint?
    
    //MARK: - State
    
    private(set) var displayState: ExerciseVCDisplayState = .question
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: ExerciseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ExerciseViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bindActions()
    }
    
    private func configureUI() {
        choice1Label.contentInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
        choice2Label.contentInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
        choice3Label.contentInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
    }
    
    private func bindUI() {
        bindQuestionText()
        bindQuestionLatex()
        bindChoice1()
        bindChoice2()
        bindChoice3()
        bindChoice1CorrectStatus()
        bindChoice2CorrectStatus()
        bindChoice3CorrectStatus()
        bindDisplayState()
    }
    
    private func bindQuestionText() {
        viewModel.question
            .observeOn(MainScheduler.instance)
            .bind(to: questionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindQuestionLatex() {
        viewModel.questionLatex
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.questionLatexLabel.latex = text
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice1() {
        viewModel.choice1
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.choice1Label.latex = text
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice2() {
        viewModel.choice2
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.choice2Label.latex = text
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice3() {
        viewModel.choice3
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.choice3Label.latex = text
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice1CorrectStatus() {
        viewModel.choice1Correct
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] isCorrect in
                self.choice1GradeImageView.isHidden = false
                self.choice1GradeImageView.setIsCorrect(isCorrect)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice2CorrectStatus() {
        viewModel.choice2Correct
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] isCorrect in
                self.choice2GradeImageView.isHidden = false
                self.choice2GradeImageView.setIsCorrect(isCorrect)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice3CorrectStatus() {
        viewModel.choice3Correct
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] isCorrect in
                self.choice3GradeImageView.isHidden = false
                self.choice3GradeImageView.setIsCorrect(isCorrect)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDisplayState() {
        viewModel.displayState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] displayState in
                self.displayState = displayState
                self.updateUIForDisplayState(displayState)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        bindChoice1Action()
        bindChoice2Action()
        bindChoice3Action()
        bindNextAction()
    }
    
    private func bindChoice1Action() {
        choice1Button.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .choice1)
                self.disableChoiceButtons()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice2Action() {
        choice2Button.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .choice2)
                self.disableChoiceButtons()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice3Action() {
        choice3Button.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .choice3)
                self.disableChoiceButtons()
            })
            .disposed(by: disposeBag)
    }
    
    private func disableChoiceButtons() {
        choice1Button.isEnabled = false
        choice2Button.isEnabled = false
        choice3Button.isEnabled = false
    }
    
    private func bindNextAction() {
        nextButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .next)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUIForDisplayState(_ displayState: ExerciseVCDisplayState) {
        if displayState == .question {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.updateUIForAnswerState()
        }
    }
    
    private func updateUIForAnswerState() {
        switch viewModel.correctChoice {
        case 1:
            updateUIForAnswerChoice1()
        case 2:
            updateUIForAnswerChoice2()
        case 3:
            updateUIForAnswerChoice3()
        default:
            break
        }
    }
    
    private func updateUIForAnswerChoice1() {
        view.bringSubviewToFront(choice1Button)
        
        convertToIndependentButtonLayoutConstraints()
        
        choice1ButtonIndependentYPositionConstraint?.isActive = false
        choice1Button.centerYAnchor.constraint(equalTo: correctFrame.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.choice2Button.alpha = 0
            self.choice3Button.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.animateNextButtonVisible()
        }
    }
    
    private func updateUIForAnswerChoice2() {
        view.bringSubviewToFront(choice2Button)
        
        convertToIndependentButtonLayoutConstraints()
        
        choice2ButtonIndependentYPositionConstraint?.isActive = false
        choice2Button.centerYAnchor.constraint(equalTo: correctFrame.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.choice1Button.alpha = 0
            self.choice3Button.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.animateNextButtonVisible()
        }
    }
    
    private func updateUIForAnswerChoice3() {
        view.bringSubviewToFront(choice3Button)
        
        convertToIndependentButtonLayoutConstraints()
        
        choice3ButtonIndependentYPositionConstraint?.isActive = false
        choice3Button.centerYAnchor.constraint(equalTo: correctFrame.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.choice1Button.alpha = 0
            self.choice2Button.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.animateNextButtonVisible()
        }
    }
    
    private func convertToIndependentButtonLayoutConstraints() {
        nextButtonCenter.isActive = false
        correctFrameBottomSpace.isActive = false
        choice1BottomSpace.isActive = false
        choice2BottomSpace.isActive = false
        choice3BottomSpace.isActive = false
        
        nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: nextButton.frame.minY).isActive = true
        correctFrame.topAnchor.constraint(equalTo: view.topAnchor, constant: correctFrame.frame.minY).isActive = true
        choice1ButtonIndependentYPositionConstraint = choice1Button.topAnchor.constraint(equalTo: view.topAnchor, constant: choice1Button.frame.minY)
        choice2ButtonIndependentYPositionConstraint = choice2Button.topAnchor.constraint(equalTo: view.topAnchor, constant: choice2Button.frame.minY)
        choice3ButtonIndependentYPositionConstraint = choice3Button.topAnchor.constraint(equalTo: view.topAnchor, constant: choice3Button.frame.minY)
        
        choice1ButtonIndependentYPositionConstraint?.isActive = true
        choice2ButtonIndependentYPositionConstraint?.isActive = true
        choice3ButtonIndependentYPositionConstraint?.isActive = true
    }
    
    private func animateNextButtonVisible() {
        nextButton.alpha = 0.0
        nextButton.isHidden = false
        
        UIView.animate(withDuration: 0.35) { [unowned self] in
            self.nextButton.alpha = 1.0
        }
    }

}
