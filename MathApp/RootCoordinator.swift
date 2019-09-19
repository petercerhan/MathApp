//
//  RootCoordinator.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import SQLite

class RootCoordinator: Coordinator {
    
    //MARK: - Dependencies
    
    private let compositionRoot: CompositionRoot
    private let containerVC: ContainerViewController
    private let databaseService: DatabaseService
    
    //MARK: - State
    
    private(set) var childCoordinator: Coordinator?
    
    //MARK: - Initialization
    
    init(compositionRoot: CompositionRoot, containerVC: ContainerViewController, databaseService: DatabaseService) {
        self.compositionRoot = compositionRoot
        self.containerVC = containerVC
        self.databaseService = databaseService
    }
    
    //MARK: - Coordinator Interface

    var containerViewController: UIViewController {
        return containerVC
    }
    
//    func start() {
//        let vc = UIViewController()
//        vc.view.backgroundColor = UIColor.blue
//        containerVC.show(viewController: vc, animation: .none)
//
////        let path = Bundle.main.url(forResource: "TestDB", withExtension: "sqlite3")
////        print("dbpath: \(path)")
////
//////        let documentsDirectory = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain:NSSearchPathDomainMask.UserDomainMask, url:nil, shouldCreate:false, error:nil);
////        let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
////        print("document path: \(documentsDirectory)")
//
//
////        let deletePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
////        let fileManager = FileManager.default
////        try? fileManager.removeItem(atPath: "\(deletePath)/database.sqlite3")
//
//
//        guard let sourceURL = Bundle.main.url(forResource: "db", withExtension: "sqlite3"),
//            let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        else {
//            return
//        }
//
//        let destinationURL = documentsDirectory.appendingPathComponent("db.sqlite3")
//
//        do {
//            print("try to copy file")
//            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
//        } catch {
//            print("error: \(error)")
//        }
//
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        guard let db = try? Connection("\(path)/db.sqlite3") else {
//            return
//        }
//
//
//    }
    
    func start() {
        databaseService.setup()

        let coordinator = compositionRoot.composeExerciseCoordinator()
        containerVC.show(viewController: coordinator.containerViewController, animation: .none)
        coordinator.start()
        childCoordinator = coordinator
    }
    
}

