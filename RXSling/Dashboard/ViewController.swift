//
//  ViewController.swift
//  RXSling
//
//  Created by Divakara Y N. on 23/03/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import ESPullToRefresh
import Contacts
import ContactsUI
import PhoneNumberKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dashboardTbl:UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var customerDict = [String: String]()
    
    var versionManager = VersionMannager.sharedInstance
    
    var dashboardArray = [SNTData](){
        
        didSet{
            dashboardTbl.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout(notification:)),
                                               name: NSNotification.Name(rawValue: "logout_Tapped"),
                                               object: nil)
        
        // Version Checking
        versionManager.checkForVersionUpdate()
        
        setupNavigationBar()
        dashboardTbl.estimatedRowHeight = 310
        dashboardTbl.isHidden = true
        dashboardTbl.backgroundColor = .clear
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            dashboardTbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
            dashboardTbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        dashboardTbl.addSubview(refreshControl)
        
        self.callPhoneBook()
    }
    
    func getUserInfo(){
        
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        if (!networkConnection!)
        {
            DispatchQueue.main.async {
                hideActivityIndicator(View: self.view)
            }
            
        }else{
            
            _=HTTPRequest.sharedInstance.request(url: Constants.Api.profileUrl, method: "POST", params: [:], header: "\(USERDEFAULTS.value(forKey:"TOKEN")!)", completion: { (response, error) in
                guard let resultData = response else{ return }
                print("UserInfo -> \(resultData.description)")
                let jsonData = try! JSONSerialization.data(withJSONObject: resultData, options: [])
                let responseData = try! JSONDecoder().decode(ProfileDataModel.self, from: jsonData)
                
                USERDEFAULTS.set(Date(), forKey: "RefreshTime")
                if error != nil
                {
                    
                    self.loadSntApiCall()
                }
                else{
                    if(responseData.statusCode == "100")
                    {
                        
                        
                        let loginInfo = responseData.data
                        
                        USERDEFAULTS.set(jsonData, forKey: "LOGIN_DATA")
                        UserDefaults.standard.set(true, forKey: "ISLOGIN")
                        USERDEFAULTS.set((loginInfo?.token), forKey: "TOKEN")
                        USERDEFAULTS.set((loginInfo?.userInfo.emailID), forKey: "USER_EMAIL")
                        USERDEFAULTS.set((loginInfo?.userInfo.mobileNo), forKey: "USER_MOBILE")
                        USERDEFAULTS.set((loginInfo?.userInfo.profilePicURL), forKey: "USER_PROFILE_PIC")
                        USERDEFAULTS.set((loginInfo?.displayIbutton), forKey: "USER_DISPLAY_IB_BUTTON")
                        USERDEFAULTS.set((loginInfo?.userInfo.selfReport), forKey: "USER_SELFREPORT")
                        
                        self.loadSntApiCall()
                        
                        
                    } else if (responseData.statusCode == "106") {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                        }
                        DispatchQueue.main.async {
                            Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired, alertButtons: 1, buttonTitle:"Ok", inView: self) { (tapVal) in
                                
                                self.tokenExpiredLogout()
                            }
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
                    } else {
                        self.loadSntApiCall()
                    }
                }
            })
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        SideMenuManager.default.leftMenuNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.menuDismissOnPush = true
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        hideBarBUttomItem()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  self.perform(#selector(loadSntApiCall), with: nil, afterDelay: 1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let storedDate = USERDEFAULTS.value(forKey: "RefreshTime") as? Date {
            let minutes = getMinutes(from: storedDate)
            print(minutes)
            if minutes >= 5 {
                DispatchQueue.main.async {
                    showActivityIndicator(View: self.view, Constants.Loader.loadingShowNtell)
                    self.getUserInfo()
                }
            } else {
                DispatchQueue.main.async {
                    showActivityIndicator(View: self.view, Constants.Loader.loadingShowNtell)
                    self.loadSntApiCall()
                }
            }
        } else {
            DispatchQueue.main.async {
                showActivityIndicator(View: self.view, Constants.Loader.loadingShowNtell)
                self.loadSntApiCall()
            }
        }
        
    }
    func getMinutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: Date()).minute ?? 0
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
                        //   print(contact.givenName)
                        //  print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        //   contacts.append(contact)
                        // new function
                        
                        for phoneNumber in contact.phoneNumbers {
                            var dictString: String!
                            let number = phoneNumber.value as! CNPhoneNumber
                            let phoneNumberStr:String = number.value(forKey: "digits") as! String
                            
                            let countrycode:String = (number.value(forKey:"countryCode") as? String ?? "")
                            
                            
                            
                            if(phoneNumberStr.contains("+")){
                                dictString =  phoneNumberStr
                            }else{
                                let ccode:String     =    self.getCountryPhonceCode(countrycode.uppercased())
                                dictString = "+" + ccode + phoneNumberStr
                            }
                            
                            
                            if dictString != nil {
                                self.customerDict.updateValue(contact.givenName,forKey:dictString)
                            }
                        }
                        // for loop ends
                    })
                    
                } catch let err {
                    print("Fialed to enumerate contact:",err)
                }
                UserDefaults.standard.set(self.customerDict, forKey: "CONTACT_DICT")
                //   self.addCustomerName()
                print("===========================*********************got the dictionary  *************************=======================================")
                
            }else{
                
                Utility.showAlertWithHandler(message: Constants.Alert.openSettings, alertButtons: 1, buttonTitle: "Ok", inView: self) { (yesTapped) in
                    if(yesTapped){
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
        }
    }
    
    
    func getCountryPhonceCode (_ country : String) -> String
    {
        var countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
                                  "AI":"1",
                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
                                  "DM":"1",
                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
                                  "GD":"1",
                                  "GP":"590",
                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
                                  "KN":"1",
                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340"]
        if let countryCode = countryDictionary[country] {
            return countryCode
        }
        return ""
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
    
    
    //MARK: - Setup Navigation Bar
    func setupNavigationBar(){
        
        self.title = "HOME"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(menuPressed), image: #imageLiteral(resourceName: "Menu"))
        
        var image = UIImage(named: "settings_icon")
        
        image = image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(settingsPressed), image: image!)
        
    }
    
    //MARK: - NavBar button Actions
    @objc func menuPressed(_ sender: UIBarButtonItem){
        self.navigationController?.show(SideMenuManager.default.leftMenuNavigationController!, sender: nil)
        
    }
    
    @objc func settingsPressed(_ sender: UIBarButtonItem){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.profilevc) as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


//MARK: - Tableview Methods
extension ViewController:UITableViewDelegate, UITableViewDataSource, DashboardCellDelegate{
    func didTapReportDetail(snt: SNTData) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.reportdetailvc) as! ReportDetailViewController
        //  vc.snt = snt
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCell.dashboard, for: indexPath) as! DashboardTableCell
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        
        let snt = dashboardArray[indexPath.row]
        cell.cellDelegate = self
        cell.setSntDetailsToCell(snt)
        return cell
    }
    
    func didTapReport(snt: SNTData) {
        
        let x = 2
        if (x == 2) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.reportvc) as! ReportViewController
            vc.snt = snt
            // showActivityIndicator(View: self.view, Constants.Loader.reportDetails)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func didTapPlay(snt: SNTData) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.playsntvc) as! PlaySntViewController
        vc.loadUrl = String("\(snt.sntURL)?k=\(snt.accessKey)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapShare(snt: SNTData) {
        
        if snt.instructionMsg != nil && snt.instructionMsg != ""{
            self.popupAlert(title: "Instruction", message: snt.instructionMsg, actionTitles: ["Cancel","Proceed"], actions: [{action1 in},{action2 in
                self.openSharePage(snt: snt)
                }])
        }else{
            openSharePage(snt: snt)
        }
    }
    
    func openSharePage(snt:SNTData){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.sharesntvc) as! ShareSntViewController
        vc.snt = snt
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        loadSntApiCall()
    }
}

//MARK:- Api Call
extension ViewController{
    
    @objc func loadSntApiCall(){
        
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        if (!networkConnection!)
        {
            hideActivityIndicator(View: self.view)
            self.popupAlert(title: "RXSling", message: "Please check your internet connection", actionTitles: ["Ok"], actions:[{action1 in
                }, nil])
        }else{
            //Api
            let api = Constants.Api.dashboard
            //Token as header
            let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
            //Network call
            NetworkManager.shared.callApiWithAlamofire(api, params: [:], header: header, modelType:SNTModel.self) {[weak self] (data, err)  in
                
                if let err = err {
                    print("Failed to fetch data:", err)
                    return
                }
                if(data.statusCode == "106"){
                    Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired, alertButtons: 1, buttonTitle:"Ok", inView: self!) { (tapVal) in
                        self!.tokenExpiredLogout()
                    }
                }else{
                    if let data = data.data{
                        self?.dashboardArray = data
                        self?.dashboardTbl.isHidden = false
                    }
                    
                }
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self!.view)
                }
            }
        }
    }
}


extension ViewController{
    
    
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




extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
