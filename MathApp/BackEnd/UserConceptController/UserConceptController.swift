//
//  UserConceptController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol UserConceptController {
    func update(id: Int, fields: [String: String])
}

class UserConceptControllerImpl: UserConceptController {
    
    //MARK: - Dependencies
    
    private let userConceptRepository: UserConceptRepository
    
    //MARK: - Initialization
    
    init(userConceptRepository: UserConceptRepository) {
        self.userConceptRepository = userConceptRepository
    }
    
    //MARK: - UserConceptController Interface
    
    func update(id: Int, fields: [String: String]) {
        userConceptRepository.set(id: id, fields: fields)
    }
    
}
