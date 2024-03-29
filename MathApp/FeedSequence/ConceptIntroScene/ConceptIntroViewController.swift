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
    @IBOutlet private(set) var iconImageView: UIImageView!
    @IBOutlet private(set) var conceptNameContainer: UIView!
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
        configureUI()
        setupTableView()
        bindUI()
        bindActions()
    }
    
    private func configureUI() {
        conceptNameContainer.layer.borderColor = UIColor.systemBlue.cgColor
        conceptNameContainer.layer.cornerRadius = 8.0
        conceptNameContainer.layer.borderWidth = 1.0
        
        iconImageView.image = UIImage(named: viewModel.icon)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName:"ConceptDetailFormulaTableViewCell", bundle: nil), forCellReuseIdentifier: "ConceptDetailFormulaTableViewCell")
        tableView.register(UINib(nibName:"ConceptDetailDiagramTableViewCell", bundle: nil), forCellReuseIdentifier: "ConceptDetailDiagramTableViewCell")
        tableView.register(UINib(nibName:"ConceptDetailTextTableViewCell", bundle: nil), forCellReuseIdentifier: "ConceptDetailTextTableViewCell")
        
        viewModel.detailItems
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] detailItems in
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
            cell.formulaLabel.latex = formulaItem.latex
            return cell
        }
        else if let diagramItem = item as? ConceptDetailDiagramItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptDetailDiagramTableViewCell") as! ConceptDetailDiagramTableViewCell
            cell.diagramView.image = UIImage(named: diagramItem.diagramCode)
            return cell
        }
        else if let textItem = item as? ConceptDetailTextItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptDetailTextTableViewCell") as! ConceptDetailTextTableViewCell
            cell.customTextLabel.text = textItem.text
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConceptDetailFormulaTableViewCell") as! ConceptDetailFormulaTableViewCell
            return cell
        }
    }

}


