//
//  MenuTableViewController.swift
//  VDetail
//
//  Created by Vinod Kumar on 10/09/18.
//  Copyright © 2018 Vinod Kumar. All rights reserved.
//

import UIKit
import SideMenu
import MessageUI


class MenuTableViewController: UITableViewController,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    var attributedString = NSMutableAttributedString()
    var isLinked:Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let image = UIImageView(image: UIImage(named: "Bg_3_320X480.png"))
        image.contentMode = .scaleToFill
        tableView.backgroundView = image
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
        self.profilePicture.layer.masksToBounds = true
        self.profilePicture.layer.borderWidth = 2
        self.profilePicture.layer.borderColor = UIColor.white.cgColor
        self.profilePicture.image = UIImage(named: "user_image.png")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileDetails()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFooterView()
    }
    
    
    //MARK: - Upadate profile details
    func updateProfileDetails(){
        
        if let loginData = UserDefaults.standard.object(forKey: "LOGIN_DATA") as? Data {
            if let response = try? JSONDecoder().decode(ProfileDataModel.self, from: loginData) {
                if(response.statusCode == "100"){
                    
                    guard let data = response.data else {return}
                    
                    
                    print(data.config)
                    
                    emailLabel.text = data.userInfo.emailID
                    firstNameLabel.text = data.userInfo.firstName ?? ""// String("\(data.userInfo.firstName)")
                    
                    let userProfilePic = ("\(USERDEFAULTS.value(forKey: "USER_PROFILE_PIC") ?? "")")
                    
                    if let url  = URL(string: (userProfilePic)){
                        self.profilePicture.load(url: url)
                    }else{
                        self.profilePicture.image = UIImage(named: "user_image.png")
                    }
                    
                    
                }
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
//        if(indexPath.row == 4){
//            self.popupAlert(title: "RXSling", message: "coming soon...", actionTitles: ["Ok"], actions:[{action in},nil])
//        }
        if(indexPath.row == 5){
            self.popupAlert(title: Constants.Alert.title, message: Constants.Loader.sureToLogout, actionTitles: ["NO","YES"], actions:[{cancel in},{ok in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout_Tapped"), object: nil)
                self.dismiss(animated: true, completion: nil)
                },nil])
        }else{
            
        }
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIView()
        footer.backgroundColor = .white
        
        return footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    @objc
    func labelTapped(sender:UITapGestureRecognizer) {
        print("tap working")
        
    }

    
    
    func loadFooterView(){
        
        print(self.view.frame.height)
        print(self.tableView.frame.width)
               
        let footerView = UIView()
        if(self.view.frame.height >= 896.0){
            
            footerView.frame = CGRect(x: 0, y: self.view.frame.height - 160, width: self.tableView.frame.width, height: 80)
            
        }else{
            
            footerView.frame = CGRect(x: 0, y: self.view.frame.height - 100, width: self.tableView.frame.width, height: 80)

        }
        
        footerView.backgroundColor = .clear
        
        
        //--- Support Label ----
        
        let builder = AttributedStringBuilder()
        builder.defaultAttributes = [
            .alignment(.left),
            .textColor(UIColor.white),
            .font( UIFont.systemFont(ofSize: 12) )
        ]
        
        builder
            .text("For support, write to ")
            .text("snt@rxprism.com", attributes: [.underline(true), .textColor(UIColor.rxGreen)])
        
        
        let supportLbl = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.width - 15, height: 21))
        supportLbl.attributedText = builder.attributedString
        footerView.addSubview(supportLbl)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(sender:)))
        supportLbl.isUserInteractionEnabled = true
        supportLbl.addGestureRecognizer(tap)
        
        //-------------
        
        //--- Version Label ----
        var appVersion: String = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]{
            
            appVersion = String("Version: \(version)")
        }
        
        
        let versionLbl = UILabel(frame: CGRect(x: 10, y: 31, width: tableView.frame.width - 15, height: 21))
        versionLbl.text = appVersion
        versionLbl.textColor = .white
        versionLbl.font = UIFont.systemFont(ofSize: 12)
        footerView.addSubview(versionLbl)
        
        self.view.addSubview(footerView)
        //-------------
    }
    
    @objc func didTapLabel(sender:UITapGestureRecognizer? = nil){
         print("tapped")
         //if(isLinked!){
         if let url = URL(string: "mailto:snt@rxprism.com") {
             if #available(iOS 10.0, *) {
                 UIApplication.shared.open(url)
             } else {
                 UIApplication.shared.openURL(url)
             }
         }
         //}
         
     }
    
}
extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
    
    
}


