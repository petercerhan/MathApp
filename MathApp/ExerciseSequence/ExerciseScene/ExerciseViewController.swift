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
    @IBOutlet private(set) var choice2Button: UIButton!
    @IBOutlet private(set) var choice3Button: UIButton!
    
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
        bindUI()
    }
    
    private func bindUI() {
        bindQuestionText()
        bindQuestionLatex()
        bindChoice1()
        bindChoice2()
        bindChoice3()
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
            .bind(to: choice1Button.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    private func bindChoice2() {
        viewModel.choice2
            .observeOn(MainScheduler.instance)
            .bind(to: choice2Button.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    private func bindChoice3() {
        viewModel.choice3
            .observeOn(MainScheduler.instance)
            .bind(to: choice3Button.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }

}
