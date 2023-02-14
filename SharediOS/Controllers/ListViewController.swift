//
//  ListViewController.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import UIKit

public final class ListViewController: UITableViewController {
    private var tableModel = [CellController]() {
        didSet { tableView.reloadData() }
    }
    
    public var onRequestToLoad: (() -> Void)?
    public var configureListView: ((UITableView) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        onRequestToLoad?()
        configure()
        configureListView?(tableView)
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableModel[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableModel[indexPath.section].tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableModel[indexPath.section].tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    public func display(sectionController: [CellController]) {
        tableModel = sectionController
    }
    
    private func configure() {
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
    }
}
