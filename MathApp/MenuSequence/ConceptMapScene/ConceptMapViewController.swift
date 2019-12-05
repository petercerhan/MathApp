//
//  ConceptMapViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConceptMapViewController: UIViewController, UITableViewDataSource {
    
    //MARK: - Dependencies
    
    private let viewModel: ConceptMapViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private(set) var backButton: UIButton!
    
    //MARK: - State
    
    private var elements = [ConceptMapElement]()
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: ConceptMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ConceptMapViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindUI()
        bindActions()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName:"ConceptMapTableViewCell", bundle: nil), forCellReuseIdentifier: "ConceptMapTableViewCell")
    }
    
    private func bindUI() {
        bindTableView()
        
        viewModel.conceptGroups.subscribe().disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        viewModel.conceptMapElements
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] elements in
                self.elements = elements
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        backButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .back)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptMapTableViewCell") as! ConceptMapTableViewCell
        cell.nameLabel.text = element.name
        cell.strengthLabel.text = "\(element.strength)/3"
        
        return cell
    }
    
}


