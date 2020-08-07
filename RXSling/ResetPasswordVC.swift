//
//  ResetPasswordVC.swift
//  RXSling Stage
//
//  Created by Divakara Y N. on 02/05/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var reEnterEyeButton: UIButton!
    @IBOutlet weak var newEyeButton: UIButton!
    @IBOutlet weak var oldEyeButton: UIButton!
    @IBOutlet weak var reEnterPasswordTextField: TextField!
    @IBOutlet weak var newPasswordTextField: TextField!
    @IBOutlet weak var oldPasswordTextField: TextField!
    @IBOutlet weak var oldPswdLabel: UILabel!
    @IBOutlet weak var newPswdLabel: UILabel!
    @IBOutlet weak var confirmPswdLabel: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "RESET PASSWORD".localizedString()
        self.oldPasswordTextField.delegate = self
        self.newPasswordTextField.delegate = self
        self.reEnterPasswordTextField.delegate = self
        
        self.oldPswdLabel.text = "Old Password".localizedString()
        self.newPswdLabel.text = "New Password".localizedString()
        self.confirmPswdLabel.text = "Confirm Password".localizedString()
        self.oldPasswordTextField.placeHolderText = "Enter Old Password".localizedString()
        self.newPasswordTextField.placeHolderText = "Enter New Password".localizedString()
        self.reEnterPasswordTextField.placeHolderText = "Confirm New Password".localizedString()
        self.cancelBtn.setTitle("CANCEL".localizedString(), for: .normal)
        self.resetBtn.setTitle("RESET".localizedString(), for: .normal)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hideBarBUttomItem()
        self.navigationController?.navigationBar.isHidden = false
        if UIDevice.current.userInterfaceIdiom == .pad {
           // self.view.backgroundColor = UIColor(red: 0.45, green: 0.67, blue: 0.30, alpha: 0.5)
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        } else {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func resetButtonTapped(_ sender: Any) {
        if(oldPasswordTextField.text == ""){
            self.popupAlert(title: "RXSling", message: "Enter a valid old password".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            return
        }else{
            if ((oldPasswordTextField.text?.count)! <= 7){
                self.popupAlert(title: "RXSling", message: "Password cannot be less then 8 characters.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                return
            }
        }

        if(!isValidPassword(testStr: self.newPasswordTextField.text!)){
            self.popupAlert(title: "RXSling", message: "Password cannot be less than 8 characters, should contain at least one capital letter, one small letter, one number and a special character(@$!%?&#^).".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            return
        }
        
        if(reEnterPasswordTextField.text! != newPasswordTextField.text){
            self.popupAlert(title: "RXSling", message: "Passwords did not match.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
        }else if (oldPasswordTextField.text! == newPasswordTextField.text){
            self.popupAlert(title: "RXSling", message: "New password cannot be same as the old password.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            return
        }else{
            self.view.endEditing(true)
            let networkConnection = try! Reachability.init()?.isConnectedToNetwork
            if (!networkConnection!)
            {
                self.popupAlert(title: "RXSling", message: "Please check your internet connection".localizedString(), actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
            }else{
                DispatchQueue.main.async {
                    showActivityIndicator(View: self.view, "Resetting your password. Please wait...".localizedString())
                }
                var email = ""
                if let loginData = UserDefaults.standard.object(forKey: "LOGIN_DATA") as? Data {
                    if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: loginData) {
                        if(response.statusCode == "100"){
                            guard let data = response.data else {return}
                            print(data.config)
                            email = data.userInfo.emailID
                        }
                    }
                }
                let params :[String:String] = ["emailId":email.trimmingCharacters(in: .whitespacesAndNewlines),"pin":"\(newPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))","oldPassword":"\(oldPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))"]

                _ = HTTPRequest.sharedInstance.request(url: Constants.Api.resetPin, method: "POST", params: params, header: "\(USERDEFAULTS.value(forKey: "TOKEN")!)") { (response, error) in
                    if error != nil
                    {
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                            self.popupAlert(title: "RXSling", message: "Please check your internet connection".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                        }
                    }
                    else{
                        if(response!["statusCode"] as! String == "100")
                        {
                            DispatchQueue.main.async {
                                print(response!)
                                hideActivityIndicator(View: self.view)
                                self.popupAlert(title: "RXSling", message: "Password has been reset successfully.".localizedString(), actionTitles: ["Ok"], actions:[{action in
                                    self.navigationController?.popViewController(animated: true)
                                    },nil])
                            }
                        }else if (response!["statusCode"] as! String == "108"){
                            DispatchQueue.main.async {
                                hideActivityIndicator(View: self.view)
                            }
                            self.popupAlert(title: "RXSling", message:"Old password is not matching. Please enter the correct old password.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                        }else{
                            DispatchQueue.main.async {
                                hideActivityIndicator(View: self.view)
                            }
                            self.popupAlert(title: "RXSling", message:"Unable to proceed due to network error. Please try after some time.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
                        }
                    }
                }
            }
        }

    }
    
    @IBAction func oldEyeTapped(_ sender: Any) {
          oldPasswordTextField.isSecureTextEntry = !oldPasswordTextField.isSecureTextEntry
            if(self.oldPasswordTextField.isSecureTextEntry){
                self.oldEyeButton.setImage(UIImage(named: "eye.png"), for: .normal)
            }else{
                self.oldEyeButton.setImage(UIImage(named: "View.png"), for: .normal)
            }
    }
    @IBAction func newEyeButtonTapped(_ sender: Any) {
          newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
        if(self.newPasswordTextField.isSecureTextEntry){
            self.newEyeButton.setImage(UIImage(named: "eye.png"), for: .normal)
        }else{
            self.newEyeButton.setImage(UIImage(named: "View.png"), for: .normal)
        }
    }
    @IBAction func reEnterEyeTapped(_ sender: Any) {
          reEnterPasswordTextField.isSecureTextEntry = !reEnterPasswordTextField.isSecureTextEntry
        if(self.reEnterPasswordTextField.isSecureTextEntry){
            self.reEnterEyeButton.setImage(UIImage(named: "eye.png"), for: .normal)
        }else{
            self.reEnterEyeButton.setImage(UIImage(named: "View.png"), for: .normal)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
//            if(nextField.tag > 1){
//                self.view.frame.origin.y = -90
//            }

        } else {
            // Not found, so remove keyboard.
            self.view.frame.origin.y = 0
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}

