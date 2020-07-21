//
//  SegmentedViewController.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 10/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import MessageUI
import Toast_Swift

protocol CallToActionProtocol:NSObjectProtocol {
    func callAction(isTrendVC:Bool)
    func whatsappAction(isTrendVC:Bool, daysReport:[String:OneDayReport], orderedDays:[String])
    func copyReportAction(isTrendVC:Bool, daysReport:[String:OneDayReport], orderedDays:[String])
    func emailAction(isTrendVC:Bool, daysReport:[String:OneDayReport], orderedDays:[String])
}

class SegmentedViewController: UIViewController {
    
    @IBOutlet weak var segmntCntrl: UISegmentedControl!
    @IBOutlet weak var containerView:UIView!
    
    @IBOutlet weak var segmentedViewHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var segmentedViewTopConstrait: NSLayoutConstraint!
    var teamData: TeamData!
    var clusterData: ClusterReportData!
    var selectedSnt: SNTData?
    var isTeamReport:Bool!
    var reportList: [Report]?
    var selectedTeamMember:String?
    
    var backButton : UIBarButtonItem!
    
    
    
    private lazy var teamRepVC: TeamRepDetailViewController = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamrepdetailsvc) as! TeamRepDetailViewController
        viewController.callToActionDelegate = self

        
        viewController.teamData = self.teamData
        viewController.clusterData = self.clusterData
        viewController.selectedSnt = self.selectedSnt
        viewController.isTeamReport = self.isTeamReport
        viewController.reportList = self.reportList
        
        self.add(asChildViewController: viewController)
        return viewController
    }()
    private lazy var teamTrendVC: TeamTrendViewController = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamtrendvc) as! TeamTrendViewController
        viewController.isTeamReport = self.isTeamReport
        viewController.callToActionDelegate = self
        self.add(asChildViewController: viewController)
        return viewController
    }()
    private lazy var teamCustomerInfoVC: TeamCustomerInfoViewController = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamcustomerinfovc) as! TeamCustomerInfoViewController
        viewController.reportList = self.reportList
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = isTeamReport ? "REP DETAILED REPORT" : "MANAGER DETAILED REPORT"
        
        if !isTeamReport {
            segmentedViewTopConstrait.constant = 0
            segmentedViewHeightConstrait.constant = -10
            segmntCntrl.isHidden = true
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        updateView()
        
        if isTeamReport {
            showActivityIndicator(View: self.view, Constants.Loader.reportDetails )
            self.callApiToFetchReportInfo()
        }
        
        if #available(iOS 13, *) {
            segmntCntrl.selectedSegmentTintColor = .rxGreen
        } else {
            segmntCntrl.tintColor = .rxGreen
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmenteAction(_ sender: UISegmentedControl)  {
        updateView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView() {
        
        switch segmntCntrl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: teamTrendVC)
            remove(asChildViewController: teamCustomerInfoVC)
            add(asChildViewController: teamRepVC)
        case 1:
            remove(asChildViewController: teamRepVC)
            remove(asChildViewController: teamCustomerInfoVC)
            add(asChildViewController: teamTrendVC)
        case 2:
            remove(asChildViewController: teamTrendVC)
            remove(asChildViewController: teamRepVC)
            add(asChildViewController: teamCustomerInfoVC)
        default:
            print("")
        }
    }
    
    
    @objc func callApiToFetchReportInfo() {
        //Api
        guard let snt = selectedSnt else {return}
        let api = Constants.Api.reportListUrl
        //Token as header
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        //Parameters
        //-----------
        
        let sntId = URL(string: snt.sntURL)!.lastPathComponent
        let userEmail = isTeamReport ? teamData.repEmailId ?? ""  : clusterData.managerId ?? ""
        
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
                        
                        self.teamRepVC.teamData = self.teamData
                        self.teamRepVC.clusterData = self.clusterData
                        self.teamRepVC.selectedSnt = self.selectedSnt
                        self.teamRepVC.reportList = responseData.data
                        
                        self.teamCustomerInfoVC.teamData = self.teamData
                        self.teamCustomerInfoVC.clusterData = self.clusterData
                        self.teamCustomerInfoVC.selectedSnt = self.selectedSnt
                        self.teamCustomerInfoVC.reportList = responseData.data
                        
                        self.teamTrendVC.reportList = responseData.data
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        if(responseData.statusCode == "104"){
                            // self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
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
    
    @objc func tokenExpiredLogin(){
        
        Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired, alertButtons: 1, buttonTitle:"Ok", inView: self) { (tapVal) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SegmentedViewController: CallToActionProtocol {
    
    func copyReportAction(isTrendVC:Bool, daysReport:[String:OneDayReport], orderedDays:[String]) {
        
        if isTrendVC {
            UIPasteboard.general.string = formTrendMessageContent(daysReport, orderedDays: orderedDays)
            self.view.makeToast("Content copied to clipboard.", duration: 1.0, position: .bottom)
            
        } else {
            if isTeamReport {
                UIPasteboard.general.string = formTheTeamMessageContent()
            } else {
                UIPasteboard.general.string = formTheCluserMessageContent()
            }
            self.view.makeToast("Content copied to clipboard.", duration: 1.0, position: .bottom)
        }

    }
    
    func emailAction(isTrendVC:Bool, daysReport:[String:OneDayReport], orderedDays:[String]) {
        
        if isTrendVC {
            let content = formTrendMessageContent(daysReport, orderedDays: orderedDays)
            let subject = selectedSnt?.title ?? ""
            let email =  teamData.userData?.emailId ?? ""
            openEmailApp(content, subject: subject,recipients: [email])
            
        } else {
            let content = isTeamReport ? formTheTeamMessageContent() : formTheCluserMessageContent()
            let subject = selectedSnt?.title ?? ""
            let email = isTeamReport ? ( teamData.userData?.emailId ?? "" ) : (clusterData.userData?.emailId ?? "")
            openEmailApp(content, subject: subject,recipients: [email])
        }
        
    }
    
    func callAction(isTrendVC:Bool) {
        let phoneNumber = isTeamReport ? teamData.userData?.mobileNo ?? ""  : clusterData.userData?.mobileNo ?? ""
        callButtonAction(mobileNumber: phoneNumber)
    }
    
    func whatsappAction(isTrendVC:Bool, daysReport:[String:OneDayReport], orderedDays:[String]) {
        
        if isTrendVC {
            let content = formTrendMessageContent(daysReport, orderedDays: orderedDays)
            let phoneNumber = teamData.userData?.mobileNo ?? ""
            openWhatsApp(content, mobileNumber: phoneNumber)
        } else {
            let content = isTeamReport ? formTheTeamMessageContent() : formTheCluserMessageContent()
            let phoneNumber = isTeamReport ? teamData.userData?.mobileNo ?? ""  : clusterData.userData?.mobileNo ?? ""
            openWhatsApp(content, mobileNumber: phoneNumber)
        }
        
    }
    
    func formTheTeamMessageContent() -> String {
         
         let repName = ( teamData.userData?.firstName ?? "" )  + " " +  ( teamData.userData?.lastName ?? "" )
        
        let data =  USERDEFAULTS.value(forKey: "LOGIN_DATA") as! Data
        let profileModel = try! JSONDecoder().decode(ProfileDataModel.self, from: data)
        let loggedInUserName = ( profileModel.data?.userInfo.firstName ?? "" ) + " " + ( profileModel.data?.userInfo.lastName ?? "" )
        
         let repMobileNumber = teamData.userData?.mobileNo ?? ""
         let repEmail = teamData.userData?.emailId ?? ""
         let contentTitle   = selectedSnt?.title ?? ""
         let contentDesc = ( selectedSnt?.desc ?? "" ).trimmingCharacters(in: .newlines)
         let sentCount = "\(teamData.sentCount ?? 0)"
         let viewedCount = "\(teamData.viewedCount ?? 0)"
        
        var successRate = ""
        if sentCount == "0" ||  viewedCount == "0" {
            successRate = "0 %"
        } else {
            let percentage =  ( Double (teamData.viewedCount!) / Double ( teamData.sentCount! ) ) * 100
            successRate = String(format: "%.2f %@", percentage, "%") // ceil(percentage*100)/100
        }
        
        return """
        Hi \(repName),

        Below is the information about your content performance as on \(getTheTimeAndDate()).

        REP Name : \(repName)
        REP Mobile No : \(repMobileNumber)
        REP Email : \(repEmail)

        Content Title : \(contentTitle)
        Content Desc : \(contentDesc)

        Content Performance as on \(getTheTimeAndDate()).

        Sent Count : \(sentCount)
        Viewed Count : \(viewedCount)
        Success Rate : \(successRate)

        Thank you,
        \(loggedInUserName)
        """
      
    }

    func formTheCluserMessageContent() -> String {
         
         let managerName = ( clusterData.userData?.firstName ?? "" )  + " " +  ( clusterData.userData?.lastName ?? "" )
        
        let data =  USERDEFAULTS.value(forKey: "LOGIN_DATA") as! Data
        let profileModel = try! JSONDecoder().decode(ProfileDataModel.self, from: data)
        let loggedInUserName = ( profileModel.data?.userInfo.firstName ?? "" ) + " " + ( profileModel.data?.userInfo.lastName ?? "" )
        
         let managerMobileNumber = clusterData.userData?.mobileNo ?? ""
         let managerEmail = clusterData.userData?.emailId ?? ""
         let contentTitle   = selectedSnt?.title ?? ""
        let contentDesc = ( selectedSnt?.desc ?? "" ).trimmingCharacters(in: .newlines)
         let sentCount = "\(clusterData.sentCount ?? 0)"
         let viewedCount = "\(clusterData.viewedCount ?? 0)"
        
        var successRate = ""
        if sentCount == "0" ||  viewedCount == "0" {
            successRate = "0 %"
        } else {
            let percentage =  ( Double (clusterData.viewedCount!) / Double ( clusterData.sentCount! ) ) * 100
            successRate = String(format: "%.2f %@", percentage, "%") // ceil(percentage*100)/100
        }
        
        
        return """
        Hi \(managerName),

        Below is the information about your content performance as on \(getTheTimeAndDate()).

        REP Name : \(managerName)
        REP Mobile No : \(managerMobileNumber)
        REP Email : \(managerEmail)

        Content Title : \(contentTitle)
        Content Desc : \(contentDesc)

        Content Performance as on \(getTheTimeAndDate()).

        Sent Count : \(sentCount)
        Viewed Count : \(viewedCount)
        Success Rate : \(successRate)

        Thank you,
        \(loggedInUserName)
        """
      
    }
    
    func formTrendMessageContent(_ tenDaysData:[String: OneDayReport], orderedDays:[String]) -> String {
        
        let repName = ( teamData.userData?.firstName ?? "" )  + " " +  ( teamData.userData?.lastName ?? "" )
        
        let data =  USERDEFAULTS.value(forKey: "LOGIN_DATA") as! Data
        let profileModel = try! JSONDecoder().decode(ProfileDataModel.self, from: data)
        let loggedInUserName = ( profileModel.data?.userInfo.firstName ?? "" ) + " " + ( profileModel.data?.userInfo.lastName ?? "" )
        
         let repMobileNumber = teamData.userData?.mobileNo ?? ""
         let repEmail = teamData.userData?.emailId ?? ""
         let contentTitle   = selectedSnt?.title ?? ""
         let contentDesc = ( selectedSnt?.desc ?? "" ).trimmingCharacters(in: .newlines)
        
         var trendArray = [String]()
         for value  in orderedDays {
            let sent = String(format: "%.0f", tenDaysData[value]?.sentCount ?? Double(0))
            let viewed = String(format: "%.0f", tenDaysData[value]?.viewedCount ?? Double(0))

            let formattedString = "\(value)     -- Sent : \(sent) & Viewed : \(viewed)"
            trendArray.append(formattedString)
         }
        
        return """
        Hi \(repName),

        Below is the information about your content performance as on \(getTheTimeAndDate()).

        REP Name : \(repName)
        REP Mobile No : \(repMobileNumber)
        REP Email : \(repEmail)

        Content Title : \(contentTitle)
        Content Desc : \(contentDesc)

        Trend from last 10 days from \(getTheTimeAndDate().components(separatedBy: ",").first!),  \(orderedDays.first!) to \(getTheTimeAndDate())
        
        \(trendArray.joined(separator: "\n"))
        
        Thank you,
        \(loggedInUserName)
        """
    }
    
    func getTheTimeAndDate() -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a ',' dd-MMM-yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        let dateString = formatter.string(from: Date())
        return dateString
    }
    
    
}

// MARK: Call to actions
extension SegmentedViewController {
    
    func callButtonAction(mobileNumber: String)  {
        
        if let phoneCallURL = URL(string: "telprompt://\(mobileNumber)") {
            
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
    
    //MARK: - Open WhatsApp
    func openWhatsApp(_ messageToSend: String, mobileNumber: String) {
        showBarButtonItem()
        
        let escapedMsg = messageToSend.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
        let numberEncode = mobileNumber.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
        //https://wa.me/15551234567?text=
        let appToOpen = "https://wa.me/\(numberEncode ?? "")?text=\(escapedMsg ?? "")"
        
        if let url = URL(string:  appToOpen){
            if UIApplication.shared.canOpenURL(url as URL)
            {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        
    }
  
    //MARK: - Open Email
    func openEmailApp(_ messageToSend: String, subject:String, recipients:[String]){
        showBarButtonItem()
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.delegate = self
            mail.modalPresentationStyle = .fullScreen
            mail.setToRecipients(recipients)
            mail.setSubject(subject)
            mail.setMessageBody("\(messageToSend)", isHTML: false)
           // mail.modalPresentationStyle = .automatic
            self.present(mail, animated: true, completion: nil)
            
        } else {
            print("Cannot send mail")
            Utility.showAlertWith(message: "Mail not configured", inView: self)
        }
    }
    
    //MARK: Open url
    func openUrl(_ appURL: URL){
        
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }
    }
}

extension SegmentedViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

