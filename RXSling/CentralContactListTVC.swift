//
//  CentralContactListTVC.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 22/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

struct Section {
    let letter : String
    let names : [String]
}

protocol CenntralConntactListProtocol:NSObjectProtocol {
    
}

class CentralContactListTVC: UITableViewController {

    let sectionTitles = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

    let tableData = ["Aadi","Balu","Chandu","Dhanujay","Eswar","Fayaz","Guru","Hari"]
    
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Central Contacts List"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        
//        // group the array to ["N": ["Nancy"], "S": ["Sue", "Sam"], "J": ["John", "James", "Jenna"], "E": ["Eric"]]
//        let groupedDictionary = Dictionary(grouping: usernames, by: {String($0.prefix(1))})
//        // get the keys and sort them
//        let keys = groupedDictionary.keys.sorted()
//        // map the sorted keys to a struct
//        sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
}

extension CentralContactListTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
