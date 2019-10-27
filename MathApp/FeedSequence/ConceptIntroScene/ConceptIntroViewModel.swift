//
//  ConceptIntroViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol ConceptIntroViewModelDelegate: class {
    func next(_ conceptIntroViewModel: ConceptIntroViewModel)
}

enum ConceptIntroAction {
    case next
}

class ConceptIntroViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: ConceptIntroViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: ConceptIntroViewModelDelegate, conceptIntro: ConceptIntroLearningStep) {
        self.delegate = delegate
        
        let concept = conceptIntro.userConcept.concept
        name = concept.name
        description = concept.description
        ruleLatex = concept.rule
    }
    
    //MARK: - ConceptIntroViewModel Interface
    
    let name: String
    let description: String
    let ruleLatex: String
    
    func dispatch(action: ConceptIntroAction) {
        switch action {
        case .next:
            handle_next()
        }
    }
    
    private func handle_next() {
        delegate?.next(self)
    }
    
}
