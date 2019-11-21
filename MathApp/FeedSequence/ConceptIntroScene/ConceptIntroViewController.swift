//
//  ConceptIntroViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import iosMath
import RxSwift
import RxCocoa

class ConceptIntroViewController: UIViewController, UITableViewDataSource {
    
    //MARK: - Dependencies
    
    private let viewModel: ConceptIntroViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var conceptNameLabel: UILabel!
    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private(set) var nextButton: UIButton!
    
    //MARK: - State
    
    private var detailItems = [ConceptDetailItem]()
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: ConceptIntroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ConceptIntroViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindUI()
        bindActions()
    }
    
    private func setupTableView() {
        tableView.register(ConceptDetailFormulaTableViewCell.self, forCellReuseIdentifier: "ConceptDetailFormulaTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        viewModel.detailItems
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] detailItems in
                
                print("got details \(detailItems.count)")
                
                self.detailItems = detailItems
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        conceptNameLabel.text = viewModel.name
    }
    
    private func bindActions() {
        nextButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .next)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = detailItems[indexPath.row]
        
        if let formulaItem = item as? ConceptDetailFormulaItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptDetailFormulaTableViewCell") as! ConceptDetailFormulaTableViewCell
            print("set latex: \(formulaItem.latex)")
            cell.formulaLabel.latex = formulaItem.latex
            
            cell.backgroundColor = UIColor.blue
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptDetailFormulaTableViewCell") as! ConceptDetailFormulaTableViewCell
            return cell
        }
    }

}


