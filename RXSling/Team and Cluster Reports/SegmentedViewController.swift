//
//  SegmentedViewController.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 10/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import MessageUI
protocol CallToActionProtocol:NSObjectProtocol {
    func callAction()
    func whatsappAction()
    func copyReportAction()
    func emailAction()
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
    func copyReportAction() {
        if isTeamReport {
            UIPasteboard.general.string = formTheTeamMessageContent()
        } else {
            UIPasteboard.general.string = formTheCluserMessageContent()
        }
    }
    
    func emailAction() {
        let content = isTeamReport ? formTheTeamMessageContent() : formTheCluserMessageContent()
        let subject = selectedSnt?.title ?? ""
        openEmailApp(content, subject: subject)
    }
    
    func callAction() {
        let phoneNumber = isTeamReport ? teamData.userData?.mobileNo ?? ""  : clusterData.userData?.mobileNo ?? ""
        callButtonAction(mobileNumber: phoneNumber)
    }
    
    func whatsappAction() {
        let content = isTeamReport ? formTheTeamMessageContent() : formTheCluserMessageContent()
        let phoneNumber = isTeamReport ? teamData.userData?.mobileNo ?? ""  : clusterData.userData?.mobileNo ?? ""
        openWhatsApp(content, mobileNumber: phoneNumber)
    }
    
    func formTheTeamMessageContent() -> String {
         
         let repName = ( teamData.userData?.firstName ?? "" )  + " " +  ( teamData.userData?.lastName ?? "" )
         let repMobileNumber = teamData.userData?.mobileNo ?? ""
         let repEmail = teamData.userData?.emailId ?? ""
         let contentTitle   = selectedSnt?.title ?? ""
         let contentDesc = selectedSnt?.desc ?? ""
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
        Hi "\(repName)",

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
        \(repName)
        """
      
    }

    func formTheCluserMessageContent() -> String {
         
         let managerName = ( clusterData.userData?.firstName ?? "" )  + " " +  ( clusterData.userData?.lastName ?? "" )
         let managerMobileNumber = clusterData.userData?.mobileNo ?? ""
         let managerEmail = clusterData.userData?.emailId ?? ""
         let contentTitle   = selectedSnt?.title ?? ""
         let contentDesc = selectedSnt?.desc ?? ""
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
        \(managerName)
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

extension SegmentedViewController: MFMailComposeViewControllerDelegate {
    
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
    /*
     //MARK: - Open SMS
     func openSmsApp(_ messageToSend: String){
     showBarButtonItem()
     let smsVC = MFMessageComposeViewController()
     smsVC.messageComposeDelegate = self
     
     // Configure the fields of the interface.
     smsVC.recipients = [(self.userPhoneNumber ?? "")]
     smsVC.body = messageToSend
     
     // Present the view controller modally.
     if MFMessageComposeViewController.canSendText() {
     smsVC.navigationBar.barTintColor = .rxGreen
     smsVC.modalPresentationStyle = .overFullScreen
     self.present(smsVC, animated: true, completion: nil)
     } else {
     print("Can't send messages.")
     }
     }
     */
    
    //MARK: - Open Email
    func openEmailApp(_ messageToSend: String, subject:String){
        showBarButtonItem()
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.modalPresentationStyle = .fullScreen
            mail.setToRecipients([])
            mail.setSubject(subject)
            mail.setMessageBody("<b>\(messageToSend)</b>", isHTML: true)
            self.present(mail, animated: true, completion: nil)
            
        } else {
            print("Cannot send mail")
            Utility.showAlertWith(message: "Mail not configured", inView: self)
        }
    }
    
    // MARK: - MessageComposeViewControllerDelegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue:
            print("Cancelled")
            dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Sent")
            dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Failed")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
            dismiss(animated: true, completion: nil)
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
            dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
            dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(error?.localizedDescription ?? " can't send mail")")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
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

