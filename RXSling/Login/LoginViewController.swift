//
//  LoginViewController.swift
//  RXSling
//
//  Created by Divakara Y N. on 23/03/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import NKVPhonePicker
import FirebaseCrashlytics

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userIdTextfield: TextField!
    @IBOutlet weak var pinTextfield: TextField!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var slingImage: UIImageView!
    
    var versionManager = VersionMannager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
   //     NotificationCenter.default.addObserver(self, selector: #selector(checkForVersionUpdate(notification:)), name: NSNotification.Name(rawValue: "VersionObjectDownloaded"), object: nil)

        
        if UIDevice.current.userInterfaceIdiom == .pad {
                   slingImage.frame = CGRect(x: (self.view.frame.width - slingImage.frame.size.width*2)/2, y: self.view.frame.width/7, width: slingImage.frame.size.width*2, height: slingImage.frame.size.height*2)
                         }

        eyeBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        
//        userIdTextfield.text = "sunilkumar.gc@rxprism.com"
//        pinTextfield.text = "12345678"

        userIdTextfield.delegate = self
        pinTextfield.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
            navigationController?.navigationBar.barTintColor = UIColor.clear
            self.navigationController?.navigationBar.tintColor = GREENCOLOUR//UIColor.white
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        showBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.navigationBar.isHidden = true
           // Version Checking
//            if let _ = versionManager.versionMannagedObj {
//                versionManager.checkForVersionUpdate()
//            }
       }
    
//       @objc func checkForVersionUpdate(notification: NSNotification) {
//           versionManager.checkForVersionUpdate()
//       }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "VersionObjectDownloaded"), object: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.view.frame.origin.y = 0
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        login()
    }


    func login(){
        if(userIdTextfield.text?.count == 0 || userIdTextfield.text == "" || !isValidEmail(testStr: userIdTextfield.text!)){
            self.popupAlert(title: "RXSling", message: "Enter a valid email ID.", actionTitles: ["Ok"], actions:[{action in},nil])
        }
        else if((pinTextfield.text?.count)! <= 7 || pinTextfield.text == ""){
            self.popupAlert(title: "RXSling", message: "Password cannot be less than 8 characters.", actionTitles: ["Ok"], actions:[{action in},nil])
        }else{
            self.view.frame.origin.y = 0
            self.view.endEditing(true)

            let networkConnection = try! Reachability.init()?.isConnectedToNetwork
            if (!networkConnection!)
            {
                self.popupAlert(title: "RXSling", message: "Please check your internet connection", actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
            }else{

                DispatchQueue.main.async {
                    showActivityIndicator(View: self.view, "Logging in. Please wait...")

                }
                let pushId = UserDefaults.standard.string(forKey: "PUSH_ID")
                print("Push ID -> \(pushId ?? "")")
                let deviceId = UserDefaults.standard.string(forKey: "DEVICE_ID")
                print("Device ID -> \(deviceId ?? "")")
                let params :[String:String] = ["username":"\(userIdTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines))","pin":"\(pinTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines))","pushId":pushId ?? "","platform":"ios","deviceId":deviceId ?? "","appVersion":getAppVersion(),"deviceInfo":"\(UIDevice.modelName) : Apple","osVersion":"ios \(UIDevice.current.systemVersion)"]
                print("PARAMS -> \(params)")
                _ = HTTPRequest.sharedInstance.request(url: Constants.Api.loginUrl, method: "POST", params: params, header: "") { (response, error) in
                    if error != nil
                    {
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(false, forKey: "ISLOGIN")
                            hideActivityIndicator(View: self.view)
                            self.popupAlert(title: "RXSling", message: "Please check your internet connection", actionTitles: ["Ok"], actions:[{action in},nil])
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                        }
                        print("RESULT DATA --> \(response!)")

                        let jsonData = try! JSONSerialization.data(withJSONObject: response!, options:.prettyPrinted)
                        let response = try! JSONDecoder().decode(ProfileDataModel.self, from: jsonData)
                        print("JSON DATA -> \(response)")
                        if(response.statusCode == "100")
                        {
                            DispatchQueue.main.async {

                                guard let data = response.data else {return}

                                UserDefaults.standard.set(true, forKey: "ISLOGIN")
                                USERDEFAULTS.set((data.token), forKey: "TOKEN")
                                USERDEFAULTS.set((data.orgId), forKey: "orgId")
                                USERDEFAULTS.set((data.userInfo.emailID), forKey: "USER_EMAIL")
                                USERDEFAULTS.set((data.userInfo.mobileNo), forKey: "USER_MOBILE")
                                USERDEFAULTS.set((data.userInfo.profilePicURL), forKey: "USER_PROFILE_PIC")
                                USERDEFAULTS.set((data.displayIbutton), forKey: "USER_DISPLAY_IB_BUTTON")
                                USERDEFAULTS.set((data.userInfo.selfReport), forKey: "USER_SELFREPORT")
                                
                                USERDEFAULTS.set(jsonData, forKey: "LOGIN_DATA")
                                hideActivityIndicator(View: self.view)
                                self.showHomeScreen()
                            }

                        }else if(response.statusCode == "101"){
                            self.popupAlert(title: "RXSling", message: "Invalid credentials.", actionTitles: ["Ok"], actions:[{action in},nil])
                        }else if(response.statusCode == "102" || response.statusCode == "104"){
                            self.popupAlert(title: "RXSling", message: "User doesn't exists.", actionTitles: ["Ok"], actions:[{action in},nil])
                        }else{
                            self.popupAlert(title: "RXSling", message: "User exists but not registered. Please register and then login.", actionTitles: ["Ok"], actions:[{action in},nil])
                        }
                    }
                }
            }
        }
    }

    func showHomeScreen(){
        hideBarBUttomItem()
        if(USERDEFAULTS.bool(forKey: "isFirstLogin")){//for first time it returns false.
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            isFirstTimeLogin = true
            USERDEFAULTS.set(true, forKey: "isFirstLogin")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC") as! HelpViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
         print("textFieldShouldReturn")
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
            if(nextField.tag > 1){
                self.view.frame.origin.y = -120
            }

        } else {
            // Not found, so remove keyboard.
            self.view.frame.origin.y = 0
            textField.resignFirstResponder()
            self.login()
        }
        // Do not add a line break
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UIDevice.current.userInterfaceIdiom == .pad {
         self.view.frame.origin.y = -170
        } else {
        self.view.frame.origin.y = -120
        }
        print("textFieldDidBeginEditing")
    }

    @IBAction func eyeButtonClicked(_ sender: Any) {
        pinTextfield.isSecureTextEntry = !pinTextfield.isSecureTextEntry
        if(pinTextfield.isSecureTextEntry){
            self.eyeBtn.setImage(UIImage(named: "eye.png"), for: .normal)
        }else{
            self.eyeBtn.setImage(UIImage(named: "View.png"), for: .normal)
        }
    }

    @IBAction func registrationBtnTapped(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func forgotPinTapped(_ sender: Any) {
        self.view.endEditing(true)

    }
}

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (index, title) in actionTitles.enumerated() {
                let action = UIAlertAction(title: title, style: .default, handler: actions[index])
                action.setValue(GREENCOLOUR, forKey: "titleTextColor")
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}

