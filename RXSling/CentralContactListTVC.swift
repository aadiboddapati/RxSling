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
    let contacts : [ContactList]
}

protocol CenntralContactListProtocol:NSObjectProtocol {
    func didSelectCentralContact(contact:ContactList)
}

class CentralContactListTVC: UITableViewController {

    weak var centralContactDelegate:CenntralContactListProtocol?
    var sections = [Section]()
    var centralContactList: CentralContactList?
    let sectionTitles = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Central Contacts List"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        if let data = centralContactList?.data {
            for char in sectionTitles {
                var contacts = [ContactList]()
                for contact in data {
                    if let name = contact.firstName {
                        if char == name.prefix(1) {
                            contacts.append(contact)
                        }
                    }
                }
                sections.append(Section(letter: char, contacts: contacts))
            }
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].contacts.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = sections[indexPath.section].contacts[indexPath.row].firstName ?? ""
        cell.detailTextLabel?.text = sections[indexPath.section].contacts[indexPath.row].phoneNumberForSms ?? ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = sections[indexPath.section].contacts[indexPath.row]
        centralContactDelegate?.didSelectCentralContact(contact: contact)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ( sections[section].contacts.count == 0 ) ? 0 : 34
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
           self.dismiss(animated: true, completion: nil)
       }
    
}


extension CentralContactListTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
