//
//  RegistrationViewController.swift
//  RXSling
//
//  Created by Divakara Y N. on 24/03/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import DropDown

// MARK: - RegistrationModel
struct RegistrationModel: Codable {
    let data: RegisterationDataClass!
    let message, statusCode: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message = "message"
        case data = "data"
    }
    // MARK: - RegisterationDataClass
    struct RegisterationDataClass: Codable {
        let id, token: String?
    }
}



class RegistrationViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var firstNameTextfield: TextField!
    @IBOutlet weak var lastNameTextfield: TextField!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var pinTextfield: TextField!
    @IBOutlet weak var pinEyeBtn: UIButton!
    @IBOutlet weak var confirmPinTextfield: TextField!
    @IBOutlet weak var confirmPinEyeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var slingImage: UIImageView!
    @IBOutlet weak var emailLabel: PaddingLabel!
    @IBOutlet weak var mobileNoLabel: PaddingLabel!
    @IBOutlet weak var genderLabel: PaddingLabel!
    
    var imagePicker: ImagePicker!
    var mobileNumber:String?
    var dropDown = DropDown()
    var emailId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        //print("Phone Number -> \(self.mobileNumber!)")
        if UIDevice.current.userInterfaceIdiom == .pad {
                   slingImage.frame = CGRect(x: (self.view.frame.width - slingImage.frame.size.width*2)/2, y: self.view.frame.width/9, width: slingImage.frame.size.width*2, height: slingImage.frame.size.height*2)
                         }
        self.mobileNoLabel.text = self.mobileNumber!
        self.emailLabel.text = self.emailId
        self.dropDownBtn.addTarget(self, action: #selector(self.dropdownTapped(sender:)), for: .touchUpInside)
        self.createDropDown()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self // This is not required
        self.termsLabel.addGestureRecognizer(tap)
        self.termsLabel.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
    // handling code
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Terms_ConditionsView") as!  Terms_ConditionsView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dropdownTapped(sender: UIButton!){
        if(sender.isSelected){
            dropDown.hide()
        }else{
            dropDown.show()
        }
    }
    
    func createDropDown(){
        dropDown.dataSource = ["Male","Female"]
        dropDown.direction = .top
        dropDown.anchorView = self.genderLabel
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderLabel.text = item
            if index == 1{
                self.genderLabel.tag = 0
            }else{
                self.genderLabel.tag = 1
            }
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "BY TAPPING 'SIGN UP', I AGREE TO THE  TERMS AND CONDITIONS.".localizedString(), attributes: underlineAttribute)
        termsLabel.attributedText = underlineAttributedString
        //self.navigationTitle.text = "SIGN UP"
        self.signUpBtn.setTitle("SIGN UP".localizedString(), for: .normal)
        self.cancelBtn.setTitle("CANCEL".localizedString(), for: .normal)
    }
    
    @IBAction func pinEyeBtnTapped(_ sender: Any) {
        pinTextfield.isSecureTextEntry = !pinTextfield.isSecureTextEntry
        if(self.pinTextfield.isSecureTextEntry){
            self.pinEyeBtn.setImage(UIImage(named: "eye.png"), for: .normal)
        }else{
            self.pinEyeBtn.setImage(UIImage(named: "View.png"), for: .normal)
        }
    }
    
    @IBAction func confirmPinEyeBtnTapped(_ sender: Any) {
        confirmPinTextfield.isSecureTextEntry = !confirmPinTextfield.isSecureTextEntry
        if(self.confirmPinTextfield.isSecureTextEntry){
            self.confirmPinEyeBtn.setImage(UIImage(named: "eye.png"), for: .normal)
        }else{
            self.confirmPinEyeBtn.setImage(UIImage(named: "View.png"), for: .normal)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.popupAlert(title: "RXSling", message: "Do you want to cancel the registration process?".localizedString(), actionTitles: ["No","Yes".localizedString()], actions:[{action1 in},{action2 in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
            },nil])
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        if (!networkConnection!)
        {
            self.popupAlert(title: "RXSling", message: "Please check your internet connection".localizedString(), actionTitles: ["Ok"], actions:[{action1 in
                }, nil])
        }else{
            if(self.firstNameTextfield.text?.count == 0 || self.firstNameTextfield.text!.trimmingCharacters(in: .whitespaces).count == 0){
                self.popupAlert(title: "Error", message: "Enter your first name".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else if(self.lastNameTextfield.text?.count == 0 || self.lastNameTextfield.text!.trimmingCharacters(in: .whitespaces).count == 0){
                self.popupAlert(title: "Error", message: "Enter your last name".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else if(self.emailLabel.text?.count == 0 || self.emailLabel.text == "" || !isValidEmail(testStr: emailLabel.text!)){
                self.popupAlert(title: "Error", message: "Enter a valid mail id".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else if self.genderLabel.text == "Gender"{
                self.popupAlert(title: "Error", message: "Select the gender.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else if(self.pinTextfield.text?.count == 0 || self.pinTextfield.text == ""){
                self.popupAlert(title: "Error", message: "Please enter the Password.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else if(!isValidPassword(testStr: self.pinTextfield.text ?? "")){
                self.popupAlert(title: "Error", message: "Password cannot be less than 8 characters, should contain at least one capital letter, one small letter, one number and a special character(@$!%?&#^).".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else if(self.confirmPinTextfield.text?.count == 0 || self.confirmPinTextfield.text == ""){
                self.popupAlert(title: "Error", message: "Please enter the Password.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else if((self.confirmPinTextfield.text?.count)! <= 7 || self.confirmPinTextfield.text == ""){
                self.popupAlert(title: "Error", message: "Password cannot be less then 8 characters.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else if(pinTextfield.text! != confirmPinTextfield.text){
                self.popupAlert(title: "RXSling", message: "Passwords did not match.".localizedString(), actionTitles: ["Ok"], actions:[{action in},nil])
            }else{
                DispatchQueue.main.async {
                    showActivityIndicator(View: self.view, "Registering user please wait.")
                }
                registrationCall(genderCount: self.genderLabel.tag)
            }
        }
    }
    
    func registrationCall(genderCount:Int){
        self.hideKeyboard()
        let pushId = UserDefaults.standard.string(forKey: "PUSH_ID")
        print("Push ID -> \(pushId ?? "")")
        let params = ["firstName":"\(firstNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines))","lastName":"\(lastNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines))","emailId":"\(emailLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines))","mobileNo":"\(self.mobileNoLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines))","gender":"\(genderCount)","pin":"\(pinTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines))","pushId":pushId ?? ""]
        print(params)
        var paramsData : NSData = NSData()
        var paramString : NSString = ""
        do
        {
            paramsData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            paramString = NSString(data: paramsData as Data, encoding: String.Encoding.utf8.rawValue)!
        }
        catch
        {
            print("error")
        }
        _ = HTTPRequest.sharedInstance.request(url: Constants.Api.registrationUrl, method: "POST", params: params, header: "", completion: { (response, error) in
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
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                }
                if(responseData.statusCode == "100")
                {
                    USERDEFAULTS.set("\(responseData.data?.token! ?? "")", forKey: "TOKEN")
                    UserDefaults.standard.set(true, forKey: "ISLOGIN")
                    self.popupAlert(title: "RXSling", message: "You have been registered successfully. Tap PROCEED to continue.", actionTitles: ["proceed"], actions:[{action in
                        
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! ViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        
                        },nil])
                }else{
                    self.popupAlert(title: "RXSling", message: "Unable to proceed due to network error. Please try after some time.", actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }
        })
    }
    func hideKeyboard(){
        self.view.endEditing(true)
        self.view.frame.origin.y = 0
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
    
}


extension RegistrationViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        print("Image Selected")
        ////self.profileImgBtn.setImage(image, for: .normal)
        /*UserDefaults.standard.set(image?.pngData(), forKey: "profilepic")
        ProfilePic.sharedInstance.uploadProflePic(viewController: self, view: self.view, urlTOUpLoad: NSURL(string: BASEURL+UPDATEPROFILEPIC)! as URL, parameters: [:]) { (response, error) in
            let responseCode = response?["code"] as! Int
            //
            if(responseCode == 100){
                self.popupAlert(title: LanguageManager.sharedInstance.LocalizedLanguage(key: "my_show_and_tell"), message: LanguageManager.sharedInstance.LocalizedLanguage(key: "profile_pic_updated"), actionTitles: [LanguageManager.sharedInstance.LocalizedLanguage(key: "ok")], actions: [{action in},nil])
                self.removePhoto.isHidden = false
                self.profilePicImage.image = image
            }
        }*/
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag > 1){
            self.view.frame.origin.y = -120
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
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
        }
        // Do not add a line break
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0
        {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if(newString.length <= 25){
                self.firstNameTextfield.text = textField.text!
            }else{
                textField.resignFirstResponder();
                self.popupAlert(title: "RXSling", message: "Should not contain more than 25 characters.", actionTitles: ["Ok"], actions:[{action in}])
            }
            return newString.length <= 25
        }else if textField.tag == 1{
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if(newString.length <= 25){
                self.lastNameTextfield.text = textField.text!
            }else{
                textField.resignFirstResponder();
                self.popupAlert(title: "RXSling", message: "Should not contain more than 25 characters.", actionTitles: ["Ok"], actions:[{action in}])
            }
            return newString.length <= 25
        }else if textField.tag == 2{
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            //if(newString.length <= 8){
                self.pinTextfield.text = textField.text!
            //}else{
                //textField.resignFirstResponder();
                //self.popupAlert(title: "RXSling", message: "Password cannot be less than 8 characters.", actionTitles: ["Ok"], actions:[{action in}])
           // }
            return true
        }else if textField.tag == 3{
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            //if(newString.length <= 8){
                self.confirmPinTextfield.text = textField.text!
            //}else{
                //textField.resignFirstResponder();
                //self.popupAlert(title: "RXSling", message: "Password cannot be less than 8 characters.", actionTitles: ["Ok"], actions:[{action in}])
            //}
            return true
        }
        return true
    }
    
}


extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
        self.layer.borderWidth = 1.25
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 12
        
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
