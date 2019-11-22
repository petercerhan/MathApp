//
//  DiagramExerciseViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class DiagramExerciseViewController: ExerciseViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: DiagramExerciseViewModel
    
    //MARK: - UI Components
    
    let imageView = UIImageView()
    
    //MARK: - Initialization
    
    init(viewModel: DiagramExerciseViewModel & ExerciseViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        equationLabel.removeFromSuperview()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: questionBodyFrame.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: questionBodyFrame.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: questionBodyFrame.heightAnchor, multiplier: 0.75).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.image = UIImage(named: "TestDiagram")
    }

}
