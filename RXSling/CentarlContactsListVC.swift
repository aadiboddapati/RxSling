//
//  CentarlContactsListVC.swift
//  RXSling Stage
//
//  Created by Aadi on 28/08/20.
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

class ContactsTableCell: UITableViewCell {
    
    @IBOutlet weak var nameInitialslabel:UILabel!
    @IBOutlet weak var titlelabel:UILabel!
    @IBOutlet weak var subTitleLabel:UILabel!
    @IBOutlet weak var locationLabel:UILabel!
    
    var cellBgColor:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         nameInitialslabel.layer.cornerRadius = 30
        nameInitialslabel.layer.masksToBounds = true
    }
}

class CentarlContactsListVC: UIViewController {
    weak var centralContactDelegate:CenntralContactListProtocol?
    var sections = [Section]()
    var centralContactList: CentralContactList?
    let sectionTitles = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var colorsArray: [UIColor] = [.systemRed, .systemGreen, .systemBlue, .systemPink, .systemOrange, .systemPurple, .rxYellow]
    @IBOutlet weak var contactsTableView: UITableView!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CENTRAL CONTACTS BOOK"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        self.contactsTableView.sectionIndexColor = .white
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.showsCancelButton = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        
        configureSearchBar(reportSearchBar: searchController.searchBar)
        
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
    
    func configureSearchBar(reportSearchBar: UISearchBar)  {
        
        let searchTextField:UITextField = (reportSearchBar.value(forKey: "searchField") as? UITextField)!
        
        let imageV = searchTextField.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.white
        searchTextField.tintColor = UIColor.white
        
        searchTextField.backgroundColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.layer.borderColor = UIColor.rxGreen.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.textColor = UIColor.white
        
        reportSearchBar.backgroundColor = .clear
        reportSearchBar.tintColor = .clear
        reportSearchBar.backgroundImage = UIImage()
        reportSearchBar.isTranslucent = true
        reportSearchBar.returnKeyType = .default
    }
    
}


extension CentarlContactsListVC: UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].contacts.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableCell", for: indexPath) as! ContactsTableCell
        cell.selectionStyle = .none
        
        if let color = cell.cellBgColor {
           cell.nameInitialslabel.backgroundColor = color
        } else {
             let randomIndex = Int(arc4random_uniform(UInt32(colorsArray.count)))
            let randomColor = colorsArray[randomIndex]
            cell.cellBgColor = randomColor
            cell.nameInitialslabel.backgroundColor = randomColor
            
        }
        
        let name = "\(sections[indexPath.section].contacts[indexPath.row].firstName?.first ?? " ")" + "\(sections[indexPath.section].contacts[indexPath.row].lastName?.first ?? " ")"
        cell.nameInitialslabel.text = name.uppercased()
        
        cell.titlelabel?.text = (sections[indexPath.section].contacts[indexPath.row].firstName ?? "") + " " + ( sections[indexPath.section].contacts[indexPath.row].lastName ?? "" )
        cell.subTitleLabel?.text = sections[indexPath.section].contacts[indexPath.row].phoneNumberForSms ?? ""
        cell.locationLabel?.text = sections[indexPath.section].contacts[indexPath.row].city ?? ""

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = sections[indexPath.section].contacts[indexPath.row]
        centralContactDelegate?.didSelectCentralContact(contact: contact)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 //( sections[section].contacts.count == 0 ) ? 0 : 34
    }
}

extension CentarlContactsListVC: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //        if self.originalDashboardArray.count == 0 {
        //            return
        //        }
        //
        //        if searchText == "" {
        //            self.dashboardArray = originalDashboardArray
        //            removeTableBackgroundView()
        //            return
        //        }
        //
        //        let filteredData = self.originalDashboardArray.filter({ (sntData) -> Bool in
        //            return sntData.title.lowercased().contains(searchText.lowercased()) || sntData.desc.lowercased().contains(searchText.lowercased())
        //        })
        
        //        removeTableBackgroundView()
        //        self.dashboardArray = filteredData
        //
        //        if filteredData.count == 0 {
        //            showNoRecordsFound()
        //        } else {
        //            removeTableBackgroundView()
        //        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func showNoRecordsFound() {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No search results found"
        self.contactsTableView.backgroundView = label
        
    }
    
    func removeTableBackgroundView() {
        self.contactsTableView.backgroundView = nil
    }}

