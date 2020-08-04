//
//  VersionMannager.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 24/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import Foundation
import UIKit

struct VersionMannagedObject: Codable {
    
    let isVersionCheckEnabled:Bool
    let isForAllVersionLock:Bool
    
    let isForRollback:Bool
    let rollbackVersion:String
    
    let isForForceUpdate:Bool
    let forceUpdateVersion:String
    
    let isForNewUpdate:Bool
    let newUpdateVersion:String
    let gracePeriod:Int
    
    let isForAppLock:Bool
    let appLockVersion:String
}

class VersionMannager {
    static let sharedInstance = VersionMannager()
    private init() {}
    var versionMannagedObj: VersionMannagedObject!
    
    
    func fetchS3Data()  {
        
        let url = URL(string: "https://rxslingmobile.s3.ap-south-1.amazonaws.com/SlingApp/Staging/update_ios.json")
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let responseData = try! JSONDecoder().decode(VersionMannagedObject.self, from: data!)
                      self.versionMannagedObj = responseData
                    //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VersionObjectDownloaded"), object: nil)
                      self.checkForVersionUpdate()
                }
            }
            
        })

        task.resume()
    }
    
    func checkForVersionUpdate() {
      //  validateVersionUpdate()

        if versionMannagedObj.isVersionCheckEnabled  {
            if let savedDate = USERDEFAULTS.value(forKey: "VersionCheckingDate") as? Date {
                let day = compareTwoDates(today: Date(), olderDate: savedDate)
                if day != .orderedSame {
                    USERDEFAULTS.set(Date(), forKey: "VersionCheckingDate")
                    validateVersionUpdate()
                } else {
                    print("version already checked for the day")
                }
            } else {
                USERDEFAULTS.set(Date(), forKey: "VersionCheckingDate")
                validateVersionUpdate()
            }
        }
    }
    
   private  func validateVersionUpdate()  {
        if !versionMannagedObj.isForAllVersionLock {
            if versionMannagedObj.isForRollback {
                self.handleRollBack()
            } else if versionMannagedObj.isForForceUpdate {
                self.handleForceUpdate()
            } else if versionMannagedObj.isForNewUpdate {
                self.handleNewUpdate()
            } else if versionMannagedObj.isForAppLock {
                self.handleAppLock()
            } else {
            }
        } else {
            self.presentAlert(message: Constants.Alert.versioncheckmsg, isTwoButtons: false, buttonTitles: ["OK"], isForceUpdate: false)
            fetchTopMostViewComntroller()?.logout()
        }
    }
    
    private func handleRollBack() {
        
        DispatchQueue.main.async {
            switch self.fetchVersionCompareResult(version: self.versionMannagedObj.rollbackVersion) {
            case .orderedAscending:
                print("orderedAscending")
            case .orderedSame:
                print("orderedSame")
            case .orderedDescending:
                self.presentAlert(message: Constants.Alert.forceupdatemsg, isTwoButtons: false, buttonTitles: ["Update"], isForceUpdate: true)
            }

        }
    }
    
    private func handleForceUpdate() {
        
        DispatchQueue.main.async {
            
            switch self.fetchVersionCompareResult(version: self.versionMannagedObj.forceUpdateVersion) {
            case .orderedAscending:
                self.presentAlert(message: Constants.Alert.forceupdatemsg, isTwoButtons: false, buttonTitles: ["Update"], isForceUpdate: true)
            case .orderedSame:
                print("orderedSame")
            case .orderedDescending:
                print("orderedDescending")
            }
        }
        
        
    }
    
    private func handleNewUpdate() {
        
        DispatchQueue.main.async {

            switch self.fetchVersionCompareResult(version: self.versionMannagedObj.newUpdateVersion) {
            case .orderedAscending:
                if let days = USERDEFAULTS.value(forKey: "ExpiredGracePeriodDays") as? Int {
                    if days == 0 {
                        // force update
                        self.presentAlert(message: Constants.Alert.forceupdatemsg, isTwoButtons: false, buttonTitles: ["Update"], isForceUpdate: true)
                    } else {
                        USERDEFAULTS.set(days - 1, forKey: "ExpiredGracePeriodDays")
                        let alertMsg = String(format: Constants.Alert.graceperiodmsg, days)
                        self.presentAlert(message: alertMsg, isTwoButtons: true, buttonTitles: ["Later","Update"], isForceUpdate: false)
                    }
                } else {
                    USERDEFAULTS.set(self.versionMannagedObj.gracePeriod - 1, forKey: "ExpiredGracePeriodDays")
                    let alertMsg = String(format: Constants.Alert.graceperiodmsg, self.versionMannagedObj.gracePeriod)
                    self.presentAlert(message: alertMsg, isTwoButtons: true, buttonTitles: ["Later","Update"], isForceUpdate: false)
                }
            case .orderedSame:
                print("orderedSame")
            case .orderedDescending:
                print("orderedDescending")
                
            }
        }
        
    }
    
    private func handleAppLock() {
        
        DispatchQueue.main.async {
            switch self.fetchVersionCompareResult(version: self.versionMannagedObj.appLockVersion) {
            case .orderedAscending:
                self.presentAlert(message: Constants.Alert.forceupdatemsg, isTwoButtons: false, buttonTitles: ["Update"], isForceUpdate: true)
            case .orderedSame:
                print("orderedSame")
            case .orderedDescending:
                print("orderedDescending")
                
            }
        }
    }
    
    private func fetchVersionCompareResult (version: String) -> ComparisonResult {
        let bundleVersion =  fetchAppVersionNumber()
        let remoteVersion = "\(version)"
        return bundleVersion.compare(remoteVersion, options: .numeric)
    }
    
    private func fetchAppVersionNumber() -> String {
        var appVersion: String = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]{
            appVersion = "\(version)"
        }
        return appVersion
    }
    
    private func openAppstore() {
        if let url = URL(string: "https://apps.apple.com/app/rxsling-app/id1511422281?mt=8") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func fetchTopMostViewComntroller() -> UIViewController?  {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.children.last {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    private func compareTwoDates(today: Date, olderDate: Date) -> ComparisonResult {
        return Calendar.current.compare(today, to: olderDate, toGranularity: .day)
    }
    
    func presentAlert(message:String, isTwoButtons:Bool, buttonTitles:[String], isForceUpdate:Bool)  {
        
        let alertContrl = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: buttonTitles.first, style: .default) { (action) in
                if action.title == "Update" {
                    DispatchQueue.main.async {
                        self.fetchTopMostViewComntroller()?.logout()
                        self.openAppstore()
                    }
                }
        }
        let action2 = UIAlertAction(title: buttonTitles.last, style: .default) { (action) in
                if action.title == "Update" {
                    DispatchQueue.main.async {
                        self.fetchTopMostViewComntroller()?.logout()
                        self.openAppstore()
                    }
            }
        }
        
        if isTwoButtons {
            alertContrl.addAction(action1)
            alertContrl.addAction(action2)
        } else {
            alertContrl.addAction(action1)
        }
        
        fetchTopMostViewComntroller()?.present(alertContrl, animated: true, completion: nil)
        alertContrl.view.tintColor = .rxGreen
    }
    
    
}

extension UIViewController {
    
    func logout()  {
        
               print(UserDefaults.standard.bool(forKey: "ISLOGIN"))
               
               UserDefaults.standard.set(false, forKey: "ISLOGIN")
               
               print(UserDefaults.standard.bool(forKey: "ISLOGIN"))
               
               DispatchQueue.main.async {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                   self.navigationController?.pushViewController(vc, animated: false)
               }
    }
}
