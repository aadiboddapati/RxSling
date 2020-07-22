//
//  CentralContactListTVC.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 22/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class CentralContactListTVC: UITableViewController {

    let tableData = ["Aadi","Balu","Chandu","Dhanujay","Eswar","Fayaz","Guru","Hari"]
    
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
}

extension CentralContactListTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
