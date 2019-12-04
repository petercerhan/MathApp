//
//  UserConceptExternalDataService.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol UserConceptExternalDataService {
    func list(chapterID: Int) -> Observable<[UserConcept]>
    func update(id: Int, fields: [String: String])
}

class UserConceptExternalDataServiceImpl: UserConceptExternalDataService {
    
    //MARK: - Dependencies
    
    private let userConceptController: UserConceptController
    
    //MARK: - Initialization
    
    init(userConceptController: UserConceptController) {
        self.userConceptController = userConceptController
    }
    
    //MARK: - UserConceptExternalDataService Interface
    
    func list(chapterID: Int) -> Observable<[UserConcept]> {
        let userConcepts = userConceptController.list(chapterID: chapterID)
        return Observable.just(userConcepts)
    }
    
    func update(id: Int, fields: [String: String]) {
        userConceptController.update(id: id, fields: fields)
    }
    
}
