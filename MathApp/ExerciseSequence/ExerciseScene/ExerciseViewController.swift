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
    
    private func bindActions() {
        bindChoice1Action()
        bindChoice2Action()
    }
    
    private func bindChoice1Action() {
        choice1Button.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .choice1)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChoice2Action() {
        choice2Button.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .choice2)
            })
            .disposed(by: disposeBag)
    }

}
