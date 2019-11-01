//
//  RxLatestValue.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift

func latestValue<T>(of observable: Observable<T>, disposeBag: DisposeBag) -> T? {
    var result: T? = nil
    
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue(label: "rxBridgeQueue").async {
        observable.take(1)
            .subscribe(onNext: { value in
                result = value
                group.leave()
            })
            .disposed(by: disposeBag)
    }
    
    _ = group.wait(timeout: DispatchTime.now() + 0.1)
    
    return result
}

func latestValue<T>(of observable: Observable<T>) -> T? {
    var result: T? = nil
    let disposeBag = DisposeBag()
    
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue(label: "rxBridgeQueue").async {
        observable.take(1)
            .subscribe(onNext: { value in
                result = value
                group.leave()
            })
            .disposed(by: disposeBag)
    }
    
    _ = group.wait(timeout: DispatchTime.now() + 0.1)
    
    return result
}
