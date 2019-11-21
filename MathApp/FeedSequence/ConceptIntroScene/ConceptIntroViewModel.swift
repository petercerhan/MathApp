//
//  ConceptIntroViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol ConceptIntroViewModelDelegate: class {
    func next(_ conceptIntroViewModel: ConceptIntroViewModel)
}

protocol ConceptIntroViewModel {
    var detailItems: Observable<[ConceptDetailItem]> { get }
    var name: String { get }
    func dispatch(action: ConceptIntroAction)
}

enum ConceptIntroAction {
    case next
}

extension ConceptIntroViewModel where Self: ConceptIntroViewModelImpl {
    var detailItems: Observable<[ConceptDetailItem]> {
        detailItemsSubject.asObservable()
    }
}

class ConceptIntroViewModelImpl: ConceptIntroViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: ConceptIntroViewModelDelegate?
    
    //MARK: - Config
    
    private let concept: Concept
    
    //MARK: - Initialization
    
    init(delegate: ConceptIntroViewModelDelegate, conceptIntro: ConceptIntroLearningStep) {
        self.delegate = delegate
        concept = conceptIntro.userConcept.concept
        
        let concept = conceptIntro.userConcept.concept
        name = concept.name
        
        updateDetailItems()
    }
    
    private func updateDetailItems() {
        let detailItems = concept.detailGlyphs.map { glyph -> ConceptDetailItem in
            if let formulaGlyph = glyph as? FormulaConceptDetailGlyph {
                return ConceptDetailFormulaItem(latex: formulaGlyph.latex)
            }
            else if let diagramGlyph = glyph as? DiagramConceptDetailGlyph {
                return ConceptDetailDiagramItem(diagramCode: diagramGlyph.diagramCode)
            }
            else if let textGlyph = glyph as? TextConceptDetailGlyph {
                return ConceptDetailTextItem(text: textGlyph.text)
            }
            else {
                return ConceptDetailFormulaItem(latex: "")
            }
        }

        detailItemsSubject.onNext(detailItems)
    }
    
    //MARK: - ConceptIntroViewModel Interface
    
    let detailItemsSubject = BehaviorSubject<[ConceptDetailItem]>(value: [])
    
    let name: String
    
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
