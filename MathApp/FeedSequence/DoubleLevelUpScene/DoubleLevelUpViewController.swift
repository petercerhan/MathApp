//
//  DoubleLevelUpViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/2/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DoubleLevelUpViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: DoubleLevelUpViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var nextButton: UIButton!
    
    @IBOutlet private(set) var concept1NameContainer: UIView!
    @IBOutlet private(set) var concept1IconImageView: UIImageView!
    @IBOutlet private(set) var rule1Label: UILabel!
    
    @IBOutlet private(set) var concept2NameContainer: UIView!
    @IBOutlet private(set) var concept2IconImageView: UIImageView!
    @IBOutlet private(set) var rule2Label: UILabel!
    
    @IBOutlet private(set) var concept1Strength1Bar: UIView!
    @IBOutlet private(set) var concept1Strength2Bar: UIView!
    @IBOutlet private(set) var concept1Strength3Bar: UIView!
    
    @IBOutlet private(set) var concept2Strength1Bar: UIView!
    @IBOutlet private(set) var concept2Strength2Bar: UIView!
    @IBOutlet private(set) var concept2Strength3Bar: UIView!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: DoubleLevelUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DoubleLevelUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindActions()
    }
    
    private func configureUI() {
        rule1Label.text = viewModel.concept1Name
        rule2Label.text = viewModel.concept2Name
        
        concept1NameContainer.layer.borderColor = UIColor.systemBlue.cgColor
        concept1NameContainer.layer.cornerRadius = 8.0
        concept1NameContainer.layer.borderWidth = 1.0
        
        concept2NameContainer.layer.borderColor = UIColor.systemBlue.cgColor
        concept2NameContainer.layer.cornerRadius = 8.0
        concept2NameContainer.layer.borderWidth = 1.0
        
        concept1IconImageView.image = UIImage(named: viewModel.concept1Icon)
        concept2IconImageView.image = UIImage(named: viewModel.concept2Icon)
        
        configureStrengthBars()
    }
    
    private func configureStrengthBars() {
        setInitialStrengthBars()
        animateNewStrengthConcept1()
        animateNewStrengthConcept2()
    }
    
    private func setInitialStrengthBars() {
        if viewModel.concept1PriorLevel > 0 {
            concept1Strength1Bar.backgroundColor = Colors.lightBlue
        }
        if viewModel.concept1PriorLevel > 1 {
            concept1Strength2Bar.backgroundColor = Colors.lightBlue
        }
        
        if viewModel.concept2PriorLevel > 0 {
            concept2Strength1Bar.backgroundColor = Colors.lightBlue
        }
        if viewModel.concept1PriorLevel > 1 {
            concept2Strength2Bar.backgroundColor = Colors.lightBlue
        }
    }
    
    private func animateNewStrengthConcept1() {
        let animationView = UIView()
        animationView.backgroundColor = Colors.lightBlue
        let newStrengthBar = self.newStrengthBarConcept1()
        newStrengthBar.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.leftAnchor.constraint(equalTo: newStrengthBar.leftAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: newStrengthBar.rightAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: newStrengthBar.bottomAnchor).isActive = true
        let heightConstraint = animationView.heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint.isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { [weak self] in
            self?.animateNewStrengthBarConcept1(animationView: animationView, heightConstraint: heightConstraint)
        }
    }
    
    private func animateNewStrengthBarConcept1(animationView: UIView, heightConstraint: NSLayoutConstraint) {
        let newStrengthView = newStrengthBarConcept1()
        
        heightConstraint.isActive = false
        animationView.topAnchor.constraint(equalTo: newStrengthView.topAnchor).isActive = true
        
        UIView.animate(withDuration: 0.55) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    private func newStrengthBarConcept1() -> UIView {
        if viewModel.concept1NewLevel == 1 {
            return concept1Strength1Bar
        } else if viewModel.concept1NewLevel == 2 {
            return concept1Strength2Bar
        } else {
            return concept1Strength3Bar
        }
    }
    
    private func animateNewStrengthConcept2() {
        let animationView = UIView()
        animationView.backgroundColor = Colors.lightBlue
        let newStrengthBar = self.newStrengthBarConcept2()
        newStrengthBar.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.leftAnchor.constraint(equalTo: newStrengthBar.leftAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: newStrengthBar.rightAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: newStrengthBar.bottomAnchor).isActive = true
        let heightConstraint = animationView.heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint.isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { [weak self] in
            self?.animateNewStrengthBarConcept2(animationView: animationView, heightConstraint: heightConstraint)
        }
    }
    
    private func animateNewStrengthBarConcept2(animationView: UIView, heightConstraint: NSLayoutConstraint) {
        let newStrengthView = newStrengthBarConcept2()
        
        heightConstraint.isActive = false
        animationView.topAnchor.constraint(equalTo: newStrengthView.topAnchor).isActive = true
        
        UIView.animate(withDuration: 0.55) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    private func newStrengthBarConcept2() -> UIView {
        if viewModel.concept2NewLevel == 1 {
            return concept2Strength1Bar
        } else if viewModel.concept2NewLevel == 2 {
            return concept2Strength2Bar
        } else {
            return concept2Strength3Bar
        }
    }
    
    private func bindActions() {
        nextButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .next)
            })
        .disposed(by: disposeBag)
    }

}
