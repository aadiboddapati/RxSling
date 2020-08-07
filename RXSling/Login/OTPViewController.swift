//
//  OTPViewController.swift
//  RXSling
//
//  Created by Divakara Y N. on 24/03/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class OTPViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var eyeBUtton: UIButton!
    
    @IBOutlet weak var otpTextField: TextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var resendOTPBtn: UIButton!
    @IBOutlet weak var slingImage: UIImageView!
    @IBOutlet weak var otpReceivedLabel: UILabel!
    var mobileNumber:String?
    var verificationID:String?
    var baseUrl,email :String?
    var emailId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.otpTextField.delegate = self
        self.addDoneButtonOnKeyboard(textField: otpTextField)
        print("Email from OTP VC \(self.emailId ?? "")")
        if UIDevice.current.userInterfaceIdiom == .pad {
                   slingImage.frame = CGRect(x: (self.view.frame.width - slingImage.frame.size.width*2)/2, y: self.view.frame.width/7, width: slingImage.frame.size.width*2, height: slingImage.frame.size.height*2)
                         }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            showToast(message: "Enter OTP received".localizedString(), view: self.view)
        }
        print("Email from OTP VC \(self.emailId ?? "")")
        self.resendOTPBtn.setTitle("Resend OTP".localizedString(), for: .normal)
        self.cancelBtn.setTitle("CANCEL".localizedString(), for: .normal)
        self.submitBtn.setTitle("SUBMIT".localizedString(), for: .normal)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBarBUttomItem()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func addDoneButtonOnKeyboard(textField:UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localizedString(), style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.barTintColor = UIColor.white
        doneToolbar.tintColor = GREENCOLOUR
        textField.inputAccessoryView = doneToolbar
        showBarButtonItem()
    }
    @objc func doneButtonAction(){
        otpTextField.resignFirstResponder()
        hideBarBUttomItem()
        self.otpValidate()
    }
    func otpValidate(){
        if((self.otpTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0){
            showActivityIndicator(View: self.view, "Validating OTP, Please wait.".localizedString())
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: self.otpTextField.text!)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if error != nil {
                    self.popupAlert(title: "RXSling", message: "Incorrect OTP".localizedString(), actionTitles: ["Ok"], actions:[{action1 in},nil])
                    print("\(String(describing: error?.localizedDescription))")
                    // ...
                }else{

                    if(self.baseUrl == Constants.Api.getUserPhoneNumberUrl){
                        self.popupAlert(title: "RXSling", message: "Your mobile number has been successfully verified. Please proceed to change password.".localizedString(), actionTitles: ["Ok"], actions:[{action1 in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "changePassword") as! changePasswordViewController
                            vc.email = self.email
                            self.navigationController?.pushViewController(vc, animated: true)
                            },nil])

                    }else{
                        self.popupAlert(title: "RXSling", message: "Your mobile number has been successfully verified. Please proceed with your registration.".localizedString(), actionTitles: ["Ok"], actions:[{action1 in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationView") as! RegistrationViewController
                            vc.mobileNumber = authResult?.user.phoneNumber
                            vc.emailId = self.emailId
                            self.navigationController?.pushViewController(vc, animated: true)
                            },nil])
                    }
                }
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                }
                // User is signed in
                // ...
            }
        }else{
            self.popupAlert(title: "RXSling", message: "Incorrect OTP".localizedString(), actionTitles: ["Ok"], actions:[{action1 in},nil])
        }
    }
    @IBAction func eyeButtonClicked(_ sender: Any) {
         otpTextField.isSecureTextEntry = !otpTextField.isSecureTextEntry
        if(self.otpTextField.isSecureTextEntry){
            self.eyeBUtton.setImage(UIImage(named: "eye.png"), for: .normal)
        }else{
            self.eyeBUtton.setImage(UIImage(named: "View.png"), for: .normal)
        }
    }
    @IBAction func resendOtpTapped(_ sender: Any) {
       // self.popupAlert(title: LanguageManager.sharedInstance.LocalizedLanguage(key: "my_show_and_tell"), message: "A", actionTitles: [LanguageManager.sharedInstance.LocalizedLanguage(key: "no"),LanguageManager.sharedInstance.LocalizedLanguage(key: "yes")], actions:[{action1 in},{action2 in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    showActivityIndicator(View: self.view, "Resending OTP".localizedString())
                }
                PhoneAuthProvider.provider().verifyPhoneNumber(self.mobileNumber!, uiDelegate: nil) { (verificationID, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                             hideActivityIndicator(View: self.view)
                        }
                        self.popupAlert(title: "RXSling", message: "\(error!.localizedDescription)", actionTitles: ["Ok","Yes".localizedString()], actions:[{action1 in},{action2 in
                            },nil])
                    }else{
                        DispatchQueue.main.async {
                             hideActivityIndicator(View: self.view)
                            self.verificationID = verificationID
                        }
                    }
                }
           // },nil])

    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        otpValidate()
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if(self.baseUrl == Constants.Api.getUserPhoneNumberUrl){
            self.popupAlert(title: "RXSling", message: "Do you want to cancel the forgot password process?".localizedString(), actionTitles: ["No","Yes".localizedString()], actions:[{action1 in},{action2 in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
                },nil])
        }else{
            self.popupAlert(title: "RXSling", message: "Do you want to cancel the registration process?".localizedString(), actionTitles: ["No","Yes".localizedString()], actions:[{action1 in},{action2 in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
                },nil])
        }
    }
    
}
