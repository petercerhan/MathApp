//
//  FakeUserConceptGroupExternalDataService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 12/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeUserConceptGroupExternalDataService: UserConceptGroupExternalDataService {

    var stubUserConceptGroups = [UserConceptGroup]()
    var listByChapter_callCount = 0

    func list(chapterID: Int) -> Observable<[UserConceptGroup]> {
        listByChapter_callCount += 1
        return Observable.just(stubUserConceptGroups)
    }
    
}
