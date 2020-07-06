//
//  ShareViewController.swift
//  RXSling
//
//  Created by Manish Ranjan on 30/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import MessageUI

class ShareViewController: UIViewController {

    @IBOutlet weak var backgroundCardView:UIView!
    @IBOutlet weak var optionsTable:UITableView!
    @IBOutlet weak var cancelButton:UIButton!

    var snt: SNTData?
    var shortenUrlData: ShortenData?
    var welcomeMessage: String?
    var userDetails: ProfileUserInfo?
    var userPhoneNumber: String?

    var optionsArray = [ProfileConfig](){
        
        didSet{
            optionsTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Share"

        optionsTable.alwaysBounceVertical = true
        
        // Do any additional setup after loading the view.
        optionsTable.backgroundColor = .white
        
        if let loginData = UserDefaults.standard.object(forKey: "LOGIN_DATA") as? Data {
            if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: loginData) {
                if(response.statusCode == "100"){
                    
                    guard let data = response.data else {return}
                    
                    print(data.config)

                    optionsArray = data.config
                    userDetails = data.userInfo
                }
            }
        }

      
    }
    
    
    
    @IBAction func cancelBtnPressed(_ sender: UIButton){
        
        self.dismiss(animated: false, completion: nil)
    }


}

extension ShareViewController: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = .black
        cell.backgroundColor = .white
        
        let config = optionsArray[indexPath.row]
        cell.textLabel?.text = config.type
        cell.textLabel?.textColor = .black
        
        if(!config.enabled){
            cell.tintColor = .gray
            cell.textLabel?.textColor = .gray
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = getcustomMessage()
        
        switch indexPath.row {
        case 0:
            
            openWhatsApp(message)
        case 1:
            openSmsApp(message)
        case 2:
            openEmailApp(message)
            
        default:
            print("Not found")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}


extension ShareViewController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    
    //MARK: - Open WhatsApp
    func openWhatsApp(_ messageToSend: String){
        showBarButtonItem()
        
        let escapedMsg = messageToSend.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
        let numberEncode = self.userPhoneNumber?.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
    //https://wa.me/15551234567?text=
        let appToOpen = "https://wa.me/\(numberEncode ?? "")?text=\(escapedMsg ?? "")"
        
        if let url = URL(string:  appToOpen){
            if UIApplication.shared.canOpenURL(url as URL)
            {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
//        if let urlString = appToOpen.addingPercentEncoding(withAllowedCharacters: CharacterSet.punctuationCharacters) {
//            if let whatsappURL = URL(string: urlString) {
//                openUrl(whatsappURL)
//            }
//        }
    }
    
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
    
    //MARK: - Open Email
      func openEmailApp(_ messageToSend: String){
         showBarButtonItem()
        if MFMailComposeViewController.canSendMail() {
              let mail = MFMailComposeViewController()
              mail.mailComposeDelegate = self
              mail.modalPresentationStyle = .fullScreen
              mail.setToRecipients([])
              mail.setSubject(messageToSend)
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

extension ShareViewController{
    
    //MARK: Get custom message
       func getcustomMessage() -> String{
           
           var customMessageToSend:String = ""
           
           /*
            1. customMessageText - from SNT model - Check for nil - Send this custom message and short url generated by Api 12 as message in all above share options
            
            Check for below in customMessageText text string and change respectively
            %name% -  If found change with - repName
            %link% -  If found change with - short url Api 12
            
            Hi, %name% is for testing.
            
            Hi, Test is for %name%
            
            customMessageText replacing %name% and %link%
            */
           
           //Check for nil
           if let message = snt?.customMessageText{
               
               if(message.count > 0){
                   
                   print("Custom message: \(message)")
                   let updatedMessage = getNameAndLinkReplacedCustomMessage(message)
                   
                   customMessageToSend = "\(updatedMessage)"
                   
               }else{
                   
                   /*
                    2. If customMessageText is not available then check welcome message
                    Welcomemessage : Title of SNT from SNT model : “Short url from Api 12” - in quotes
                    */
                   let welcomeMessage = checkForWelcomMessage()
                   return welcomeMessage
               }
               
           }
           else
           {
               /*
                2. If customMessageText is not available then check welcome message
                Welcomemessage : Title of SNT from SNT model : “Short url from Api 12” - in quotes
                */
               let welcomeMessage = checkForWelcomMessage()
               return welcomeMessage
               
           }
//        let data = customMessageToSend.data(using: String.Encoding.utf8)
//        let str = String.init(data: data!, encoding: String.Encoding.utf8)
        return customMessageToSend
       }
       
       
       func checkForWelcomMessage() -> String{
           
           var welcomeMsg:String = ""
           let shortUrl:String = getShortenUrl()
           
           print("Custom message NOT FOUND")
           
           if let welcomeMessage = welcomeMessage{
               
               if(welcomeMessage.count > 0){
                   
                   print("welcomeMessage: \(welcomeMessage)")
                welcomeMsg = "\(welcomeMessage) : \(snt!.title) : \(shortUrl)"
                   return welcomeMsg
                   
               }else{
                   
                   print("Welcome message NOT FOUND")
                welcomeMsg = "\(snt!.title) : \(shortUrl)"
                   return welcomeMsg
               }
               
           }else{
               print("Welcome message NOT FOUND")
               
               /*
                3. If customMessageText && Welcomemessage == Nil
                Title of SNT from SNT model : “Short url from Api 12” - in quotes
                */
               
            welcomeMsg = "\(snt!.title) : \(shortUrl)"
               return welcomeMsg
           }
       }
       
       
       func getShortenUrl() -> String{
           var shortUrl:String = ""
           
           if let shortenUrl = shortenUrlData{
               
            if(shortenUrl.shortenURL.count > 0){
                   
                   shortUrl = shortenUrl.shortenURL
                   return shortUrl
               }else{
                   return shortUrl
               }
           }else{
               return shortUrl
           }
       }
       
       func getNameAndLinkReplacedCustomMessage(_ message: String) -> String{
           
           var replaced = ""
           var finalReplaced = ""
           
           if let user = userDetails{
               
               let userName = String("\(user.firstName!) \(user.lastName!)")
               replaced = message.replacingOccurrences(of: "%name%", with: userName)
               
           }
           
           if let shortenUrlData = shortenUrlData{
               
               finalReplaced = replaced.replacingOccurrences(of: "%link%", with: shortenUrlData.shortenURL)
           }
           
           /*
            Hi, this is for testing custom message. This message is shared by %name% and the URL for the content is %link% : SNT for Manish : http://rxp.at/oM0gw3KGl7zA
            */
           
           return finalReplaced
       }
}

extension String{
    func utf8DecodedString()-> String {
         let data = self.data(using: .utf8)
         if let message = String(data: data!, encoding: .nonLossyASCII){
                return message
          }
          return ""
    }

    func utf8EncodedString()-> String {
         let messageData = self.data(using: .nonLossyASCII)
         let text = String(data: messageData!, encoding: .utf8)
        return text ?? ""
    }

}
