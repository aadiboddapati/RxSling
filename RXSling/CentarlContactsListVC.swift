//
//  CentarlContactsListVC.swift
//  RXSling Stage
//
//  Created by Aadi on 28/08/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

struct DoctorListModel: Codable {
       let statusCode: String?
       let data: [DoctorList]?
       let message: String?
}

struct DoctorList: Codable {
   // {"CreatedDate":1592480337012,"DoctorMobNo":"+91 6363 938 338","doctorAccountID":null,"viewTimeStamp":0}
    let CreatedDate:Double?
    let viewTimeStamp:Double?
    let DoctorMobNo: String?
    let doctorAccountID: String?
}

protocol CenntralContactListProtocol:NSObjectProtocol {
    func didSelectCentralContact(contact:ContactList)
}

class ContactsTableCell: UITableViewCell {
    
    @IBOutlet weak var nameInitialslabel:UILabel!
    @IBOutlet weak var titlelabel:UILabel!
    @IBOutlet weak var subTitleLabel:UILabel!
    @IBOutlet weak var locationLabel:UILabel!
    @IBOutlet weak var transperentNameActionButton:UIButton!
    @IBOutlet weak var checkMarkImageview:UIImageView!
    @IBOutlet weak var sentOnLbl:UILabel!
    @IBOutlet weak var viewedOnLbl:UILabel!
    @IBOutlet weak var stackViewHeightConstraint:NSLayoutConstraint!
    var cellBgColor:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         nameInitialslabel.layer.cornerRadius = 30
        nameInitialslabel.layer.masksToBounds = true
    }
}

class CentarlContactsListVC: UIViewController {
    weak var centralContactDelegate:CenntralContactListProtocol?
    var contacts = [ContactList]()
    var originalContacts = [ContactList]()
    
    var doctorIDWithDoctors = [String: [DoctorList]]()

    
    var centralContactList: CentralContactList?
    let sectionTitles = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var colorsArray: [UIColor] = [.systemRed, .systemGreen, .systemBlue, .systemPink, .systemOrange, .systemPurple, .rxYellow]
    @IBOutlet weak var contactsTableView: UITableView!
    var searchController: UISearchController!
    
    var sntId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CENTRAL CONTACTS BOOK"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        
        // side alphabets color
        self.contactsTableView.sectionIndexColor = .white
        self.contactsTableView.tableFooterView = UIView()

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
                for contact in data {
                    if let name = contact.firstName {
                        if char.lowercased() == name.prefix(1).lowercased() {
                            contacts.append(contact)
                        }
                    }
                }
            }
        }
        
        // Duplicating the obj for search functionality
        originalContacts = contacts
        
        // Get doctors list
        getDoctorLsit()
        
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


///MARK: API call
extension CentarlContactsListVC {
    
    func getDoctorLsit()  {
        
        DispatchQueue.main.async {
            showActivityIndicator(View: self.view, Constants.Loader.processing.localizedString())
        }
        
        let api = Constants.Api.getdoctorlist
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        let userEmail = ("\(USERDEFAULTS.value(forKey: "USER_EMAIL")!)")
        let parameters:  [String : Any] =
            ["repEmailId": userEmail, "sntId": self.sntId ?? ""]
        
        _ = HTTPRequest.sharedInstance.newRequest(url: api, method: "POST", params: parameters, header: header, completion: { (response, error) in
            DispatchQueue.main.async {
                hideActivityIndicator(View: self.view)
                
            }
            
            if error != nil  {
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                    self.popupAlert(title: Constants.Alert.title, message: error?.localizedDescription ?? "", actionTitles: ["Ok"], actions:[{action in},nil])
                }
                return
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: response!, options: [])
            let responseData = try! JSONDecoder().decode(DoctorListModel.self, from: jsonData)
            if responseData.statusCode == "100" {
                if let data = responseData.data, data.count > 0 {
                    self.processDoctors(data: data)
                } else {
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        self.popupAlert(title: Constants.Alert.title, message: "No data", actionTitles: ["Ok"], actions:[{action in},nil])
                    }
                }
            } else {
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                    self.popupAlert(title: Constants.Alert.title, message: responseData.message ?? "", actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }
        })
        
    }
    
    func processDoctors(data: [DoctorList])  {
        
        // Group Doctors with groupid
        for doctor in data {
            if let doctorId = doctor.doctorAccountID {
                if  !doctorIDWithDoctors.keys.contains(doctorId)  {
                    doctorIDWithDoctors[doctorId] =  [doctor] // assigning first time
                } else {
                    doctorIDWithDoctors[doctorId]?.append(doctor)
                }
            }
        }
        
        // sort doctors based on date
        for (_, value) in doctorIDWithDoctors.enumerated() {
            
            let sortedArray = value.value.sorted { //(item1, item2) -> Bool in
                let (_, dateString1) = convertTimestampToDate(timestamp: $0.CreatedDate ?? 0)
                let (_, dateString2) = convertTimestampToDate(timestamp: $1.CreatedDate ?? 0)
                return dateString1.toDate()! > dateString2.toDate()!
            }
            doctorIDWithDoctors[value.key] = sortedArray
        }
        
        DispatchQueue.main.async {
            self.contactsTableView.reloadData()
        }
    }
    
    func convertTimestampToDate(timestamp:Double) -> (Date, String)  {
        
        let date = Date(timeIntervalSince1970: (Double( timestamp) / 1000.0))

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "hh:mm a, dd-MMM-yy"
        let dateString = dateFormatter.string(from: date)
        return (date , dateString)
    }
    
    @objc func nameButonAction(_ sender: UIButton) {
        print(sender.tag)
        
        let accountId = contacts[sender.tag].accountId ?? ""
        let doctorName = contacts[sender.tag].firstName ?? ""

        if doctorIDWithDoctors.keys.contains(accountId) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorDetailInfoVC") as! DoctorDetailInfoVC
            vc.modalPresentationStyle = .overFullScreen
            //vc.modalPresentationStyle = .formSheet
            vc.doctorsList = doctorIDWithDoctors[accountId]
            vc.doctorName = doctorName + "'s details"
            self.present(vc, animated: true, completion: nil)
        } else {
            showToast(message: "No sent details available", view: self.view)
        }
        
    }
    
}

extension CentarlContactsListVC: UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles //sections.map{$0.letter}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableCell", for: indexPath) as! ContactsTableCell
        cell.selectionStyle = .none
        cell.transperentNameActionButton.tag =  indexPath.row
        cell.transperentNameActionButton.addTarget(self, action: #selector(nameButonAction(_:)), for: .touchUpInside)
        if let color = cell.cellBgColor {
           cell.nameInitialslabel.backgroundColor = color
        } else {
            let randomIndex = Int(arc4random_uniform(UInt32(colorsArray.count)))
            let randomColor = colorsArray[randomIndex]
            cell.cellBgColor = randomColor
            cell.nameInitialslabel.backgroundColor = randomColor
        }
        
        let name = "\(contacts[indexPath.row].firstName?.first ?? " ")" + "\(contacts[indexPath.row].lastName?.first ?? " ")"
        cell.nameInitialslabel.text = name.uppercased()
        
        cell.titlelabel?.text = (contacts[indexPath.row].firstName ?? "") + " " + ( contacts[indexPath.row].lastName ?? "" )
        
        let designation = contacts[indexPath.row].officialDesignation ?? ""
        let pgDegree = contacts[indexPath.row].pgDegree ?? ""
        let speciality = contacts[indexPath.row].specialty ?? ""
        let finalStr  = String(format: "%@,%@,%@", designation,pgDegree,speciality)
        cell.subTitleLabel?.text = finalStr
        
        cell.locationLabel?.text = contacts[indexPath.row].city ?? ""
        
        let accountId = contacts[indexPath.row].accountId ?? ""
        if doctorIDWithDoctors.keys.contains(accountId) {
            cell.checkMarkImageview.isHidden = false
            
            let (_, sentDate) = convertTimestampToDate(timestamp: doctorIDWithDoctors[accountId]?.first?.CreatedDate ?? 0)
            cell.sentOnLbl.text = sentDate
            cell.stackViewHeightConstraint.constant = 18.5
            
            if let viewdDate = doctorIDWithDoctors[accountId]?.first?.viewTimeStamp {
                if viewdDate != 0{
                    let (_, viewdDate) = convertTimestampToDate(timestamp: viewdDate)
                    cell.viewedOnLbl.text = viewdDate
                } else {
                    cell.viewedOnLbl.text = "Not Viewed"
                }
            } else {
                cell.viewedOnLbl.text = "Not Viewed"
            }

        } else {
            cell.checkMarkImageview.isHidden = true
            cell.sentOnLbl.text = ""
            cell.stackViewHeightConstraint.constant = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let accountId = contacts[indexPath.row].accountId ?? ""
        if doctorIDWithDoctors.keys.contains(accountId) {
            return 110.0
        } else {
          return  80
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = contacts[indexPath.row]
        centralContactDelegate?.didSelectCentralContact(contact: contact)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CentarlContactsListVC: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if self.originalContacts.count == 0 {
            return
        }
        
        if searchText == "" {
            self.contacts = originalContacts
            removeTableBackgroundView()
            contactsTableView.reloadData()
            return
        }
        
        let filteredData = self.originalContacts.filter { (contact) -> Bool in
                   let fullname = (contact.firstName ?? "") + " " + ( contact.lastName ?? "" )
                   
                   let designation = contact.officialDesignation ?? ""
                   let pgDegree = contact.pgDegree ?? ""
                   let speciality = contact.specialty ?? ""
                   let finalDesignationStr  = String(format: "%@,%@,%@", designation,pgDegree,speciality)
                   
                return (contact.city ?? "").lowercased().contains(searchText.lowercased()) || fullname.lowercased().contains(searchText.lowercased()) || finalDesignationStr.lowercased().contains(searchText.lowercased())
            }
                
         removeTableBackgroundView()
         self.contacts = filteredData
         
        contactsTableView.reloadData()
        
        if filteredData.count == 0 {
            showNoRecordsFound()
        } else {
            removeTableBackgroundView()
        }
        
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
    }
    
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "hh:mm a, dd-MMM-yy"
        return formatter.date(from: self)
    }
}

