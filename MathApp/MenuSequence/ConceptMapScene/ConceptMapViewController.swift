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
        tableView.register(UINib(nibName:"ConceptTableViewCell", bundle: nil), forCellReuseIdentifier: "ConceptTableViewCell")
        tableView.register(UINib(nibName:"ConceptGroupTableViewCell", bundle: nil), forCellReuseIdentifier: "ConceptGroupTableViewCell")
    }
    
    private func bindUI() {
        bindTableView()
    }
    
    private func bindTableView() {
        viewModel.mapElements
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
        if let groupElement = element as? GroupConceptMapElement {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptGroupTableViewCell") as! ConceptGroupTableViewCell
            cell.nameLabel.text = groupElement.name
            return cell
        }
        else if let conceptElement = element as? ContentConceptMapElement {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptTableViewCell") as! ConceptTableViewCell
            cell.nameLabel.text = conceptElement.name
            cell.setUIForStrength(conceptElement.strength)
            cell.iconImageView.image = UIImage(named: conceptElement.icon)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptTableViewCell") as! ConceptTableViewCell
        return cell
    }
    
}


