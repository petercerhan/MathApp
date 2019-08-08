//
//  Coordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

protocol Coordinator {
    var containerViewController: UIViewController { get }
    func start()
}
