//
//  ValidatePhoneNumberVC.swift
//  RXSling
//
//  Created by Divakara Y N. on 24/03/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import PhoneNumberKit
import NKVPhonePicker
import Firebase
import FirebaseAuth

class ValidatePhoneNumberVC: UIViewController {

   @IBOutlet weak var phoneNumberTextField: NKVPhonePickerTextField!
   @IBOutlet weak var validateBtn: UIButton!
   @IBOutlet weak var cancelBtn: UIButton!
   @IBOutlet weak var slingImage: UIImageView!
   @IBOutlet weak var preRegisterNumberLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
   let phoneNumberKit = PhoneNumberKit()

   var countryCode:String?
   //var isValid:Bool = false
   var toolBar = UIView()
   override func viewDidLoad() {
       super.viewDidLoad()
       phoneNumberTextField.layer.borderWidth = 1.2
       phoneNumberTextField.layer.cornerRadius = 12
       phoneNumberTextField.layer.masksToBounds = true
       phoneNumberTextField.layer.borderColor = UIColor.white.cgColor
       phoneNumberTextField.phonePickerDelegate = self
       if UIDevice.current.userInterfaceIdiom == .pad {
               slingImage.frame = CGRect(x: (self.view.frame.width - slingImage.frame.size.width*2)/2, y: self.view.frame.width/7, width: slingImage.frame.size.width*2, height: slingImage.frame.size.height*2)
                     }
       let country = Country.country(for: NKVSource(countryCode: "IN"))
       phoneNumberTextField.country = country
       phoneNumberTextField.flagSize = CGSize(width: 35, height: 35)
       let attributes = [
           NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
           NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) // Note the !
       ]
    let attributedPlaceholder = NSMutableAttributedString(string: "Enter mobile number.".localizedString(), attributes: attributes)
       //self.phoneNumberTextField.attributedPlaceholder = attributedPlaceholder
       self.phoneNumberTextField.tintColor = UIColor.white

       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(notification:)), name:  UIResponder.keyboardDidShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(notification:)), name:  UIResponder.keyboardDidHideNotification, object: nil)
       self.validateBtn.isExclusiveTouch = true
       validateBtn.isMultipleTouchEnabled = false
   }
   override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       self.validateBtn.isUserInteractionEnabled = true
       addDoneButtonOnKeyboard(textField: self.phoneNumberTextField)
       showBarButtonItem()
   }
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
   }
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
    signUpLabel.text = "SIGN UP".localizedString()
    self.validateBtn.setTitle("SEND OTP".localizedString(), for: .normal)
       self.cancelBtn.setTitle("CANCEL".localizedString(), for: .normal)
     preRegisterNumberLabel.text = "PLEASE ENTER THE PRE-REGISTERED  PHONE NUMBER".localizedString()
   }
   override func viewDidDisappear(_ animated: Bool) {

   }
   @objc func keyboardWillAppear(notification: NSNotification?) {

       guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
           return
       }

       let keyboardHeight: CGFloat
       if #available(iOS 11.0, *) {
           keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
       } else {
           keyboardHeight = keyboardFrame.cgRectValue.height
       }
       toolBar = UIView(frame: CGRect(x: 0, y: self.view.frame.height - keyboardHeight-70, width: self.view.frame.width , height: 70))
       self.view.addSubview(toolBar)
       self.reloadInputViews()
   }

   @objc func keyboardWillDisappear(notification: NSNotification?) {
       self.toolBar.removeFromSuperview()
   }
   func sendButtonTapped(){
       //validateBtn.isUserInteractionEnabled = false
       if((self.phoneNumberTextField.text?.count)! > 2){
           DispatchQueue.main.async {
            showActivityIndicator(View: self.view, "Sending OTP, Please wait.".localizedString())
           }

           if(self.verifyPhoneNumber(self.phoneNumberTextField.phoneNumber!)){
               DispatchQueue.main.async {
                   hideActivityIndicator(View: self.view)
               }
               validatePhoneNumber()
           }else{
               DispatchQueue.main.async {
                   self.validateBtn.isUserInteractionEnabled = true
                   hideActivityIndicator(View: self.view)
               }
            self.popupAlert(title: "RXSling", message: "Enter valid mobile number.".localizedString(), actionTitles: ["Ok"], actions:[{action1 in},nil])
           }

       }else{
           validateBtn.isUserInteractionEnabled = true
           self.popupAlert(title: "RXSling", message: "Enter valid mobile number.".localizedString(), actionTitles: ["Ok"], actions:[{action1 in},nil])
       }
   }
   @IBAction func sendOtpBUttonTApped(_ sender: Any) {
       sendButtonTapped()
   }

   @IBAction func cancelTapped(_ sender: Any) {
       hideBarBUttomItem()
       self.popupAlert(title: "RXSling", message: "Do you want to cancel the registration process?".localizedString(), actionTitles: ["No","YES".localizedString()], actions:[{action1 in},{action2 in
           self.navigationController?.popViewController(animated: true)
           },nil])
   }
   private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
       let toolbar: UIToolbar = UIToolbar()

       toolbar.barStyle = UIBarStyle.default
       toolbar.items = items
    toolbar.tintColor = GREENCOLOUR
       toolbar.barTintColor = GREENCOLOUR
       toolbar.sizeToFit()

       return toolbar
   }
   func validatePhoneNumber(){
       let networkConnection = try! Reachability.init()?.isConnectedToNetwork
       if (!networkConnection!)
       {
           self.validateBtn.isUserInteractionEnabled = true
           self.popupAlert(title: "RXSling", message: "Please check your internet connection.".localizedString(), actionTitles: ["Ok"], actions:[{action1 in
               }, nil])
       }else{
           DispatchQueue.main.async {
               showActivityIndicator(View: self.view, "Validating mobile number. Please wait...".localizedString())
           }

           print("+" + "\(phoneNumberTextField.phoneNumber!)")
        _ = HTTPRequest.sharedInstance.request(url: Constants.Api.validateMobileNumberUrl, method: "POST", params: ["mobileNo":"+" + "\(phoneNumberTextField.phoneNumber!)"], header: "", completion: { (response, error) in
               if error != nil
               {
                   DispatchQueue.main.async {
                       hideActivityIndicator(View: self.view)
                       self.validateBtn.isUserInteractionEnabled = true
                       self.popupAlert(title: "RXSling", message: "Please check your internet connection.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                   }
               }else{
                    print(response!)
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                    self.validateBtn.isUserInteractionEnabled = true
                }
                    if(response!["statusCode"] as! String == "100")
                    {
                        var email: String = ""
                        let data = response!["data"] as! [String:Any]
                        if((data["emailId"]) == nil){
                            
                            self.popupAlert(title: "RXSling", message: "Mobile no already exists.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                        }else{
                            email = data["emailId"] as! String
                            
                        }
                            DispatchQueue.main.async {
                                hideActivityIndicator(View: self.view)
                                self.generateOtp(email: email)
                            }
                    }else if(response!["statusCode"] as! String == "101"){
                        self.popupAlert(title: "RXSling", message: "This mobile number is already registered.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                    }else{
                        self.popupAlert(title: "RXSling", message: "Please enter a valid pre-registered mobile number.".localizedString(), actionTitles: ["Ok"], actions: [{action in},nil])
                        
                }
               }
           })
       }
   }









    func generateOtp(email:String)
   {
       DispatchQueue.main.async {
        showActivityIndicator(View: self.view, "Sending OTP, please wait.".localizedString())
       }
       PhoneAuthProvider.provider().verifyPhoneNumber("+" + "\(phoneNumberTextField.phoneNumber!)", uiDelegate: nil) { (verificationID, error) in
           if error != nil {
               DispatchQueue.main.async {
                   self.validateBtn.isUserInteractionEnabled = true
                   hideActivityIndicator(View: self.view)
               }
            self.popupAlert(title: "RXSling", message: "\(error!.localizedDescription)", actionTitles: ["No","YES".localizedString()], actions:[{action1 in},{action2 in
                   },nil])
           }else{
               DispatchQueue.main.async {
                   hideActivityIndicator(View: self.view)
               }

               let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPView") as! OTPViewController
               vc.mobileNumber = "+" + "\(self.phoneNumberTextField.phoneNumber!)"
               vc.verificationID = verificationID
               vc.baseUrl = ""
                print("EMAIL ID -> \(email)")
                vc.emailId = email
               self.validateBtn.isUserInteractionEnabled = true
               self.navigationController?.pushViewController(vc, animated: true)
               hideBarBUttomItem()
           }}
   }
   func verifyPhoneNumber(_ number: String)->Bool {
       var isValid = false
       do {
           let phoneNumber = try phoneNumberKit.parse(number)
           //            parsedNumberLabel.text = phoneNumberKit.format(phoneNumber, toType: .international)
           //            parsedCountryCodeLabel.text = String(phoneNumber.countryCode)
           if let regionCode = phoneNumberKit.mainCountry(forCode:phoneNumber.countryCode) {
               let country = Locale.current.localizedString(forRegionCode: regionCode)
               isValid = true
           }
       }
       catch {
           isValid = false
           print("Something went wrong")
       }
       return isValid
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

   }
   @objc func doneButtonAction(){
       self.view.endEditing(true)
       sendButtonTapped()
   }
}
