//
//  UserConceptGroupExternalDataService.swift
//  MathApp
//
//  Created by Peter Cerhan on 12/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

protocol UserConceptGroupExternalDataService {
    func list(chapterID: Int) -> Observable<[UserConceptGroup]>
}

class UserConceptGroupExternalDataServiceImpl: UserConceptGroupExternalDataService {
    
    //MARK: - Dependencies
    
    private let userConceptGroupController: UserConceptGroupController
    
    //MARK: - Initialization
    
    init(userConceptGroupController: UserConceptGroupController) {
        self.userConceptGroupController = userConceptGroupController
    }
    
    //MARK: - UserConceptGroupExternalDataService Interface
    
    func list(chapterID: Int) -> Observable<[UserConceptGroup]> {
        let userConceptGroups = userConceptGroupController.list(chapterID: chapterID)
        return Observable<[UserConceptGroup]>.just(userConceptGroups)
    }
    
}
