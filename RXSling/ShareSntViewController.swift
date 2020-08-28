//
//  ShareSntViewController.swift
//  RXSling
//
//  Created by Manish Ranjan on 27/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import PhoneNumberKit


class ShareSntViewController: UIViewController {
    
    //MARK: - IBOutlets and properties
    
    @IBOutlet weak var contentDashBoardLabel: UILabel!
    @IBOutlet weak var addCustomerLabel: UILabel!
    @IBOutlet weak var selectMobileNumberLabel: UILabel!
    @IBOutlet weak var addWelcomeMSGLabel:UILabel!
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var scollerContentView:UIView!
    @IBOutlet weak var totalStack: UIStackView!
    @IBOutlet weak var sharedStack: UIStackView!
    @IBOutlet weak var availableStack: UIStackView!
    @IBOutlet weak var validateStack: UIStackView!
    //Card One
    @IBOutlet weak var totallbl:UILabel!
    @IBOutlet weak var totalLabel:UILabel!
    @IBOutlet weak var sharedbl:UILabel!
    @IBOutlet weak var sharedLabel:UILabel!
    @IBOutlet weak var avilablelbl:UILabel!
    @IBOutlet weak var availableLabel:UILabel!
    
    //Card Two
    @IBOutlet weak var sntTopBlurView:UIView!
    @IBOutlet weak var sntImage:UIImageView!
    @IBOutlet weak var sntHrsAgoLabel:UILabel!
    @IBOutlet weak var sntTitleLabel:UILabel!
    @IBOutlet weak var sntDescriptionLabel:UILabel!
    @IBOutlet weak var sntCreatedbyLabel:UILabel!
    
    //Card Three
    @IBOutlet weak var doctorInfoView:UIView!
    @IBOutlet weak var doctorNameLabel:UILabel!
    @IBOutlet weak var doctorMobileLabel:UILabel!
    @IBOutlet weak var NameLabel:UILabel!
    @IBOutlet weak var MobileLabel:UILabel!
    @IBOutlet weak var selectPhoneNumLabel:UILabel!
    @IBOutlet weak var selectPhoneNumButton:UIButton!
    @IBOutlet weak var cancelDoctorInfoButton:UIButton!
    
    //Card Four
    @IBOutlet weak var verticalLine2:UIView!
    @IBOutlet weak var twoRoundLabel: UILabel!
    @IBOutlet weak var verticalLine3:UIView!
    @IBOutlet weak var cardFour:UIView!
    @IBOutlet weak var yesButton:UIButton!
    @IBOutlet weak var noButton:UIButton!
    @IBOutlet weak var welcomeMessageStaticLabel:UILabel!
    @IBOutlet weak var welcomeMessage:UITextView!
    ///@IBOutlet weak var welcomeMessageTextfield: UITextField!
    @IBOutlet weak var pencilButton:UIButton!
    @IBOutlet weak var welcomeMessageMaxLenLabel:UILabel!
    @IBOutlet weak var doYouWantToAddWelcomeMessageStaticLabel:UILabel!
    @IBOutlet weak var staticNotAddedLabel:UILabel!
    
    //proceed preview and share button
    @IBOutlet weak var proceedButton:UIButton!
    @IBOutlet weak var previewButton:UIButton!
    @IBOutlet weak var shareButton:UIButton!
    
    @IBOutlet weak var anotherProceedButton:UIButton!
    @IBOutlet weak var anotherPreviewButton:UIButton!
    @IBOutlet weak var anotherShareButton:UIButton!
    
    @IBOutlet weak var cardThreeHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var selectPhoneNumberHeightConstraint: NSLayoutConstraint!
    
    // @IBOutlet weak var proceedButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardFourHeightConstraint: NSLayoutConstraint!
    
    //@IBOutlet weak var proceedShareStackHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var staticWelcomMessageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pencilHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var staticNotAddedHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollerContentViewHeightConstraint: NSLayoutConstraint!
    //label
    
    
    var snt: SNTData?
    var shareCountModel: ShareCountModel?
    var availableShareCount:Int = 0
    var isDocInfoValidated: Bool = false
    var isDocInfoShown: Bool = false
    var doctor: Doctor?
    var shortenUrlData: ShortenData?
    
    var addWelcomeMessageBool:Bool = false
    
    var centralContactList: CentralContactList?
    
    //MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anotherProceedButton.isHidden = true
        anotherPreviewButton.isHidden = true
        anotherShareButton.isHidden = true

        if UIDevice.current.userInterfaceIdiom == .pad {
        scroller.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        scroller.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
        totalStack.widthAnchor.constraint(equalToConstant: 150).isActive = true
        sharedStack.widthAnchor.constraint(equalToConstant: 150).isActive = true
        availableStack.widthAnchor.constraint(equalToConstant: 140).isActive = true
            
            NameLabel.text   = "Customer Name"
            MobileLabel.text = "Customer Mobile"

        }
        
        self.title = "SHARE".localizedString()
        welcomeMessage.delegate = self
        welcomeMessage.text = ""
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scroller.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        print(URL(string: snt!.sntURL)!.lastPathComponent)
        
        displaySntDataOnUI()
        showHideCard4(false)
        scollerContentView.backgroundColor = .clear
        scrollerContentViewHeightConstraint.constant = self.view.frame.size.height + 60

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "SHARE".localizedString()
        contentDashBoardLabel.text = "Content Shared Dashboard".localizedString()
        addCustomerLabel.text = "Add Customer".localizedString()
        selectMobileNumberLabel.text = "Please select customer mobile number to share".localizedString()
        selectPhoneNumLabel.text = "Selected Customer Info".localizedString()
        totallbl.text = "Total".localizedString()
        sharedbl.text = "Shared".localizedString()
        avilablelbl.text = "Available".localizedString()
        selectPhoneNumButton.setTitle("Select Phone Number".localizedString(), for: .normal)
        NameLabel.text   = "Name".localizedString()
        MobileLabel.text = "Mobile".localizedString()
        doYouWantToAddWelcomeMessageStaticLabel.text = "Do you want to add welcome message?".localizedString()
        previewButton.setTitle("Preview".localizedString(), for: .normal)
        proceedButton.setTitle("Proceed".localizedString(), for: .normal)
        shareButton.setTitle("Share".localizedString(), for: .normal)
        addWelcomeMSGLabel.text = "Add welcome message".localizedString()
        welcomeMessageStaticLabel.text = "Welcome message".localizedString()
        staticNotAddedLabel.text = "Not added".localizedString()
        yesButton.setTitle("YES".localizedString(), for: .normal)
        noButton.setTitle("NO".localizedString(), for: .normal)
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        //Card Two
        let backImageview = UIImageView()
        backImageview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
     //   backImageview.image = #imageLiteral(resourceName: "Bg_3_320X480")
         backImageview.image = #imageLiteral(resourceName: "Bg_3_320X480")
        backImageview.contentMode = .scaleToFill
        self.view.addSubview(backImageview)
        self.view.bringSubviewToFront(scroller)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sntTopBlurView.clipsToBounds = true
        
        self.setBlurViewOnBack(sntTopBlurView)
        sntTopBlurView.bringSubviewToFront(sntHrsAgoLabel)
        
        self.navigationController?.navigationBar.topItem?.hidesBackButton = false

    }
    
    func setBlurViewOnBack(_ view:UIView){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.roundCorners(corners: [.topLeft, .topRight], radius: 10, view: view)
      //  view.addSubview(blurEffectView)
        
    }
    
    //MARK: - Show snt details on UI
    func displaySntDataOnUI(){
        
        
        guard let snt = snt else {return}
        
        //Card One
        if let loginData = UserDefaults.standard.object(forKey: "LOGIN_DATA") as? Data {
            if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: loginData) {
                
                let totalShareCount = response.data?.userInfo.totalShareCount ?? 0
                availableShareCount = totalShareCount - (shareCountModel?.data?.shareCount ?? 0)
                
                totalLabel.text = String("    \(totalShareCount)")
                sharedLabel.text = String(shareCountModel?.data?.shareCount ?? 0)
                
                if(availableShareCount <= 0){
                    self.availableLabel.text = "0"
                }else{
                    self.availableLabel.text = String(availableShareCount)
                }
            }
        }
        
        //Card Two
        //Utility.setBlurViewOn(sntTopBlurView)
        //sntTopBlurView.bringSubviewToFront(sntHrsAgoLabel)
        sntHrsAgoLabel.text = Utility.timeAgoSinceDate(snt.createdDate, currentDate: Date(), numericDates: true)
        sntImage.contentMode = .scaleAspectFill
        sntImage.load(url: URL(string: snt.thumbnailURL)!)
        sntTitleLabel.text = snt.title
        sntDescriptionLabel.text = snt.desc
       // let crtByString = "Created by:"
        sntCreatedbyLabel.text = String("Created by:".localizedString() + " \(snt.createdBy)")
        
        //Card Three
        yesButton.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
        yesButton.tintColor = .rxGreen
        noButton.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
        noButton.tintColor = .rxGreen
        selectPhoneNumLabel.isHidden = false
        doctorInfoView.isHidden = true
        cardThreeHeightContraint.constant = 120
        selectPhoneNumberHeightConstraint.constant = 35
        
        cardFourHeightConstraint.constant = 140
    }
    
    func getHours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
    }
    
    func presentContactsListVC()  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.centralcontactlistvc) as! CentarlContactsListVC
        vc.centralContactList = self.centralContactList
        vc.centralContactDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK: - Button methods
    @IBAction func selectPhoneNumberPressed(_ sender: UIButton) {
        
        if availableShareCount <= 0 {
            let msg = "As per current account plan, you have exceeded the forwarding limit for this content, Please upgrade your account plan.".localizedString()
            self.popupAlert(title: Constants.Alert.title, message: msg, actionTitles: ["Ok"], actions:[{action in},nil])
            return
        }
        
        if (self.snt?.canSendSnt())!{
            noButtonPressed(noButton)
            if(!isDocInfoShown){
                // check for availability to share
                 /*
                let contactStore = CNContactStore()
                contactsAuthorization(for: contactStore) { (athorisedBool) in
                    if(athorisedBool){
                        DispatchQueue.main.async {
                            showActivityIndicator(View: self.navigationController!.view, Constants.Loader.loadingContacts.localizedString())
                            self.perform(#selector(self.getContactsFromPhoneBook), with: nil, afterDelay: 1.0)
                        }
                    }else{
                        print("NOT Athorised")
                        Utility.showAlertWithHandler(message: Constants.Alert.openSettings.localizedString(), alertButtons: 1, buttonTitle: "Ok", inView: self) { (yesTapped) in
                            if(yesTapped){
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }
                        }
                    }
                }
                */
               
                let data =  USERDEFAULTS.value(forKey: "LOGIN_DATA") as! Data
                let profileModel = try! JSONDecoder().decode(ProfileDataModel.self, from: data)
                
                if let boolValue = profileModel.data?.settings?.isCentralizedContact, boolValue == true {
                    
                    if let contactsRefreshtime = USERDEFAULTS.value(forKey: "ContactsRefreshTime") as? Date {
                        let definedHours = profileModel.data?.settings?.isContactListRefreshHrs ?? 0
                        let savedHours = getHours(from: contactsRefreshtime)
                        if savedHours >= definedHours {
                            DispatchQueue.main.async {
                                showActivityIndicator(View: self.navigationController!.view, Constants.Loader.loadingContacts)
                            }
                            callApiToFetchConntactsList()
                        } else {
                            // show offline data
                            let jsonData = USERDEFAULTS.value(forKey: "ContactsListData") as! Data
                            let responseData = try! JSONDecoder().decode(CentralContactList.self, from: jsonData)
                            self.centralContactList = responseData
                            
                            presentContactsListVC()
                            
                        }
                    } else {
                        DispatchQueue.main.async {
                            showActivityIndicator(View: self.navigationController!.view, Constants.Loader.validating)
                        }
                        callApiToFetchConntactsList()
                    }
                } else {
                    
                    let contactStore = CNContactStore()
                    contactsAuthorization(for: contactStore) { (athorisedBool) in
                        if(athorisedBool){
                            DispatchQueue.main.async {
                                showActivityIndicator(View: self.navigationController!.view, Constants.Loader.loadingContacts)
                                self.perform(#selector(self.getContactsFromPhoneBook), with: nil, afterDelay: 1.0)
                            }
                        }else{
                            print("NOT Athorised")
                            Utility.showAlertWithHandler(message: Constants.Alert.openSettings, alertButtons: 1, buttonTitle: "Ok", inView: self) { (yesTapped) in
                                if(yesTapped){
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }
                            }
                        }
                    }
                }
               
            }else{
                
                //Call validate api
                print("Call validate api")
                let networkConnection = try! Reachability.init()?.isConnectedToNetwork
                if networkConnection != nil{
                    
                    DispatchQueue.main.async {
                        
                        showActivityIndicator(View: self.navigationController!.view, Constants.Loader.validating.localizedString())
                    }
                    self.perform(#selector(callApiToValidateDoctorInfo), with: nil, afterDelay: 2.0)
                }
                else{
                    self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.internetNotFound.localizedString(), actionTitles: ["Ok"], actions:[{action1 in
                        }, nil])
                }
            }
        }else{
            self.popupAlert(title: Constants.Alert.title, message: Constants.Alert.restrictShareingSnt.localizedString(), actionTitles: ["Ok"], actions:[{action1 in
                }, nil])
        }
    }
    
    @IBAction func cancelDoctorInfoPressed(_ sender: UIButton){
        
        Utility.showAlertWithHandler(message: Constants.Loader.removeCustomer.localizedString(), alertButtons:2, buttonTitle:"Yes".localizedString(), inView: self) { (tapValue) in
            if(tapValue){
                
                print("Cancel tapped")
                self.isDocInfoValidated = false
                self.isDocInfoShown = false
                self.showDoctorInfoCard(self.isDocInfoShown)
                self.showHideCard4(false)
                
                self.anotherProceedButton.isHidden = true
                self.anotherPreviewButton.isHidden = true
                self.anotherShareButton.isHidden = true
                self.staticNotAddedLabel.isHidden = true
            }
        }
    }
    
    @IBAction func proceedPressed(_ sender: UIButton){
        
        print("Proceed tapped")
        self.view.endEditing(true)
        
        if(isDocInfoValidated && isDocInfoShown){
            
            setupParametersforShortenApi()
            
            //self.perform(#selector(setupParametersforShortenApi), with: nil, afterDelay: 2.0)
            
        }else{
            
            Utility.showAlertWith(message: "Doctor not validated", inView: self)
        }
    }
    
    
    @IBAction func yesButtonPressed(_ sender:UIButton){
        
        print("YES tapped")

        staticWelcomMessageHeightConstraint.constant = 81
        pencilHeightConstraint.constant = 81
        
        addWelcomeMessageBool = true
        welcomeMessageStaticLabel.isHidden = false
        welcomeMessage.isHidden = false
        //self.addDoneButtonOnKeyboard(textField: self.welcomeMessage)
       welcomeMessage.isUserInteractionEnabled = true
        pencilButton.isHidden = true
        welcomeMessageMaxLenLabel.isHidden = false
        yesButton.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
        yesButton.tintColor = .rxGreen
        noButton.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
        noButton.tintColor = .rxGreen
        

        cardFourHeightConstraint.constant = 230
        //proceedButtonHeightConstraint.constant = 310

    }
    
    @IBAction func noButtonPressed(_ sender:UIButton){
        
        print("NO tapped")

        welcomeMessageMaxLenLabel.text = String("0 / 50")
        
        self.view.endEditing(true)
        doYouWantToAddWelcomeMessageStaticLabel.isHidden = false
        yesButton.isHidden = false
        noButton.isHidden = false
        
        addWelcomeMessageBool = false
        welcomeMessageStaticLabel.isHidden = true
        welcomeMessage.isHidden = true
        welcomeMessage.text = ""
        pencilButton.isHidden = true
        welcomeMessageMaxLenLabel.isHidden = true
        yesButton.setImage(#imageLiteral(resourceName: "new_round_radio_button_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
        yesButton.tintColor = .rxGreen
        noButton.setImage(#imageLiteral(resourceName: "new_round_radio_button").withRenderingMode(.alwaysTemplate), for: .normal)
        noButton.tintColor = .rxGreen
        
        cardFourHeightConstraint.constant = 130
        // proceedButtonHeightConstraint.constant = 250

    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton){
        
        print("Share tapped")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.sharevc) as! ShareViewController
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overFullScreen
        vc.snt = snt
        vc.userPhoneNumber = self.doctorMobileLabel.text ?? ""
        vc.shortenUrlData = shortenUrlData
        vc.welcomeMessage = welcomeMessage.text
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func previewButtonPressed(_ sender: UIButton){
        
        print("Preview tapped")
        
        guard let snt = snt else {
            return
        }
        
        guard let shortenUrl = shortenUrlData else {
            return
        }
        
        //Longer url + “999” + ”&k=AccessKey”
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.playsntvc) as! PlaySntViewController
        vc.loadUrl = String("\(shortenUrl.longURL)999&k=\(snt.accessKey)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pencilButtonPressed(_ sender: UIButton){
        
        print("Pencil tapped")
        cardFourHeightConstraint.constant = 230

        staticWelcomMessageHeightConstraint.constant = 81
        pencilHeightConstraint.constant = 81
        doYouWantToAddWelcomeMessageStaticLabel.isHidden = false
        staticNotAddedLabel.isHidden = true
        yesButton.isHidden = false
        noButton.isHidden = false
        welcomeMessage.isUserInteractionEnabled = true
        welcomeMessage.isHidden = false
        pencilButton.isHidden = true
        previewButton.isHidden = true
        shareButton.isHidden = true
        proceedButton.isHidden = false
        
        yesButtonPressed(yesButton)
        
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
        hideBarBUttomItem()
        welcomeMessage.endEditing(true)
        welcomeMessage.resignFirstResponder()

    }
    
    
    //MARK: - Show doctor info card
    func showDoctorInfoCard(_ show: Bool){
        
        
        switch show {
        case true:
            //Show card
            selectPhoneNumLabel.isHidden = true
            doctorInfoView.isHidden = false
            cardThreeHeightContraint.constant = 190
            selectPhoneNumberHeightConstraint.constant = 105
            selectPhoneNumButton.setTitle("Validate", for: .normal)
            

        case false:
            //Hide card
            selectPhoneNumLabel.isHidden = false
            doctorInfoView.isHidden = true
            cardThreeHeightContraint.constant = 120
            selectPhoneNumberHeightConstraint.constant = 35
            selectPhoneNumButton.setTitle("Select Phone Number", for: .normal)
            selectPhoneNumButton.isEnabled = true
            

        }
        
    }
    
}

extension ShareSntViewController: CNContactPickerDelegate,CenntralContactListProtocol{
    
    //MARK:- Contacts import picker
    @objc func getContactsFromPhoneBook(){
        
        hideActivityIndicator(View: self.view)
        
        showBarButtonItem()
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        // contactPicker.predicateForSelectionOfContact = NSPredicate(format: "phoneNumber.@count >= 0")
        
        contactPicker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
        
    }
  
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact
        
        // user name
        let userName:String = contact.givenName + " " + contact.familyName
        
        let phoneNumber:CNPhoneNumber = contactProperty.value as! CNPhoneNumber
        
        let countrycode:String = (phoneNumber.value(forKey:"countryCode") as? String)!
        
        // user phone number string
        let phoneNumberStr:String = phoneNumber.value(forKey: "digits") as! String
        
        let phoneNumberKit = PhoneNumberKit()
        
        do {
            //let phoneNumber = try phoneNumberKit.parse(primaryPhoneNumberStr)
            let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(phoneNumberStr, withRegion: countrycode.uppercased(), ignoreType: true)
            
            print(countrycode.uppercased())
            // print(phoneNumber)
            print(phoneNumberCustomDefaultRegion)
            // print(phoneNumberKit.format(phoneNumber, toType: .e164))
            
            isDocInfoShown = true
            showDoctorInfoCard(isDocInfoShown)
            doctorNameLabel.text = userName
            
            if(phoneNumberCustomDefaultRegion.numberString.contains("+")){
                doctorMobileLabel.text = phoneNumberCustomDefaultRegion.numberString
            } else {
                doctorMobileLabel.text = "+" + String(phoneNumberCustomDefaultRegion.countryCode) + phoneNumberCustomDefaultRegion.numberString
            }
            
            
        }
        catch {
            print("Generic parser error")
        }
        
    }
    
    func didSelectCentralContact(contact: ContactList) {
        print(contact)
    }
    
    
    /*
     func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
     
     // user name
     let userName:String = contact.givenName + " " + contact.familyName
     print(userName)
     
     // user phone number
     let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
     let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
     let countrycode:String = (userPhoneNumbers[0].value.value(forKey:"countryCode") as? String)!
     
     
     // user phone number string
     let primaryPhoneNumberStr:String = firstPhoneNumber.value(forKey: "digits") as! String
     
     let phoneNumberKit = PhoneNumberKit()
     
     
     do {
     //let phoneNumber = try phoneNumberKit.parse(primaryPhoneNumberStr)
     let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(primaryPhoneNumberStr, withRegion: countrycode.uppercased(), ignoreType: true)
     
     print(countrycode.uppercased())
     // print(phoneNumber)
     print(phoneNumberCustomDefaultRegion)
     // print(phoneNumberKit.format(phoneNumber, toType: .e164))
     
     isDocInfoShown = true
     showDoctorInfoCard(isDocInfoShown)
     doctorNameLabel.text = userName
     
     if(phoneNumberCustomDefaultRegion.numberString.contains("+")){
     
     doctorMobileLabel.text = phoneNumberCustomDefaultRegion.numberString
     
     }else{
     
     doctorMobileLabel.text = "+" + String(phoneNumberCustomDefaultRegion.countryCode) + phoneNumberCustomDefaultRegion.numberString
     
     }
     
     
     }
     catch {
     print("Generic parser error")
     }
     
     
     }*/
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }

    //MARK: - Contacts import authorization
    func contactsAuthorization(for store: CNContactStore, completionHandler: @escaping ((_ isAuthorized: Bool) -> Void)) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (isAuthorized: Bool, error: Error?) in
                completionHandler(isAuthorized)
            })
        case .denied:
            completionHandler(false)
        case .restricted:
            completionHandler(false)
        default:
            completionHandler(false)
            
        }
    }
}

extension ShareSntViewController{
    
    //MARK: - Central Contact List Api
    
    @objc func callApiToFetchConntactsList() {
        //Api
        let api = Constants.Api.contactList
        
        //Token as header
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        
        //Parameters
        let userEmail = ("\(USERDEFAULTS.value(forKey: "USER_EMAIL")!)")
        let parameters:  [String : Any] =
            ["repEmailId": userEmail, "tagInclude": [],"tagExclude": []]
        
        
        _ = HTTPRequest.sharedInstance.newRequest(url: api, method: "POST", params: parameters, header: header) { (response, error) in
            
            if error != nil
            {
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                    self.popupAlert(title: Constants.Alert.title, message: error?.description, actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }
            else{
                
                let jsonData = try! JSONSerialization.data(withJSONObject: response!, options: [])
                let responseData = try! JSONDecoder().decode(CentralContactList.self, from: jsonData)
                
                if(responseData.statusCode == "100") {
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        USERDEFAULTS.set(Date(), forKey: "ContactsRefreshTime")
                        USERDEFAULTS.set(jsonData, forKey: "ContactsListData")
                        self.centralContactList = responseData
                        
                        // navigate
                        DispatchQueue.main.async {
                            self.presentContactsListVC()
                        }
                        
                    }
                }else {
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        if(responseData.statusCode == "106"){
                            self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                        }
                    }
                }
            }
        }
        
    }
    
    
    //MARK: - Call validate Api
    @objc func callApiToValidateDoctorInfo(){
        
        //Api
        let api = Constants.Api.validateDoctorInfo
        
        //Token as header
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        
        //Parameters
        //-----------
        guard let snt = snt else {return}
        let sntId = URL(string: snt.sntURL)!.lastPathComponent
        let userEmail = ("\(USERDEFAULTS.value(forKey: "USER_EMAIL")!)")
        let parameters:[String : String] =
            ["doctorMobNo": doctorMobileLabel.text!,
             "repEmail": userEmail,
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
                let responseData = try! JSONDecoder().decode(ValidateModel.self, from: jsonData)
                
                if(responseData.statusCode == "100"){
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        
                        //DO SOMETHING WITH RESPONSE
                        print("JSON DATA -> \(responseData)")
                        self.doctor = responseData.data
                        
                        self.validateAndShowCard4(responseData)
                    }
                }else{
                    
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        
                        if(responseData.statusCode == "106"){
                            self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                        }
                    }
                }
            }
        }
    }
    
    func validateAndShowCard4(_ response:ValidateModel ){
        
        selectPhoneNumButton.setTitle("Validated", for: .normal)
      
        selectPhoneNumButton.isEnabled = false
        isDocInfoValidated = true
        
        guard let doctor = response.data else {return}
        
        //getConsentflag != 0 && !isAuthorised)
        if(doctor.consentflag != 0 && !doctor.isAuthorised){
            
            Utility.showAlertWith(message:"You don’t have consent to send to this Recipient.".localizedString() , inView: self)
        }
            //else if (!isOrgLevelAuthorised)
        else if (!doctor.isOrgLevelAuthorised){
            Utility.showAlertWith(message:"You cannot send this content to this Recipient today as per restriction limit, Try later.".localizedString() , inView: self)
            
        }
            //else if (!isRepLevelAuthorised())
        else if(!doctor.isRepLevelAuthorised){
            
            Utility.showAlertWith(message:"You have recently sent a content to this Recipient, So as per restriction limit you can’t send today, Try later.".localizedString() , inView: self)
            
        }
            // else if (isSentToDoctor())
        else if(doctor.isSentToDoctor){
            
            let lastSent = Date(timeIntervalSince1970:(Double(Int(doctor.lastSentDate)!) / 1000.0))
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMM yyyy"
            
            print(dateFormatterPrint.string(from: lastSent))
            let lastSentStr = dateFormatterPrint.string(from: lastSent)
            let message: String!
              if ("\(USERDEFAULTS.value(forKey: "AppLanguage")!)" == "Spanish") {
                  message = "You have sent same content to this Recipient on \(lastSentStr), Are you sure you want to send again?" } else {
                message = "Ha enviado el mismo contenido a este Destinatario el \(lastSentStr), está seguro de que desea enviar nuevamente?"
            }
            
            let alert = UIAlertController(title: Constants.Alert.title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction (title: "No", style: UIAlertAction.Style.default, handler:{ (action) in
                
                self.selectPhoneNumButton.isEnabled = true
                self.isDocInfoValidated = false
                // self.showHideCard4(true)
                
            }))
            alert.addAction(UIAlertAction (title: "Yes".localizedString(), style: UIAlertAction.Style.default, handler: { (action) in
                
                //Enable step 2
                self.enableStep2ToAddWelcomeMessage(doctor.isOrgLevelAuthorised)
            }))
            
            self.present(alert, animated: true, completion: nil)
            alert.view.tintColor = .rxGreen
            
        }else{
            
            //Enable step 2
            enableStep2ToAddWelcomeMessage(doctor.isOrgLevelAuthorised)
            
        }
    }
    
    func enableStep2ToAddWelcomeMessage(_ isOrgLevelAuthorised: Bool){
        
        guard let snt = snt else {return}
        
        print(snt.lockWelcomeMsg)
        // — If lockWelcomemessage - true then don’t include message key
        if(!snt.lockWelcomeMsg){
            
            // — if welcome message is false then ask user to include message in pop up - If user clicks NO on popup then don’t add message key.
            
            showHideCard4(true)
            
        }else{
            anotherProceedButton.isHidden = false
        }
        
        if (!isOrgLevelAuthorised){
            Utility.showAlertWith(message:"You cannot send this content to this Recipient today as per restriction limit, Try later.".localizedString() , inView: self)
            
        }else{
            
            //Show card 4
            //showHideCard4(true)
            
        }
    }
    
    func showHideCard4(_ show: Bool){
        
        switch show {
        case true:
            scroller.contentSize.height = 1050
            scrollerContentViewHeightConstraint.constant = 1050

            twoRoundLabel.isHidden = false
            verticalLine2.isHidden = false
            verticalLine3.isHidden = false
            cardFour.isHidden = false
            proceedButton.isHidden = false
            // proceedButtonHeightConstraint.constant = 225
            // previewButton.isHidden = false
            //shareButton.isHidden = false
            
        case false:
            twoRoundLabel.isHidden = true
            verticalLine2.isHidden = true
            verticalLine3.isHidden = true
            cardFour.isHidden = true
            proceedButton.isHidden = true
            previewButton.isHidden = true
            shareButton.isHidden = true
            
            noButtonPressed(noButton)
            scroller.contentSize.height = self.view.frame.size.height + 60
            scrollerContentViewHeightConstraint.constant = self.view.frame.size.height + 60
        }
    }
    
    //MARK: - Setup Parameters fro Shorten Api
    func setupParametersforShortenApi(){
        
        //Parameters
        //-----------
        var parameters:[String : Any]?
        
        guard let snt = snt else {return}
        let sntId = URL(string: snt.sntURL)!.lastPathComponent
        let userEmail = ("\(USERDEFAULTS.value(forKey: "USER_EMAIL")!)")
        let userMobile = ("\(USERDEFAULTS.value(forKey: "USER_MOBILE")!)")
        let userProfilePic = ("\(USERDEFAULTS.value(forKey: "USER_PROFILE_PIC") ?? "")")
        let displayIButton = ("\(USERDEFAULTS.value(forKey: "USER_DISPLAY_IB_BUTTON")!)")
        let orgId = "\(USERDEFAULTS.value(forKey: "orgId") ?? "")"

        
        var doctorAccountId: String = ""
        var isDoctorAvailable: Bool = false
        
        if let doc = doctor{
            doctorAccountId = doc.doctorAccountId
            isDoctorAvailable = doc.isDoctorAvailable
        }
        //var settingsObj: Settings
        if let loginData = UserDefaults.standard.object(forKey: "LOGIN_DATA") as? Data {
            if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: loginData) {
                if(response.statusCode == "100"){
                    guard let data = response.data else {return}
                    if data.settings != nil{
                        parameters = ["sntURL": snt.sntURL,
                        "doctorMobNo": doctorMobileLabel.text!,
                        "repMobNo": userMobile,
                        "repEmail": userEmail,
                        "createdBy": snt.createdBy,
                        "accessKey": snt.accessKey,
                        "doctorAccountId":doctorAccountId,
                        "sb": snt.hideShareBtn,
                        "vd": snt.hideViewCountBtn,
                        "iB": displayIButton.getBool,
                        "sntId": sntId,
                        "approvalNumber": snt.approvalNo,
                        "isDoctorAvailable": isDoctorAvailable,
                        "lang": snt.selectedLanguage.languageCode,
                        "isWhiteLabel":data.settings?.isWhiteLabel ?? false,
                        "isCustomCookie":data.settings?.isCustomCookie ?? false,
                        "cookieLink":data.settings?.cookieLink ?? "",
                        "timezone":data.settings?.timezone ?? "",
                        "isTokenExpiry":data.settings?.isTokenExpiry ?? false,
                        "noOfDaysforToken":data.settings?.noOfDaysforToken ?? 0,
                        "isTrackIP":data.settings?.isTrackIP ?? false,
                        "isTrackLatandLong":data.settings?.isTrackLatandLong ?? false,
                        "isTrackCity":data.settings?.isTrackCity ?? false,
                        "isScrambleCustomerNumber":data.settings?.isScrambleCustomerNumber ?? false,
                        "isEnableStaticTags":data.settings?.isEnableStaticTags ?? false,
                        "isEnableDynamicTags":data.settings?.isEnableDynamicTags ?? false,
                        "mediaOverlayPosition": snt.mediaOverlayPosition ?? "",
                        "mediaOverlayHide": snt.mediaOverlayHide,
                        "title": snt.title,
                        "description":snt.desc,
                        "imageUrl" :snt.thumbnailURL,
                        "orgId": data.orgId ?? ""
                        ]
                    }else{
                        parameters =
                        ["sntURL": snt.sntURL,
                         "doctorMobNo": doctorMobileLabel.text!,
                         "repMobNo": userMobile,
                         "repEmail": userEmail,
                         "createdBy": snt.createdBy,
                         "accessKey": snt.accessKey,
                         "doctorAccountId":doctorAccountId,
                         "sb": snt.hideShareBtn,
                         "vd": snt.hideViewCountBtn,
                         "iB": displayIButton.getBool,
                         "sntId": sntId,
                         "approvalNumber": snt.approvalNo,
                         "isDoctorAvailable": isDoctorAvailable,
                         "lang": snt.selectedLanguage.languageCode,
                        "orgId": orgId ]
                    }
                }
            }
        }
        
        if(addWelcomeMessageBool){
            
            if(!welcomeMessage.text!.isEmpty){
                //let escapedMsg = welcomeMessage.text.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
                //self.welcomeMessage.text = escapedMsg
                parameters!["message"] = welcomeMessage.text
                
            }else{
                
                Utility.showAlertWith(message: "Please enter welcome message".localizedString(), inView: self)
                
                return
                
            }
        }
        
        
        //If lockprofilepic == false then include repProfilePicURL in snt card details
        //Else lockprofilepic key will not be added
        if(!snt.lockProfilePic){
            
            parameters!["repProfilePicURL"] = userProfilePic
            
        }
        
        
        //lockcta key in snt card = false then B val will go in request
        if(!snt.lockCTA){
            
            //Check if ctaLabel has some value
            if let ctaLabel = snt.ctaLabel{
                
                //{"val" : "+91823258824","t":2}
                //Check ctaLabel for whatsapp me, sms me, email me
                //That means ctaLabel != OTHERS
                var bValue:[String : Any]?
                if(ctaLabel.lowercased() == "whatsapp me"){
                    
                    // t  = 1
                    // val = repPhoneNumber -(Logged in user)
                    
                    bValue = ["val": userMobile,
                              "t": 1]
                    parameters!["b"] = bValue
                    
                    
                }
                else if(ctaLabel.lowercased() == "sms me"){
                    
                    // t  = 2
                    // val = repPhoneNumber -(Logged in user)
                    bValue = ["val": userMobile,
                              "t": 2]
                    parameters!["b"] = bValue
                    
                }
                else if(ctaLabel.lowercased() == "email me"){
                    
                    // t  = 3
                    // val = repEmail -(Logged in user)
                    bValue = ["val": userEmail,
                              "t": 3]
                    parameters!["b"] = bValue
                    
                }else{
                    
                    //That means ctaLabel == OTHERS
                    //b key will not be added
                    
                }
                
            }
            
        }
        
        print("ShortenURL Parameters -> \(parameters!)")
        
        DispatchQueue.main.async {
            
            showActivityIndicator(View: self.navigationController!.view, Constants.Loader.processing.localizedString())
            
        }
        self.perform(#selector(shortenUrlApiCall), with: parameters, afterDelay: 2.0)
        
        
        
    }
    
    
    
    //MARK: - Shorten Api call
    @objc func shortenUrlApiCall(_ parameters: [String : Any]?){
        
        guard let parameter = parameters else {
            
            Utility.showAlertWith(message: "Parameters not correct", inView: self)
            return
        }
        
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        if (!networkConnection!)
        {
            DispatchQueue.main.async {
                hideActivityIndicator(View: self.view)
            }
            self.popupAlert(title: "RXSling", message: "Please check your internet connection".localizedString(), actionTitles: ["Ok"], actions:[{action1 in
                }, nil])
            
            return
        }
        
        //-----------
        //Network call
        
        let api = Constants.Api.shortenUrl
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        
        
        //================
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
        
        let myJSON =  try! JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as? NSDictionary
        print("ACTUAL PARAMETER TO send --> \(String(describing: myJSON))")
        
        //=================
        
        _ = HTTPRequest.sharedInstance.newRequest(url: api, method: "POST", params: parameter, header: header) { (response, error) in
            
            if error != nil
            {
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                    self.popupAlert(title: Constants.Alert.title, message: error?.description, actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }
            else{
                
                let jsonData = try! JSONSerialization.data(withJSONObject: response!, options: [])
                let responseData = try! JSONDecoder().decode(ShortenModel.self, from: jsonData)
                
                if(responseData.statusCode == "100"){
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        
                        //DO SOMETHING WITH RESPONSE
                        print("JSON DATA -> \(responseData)")
                        
                        self.shortenUrlData = responseData.data
                        
                        if(!self.addWelcomeMessageBool){
                            
                            self.cardFourHeightConstraint.constant = 85

                            
                            self.welcomeMessageStaticLabel.isHidden = false
                            self.staticNotAddedLabel.isHidden = false
                            
                        }else{
                            
                            self.cardFourHeightConstraint.constant = 160

                            
                        }
                        
                        self.staticWelcomMessageHeightConstraint.constant = 10
                        self.staticNotAddedHeightConstraint.constant = 10
                        self.pencilHeightConstraint.constant = 10
                        self.doYouWantToAddWelcomeMessageStaticLabel.isHidden = true
                        self.yesButton.isHidden = true
                        self.noButton.isHidden = true
                        self.welcomeMessage.isUserInteractionEnabled = false
                        self.pencilButton.isHidden = false
                        self.proceedButton.isHidden = true
                        self.shareButton.isHidden = false
                        self.previewButton.isHidden = false
                        
                        
                        guard let snt = self.snt else {return}
                        
                        // — If lockWelcomemessage - true then don’t include message key
                        if(snt.lockWelcomeMsg){
                            
                            self.proceedButton.isHidden = true
                            self.shareButton.isHidden = true
                            self.previewButton.isHidden = true
                            
                            self.anotherProceedButton.isHidden = true
                            self.anotherPreviewButton.isHidden = false
                            self.anotherShareButton.isHidden = false
                            
                        }
                        
                        self.sharedLabel.text = String(snt.usedShareCount + 1)
                        
                        if(snt.availableShareCount <= 0){
                            
                            self.availableLabel.text = "0"
                            
                        }else{
                            
                            self.availableLabel.text = String(snt.availableShareCount - 1)
                            self.snt?.availableShareCount = snt.availableShareCount - 1
                        }
                        
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                        
                        if(responseData.statusCode == "106"){
                            
                            self.perform(#selector(self.tokenExpiredLogin), with: nil, afterDelay: 1.0)
                            
                        }
                    }
                    
                    
                }
            }
        }
        
    }
    
    //MARK: - Token expired login
    @objc func tokenExpiredLogin(){
        
        Utility.showAlertWithHandler(message: Constants.Alert.tokenExpired.localizedString(), alertButtons: 1, buttonTitle:"Ok", inView: self) { (tapVal) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
    }
    
    
}


extension ShareSntViewController:UITextViewDelegate{
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(textView.text!)
        
        if(textView.text.count == 50){
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Ended editing")
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /*let str = (textView.text + text)
        if str.count <= 50 {
            
            welcomeMessageMaxLenLabel.text = String("\(str.count) / 50")
            textView.text = (textView.text! as NSString).replacingCharacters(in: range, with: text.uppercased())
            return false
        }
        
        textView.text = str.substring(to: str.index(str.startIndex, offsetBy: 50))
        return false*/
        
        let newLength = (textView.text?.count)! + text.count - range.length
        if(newLength <= 50){
            welcomeMessageMaxLenLabel.text = String("\(newLength) / 50")            //self.updateTextCount(Count: newLength, textViewTag: 1)
        }
        if (text == "\n") {
            if let nextField = textView.superview?.viewWithTag(textView.tag + 1) as? UITextView {
                nextField.becomeFirstResponder()
            } else {
                // Not found, so remove keyboard.
                textView.resignFirstResponder()
            }
        }
        
        return newLength <= 50
    }
}

extension ShareSntViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.text!)
        
        if(textField.text!.count == 50){
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Ended editing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! + string)
        if str.count <= 50 {
            
            welcomeMessageMaxLenLabel.text = String("\(str.count) / 50")
            textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
            return false
        }
        
        textField.text = str.substring(to: str.index(str.startIndex, offsetBy: 50))
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}


//extension UIScrollView {
//    func updateScrollContentView() {
//        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
//    }
//}
//
//extension UIView{
//    func updateViewContents() {
//        self.frame.size.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? self.frame.size.height
//    }
//
//}
