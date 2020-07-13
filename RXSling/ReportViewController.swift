//
//  ReportViewController.swift
//  RXSling Stage
//
//  Created by Vivek on 6/2/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import PhoneNumberKit

class ReportViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var FilteredData = [Report]()
    var listingData = [Report]()
    
    
    var mobileNumberArray = [String]()
    var tmobilearr:[String] = []
    var mobiarr:[String] = ["vivek","paliwal"]
    var report: Report?
    var snt: SNTData?
    var doctorToken: String!
    var searchBool: Bool = false
    var noReportBool: Bool = false
    var numberIndex: Int = 0
    var fetchIndex: Int = 0
    var shortenUrlData: ShortenData?
    var refreshControl = UIRefreshControl()
    var contactDict = [String: String]() // contact Dictionary
    var previewLoadURL : String!
    var sntTitle: String!
    var sntDesc: String!
    var tapperowindex: Int = 0
    var tappedrowSection: Int = 0
    var viewedInt: Int = 0
    var sntUsedInt: Int = 0
    var tablevHeightConst: CGFloat = 0
    
    var fixedHeight: CGFloat = 280
    var searchFixedHeight:CGFloat = 320
    var minimumTableViewHeight: CGFloat = 80
    var searchViewHeight:CGFloat = 40
    
    
    var tablebyNumber = true
    var isToggleClicked = false
    
    @IBOutlet weak var tableViewTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var tableViewbottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var reportListViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var noreportlblConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    // @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var reportSearchBar: UISearchBar!
    @IBOutlet weak var createdBylbl:UILabel!
    @IBOutlet weak var noReplbl:UILabel!
    @IBOutlet weak var lblTotal:UILabel!
    @IBOutlet weak var lblTotalsub:UILabel!
    @IBOutlet weak var lblShared:UILabel!
    @IBOutlet weak var lblsharedSub:UILabel!
    @IBOutlet weak var lblAvailable:UILabel!
    @IBOutlet weak var lblAvailablesub:UILabel!
    @IBOutlet weak var lblSuccessRate:UILabel!
    @IBOutlet weak var createdBywhite:UILabel!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var reportTbl:UITableView!
    @IBOutlet weak var reportListView:UIView!
    @IBOutlet weak var listView:UIView!
    var clusterReportBtn : UIBarButtonItem!
    var teamReportBtn : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewTopConstrain.constant = 0
        self.reportListViewHeightConstrain.constant = 300
        
        DispatchQueue.main.async {
            showActivityIndicator(View: self.view, Constants.Loader.reportDetails)
        }
        
        scroller.contentSize.height = 1.0
        previewLoadURL = String("\(snt?.sntURL)?k=\(snt?.accessKey)")
        sntTitle = snt?.title
        sntDesc = snt?.desc
        reportSearchBar.delegate = self
        reportSearchBar.layer.borderWidth = 0.5
        
        
        self.infoBtn.isHidden = true
        self.searchBtn.isHidden = true
        
        
        self.clusterReportBtn = UIBarButtonItem(image: UIImage(named:"manager_icon"), style: .plain, target: self, action: #selector(clusterReportButtonTapped))
        self.clusterReportBtn.tintColor = .white
        self.teamReportBtn = UIBarButtonItem(image: UIImage(named:"team_icon"), style: .plain, target: self, action:#selector(teamReportButtonTapped))
        self.teamReportBtn.tintColor = .white
        // self.navigationItem.rightBarButtonItems = [teamReportBtn,clusterReportBtn]
        
        let searchTextField:UITextField = (reportSearchBar.value(forKey: "searchField") as? UITextField)!
        searchTextField.tintColor = UIColor.white
        
        searchTextField.backgroundColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        searchTextField.rightViewMode = UITextField.ViewMode.always
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.textColor = UIColor.white
        reportSearchBar.barTintColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        reportSearchBar.tintColor = UIColor.white
        let image = UIImage()
        reportSearchBar.layer.borderColor = UIColor.clear.cgColor
        reportSearchBar.layer.borderWidth = 1
        reportSearchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        
        reportTbl.isHidden = true
        reportTbl.backgroundColor = .clear
        noReplbl.isHidden = true
        
        reportTbl.isHidden = true
        refreshControl.tintColor = .white
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            scroller.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
            scroller.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
        }
        
        
        guard let snt = snt else {return}
        displaySntDataOnUI()
        sntUsedInt = snt.usedShareCount
        self.perform(#selector(callApiToFetchReportInfo), with: nil, afterDelay: 1.0)
        
        
    }
    //MARK: - Show snt details on UI
         func displaySntDataOnUI(){
             guard let snt = snt else {return}
          createdBylbl.text = "Created by:"
          createdBywhite.text = String(" \(snt.createdBy)")
      }
    func callPhoneBook(){
        let contactStore = CNContactStore()
        contactsAuthorization(for: contactStore) { (athorisedBool) in
            if(athorisedBool){
                self.fetchContactsFromPhoneBook()
                
            } else {
                
                hideActivityIndicator(View: self.view)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "REPORTS"
        
        self.navigationController?.navigationBar.topItem?.hidesBackButton = false
        
        if ( self.contactDict.count > 0) {
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                
                
            } }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "REPORTS"
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    func applyListViewHeightConstraint(sizeOfArray: Int, isSearch:Bool)  {
        DispatchQueue.main.async {
            if (self.searchBool == true) {
                
                if sizeOfArray == 0 {
                    self.reportListViewHeightConstrain.constant = 300
                    return
                }
                let rowsHeight = CGFloat(sizeOfArray * 35)
                let reportListViewHeight = rowsHeight + self.minimumTableViewHeight + ( self.searchBool ? self.searchViewHeight : CGFloat(0) )
                
                if reportListViewHeight >= ( self.view.frame.height - self.searchFixedHeight ) {
                    self.reportListViewHeightConstrain.constant = self.view.frame.height - (  self.searchFixedHeight )
                }else {
                    self.reportListViewHeightConstrain.constant = reportListViewHeight

                }
                
            } else {
                
                if sizeOfArray == 0 {
                    self.reportListViewHeightConstrain.constant = 300
                    return
                }
                let rowsHeight = CGFloat(sizeOfArray * 35)
                let reportListViewHeight = rowsHeight + self.minimumTableViewHeight
                if reportListViewHeight >= ( self.view.frame.height - self.fixedHeight ) {
                    self.reportListViewHeightConstrain.constant = self.view.frame.height - (  self.fixedHeight )
                }else {
                    self.reportListViewHeightConstrain.constant = reportListViewHeight
                }
            }
        }
    }
    
    var dashboardArray = [Report](){
        didSet{
            DispatchQueue.main.async {
                if (self.searchBool == true) {
                    
                    let rowsHeight = CGFloat(self.dashboardArray.count * 35)
                    let reportListViewHeight = rowsHeight + self.minimumTableViewHeight + ( self.searchBool ? self.searchViewHeight : CGFloat(0) )
                    
                    if reportListViewHeight >= ( self.view.frame.height - self.searchFixedHeight ) {
                        self.reportListViewHeightConstrain.constant = self.view.frame.height - (  self.searchFixedHeight )
                    }else {
                        self.reportListViewHeightConstrain.constant = reportListViewHeight

                    }
                    
                } else {
                    
                    let rowsHeight = CGFloat(self.dashboardArray.count * 35)
                    let reportListViewHeight = rowsHeight + self.minimumTableViewHeight
                
                    if reportListViewHeight >= ( self.view.frame.height - self.fixedHeight ) {
                        self.reportListViewHeightConstrain.constant = self.view.frame.height - (  self.fixedHeight )
                    }else {
                        self.reportListViewHeightConstrain.constant = reportListViewHeight
                    }
                }
            }
            
        }
    }
    
    @objc func clusterReportButtonTapped(){
        getTeamOrClusterReportDetails(isTeamReport: false)
    }
    @objc func teamReportButtonTapped(){
        getTeamOrClusterReportDetails(isTeamReport: true)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        hideBarBUttomItem()
        
        
        
        self.title = "REPORTS"
        self.navigationController?.navigationBar.isHidden = false
    }
        

    func addCustomerName() {
        
        guard let customerDict = USERDEFAULTS.value(forKey: "CONTACT_DICT")  else
        {return}
        
        self.contactDict = customerDict as! [String : String]
        
        
        if (self.contactDict.count > 0 && dashboardArray.count > 0) {
            
            for value in 0..<dashboardArray.count{
                let number = dashboardArray[value].DoctorMobNo!
                
                
                dashboardArray[value].CustomerName = self.contactDict[String(number)]
                
                dashboardArray[value].displayByNumber = true
                
            }
            listingData = dashboardArray
            
        }
        
    }
    
    
    
    @objc func fetchContactsFromPhoneBook() {
        
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        contactsAuthorization(for: contactStore) { (athorisedBool) in
            if(athorisedBool){
                
                
                let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                //  var contactDict = [String: String]()
                do {
                    try contactStore.enumerateContacts(with: request, usingBlock: {
                        (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        
                        for phoneNumber in contact.phoneNumbers {
                            var dictString: String!
                            let number = phoneNumber.value as! CNPhoneNumber
                            let phoneNumberStr:String = number.value(forKey: "digits") as! String
                            
                            let countrycode:String = (number.value(forKey:"countryCode") as? String)!
                            
                            
                            let phoneNumberKit = PhoneNumberKit()
                            do {
                                //let phoneNumber = try phoneNumberKit.parse(primaryPhoneNumberStr)
                                let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(phoneNumberStr, withRegion: countrycode.uppercased(), ignoreType: true)
                                
                                if(phoneNumberCustomDefaultRegion.numberString.contains("+")){
                                    //     print(phoneNumberCustomDefaultRegion.numberString)
                                    dictString = phoneNumberCustomDefaultRegion.numberString
                                    
                                }else{
                                    dictString = "+" + String(phoneNumberCustomDefaultRegion.countryCode) + phoneNumberCustomDefaultRegion.numberString
                                }
                                print("got the Contact ")
                            }   catch {
                                print("Generic parser error")
                            }
                            
                            //  self.contactDict.updateValue(contact.givenName,forKey:phoneNumberStr)
                            
                            if dictString != nil {
                                self.contactDict.updateValue(contact.givenName,forKey:dictString)
                            }
                        }
                        // for loop ends
                    })
                    
                } catch let err {
                    print("Fialed to enumerate contact:",err)
                }
                UserDefaults.standard.set(self.contactDict, forKey: "CONTACT_DICT")
                self.addCustomerName()
                
                if (self.fetchIndex == 1 ) {
                    self.perform(#selector(self.numberButtonTapped), with: nil, afterDelay: 1.0)
                } else if (self.fetchIndex == 2 ) {
                    self.perform(#selector(self.infoButtonTapped), with: nil, afterDelay: 1.0)
                }
                
                
                
            }else{
                
                Utility.showAlertWithHandler(message: Constants.Alert.openSettings, alertButtons: 1, buttonTitle: "Ok", inView: self) { (yesTapped) in
                    if(yesTapped){
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
        }
    }
    
    func fetchContactFromDict(contact:[CNContact] )
    {
        for value in contact {
            for phoneNumber in value.phoneNumbers {
                var dictString: String!
                let number = phoneNumber.value as! CNPhoneNumber
                let phoneNumberStr:String = number.value(forKey: "digits") as! String
                let countrycode:String = (number.value(forKey:"countryCode") as? String)!
                let phoneNumberKit = PhoneNumberKit()
                do {
                    //let phoneNumber = try phoneNumberKit.parse(primaryPhoneNumberStr)
                    let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(phoneNumberStr, withRegion: countrycode.uppercased(), ignoreType: true)
                    
                    if(phoneNumberCustomDefaultRegion.numberString.contains("+")){
                        //   print(phoneNumberCustomDefaultRegion.numberString)
                        
                    }else{
                        dictString = "+" + String(phoneNumberCustomDefaultRegion.countryCode) + phoneNumberCustomDefaultRegion.numberString
                    }
                }   catch {
                    print("Generic parser error")
                }
                
                
                if dictString != nil {
                    self.contactDict.updateValue(value.givenName,forKey:dictString)
                }
            }
        }
        print("dict count =====\(contactDict.count) ======")
        
    }
    
    //MARK: - Contacts import authorization
    func contactsAuthorization(for store: CNContactStore, completionHandler: @escaping ((_ isAuthorized: Bool) -> Void)) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (isAuthorized: Bool, error: Error?) in
                completionHandler(isAuthorized)
            })
        case .denied:
            completionHandler(false)
        case .restricted:
            completionHandler(false)
        default:
            completionHandler(false)
            
        }
    }
    
    @objc func callApiToFetchReportInfo() {
        //Api
        guard let snt = snt else {return}
        let api = Constants.Api.reportListUrl
        //Token as header
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        //Parameters
        //-----------
        
        let sntId = URL(string: snt.sntURL)!.lastPathComponent
        let userEmail = ("\(USERDEFAULTS.value(forKey: "USER_EMAIL")!)")
        
        let parameters:[String : String] =
            ["repEmail": userEmail,
             "sntId": sntId]
        //-----------
        //Network call
        _ = HTTPRequest.sharedInstance.request(url: api, method: "POST", params: parameters, header: header) { (response, error) in
            if error != nil
            {
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                    self.popupAlert(title: Constants.Alert.title, message: error?.description, actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }
            else{
                let jsonData = try! JSONSerialization.data(withJSONObject: response!, options: [])
                let responseData = try! JSONDecoder().decode(reportModel.self, from: jsonData)
                
                if(responseData.statusCode == "100"){
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        //DO SOMETHING WITH RESPONSE
                        
                        self.showSntData(responseData)
                        self.addCustomerName()
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        if(responseData.statusCode == "104"){
                            // self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                            self.lblTotalsub.text =  String(snt.usedShareCount)
                            
                            //   self.noreportlblConstrain.constant = self.reportListView.frame.size.height/2 //CGFloat(75)
                            self.noReplbl.isHidden = false
                            self.reportTbl.isHidden = true
                            
                            self.reportTbl.frame.origin.y = CGFloat(100)
                            //  self.reportListView.frame.size.height = CGFloat(150)
                            self.noReplbl.centerYAnchor.constraint(equalTo: self.reportListView.centerYAnchor).isActive = true
                        } else if(responseData.statusCode == "106"){
                            print(responseData.message)
                            self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                        }else if(responseData.statusCode == "404") {
                            DispatchQueue.main.async {
                                hideActivityIndicator(View: self.view)
                                Utility.showAlertWithHandler(message: Constants.Alert.poorinternent, alertButtons: 1, buttonTitle: "OK", inView: self) { (boolValur) in }
                            }
                        }else if(responseData.statusCode == "443") {
                            DispatchQueue.main.async {
                                hideActivityIndicator(View: self.view)
                                Utility.showAlertWithHandler(message: Constants.Alert.poorinternent, alertButtons: 1, buttonTitle: "OK", inView: self) { (boolValur) in }
                            }
                        }else {
                            
                        }
                    }
                }
            }
        }
    }
    
    func getTeamOrClusterReportDetails(isTeamReport: Bool)  {
        
        guard let snt = snt else {return}
        showActivityIndicator(View: self.view, Constants.Loader.reportDetails)
        let api = isTeamReport ? Constants.Api.teamReport : Constants.Api.clusterReport
        //Token as header
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        //Parameters
        //-----------
        
        let userEmail = ("\(USERDEFAULTS.value(forKey: "USER_EMAIL")!)")
        let sntId = URL(string: snt.sntURL)!.lastPathComponent
        
        let parameters:[String : String] =
            ["repEmailId": userEmail,
             "sntId": sntId]
        
        _ = HTTPRequest.sharedInstance.request(url: api, method: "POST", params: parameters, header: header, completion: { (response, error) in
            if error != nil
            {
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                    self.popupAlert(title: Constants.Alert.title, message: error?.description, actionTitles: ["Ok"], actions:[{action in},nil])
                }
            } else {
                
                let jsonData = try! JSONSerialization.data(withJSONObject: response!, options: [])
                
                if isTeamReport {
                    let responseData = try! JSONDecoder().decode(TeamReportModel.self, from: jsonData)
                    if responseData.statusCode == "100" {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            if let count = responseData.data?.count, count > 0 {
                                // navigate to next screen
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamreportvc) as! TeamReportViewController
                                vc.teamReports = responseData
                                vc.selectedSnt = snt
                                vc.isTeamReport = isTeamReport
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.noTeamReportsFound, actionTitles: ["Ok"], actions:[{action in},nil])
                            }
                        }
                    } else if(responseData.statusCode == "106") {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            print(responseData.message)
                            self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                        }
                    }else if(responseData.statusCode == "104") {
                        print(responseData.message)
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.noTeamReportsFound, actionTitles: ["Ok"], actions:[{action in},nil])
                        }
                    }else if(responseData.statusCode == "404") {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            Utility.showAlertWithHandler(message: Constants.Alert.poorinternent, alertButtons: 1, buttonTitle: "OK", inView: self) { (boolValur) in }
                        }
                    }else if(responseData.statusCode == "443") {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            Utility.showAlertWithHandler(message: Constants.Alert.poorinternent, alertButtons: 1, buttonTitle: "OK", inView: self) { (boolValur) in }
                        }
                    }
                    else {
                        print("other scenario")
                        // handle other scenarios
                    }
                } else { // cluster level
                    let responseData = try! JSONDecoder().decode(ClusterReportModel.self, from: jsonData)
                    if responseData.statusCode == "100" {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            if let count = responseData.data?.count, count > 0 {
                                // navigate to next screen
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamreportvc) as! TeamReportViewController
                                vc.isTeamReport = isTeamReport
                                vc.selectedSnt = snt
                                vc.clusterReports = responseData
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.noClusterReportsFound, actionTitles: ["Ok"], actions:[{action in},nil])
                            }
                        }
                    } else if(responseData.statusCode == "101") {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.noClusterReportsFound, actionTitles: ["Ok"], actions:[{action in},nil])
                        }
                    } else if(responseData.statusCode == "106") {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                        }
                    }else if(responseData.statusCode == "104") {
                        print(responseData.message)
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.noClusterReportsFound, actionTitles: ["Ok"], actions:[{action in},nil])
                        }
                        
                    }else if(responseData.statusCode == "404") {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            Utility.showAlertWithHandler(message: Constants.Alert.poorinternent, alertButtons: 1, buttonTitle: "OK", inView: self) { (boolValur) in }
                        }
                    }else if(responseData.statusCode == "443") {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            Utility.showAlertWithHandler(message: Constants.Alert.poorinternent, alertButtons: 1, buttonTitle: "OK", inView: self) { (boolValur) in }
                        }
                    }else {
                        // handle other scenarios
                    }
                }
            }
            
        })
        
    }
    
    func showSntData(_ response:reportModel ){
        
        if let data = response.data{
            
            let sortArray = data.sorted(by: { $0.CreatedDate!   > $1.CreatedDate! }  )
            for value in sortArray {
                //  guard let Cview = value.ContentViewed else { return}
                if( value.ContentViewed != nil){
                    self.viewedInt = self.viewedInt + 1
                }
            }
            if sortArray.count > 0 {
                self.lblTotalsub.text =  "\(sortArray.count)"
                self.lblsharedSub.text = String(self.viewedInt)
                self.lblAvailablesub.text = String(sortArray.count - self.viewedInt )
                
                let successrate = ( Double(self.viewedInt)/Double(sortArray.count) ) * 100
                self.lblSuccessRate.text = String(Int(successrate)) + "%"

                self.dashboardArray = sortArray
                
                self.tablevHeightConst = CGFloat(self.dashboardArray.count*35)
                self.reportTbl.reloadData()
                self.reportTbl.isHidden = false
                self.noReplbl.isHidden = true
                self.infoBtn.isHidden = false
                self.searchBtn.isHidden = false
            }
            
        }
        self.reportTbl.isHidden = false
        
        //  print("===========================*********************ShowSntData Finished*************************=======================================")
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton){
        
        
        if (searchBool == false) {
            listingData = dashboardArray
            reportSearchBar.returnKeyType = .default
            self.tableViewTopConstrain.constant = 45
            self.searchView.isHidden = false
            //    self.searchButton.isHidden = true
            showBarButtonItem()
            reportSearchBar.becomeFirstResponder()
            searchBool = true
            self.applyListViewHeightConstraint(sizeOfArray:listingData.count, isSearch: searchBool)
        }
        else {
            dashboardArray = listingData
            
            self.tableViewTopConstrain.constant = 0
            
            reportSearchBar.text! = ""
            //    self.reportListViewConstrain.constant = constraintSize
            reportTbl.reloadData()
            self.reportTbl.isHidden = false
            self.noReplbl.isHidden = true
            
            self.searchView.isHidden = true
            
            searchBool = false
            self.applyListViewHeightConstraint(sizeOfArray: dashboardArray.count, isSearch: searchBool)
            view.endEditing(true)

        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tableViewTopConstrain.constant = 0
        
        self.reportTbl.reloadData()
        self.searchView.isHidden = true
        
        view.endEditing(true)
    }
    
    @IBAction func numberButtonTapped(_ sender: UIButton)
    {
        //real one
        // var indexPath: IndexPath!
        isToggleClicked = true
        if (self.contactDict.count > 0) {
            let cell = sender.superview?.superview?.superview as? ReportTableCell
            let mindexPath = self.reportTbl.indexPath(for: cell!)! as IndexPath?
            let rindexPath = self.reportTbl.indexPath(for: cell!)
            
            
            let number = sender.titleLabel?.text
            print(number)
            print(self.contactDict)
            
            let keyarray = self.contactDict.values
            if (keyarray.contains(number ?? "")) {
                
                self.dashboardArray[mindexPath!.row].displayByNumber = true
                self.reportTbl.reloadRows(at: [rindexPath!], with: .none)
                //    let doctorNumber = self.dashboardArray[mindexPath!.row].DoctorMobNo
                
            } else {
                
                self.dashboardArray[mindexPath!.row].displayByNumber = false
                self.reportTbl.reloadRows(at: [mindexPath!], with: .none)
                
            }
        } else {
            self.fetchIndex = 1
            let contactStore = CNContactStore()
            contactsAuthorization(for: contactStore) { (athorisedBool) in
                if(athorisedBool){
                    self.addCustomerName()
                } else {
                    self.fetchContactsFromPhoneBook()
                    
                }
            }
            
        }
    }
    
}

//MARK: - Tableview Methods
extension ReportViewController:UITableViewDelegate, UITableViewDataSource, ReportCellDelegate{
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableCell", for: indexPath) as! ReportTableCell
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        
        let snt = dashboardArray[indexPath.row]
        mobileNumberArray.append(snt.DoctorMobNo!)
        let backgroundView = UIView()
        cell.selectedBackgroundView = backgroundView
        
        let templateImage = cell.statusView.image?.withRenderingMode(.alwaysTemplate)
        cell.statusView.image = templateImage
        cell.customerNumberBtn.addTarget(self, action: #selector(numberButtonTapped), for: .touchUpInside)
        cell.reportcellDelegate = self
        let countInt = dashboardArray.count - 1
        var cellIndex: Int = 0
        if(indexPath.row == countInt)
        {
            cellIndex = 1
        } else {
            cellIndex = 0
        }
        
        if #available(iOS 13.0, *) {
            //   cell.setreportDetailsToCell(snt, lastIndex: cellIndex)
            cell.setreportDetailsToCell(snt, lastIndex: cellIndex, byNumber: tablebyNumber, toggleClicked: isToggleClicked)
            isToggleClicked = false
        } else {
            cell.setDetailsToCell(snt, lastIndex: cellIndex, byNumber: tablebyNumber, toggleClicked: isToggleClicked)
            isToggleClicked = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        numberIndex = indexPath.row
        let snt = dashboardArray[indexPath.row]
        tapperowindex = indexPath.row
        tappedrowSection = indexPath.section
        
        
    }
    
    
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        
        self.tableViewTopConstrain.constant = 0
        isToggleClicked = false
        if (listingData.count > 0) {
            dashboardArray = listingData }
        reportSearchBar.text! = ""
        if (contactDict.count > 0) {
            
            let message = "Select the display type"
            
            let alert = UIAlertController(title: Constants.Alert.title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction (title: "By Contact names", style: UIAlertAction.Style.default, handler:{ (action) in
                
                self.tablebyNumber = false
                
                for value in 0..<self.dashboardArray.count {
                    // value.displayByNumber = false
                    self.dashboardArray[value].displayByNumber = false
                }
                
                self.view.endEditing(true)
                self.reportTbl.reloadData()
                self.reportTbl.isHidden = false
                self.noReplbl.isHidden = true
                
            }))
            alert.addAction(UIAlertAction (title: "By Contact numbers", style: UIAlertAction.Style.default, handler: { (action) in
                for value in 0..<self.dashboardArray.count {
                    
                    self.dashboardArray[value].displayByNumber = true
                }
                self.tablebyNumber = true
                self.reportTbl.isHidden = false
                self.noReplbl.isHidden = true
                self.view.endEditing(true)
                self.reportTbl.reloadData()
                
            }))
            alert.addAction(UIAlertAction (title: "Cancel", style: UIAlertAction.Style.default, handler:{ (action) in
                self.view.endEditing(true)
            }))
            
            self.present(alert, animated: true, completion: nil)
            alert.view.tintColor = .rxGreen
            
            self.searchView.isHidden = true
            searchBool = false
            
            self.view.endEditing(true)
        }
        else {
            fetchIndex = 2
            // fetchContactsFromPhoneBook()
            let contactStore = CNContactStore()
            contactsAuthorization(for: contactStore) { (athorisedBool) in
                //       showToast(message: " no Data available Yet. Dict count is: \(self.contactDict) ", view: self.view)
                if(athorisedBool){
                    self.addCustomerName()
                } else {
                    self.fetchContactsFromPhoneBook()
                }
            }
            
        }
    }
    
    @objc func didTapNumber(number: String) {
        
        print(number)
        print(self.contactDict)
        
        DispatchQueue.main.async {
            //  guard let phonenumber = number else {return}
            showToast(message: "There is no contact available for this Number '\(number)' ", view: self.view)
        }
        isToggleClicked = false
        
        
        
    }
    
    func didTapInfo(reportsnt: Report) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.reportdetailvc) as! ReportDetailViewController
        
        showActivityIndicator(View: self.view, Constants.Loader.reportDetails)
        callApiToFetchDetailReportInfo(token: reportsnt.DoctorToken!)
    }
    
    @objc func callApiToFetchDetailReportInfo(token: String)   {
        
        let api = Constants.Api.sntReportDetailUrl
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        //    let dctrToken = token
        let parameters:[String : String] =  ["token": token]
        //           let parameters:[String : String] =
        //           [:]
        _ = HTTPRequest.sharedInstance.request(url: api, method: "POST", params: parameters, header: header) { (response, error) in
            if error != nil
            {
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                    self.popupAlert(title: Constants.Alert.title, message: error?.description, actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }
            else{
                let jsonData = try! JSONSerialization.data(withJSONObject: response!, options: [])
                let responseData = try! JSONDecoder().decode(reportDetailModel.self, from: jsonData)
                
                if(responseData.statusCode == "100"){
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        //DO SOMETHING WITH RESPONSE
                        print("JSON DATA -> \(responseData)")
                        // self.report = responseData.data
                        if let data = responseData.data{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.reportdetailvc) as! ReportDetailViewController
                            
                            
                            vc.loadUrld = self.previewLoadURL
                            
                            //  vc.doctorToken = reportsnt.DoctorToken
                            vc.sntTitle = self.sntTitle
                            vc.reportDetail = responseData.data
                            if (self.contactDict.count > 0){
                                vc.detailContactDict = self.contactDict }
                            vc.sntDesc = self.sntDesc
                            vc.snt = self.snt
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        if(responseData.statusCode == "106"){
                            
                            self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                        }
                        else if(responseData.statusCode == "404") {
                            DispatchQueue.main.async {
                                hideActivityIndicator(View: self.view)
                                Utility.showAlertWithHandler(message: Constants.Alert.poorinternent, alertButtons: 1, buttonTitle: "OK", inView: self) { (boolValur) in }
                            }
                        }else if(responseData.statusCode == "443") {
                            DispatchQueue.main.async {
                                hideActivityIndicator(View: self.view)
                                Utility.showAlertWithHandler(message: Constants.Alert.poorinternent, alertButtons: 1, buttonTitle: "OK", inView: self) { (boolValur) in }
                            }
                        }else {
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        
        callApiToFetchReportInfo()
        
    }
    
}

extension ReportViewController{
    
    //MARK: - Token Expired Logout
    private func tokenExpiredLogout(){
        
        print(UserDefaults.standard.bool(forKey: "ISLOGIN"))
        
        UserDefaults.standard.set(false, forKey: "ISLOGIN")
        
        print(UserDefaults.standard.bool(forKey: "ISLOGIN"))
        
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK: - Token expired login
    @objc func tokenExpiredLogin(){
        
        Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired, alertButtons: 1, buttonTitle:"Ok", inView: self) { (tapVal) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
    }
    
    @objc private func logout(notification: NSNotification){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            //Call logout Api
            showActivityIndicator(View: self.view, Constants.Loader.loggingOut)
            
            self.perform(#selector(self.callLogOutApi), with: nil, afterDelay: 2.0)
        }
        
    }
    
    @objc func callLogOutApi(){
        
        DispatchQueue.main.async {
            hideActivityIndicator(View: self.view)
            
        }
        
        self.tokenExpiredLogout()
        
        
    }
}


extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    } }

extension Dictionary where Value: Equatable {
    func someValue(forKey val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

extension ReportViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if reportSearchBar.text! == "" {
            if (listingData.count > 0) {
                dashboardArray = listingData }
            reportTbl.reloadData()
            self.reportTbl.isHidden = false
            self.noReplbl.isHidden = true
            self.applyListViewHeightConstraint(sizeOfArray:dashboardArray.count, isSearch: searchBool)
            
        } else {
            FilteredData = listingData
            FilteredData.removeAll()
            // searchData = dashboardArray
            let decimalCharacters = CharacterSet.decimalDigits
            
            let decimalRange = reportSearchBar.text!.rangeOfCharacter(from: decimalCharacters)
            var  FilteredDataA = [Report]()
            var FilteredDataB = [Report]()
            if decimalRange != nil {
                FilteredDataA = listingData.filter {
                    $0.DoctorMobNo!.lowercased().contains(reportSearchBar.text!.lowercased())
                    
                }
            } else {
                var nameArray = listingData.filter{
                    $0.CustomerName != nil
                }
                
                FilteredDataB = nameArray.filter {
                    //  guard let data = $0.CustomerName! else {return}
                    $0.CustomerName!.lowercased().contains(reportSearchBar.text!.lowercased())
                    
                }}
            
            FilteredData = FilteredDataA + FilteredDataB
            
            if (FilteredData.count > 0) {
                //    listingData = dashboardArray
                dashboardArray  =  FilteredData
                reportTbl.reloadData();
                self.reportTbl.isHidden = false
                self.noReplbl.isHidden = true
                //  dashboardArray = listingData                
            } else {
                //  self.FilteredData = self.dashboardArray
                self.reportTbl.isHidden = true
                self.noReplbl.isHidden = false
                if (noReportBool == false) {
                    self.noReplbl.centerYAnchor.constraint(equalTo: self.reportListView.centerYAnchor).isActive = true
                }
                noReportBool = true
            }
            self.applyListViewHeightConstraint(sizeOfArray:FilteredData.count, isSearch: searchBool)
            
            
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reportSearchBar.resignFirstResponder()
    }
    
}


