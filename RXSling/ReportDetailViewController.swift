//
//  ReportDetailViewController.swift
//  RXSling Stage
//
//  Created by Vivek on 6/5/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import PhoneNumberKit

class ReportDetailViewController: UIViewController {

    var doctorToken: String!
    var detailContactDict = [String: String]()
    var sntTitle: String!
    var sntDesc: String!
    var snt: SNTData?
    var loadUrld:String!
    var shortUrld:String!
    var doctorMobileNo: String!
    var welcomeMessage: String!
    var shortenUrlDatad: ShortenData?
    var reportDetail: ReportDetail?
    var expiredBool: Bool = false
    @IBOutlet weak var cNamelbl:UILabel!
    @IBOutlet weak var cNumberlbl:UILabel!
    @IBOutlet weak var sentTimelbl:UILabel!
    @IBOutlet weak var viewedTimelbl:UILabel!
    @IBOutlet weak var viewedStatuslbl:UILabel!
    @IBOutlet weak var contentStatuslbl:UILabel!
    @IBOutlet weak var expDatelbl:UILabel!
    @IBOutlet weak var contentTitlelbl:UILabel!
    @IBOutlet weak var contentDesclbl:UILabel!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var iButton: UIButton!
     var backButton : UIBarButtonItem!
    var clusterReportBtn : UIBarButtonItem!
    var teamReportBtn : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    scroller.contentSize.height = 700
        scroller.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 60)
        scroller.contentSize.height = self.view.frame.size.height + 60
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        //  scroller.contentSize.height = 1.0
        contentTitlelbl.text = sntTitle
        contentDesclbl.text = sntDesc
        self.title = "REPORT DETAILS"
                    self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.setHidesBackButton(true, animated: false)
               self.navigationController?.navigationBar.topItem?.hidesBackButton = true
               self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
               self.navigationItem.leftBarButtonItem = backButton
               self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
               self.navigationController?.navigationBar.isExclusiveTouch = true
               self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        self.clusterReportBtn = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(clusterReportButtonTapped))
        self.teamReportBtn = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(teamReportButtonTapped))
        self.navigationItem.rightBarButtonItems = [clusterReportBtn, teamReportBtn]

        
        // Do any additional setup after loading the view.
        if reportDetail != nil {
        changeDetailUI(reportDetail: reportDetail!)
        }
        
        self.loadUrld = reportDetail?.longUrl
                                 self.shortUrld = reportDetail?.shortUrl
                                self.shortenUrlDatad = ShortenData(shortenURL: (reportDetail?.shortUrl)!, longURL: (reportDetail?.longUrl)!)
                          
                                 self.welcomeMessage = reportDetail?.welcomeMessage
    }
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clusterReportButtonTapped(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.clusterreportvc) as! ClusterReportViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func teamReportButtonTapped(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamreportvc) as! TeamReportViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
             super.viewDidAppear(animated)
             
//             DispatchQueue.main.async {
//                 showActivityIndicator(View: self.view, Constants.Loader.reportDetails)
//              }
          //   self.perform(#selector(callApiToFetchReportInfo), with: nil, afterDelay: 1.0)
         }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          deleteButton.isEnabled = false
          deleteButton.isUserInteractionEnabled = false
        deleteButton.alpha = 0.5
      }
    
    @objc func callApiToFetchReportInfo(){
             //Api
         //   guard let snt = snt else {return}
            let api = Constants.Api.sntReportDetailUrl
            //Token as header
            let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
             //Parameters
            //-----------
        //    guard let snt = snt else {return}
            let token = doctorToken
         //   let userEmail = ("\(USERDEFAULTS.value(forKey: "USER_EMAIL")!)")
    //        let parameters:[String : String] =
    //            ["doctorMobNo": doctorMobileLabel.text!,
    //             "repEmail": userEmail,
    //             "sntId": sntId]
        //    let sntId = "XcUbVN5v59QP"    //"Z87B6tQnW8"
         //   let userEmail = "sunilkumar.gc@rxprism.com"  //"epatient3400@gmail.com"
            let parameters:[String : String] =
                [:]
            //-----------
             //Network call
        _ = HTTPRequest.sharedInstance.request(url: api, method: "POST", params: parameters, header: doctorToken) { (response, error) in
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
                                                   
                                                 //  self.dashboardArray = data
                                                 //  self.reportTbl.isHidden = false
                                
                                               }
                            //  self.validateAndShowCard4(responseData)
                           self.changeUI(responseData)
                            self.loadUrld = responseData.data?.longUrl
                            self.shortUrld = responseData.data?.shortUrl
                           self.shortenUrlDatad = ShortenData(shortenURL: (responseData.data?.shortUrl)!, longURL: (responseData.data?.longUrl)!)
                     
                            self.welcomeMessage = responseData.data?.welcomeMessage
                        }
                    }else{
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            if(responseData.statusCode == "106"){
                                
                               // self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                            }
                        }
                    }
                }
            }
        }
    
    @IBAction func shareButtonPressed(_ sender: UIButton){
            print("Share tapped")
        if(expiredBool == true) {
             self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.contentResent, actionTitles: ["Ok"], actions:[{action1 in
              }, nil])
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.sharevc) as! ShareViewController
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overFullScreen
            vc.snt = snt
            vc.userPhoneNumber = doctorMobileNo
            vc.shortenUrlData =  self.shortenUrlDatad
            vc.welcomeMessage = self.welcomeMessage
            self.present(vc, animated: false, completion: nil)
        }
    }
      @IBAction func previewButtonPressed(_ sender: UIButton){
        
        if(expiredBool == true) {
             self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.contentExpired, actionTitles: ["Ok"], actions:[{action1 in
              }, nil])
        } else {
        
          let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.playsntvc) as! PlaySntViewController
        if let accesskey = snt?.accessKey {
            guard let  string1 = self.loadUrld else { return  }
            let string2 = "999&k="
            let string3 = accesskey
            let finalkey = string1 + string2 + string3
       // vc.loadUrl = String("\(self.loadUrld)999&k=\(accesskey)")
            vc.loadUrl = finalkey
        } else {
            vc.loadUrl = ""
        }
                  //  self.loadUrld
                self.navigationController?.pushViewController(vc, animated: true)
      }
    }
      
      @IBAction func callButtonPressed(_ sender: UIButton){
       
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StackViewController") as! StackViewController
//
//                  self.navigationController?.pushViewController(vc, animated: true)
    
        guard let phonestring = doctorMobileNo else { return}
            if let phoneCallURL = URL(string: "telprompt://\(phonestring)") {

                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                         application.openURL(phoneCallURL as URL)

                    }
                }
            }
    }

    
    @IBAction func expireNowButtonPressed(_ sender: UIButton){
        DispatchQueue.main.async {
            showToast(message: "Coming Soon", view: self.view)
        }
    }
       
    func changeUI(_ response:reportDetailModel )
    {
 
         let contactDict = "\(USERDEFAULTS.value(forKey: "CONTACT_DICT")!)"
        for contact in contactDict.reversed() {
         //   print("\(contact.value) is from \(contact.key)")
        }
        
        //1
        cNamelbl.text = "NA"
        //2
        doctorMobileNo = response.data?.mobileNumber
         cNumberlbl.text = response.data?.mobileNumber
        //3 sent time
       
        
        if let senttime = response.data?.sentTimeStamp {
          let date = Date(timeIntervalSince1970: (Double( senttime ?? 5) / 1000.0))
//            let dateFormatterGet = DateFormatter()
//                       dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                     //   let dateAsString = "6:35 PM"
                       let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                dateFormatterPrint.timeZone = TimeZone(abbreviation: "GMT")
                       dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm a"
                       
               //        print(dateFormatterPrint.string(from: lastSent))
                       let lastSentStr = dateFormatterPrint.string(from: date)
            
            
            
            self.sentTimelbl.text = String("\(lastSentStr)") }
        else {
            self.sentTimelbl.text = "NA"
        }
            //4 viewed status
            if (response.data?.viewStatus == true){
                       viewedTimelbl.text = "Viewed"}
                   else {
                       viewedTimelbl.text = "Not Viewed"
                   }
        
            //5 - Viewed Time
        let date = Date(timeIntervalSince1970: (Double( response.data?.viewTimeStamp ?? 5) / 1000.0))
        print("date - \(date)")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm a"
       viewedStatuslbl.text = formatter.string(from: date)
       
        //6 - content Status (expiry)
              if (response.data?.expiryStatus == true){
                expiredBool = true
                contentStatuslbl.text = "EXPIRED"
                contentStatuslbl.textColor = UIColor.red
              } else {
                expiredBool = false
                    contentStatuslbl.text = "ACTIVE"
                contentStatuslbl.textColor = UIColor.white
            }
        
        //7 - expiry Date
        if (response.data?.expiryDate) != 0 {
        
            let dateexp = Date(timeIntervalSince1970: (Double( response.data?.expiryDate ?? 5) / 1000.0))
            let string1 = formatter.string(from: dateexp)
        
        var string2 = ""
             print("date - \(date)")
        if #available(iOS 13.0, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.localizedString(from: DateComponents(day: -1)) // "1 day ago"
            formatter.localizedString(from: DateComponents(hour: 2)) // "in 2 hours"
            formatter.localizedString(from: DateComponents(minute: 45)) // "in 45 minutes"
            formatter.dateTimeStyle = .named
            formatter.localizedString(from: DateComponents(day: -1))
            
            string2 = formatter.string(for: dateexp)!
            
        } else {
            let calendar = Calendar.current
             let date = Date(timeIntervalSince1970: (Double( response.data?.expiryDate ?? 5) / 1000.0))
             print("date - \(date)")
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if abs(day) < 2 {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                formatter.doesRelativeDateFormatting = true
               string2 = formatter.string(from: date)
            } else if day > 1 {
                string2 = "In \(day) days"
            } else {
               string2 = "\(-day) days ago"
            }
        }
            expDatelbl.text = string1 + " (" + string2 + ")"
        }
        else {
               expDatelbl.text = "NA"
        }
    }
    func fetchContactsFromPhoneBook() {
    
               let contactStore = CNContactStore()
               contactsAuthorization(for: contactStore) { (athorisedBool) in
                   if(athorisedBool){
                       
                       DispatchQueue.main.async {
                         //  showActivityIndicator(View: self.navigationController!.view, Constants.Loader.loadingContacts)
                           
                           // you can do things here for sure...
                           let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]
                                  let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                                 //  var contactDict = [String: String]()
                                  do {
                                      try contactStore.enumerateContacts(with: request, usingBlock: {
                                       (contact, stopPointerIfYouWantToStopEnumerating) in
                                       print(contact.givenName)
                                       print(contact.phoneNumbers.first?.value.stringValue ?? "")
                                      
                                       self.detailContactDict.updateValue(contact.phoneNumbers.first?.value.stringValue ?? "", forKey: contact.givenName)
                                          print("=================")
                                       print(self.detailContactDict)
                                          print("=================")
                                       UserDefaults.standard.set(self.detailContactDict, forKey: "CONTACT_DICT")
                                       
                                      })
                                   
                                    self.perform(#selector(self.iButtonPressed), with: nil, afterDelay: 1.0)

                                  } catch let err {
                                   print("Fialed to enumerate contact:",err)
                                  
                           }
                           
                     //      self.perform(#selector(self.getContactsFromPhoneBook), with: nil, afterDelay: 1.0)
                   //        self.perform(#selector(self.getAllContactsFromPhoneBook), with: nil, afterDelay: 1.0)
                       }
                       
                   }else{
                       //Show alert to enable
                       //contact import in app settings
                       print("NOT Athorised")
                       Utility.showAlertWithHandler(message: Constants.Alert.openSettings, alertButtons: 1, buttonTitle: "Ok", inView: self) { (yesTapped) in
                           if(yesTapped){
                               UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                           }
                       }
                   }
               }
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
    
    @IBAction func iButtonPressed(_ sender: UIButton){
    
    if (detailContactDict.count > 0)
               { // search reportDetail.mobileNumber in dict
                let number = doctorMobileNo
                          //  let index = number?.index(number!.endIndex, offsetBy:-10)
                         //   let transformedNumber = String((number?[index!...])!)
              //  let customerNumber = number!.suffix(10)
                if (detailContactDict.keys.contains(number!))
                {
                    if (self.detailContactDict[number!] == "") {
                           cNamelbl.text = "NA"
                    } else {
                     cNamelbl.text = self.detailContactDict[number!]
                    iButton.isHidden = true
                    }
                    print("Avaialbel")
                } else {
                    DispatchQueue.main.async {
                        guard let toastString = self.doctorMobileNo else {return}
                                                showToast(message: "There is no contact available for this Number '\(toastString)' ", view: self.view)
                                            }
                }
               } else {
                   cNamelbl.text = "NA"
                    fetchContactsFromPhoneBook()
        
               }
    
    }
    
    func changeDetailUI( reportDetail:ReportDetail)
        {
//            if (detailContactDict.count > 0)
//            { // search reportDetail.mobileNumber in dict
//
                
                  let number = reportDetail.mobileNumber
              //  let index = number?.index(number!.endIndex, offsetBy:-10)
               // let transformedNumber = String((number?[index!...])!)
            // let customerNumber = number!.suffix(10)
                if (detailContactDict.keys.contains(number!))
                {
                    if (self.detailContactDict[number!] == "") {
                           cNamelbl.text = "NA"
                    } else {
                     cNamelbl.text = self.detailContactDict[number!]
                    iButton.isHidden = true
                    }
                    print("Avaialbel")
                } else {
              
              /*
                for value in self.detailContactDict.keys {
                               
                      let dicnumber = value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    if (dicnumber.contains(transformedNumber)) {
                                 cNamelbl.text = self.detailContactDict[value]
                                //   if let key = detailContactDict.someKey(forValue: value) {
                                 print("------\(self.detailContactDict[value])------")
                        if (self.detailContactDict[value] == "")
                        {
                             cNamelbl.text = "NA"
                        }
                                    iButton.isHidden = true
                                }
                                   } */
          
                cNamelbl.text = "NA"
                iButton.isHidden = false
            }
             doctorMobileNo = reportDetail.mobileNumber
             cNumberlbl.text = reportDetail.mobileNumber
    
             //3 sent time
                 if let senttime = reportDetail.sentTimeStamp {
                      let date = Date(timeIntervalSince1970: (Double( senttime ?? 5) / 1000.0))
            //            let dateFormatterGet = DateFormatter()
            //                       dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                 //   let dateAsString = "6:35 PM"
                                   let dateFormatterPrint = DateFormatter()
                            dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                            dateFormatterPrint.timeZone = TimeZone(abbreviation: "GMT")
                                   dateFormatterPrint.dateFormat = "dd-MMM-yy HH:mm a"
                                   
                           //        print(dateFormatterPrint.string(from: lastSent))
                                   let lastSentStr = dateFormatterPrint.string(from: date)
                        
                        
                        
                        self.sentTimelbl.text = String("\(lastSentStr)") }
                    else {
                        self.sentTimelbl.text = "NA"
                    }
            
            //4 viewed status
                       if (reportDetail.viewStatus == true){
                        
                        viewedTimelbl.text = "Viewed"}
                              else {
                      
                        viewedTimelbl.text = "Not Viewed"
                              }
            //5 - Viewed Time
                  let date = Date(timeIntervalSince1970: (Double( reportDetail.viewTimeStamp ?? 5) / 1000.0))
                  print("date - \(date)")
                  let formatter = DateFormatter()
                  formatter.dateFormat = "dd-MMM-yy HH:mm a"
                 viewedStatuslbl.text = formatter.string(from: date)
                 
                  //6 - content Status (expiry)
                        if (reportDetail.expiryStatus == true){
                            expiredBool = true
                          contentStatuslbl.text = "EXPIRED"
                          contentStatuslbl.textColor = UIColor.red
                        } else {
                              expiredBool = false
                              contentStatuslbl.text = "ACTIVE"
                          contentStatuslbl.textColor = UIColor.white
                      }
            //7 - expiry Date
            if (reportDetail.expiryDate) != 0 {
            
                let dateexp = Date(timeIntervalSince1970: (Double( reportDetail.expiryDate ?? 5) / 1000.0))
                let string1 = formatter.string(from: dateexp)
            
            var string2 = ""
                 print("date - \(date)")
            if #available(iOS 13.0, *) {
                let formatter = RelativeDateTimeFormatter()
                formatter.localizedString(from: DateComponents(day: -1)) // "1 day ago"
                formatter.localizedString(from: DateComponents(hour: 2)) // "in 2 hours"
                formatter.localizedString(from: DateComponents(minute: 45)) // "in 45 minutes"
                formatter.dateTimeStyle = .named
                formatter.localizedString(from: DateComponents(day: -1))
                
                string2 = formatter.string(for: dateexp)!
                
            } else {
                let calendar = Calendar.current
                 let date = Date(timeIntervalSince1970: (Double( reportDetail.expiryDate ?? 5) / 1000.0))
                 print("date - \(date)")
                let startOfNow = calendar.startOfDay(for: Date())
                let startOfTimeStamp = calendar.startOfDay(for: date)
                let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
                let day = components.day!
                if abs(day) < 2 {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    formatter.doesRelativeDateFormatting = true
                   string2 = formatter.string(from: date)
                } else if day > 1 {
                    string2 = "In \(day) days"
                } else {
                   string2 = "\(-day) days ago"
                }
            }
                expDatelbl.text = string1 + "(" + string2 + ")"
            }
            else {
                   expDatelbl.text = "NA"
            }
    }

}
