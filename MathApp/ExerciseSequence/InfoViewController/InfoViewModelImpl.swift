//
//  InfoViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol InfoViewModel {
    var infoViewContent: [InfoViewContentElement] { get }
    func dispatch(action: InfoAction)
}

protocol InfoViewModelDelegate: class {
    func quit(_ infoViewModel: InfoViewModelImpl)
}

enum InfoAction {
    case quit
}

class InfoViewModelImpl: InfoViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: InfoViewModelDelegate?
    
    //MARK: - Config
    
    private let concept: Concept
    
    //MARK: - Initialization
    
    init(delegate: InfoViewModelDelegate, concept: Concept) {
        self.delegate = delegate
        self.concept = concept
        
        let titleElement = InfoViewContentElement(contentType: .text, content: concept.name)
        let descriptionElement = InfoViewContentElement(contentType: .text, content: concept.description)
        let exampleIntroElement = InfoViewContentElement(contentType: .text, content: "Example:")
        let exampleLatex = InfoViewContentElement(contentType: .latex, content: concept.example)
        
        infoViewContent = [titleElement, descriptionElement, exampleIntroElement, exampleLatex]
    }
    
    //MARK: - InfoViewModel Interface
    
    let infoViewContent: [InfoViewContentElement]
    
    func dispatch(action: InfoAction) {
        switch action {
        case .quit:
            handle_quit()
        }
    }
    
    private func handle_quit() {
        delegate?.quit(self)
    }

}

