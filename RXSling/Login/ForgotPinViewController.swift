//
//  ForgotPinViewController.swift
//  RXSling
//
//  Created by Divakara Y N. on 23/03/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPinViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailIDTextField: TextField!
    
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var slingImage: UIImageView!
    @IBOutlet weak var forgotPassNavLabel: UILabel!
    override func viewDidLoad() {
            super.viewDidLoad()
            self.mailIDTextField.delegate = self
             if UIDevice.current.userInterfaceIdiom == .pad {
                       slingImage.frame = CGRect(x: (self.view.frame.width - slingImage.frame.size.width*2)/2, y: self.view.frame.width/7, width: slingImage.frame.size.width*2, height: slingImage.frame.size.height*2)
                             }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            forgotPassNavLabel.text = "FORGOT PASSWORD".localizedString()
            self.mailIDTextField.placeHolderText = "Enter Email ID".localizedString()
            self.descriptionText.text = "PLEASE ENTER YOUR REGISTERED EMAIL ID. WE WILL SEND THE OTP TO YOUR ASSOCIATED MOBILE NUMBER.".localizedString()
            self.cancelBtn.setTitle("CANCEL".localizedString(), for: .normal)
            self.proceedBtn.setTitle("PROCEED".localizedString(), for: .normal)
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }

        @IBAction func cancelButtonTapped(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        callForgotApi()
    }
        func verifyMobileNumber(phoneNumber:String){

            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    DispatchQueue.main.async {
                         hideActivityIndicator(View: self.view)
                    }
                    self.popupAlert(title: "RXSling", message: "\(error!.localizedDescription)", actionTitles: ["NO","YES".localizedString()], actions:[{action1 in},{action2 in
                        },nil])
                }else{
                    DispatchQueue.main.async {
                         hideActivityIndicator(View: self.view)
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPView") as! OTPViewController
                    vc.mobileNumber = phoneNumber
                    vc.verificationID = verificationID
                    vc.baseUrl = Constants.Api.getUserPhoneNumberUrl
                    vc.email = self.mailIDTextField.text
                    self.navigationController?.pushViewController(vc, animated: true)
                }}

        }
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder();
            self.callForgotApi()
            return true;
        }
    }


extension ForgotPinViewController{
    
    
    func callForgotApi(){
        if(mailIDTextField.text?.count == 0 || mailIDTextField.text == "" || !isValidEmail(testStr: mailIDTextField.text!)){
            self.popupAlert(title: "RXSling", message: "Enter a valid email ID.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                }else{
                let networkConnection = try! Reachability.init()?.isConnectedToNetwork
                if (!networkConnection!)
                {
                    self.popupAlert(title: "RXSling", message: "Please check your internet connection.".localizedString(), actionTitles: ["Ok"], actions:[{action1 in
                        }, nil])
                }else{
                    DispatchQueue.main.async {
                        showActivityIndicator(View: self.view, "Processing. Please wait...".localizedString())
                    }
                    let emailID = mailIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    print("forgot:\(mailIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))")
                    _ = HTTPRequest.sharedInstance.request(url: Constants.Api.getUserPhoneNumberUrl, method: "POST", params: ["emailId":"\(emailID.trimmingCharacters(in: .whitespacesAndNewlines))"], header: "") { (response, error) in
                        if error != nil
                        {
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(false, forKey: "ISLOGIN")
                                 hideActivityIndicator(View: self.view)
                                self.popupAlert(title: "RXSling", message: "Please check your internet connection.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                            }
                        }
                        else{
                            print("STATUS CODE -> \(response!["statusCode"] as! String)")
                            if(response!["statusCode"] as! String == "100")
                            {
                                let data = response!["data"] as! [String:Any]
                                if((data["mobileNo"]) == nil){
                                    DispatchQueue.main.async {
                                     hideActivityIndicator(View: self.view)
                                        let msg = data["message"]
                                        self.popupAlert(title: "RXSling", message: "\(msg ?? "")", actionTitles: ["Ok"], actions:[{action in},nil])}
                                }else{
                                    let phoneNumber = data["mobileNo"] as! String
                                    print(phoneNumber)
                                    self.verifyMobileNumber(phoneNumber: phoneNumber)
                                }
                            }else if (response!["statusCode"] as! String == "104") {
                                DispatchQueue.main.async {
                                     hideActivityIndicator(View: self.view)
                                }
                                self.popupAlert(title: "RXSling", message: "User doesn't exists.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                            }else{
                                DispatchQueue.main.async {
                                     hideActivityIndicator(View: self.view)
                                }
                                self.popupAlert(title: "RXSling", message: "Unable to proceed due to network error. Please try after some time.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                            }
                        }
                    }
                }
            }
    }
}
