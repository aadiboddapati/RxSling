//
//  ProfileViewController.swift
//  ParrotNote
//
//  Created by Vinod Kumar on 22/01/19.
//  Copyright © 2019 Vinod Kumar. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - ProfileDataModel
struct ProfileDataModel: Codable {
    var data: DataModel?
    let message, statusCode: String?
}

// MARK: - DataClass
struct DataModel: Codable {
    let config: [ProfileConfig]
    let displayIbutton, isAutoConsent: Bool
    let settings: Settings?
    let token: String
    let orgId:String?
    var userInfo: ProfileUserInfo
}

// MARK: - Config
struct ProfileConfig: Codable {
    let enabled: Bool
    let type: String
}

// MARK: - Settings
struct Settings: Codable {

    //TODO: Remove below keys - NOT
    let cookieLink: String
    let isCentralSMS: Bool?
    let isAnonymousDoctorNumber, isCentralSMSGateway, isCentralWhatsappGateway: Bool
    let isCentralizedContact: Bool
    let isContactListRefreshHrs: Int
    let isCustomCookie, isEnableDynamicTags, isEnableStaticTags, isScrambleCustomerNumber: Bool
    let isTokenExpiry, isTrackCity, isTrackIP, isTrackLatandLong: Bool
    let isWhiteLabel: Bool
    let noOfDaysforToken: Int
    let timezone: String
}

// MARK: - UserInfo
struct ProfileUserInfo: Codable {
    let emailID: String
    var firstName: String?
    let gender: Int
    var lastName, mobileNo: String?
    let profilePicURL: String
    let selfReport: Bool
    let clusterReport:Bool
    let teamReport:Bool
    
    enum CodingKeys: String, CodingKey {
        case emailID = "emailId"
        case firstName = "firstName"
        case gender = "gender"
        case lastName = "lastName"
        case mobileNo = "mobileNo"
        case profilePicURL = "profilePicUrl"
        case selfReport = "selfReport"
        case clusterReport = "clusterReport"
        case teamReport = "teamReport"
    }
}


class ProfileViewController: UIViewController,UITextFieldDelegate {
    var imagePicker: ImagePicker!
    @IBOutlet weak var profilePicImage: UIImageView!
    //@IBOutlet weak var loginImage: UIImageView!
    //@IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var resetPswdBtn: UIButton!
    @IBOutlet weak var lNameBtn: UIButton!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var mobileNumberTextField: TextField!
    @IBOutlet weak var emailIDBtn: UIButton!
    @IBOutlet weak var emailIDTextField: TextField!
    @IBOutlet weak var fNameBtn: UIButton!
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var removePhoto: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var famaleLabel: UILabel!
    
    var backButton : UIBarButtonItem!
    var selectedGender: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileDetails()
        getUserInfo()
        self.resetPswdBtn.addTarget(self, action: #selector(self.self.resetTapped(_:)), for: .touchUpInside)
        self.resetPswdBtn.isHidden = true
        self.maleBtn.isUserInteractionEnabled = false
        self.femaleBtn.isUserInteractionEnabled = false
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height-150)
        
        self.navigationItem.title = "PROFILE SETTINGS".localizedString()
        self.navigationController?.navigationBar.isHidden = false
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        let viewFN = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        viewFN.backgroundColor = UIColor.clear
        viewFN.tintColor = GREENCOLOUR
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button1.setTitle("EDIT".localizedString(), for: .normal)
        button1.setTitleColor(GREENCOLOUR, for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button1.addTarget(self, action: #selector(self.editTapped), for: UIControl.Event.touchUpInside)
        viewFN.addSubview(button1)
        let rightBarButton = UIBarButtonItem(customView: viewFN)
        self.navigationItem.rightBarButtonItem = rightBarButton
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.profilePicImage.layer.borderColor = UIColor.lightGray.cgColor
        self.profilePicImage.layer.borderWidth = 2
        self.profilePicImage.layer.cornerRadius = self.profilePicImage.frame.width/2
        self.profilePicImage.layer.masksToBounds = true
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        scrollView.isScrollEnabled = false
        mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: "Enter Mobile Number",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailIDTextField.attributedPlaceholder = NSAttributedString(string: "Emter Email ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.navigationController?.navigationBar.tintColor = GREENCOLOUR
        self.navigationItem.rightBarButtonItem?.tintColor = GREENCOLOUR
        UITextView.appearance().tintColor = UIColor.white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        self.firstNameTextField.borderColor = UIColor.lightGray
        self.lastNameTextField.borderColor = UIColor.lightGray
        self.firstNameTextField.textColor = UIColor.lightGray
        self.lastNameTextField.textColor = UIColor.lightGray
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        maleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
        femaleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
        maleBtn.setTitle("Male".localizedString(), for: .normal)
        femaleBtn.setTitle("Female".localizedString(), for: .normal)
        self.fNameBtn.setTitle("First Name".localizedString(), for: .normal)
        self.firstNameTextField.placeHolderText = "Enter First Name".localizedString()
        self.lNameBtn.setTitle("Last Name".localizedString(), for: .normal)
        self.lastNameTextField.placeHolderText = "Enter Last Name".localizedString()
        self.mobileBtn.setTitle("Mobile Number".localizedString(), for: .normal)
        //self.mobileNumberTextField.placeHolderText = LanguageManager.sharedInstance.LocalizedLanguage(key: "")
        self.emailIDBtn.setTitle("Email ID".localizedString(), for: .normal)
        //self.emailIDTextField.placeHolderText = LanguageManager.sharedInstance.LocalizedLanguage(key: "")
        self.resetPswdBtn.setTitle("RESET PASSWORD".localizedString(), for: .normal)
        self.cancelButton.setTitle("CANCEL".localizedString(), for: .normal)
        self.updateButton.setTitle("SAVE".localizedString(), for: .normal)
        self.removePhoto.setTitle("Remove Photo".localizedString(), for: .normal)
        genderButton.setTitle("Gender".localizedString(), for: .normal)
                  maleLabel.text = "Male".localizedString()
                  famaleLabel.text = "Female".localizedString()
        self.navigationController?.navigationBar.isHidden = false
    }
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        
        maleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
        femaleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
        self.selectedGender = 1
    }
    
    @IBAction func femaleBtnTapped(_ sender: Any) {
        maleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
        femaleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
        self.selectedGender = 0
    }
    
    @objc func editTapped(sender: UIButton!) {
        
        self.initUI()
        let userProfilePic = ("\(USERDEFAULTS.value(forKey: "USER_PROFILE_PIC") ?? "")")
        if userProfilePic != ""{
            self.removePhoto.isHidden = !removePhoto.isHidden
        }else{
            self.removePhoto.isHidden = true
        }
        
        self.resetPswdBtn.isHidden = !resetPswdBtn.isHidden
        if(!cancelButton.isHidden){
            if(UIScreen.main.bounds.height <= 568){
                scrollView.isScrollEnabled = true
            }
            self.firstNameTextField.isUserInteractionEnabled = true
            self.lastNameTextField.isUserInteractionEnabled = true
            self.firstNameTextField.borderColor = UIColor.white
            self.lastNameTextField.borderColor = UIColor.white
            self.firstNameTextField.textColor = UIColor.white
            self.lastNameTextField.textColor = UIColor.white
            self.profilePicImage.layer.borderColor = UIColor.white.cgColor
        }else{
            self.firstNameTextField.isUserInteractionEnabled = false
            self.lastNameTextField.isUserInteractionEnabled = false
            self.firstNameTextField.borderColor = UIColor.lightGray
            self.lastNameTextField.borderColor = UIColor.lightGray
            self.firstNameTextField.textColor = UIColor.lightGray
            self.lastNameTextField.textColor = UIColor.lightGray
            self.profilePicImage.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }
    func initUI(){
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        self.cancelButton.isHidden = !cancelButton.isHidden
        self.plusButton.isHidden = !plusButton.isHidden
        self.updateButton.isHidden = !self.updateButton.isHidden
        
        
        if(UIScreen.main.bounds.height <= 812){
            self.scrollView.isScrollEnabled = !self.scrollView.isScrollEnabled
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0
        {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if(newString.length <= 25){
                self.firstNameTextField.text =  textField.text
            }else{
                textField.resignFirstResponder();
                self.popupAlert(title: "RXSling", message: "Should not contain more than 25 characters", actionTitles: ["Ok"], actions:[{action in}])
            }
            return newString.length <= 25
        }else if textField.tag == 1{
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if(newString.length <= 25){
                self.lastNameTextField.text = textField.text
            }else{
                textField.resignFirstResponder();
                self.popupAlert(title: "RXSling", message: "Should not contain more than 25 characters", actionTitles: ["Ok"], actions:[{action in}])
            }
            return newString.length <= 25
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
            if(nextField.tag > 1){
                self.view.frame.origin.y = -90
            }
        } else {
            // Not found, so remove keyboard.
            self.view.frame.origin.y = 0
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    @IBAction func changeProfileTapped(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    
    @IBAction func resetTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassword") as! ResetPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        initUI()
        self.firstNameTextField.isUserInteractionEnabled = false
        self.lastNameTextField.isUserInteractionEnabled = false
    }
    
    @IBAction func removePhotoClicked(_ sender: Any) {
        self.popupAlert(title: "RXSling", message: "Are you sure you want to remove your profile picture?", actionTitles: ["NO","YES"], actions:[{action1 in},{action2 in
            ProfilePic.sharedInstance.uploadProfilePictToServer(api: Constants.Api.removeProfilePic,viewController: self, params:[:], modelType: ProfilePicModel.self, completion: {[weak self]             (data,err) in
                
                if let err = err {
                    print("Failed to fetch data:", err)
                    return
                }
                
                if(data.statusCode == "106"){
                    Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired.localizedString(), alertButtons: 1, buttonTitle:"Ok", inView: self!) { (tapVal) in
                        self!.tokenExpiredLogout()
                    }
                }else if(data.statusCode == "100"){
                    
                    if let data = data.data{
                        print(data)
                        
                        
                        USERDEFAULTS.removeObject(forKey: "USER_PROFILE_PIC")
                        
                        self!.popupAlert(title: "RXSling", message: "Your profile picture has been removed successfully.", actionTitles: ["Ok"], actions: [{action in},nil])
                        DispatchQueue.main.async {
                            if let url  = URL(string: (data.profilePic)){
                                self!.profilePicImage.load(url: url)
                            }else{
                                DispatchQueue.main.async {
                                    self?.removePhoto.isHidden = true
                                }
                                self!.profilePicImage.image = UIImage(named: "user_image.png")
                            }
                        }
                    }
                }else{
                    self!.popupAlert(title: "RXSling", message: "Unable to proceed due to network error. Please try after some time.", actionTitles: ["Ok"], actions: [{action in},nil])
                }
            })
            },nil])
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        if (!networkConnection!)
        {
            self.popupAlert(title: "RXSling", message: "Please check your internet connection", actionTitles: ["Ok"], actions:[{action1 in
                }, nil])
        }else{
            if(self.firstNameTextField.text?.count == 0 || self.firstNameTextField.text!.trimmingCharacters(in: .whitespaces).count == 0){
                self.popupAlert(title: "Error", message: "Enter the first name", actionTitles: ["Ok"], actions:[{action in},nil])
            }else if(self.lastNameTextField.text?.count == 0 || self.lastNameTextField.text!.trimmingCharacters(in: .whitespaces).count == 0){
                self.popupAlert(title: "Error", message: "Enter the last name", actionTitles: ["Ok"], actions:[{action in},nil])
            }else{
                DispatchQueue.main.async {
                    showActivityIndicator(View: self.view, "Updating your info. Please wait...")
                }
                updateProfileInfo()
            }
        }
    }
    
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    
    func convertBase64ToImage(_ str: String) -> UIImage {
        let dataDecoded : Data = Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        return decodedimage!
    }
    
    func updateProfileInfo(){
        let pushId = UserDefaults.standard.string(forKey: "PUSH_ID")
        print("Push ID -> \(pushId ?? "")")
        let params = ["firstName":"\(self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))","lastName":"\(lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))","emailId":"\(emailIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))","mobileNo":"\(self.mobileNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))","gender":"\(self.selectedGender ?? 1)","pushId":pushId ?? "","platform":"ios"]
        print(params)
        var paramsData : NSData = NSData()
        var paramString : NSString = ""
        let token = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        do
        {
            paramsData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            paramString = NSString(data: paramsData as Data, encoding: String.Encoding.utf8.rawValue)!
        }
        catch
        {
            print("error")
        }
        _ = HTTPRequest.sharedInstance.request(url: Constants.Api.updateProfileInfoUrl, method: "POST", params: params, header: token, completion: { (response, error) in
            guard let resultData = response else{ return }
            let jsonData = try! JSONSerialization.data(withJSONObject: resultData, options: [])
            let responseData = try! JSONDecoder().decode(RegistrationModel.self, from: jsonData)
            print(responseData)
            if error != nil
            {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(false, forKey: "ISLOGIN")
                    hideActivityIndicator(View: self.view)
                }
            }
            else{
                if let loginData = UserDefaults.standard.object(forKey: "LOGIN_DATA") as? Data {
                    if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: loginData) {
                        var newModel :ProfileDataModel?
                        if(response.statusCode == "100"){
                            //guard let data = response.data else {return}
                            DispatchQueue.main.async {
                                newModel = response
                                newModel?.data?.userInfo.firstName = self.firstNameTextField.text!
                                newModel?.data?.userInfo.lastName = self.lastNameTextField.text!
                                if let encoded = try? JSONEncoder().encode(newModel) {
                                    if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: encoded) {
                                        print("Response After Update -> \(response.data.debugDescription)")
                                    }
                                    UserDefaults.standard.set(encoded, forKey: "LOGIN_DATA")
                                }
                            }
                            
                            
                        }
                    }
                }
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                }
                if(responseData.statusCode == "100")
                {
                    USERDEFAULTS.set("\(responseData.data?.token! ?? "")", forKey: "TOKEN")
                    UserDefaults.standard.set(true, forKey: "ISLOGIN")
                    DispatchQueue.main.async {
                        showToast(message: "Profile details updated successfully.", view: self.view)
                    }
                }else if(responseData.statusCode == "106"){
                    
                    Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired.localizedString(), alertButtons: 1, buttonTitle:"Ok", inView: self) { (tapVal) in
                        
                        self.tokenExpiredLogout()
                    }
                }else{
                    self.popupAlert(title: "RXSling", message: "Unable to proceed due to network error. Please try after some time.", actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }
        })
    }
    
    func getUserInfo(){
        DispatchQueue.main.async {
            showActivityIndicator(View: self.view, "Refreshing userinfo. Please wait...")
        }
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        if (!networkConnection!)
        {
            DispatchQueue.main.async {
                hideActivityIndicator(View: self.view)
            }
            //            self.popupAlert(title: LanguageManager.sharedInstance.LocalizedLanguage(key: "my_show_and_tell"), message: LanguageManager.sharedInstance.LocalizedLanguage(key: "please_check_internet"), actionTitles: [LanguageManager.sharedInstance.LocalizedLanguage(key: "ok")], actions:[{action1 in
            //                }, nil])
        }else{
            DispatchQueue.main.async {
                hideActivityIndicator(View: self.view)
            }
            _=HTTPRequest.sharedInstance.request(url: Constants.Api.profileUrl, method: "POST", params: [:], header: "\(USERDEFAULTS.value(forKey:"TOKEN")!)", completion: { (response, error) in
                guard let resultData = response else{ return }
                print("UserInfo -> \(resultData.description)")
                let jsonData = try! JSONSerialization.data(withJSONObject: resultData, options: [])
                let responseData = try! JSONDecoder().decode(ProfileDataModel.self, from: jsonData)
                if error != nil
                {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(false, forKey: "ISLOGIN")
                        hideActivityIndicator(View: self.view)
                    }
                }
                else{
                    if(responseData.statusCode == "100")
                    {
                        
                        // USERDEFAULTS.set(jsonData, forKey: "registrationInfo")
                        let userInfo = try! JSONDecoder().decode(ProfileDataModel.self, from: jsonData)
                        USERDEFAULTS.set(jsonData, forKey: "LOGIN_DATA")
                        
                        DispatchQueue.main.async {
                         
                            self.firstNameTextField.text = userInfo.data?.userInfo.firstName
                            self.lastNameTextField.text = userInfo.data?.userInfo.lastName
                            self.mobileNumberTextField.text = userInfo.data?.userInfo.mobileNo
                            self.emailIDTextField.text = userInfo.data?.userInfo.emailID
                            self.selectedGender = userInfo.data?.userInfo.gender
                            if userInfo.data?.userInfo.gender == 0{
                                
                                self.maleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
                                self.femaleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
                                
                            }else{
                                self.maleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
                                self.femaleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
                            }
                            if let url  = URL(string: (userInfo.data?.userInfo.profilePicURL)!){
                                USERDEFAULTS.set((userInfo.data?.userInfo.profilePicURL)!, forKey: "USER_PROFILE_PIC")
                                
                                self.profilePicImage.load(url: url)
                            }else{
                                self.profilePicImage.image = UIImage(named: "user_image.png")
                            }
                               hideActivityIndicator(View: self.view)
                        }
                    }else if(responseData.statusCode == "106"){
                        
                        Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired.localizedString(), alertButtons: 1, buttonTitle:"Ok", inView: self) { (tapVal) in
                            
                            self.tokenExpiredLogout()
                        }
                    }else{
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                        }
                        self.popupAlert(title: "RXSling", message: "Unable to proceed due to network error. Please try after some time.", actionTitles: ["Ok"], actions:[{action in},nil])
                    }
                }
            })
        }
    }
    
    func jsonString(parameters:[String:AnyObject])->String{
        var paramsData : NSData = NSData()
        var paramString : String = ""
        do
        {
            paramsData = try JSONSerialization.data(withJSONObject: parameters, options: []) as NSData
            paramString = String(data: paramsData as Data, encoding: String.Encoding.utf8)!
        }
        catch
        {
            print("error")
        }
        
        return paramString.replacingOccurrences(of: "\\", with: "")
    }
}

extension ProfileViewController: ImagePickerDelegate {
    
    //MARK: - Token Expired Logout
    private func tokenExpiredLogout(){
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK: - Profile image update API
    func didSelect(image: UIImage?) {
        let base64Str = self.convertImageToBase64(image!)
        //UserDefaults.standard.set(image?.pngData(), forKey: "profilepic")
        
        ProfilePic.sharedInstance.uploadProfilePictToServer(api: Constants.Api.updateProfilePic, viewController: self, params: ["profilePic":"\(base64Str)"], modelType: ProfilePicModel.self, completion: {[weak self] (data,err) in
            
            if let err = err {
                print("Failed to fetch data:", err)
                return
            }
            
            if(data.statusCode == "106"){
                
                Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired.localizedString(), alertButtons: 1, buttonTitle:"Ok", inView: self!) { (tapVal) in
                    
                    self!.tokenExpiredLogout()
                }
            }else{
                
                if let data = data.data{
                    print(data)
                    
                    USERDEFAULTS.set((data.profilePic), forKey: "USER_PROFILE_PIC")
                    
                    self!.popupAlert(title: "RXSling", message: "Profile pic updated successfully", actionTitles: ["Ok"], actions: [{action in},nil])
                    self?.profilePicImage.load(url: URL(string: data.profilePic)!)
                    DispatchQueue.main.async {
                        self?.removePhoto.isHidden = false
                    }
                    
                    
                }
            }
        })
    }
    
    func updateUserDefaultData(newData: ProfilePicDataClass)
    {
        if let loginData = UserDefaults.standard.object(forKey: "LOGIN_DATA") as? Data {
            if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: loginData) {
                if(response.statusCode == "100"){
                    
                    guard let data = response.data else {return}
                    
                    
                    
                }
            }
        }
    }
}



extension ProfileViewController{
    
    func updateProfileDetails(){
        
        if let loginData = UserDefaults.standard.object(forKey: "LOGIN_DATA") as? Data {
            if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: loginData) {
                if(response.statusCode == "100"){
                    
                    guard let data = response.data else {return}
                    
                    
                    print(data.config)
                    
                    self.emailIDTextField.text = data.userInfo.emailID
                    self.firstNameTextField.text = data.userInfo.firstName
                    self.lastNameTextField.text = data.userInfo.lastName
                    self.mobileNumberTextField.text = data.userInfo.mobileNo
                    if data.userInfo.gender == 0{
                        
                        self.maleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
                        self.femaleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
                    }else{
                        
                        self.maleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
                        self.femaleBtn.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
                    }
                    if let url  = URL(string: (data.userInfo.profilePicURL)){
                        
                        USERDEFAULTS.set((data.userInfo.profilePicURL), forKey: "USER_PROFILE_PIC")
                        self.profilePicImage.load(url: url)
                        
                        
                    }else{
                        self.profilePicImage.image = UIImage(named: "user_image.png")
                    }
                }
            }
        }
        
        
    }
}
