//
//  changePasswordViewController.swift
//  RXSling
//
//  Created by Divakara Y N. on 07/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class changePasswordViewController: UIViewController, UITextFieldDelegate {
    var email:String?
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var confirmEyeBtn: UIButton!
    @IBOutlet weak var confirmNewPswd: TextField!
    @IBOutlet weak var slingImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
                   slingImage.frame = CGRect(x: (self.view.frame.width - slingImage.frame.size.width*2)/2, y: self.view.frame.width/7, width: slingImage.frame.size.width*2, height: slingImage.frame.size.height*2)
                         }
        self.emailField.text = self.email
        self.passwordTextField.delegate = self
        self.confirmNewPswd.delegate = self
        // Do any additional setup after loading the view.
        self.changeBtn.setTitle("CHANGE", for: .normal)
        self.cancelBtn.setTitle("CANCEL", for: .normal)
        //self.emailField.placeHolderText = "enter_password"
        self.passwordTextField.placeHolderText = "Enter New Password"
        self.confirmNewPswd.placeHolderText = "Confirm New Password"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //addDoneButtonOnKeyboard(textField: passwordTextField)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func addDoneButtonOnKeyboard(textField:UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.barTintColor = UIColor.white
        doneToolbar.tintColor = GREENCOLOUR
        textField.inputAccessoryView = doneToolbar
        showBarButtonItem()
    }
    @objc func doneButtonAction(){
        self.view.endEditing(true)
        if(!isValidPassword(testStr: self.passwordTextField.text!)){
            self.popupAlert(title: "RXSling", message: "Password cannot be less than 8 characters, should contain at least one capital letter, one small letter, one number and a special character(@$!%?&#^).", actionTitles: ["Ok"], actions:[{action in},nil])
            return
        }else if (confirmNewPswd.text! !=  passwordTextField.text!){
            self.popupAlert(title: "RXSling", message: "Passwords did not match.", actionTitles: ["Ok"], actions:[{action in},nil])
        }else{
            self.changeTapped()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBarBUttomItem()
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.popupAlert(title: "RXSling", message: "Do you want to cancel the forgot password process?", actionTitles: ["NO","YES"], actions:[{action1 in},{action2 in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
            },nil])
    }
    @IBAction func eyeButtonTapped(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if(self.passwordTextField.isSecureTextEntry){
            self.eyeButton.setImage(UIImage(named: "eye.png"), for: .normal)
        }else{
            self.eyeButton.setImage(UIImage(named: "View.png"), for: .normal)
        }
    }

    @IBAction func confirmEyeBtnTapped(_ sender: Any) {
        confirmNewPswd.isSecureTextEntry = !confirmNewPswd.isSecureTextEntry
        if(self.confirmNewPswd.isSecureTextEntry){
            self.confirmEyeBtn.setImage(UIImage(named: "eye.png"), for: .normal)
        }else{
            self.confirmEyeBtn.setImage(UIImage(named: "View.png"), for: .normal)
        }
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        if(!isValidPassword(testStr: self.passwordTextField.text!)){
            self.popupAlert(title: "RXSling", message: "Password cannot be less than 8 characters, should contain at least one capital letter, one small letter, one number and a special character(@$!%?&#^).", actionTitles: ["Ok"], actions:[{action in},nil])
            return
        }else if (confirmNewPswd.text! !=  passwordTextField.text!){
            self.popupAlert(title: "RXSling", message: "Passwords did not match.", actionTitles: ["Ok"], actions:[{action in},nil])
        }else{
            self.changeTapped()
        }

    }
    func changeTapped(){
        DispatchQueue.main.async {
            showActivityIndicator(View: self.view, "Changing password. Please wait...")
        }

        _=HTTPRequest.sharedInstance.request(url: Constants.Api.forgotPasswordUrl, method: "POST", params: ["emailId":self.email!.trimmingCharacters(in: .whitespacesAndNewlines),"pin":"\(passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))"], header: "", completion: { (response, error) in
            guard let resultData = response else{ return }
            if error != nil
            {
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                }
            }
            else{
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                }
                if(resultData["statusCode"] as! String == "100")
                {
                    self.popupAlert(title: "RXSling", message: "Your password has been changed successfully. Tap LOGIN to continue.", actionTitles: ["LOGIN"], actions:[{action in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        },nil])
                }else{
                    self.popupAlert(title: "RXSling", message: "\(resultData["message"]!)", actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if(!isValidPassword(testStr: self.passwordTextField.text!)){
                self.popupAlert(title: "RXSling", message: "Password cannot be less than 8 characters, should contain at least one capital letter, one small letter, one number and a special character(@$!%?&#^).", actionTitles: ["Ok"], actions:[{action in},nil])
            }else if (confirmNewPswd.text! !=  passwordTextField.text!){
                self.popupAlert(title: "RXSling", message: "Passwords did not match.", actionTitles: ["Ok"], actions:[{action in},nil])
            }else{
                self.changeTapped()
            }
        }
        // Do not add a line break
        return true
    }
}
