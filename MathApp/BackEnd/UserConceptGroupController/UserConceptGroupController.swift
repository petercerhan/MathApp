//
//  UserConceptGroupController.swift
//  MathApp
//
//  Created by Peter Cerhan on 12/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol UserConceptGroupController {
    func list(chapterID: Int) -> [UserConceptGroup]
}

class UserConceptGroupControllerImpl: UserConceptGroupController {
    
    //MARK: - Dependencies
    
    private let userConceptGroupRepository: UserConceptGroupRepository
    
    //MARK: - Initialization
    
    init(userConceptGroupRepository: UserConceptGroupRepository) {
        self.userConceptGroupRepository = userConceptGroupRepository
    }
    
    //MARK: - UserConceptGroupController Interface
    
    func list(chapterID: Int) -> [UserConceptGroup] {
        return userConceptGroupRepository.list(chapterID: chapterID)
    }
    
}
