//
//  ProfilePic.swift
//  ParrotNote
//
//  Created by Vinod Kumar on 04/04/19.
//  Copyright © 2019 Vinod Kumar. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - ProfilePicModel
struct ProfilePicModel: Codable {
    let data: ProfilePicDataClass?
    let message, statusCode: String?
}

// MARK: - DataClass
struct ProfilePicDataClass: Codable {
    let profilePic: String
}

class ProfilePic: NSObject {

    static let sharedInstance = ProfilePic()
    override init() {

    }
    
    func uploadProfilePictToServer<T : Codable>(api:String,viewController:UIViewController,params : [String:String],modelType:T.Type, completion:@escaping (T, Error?)->Void){
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        if (!networkConnection!)
        {
            DispatchQueue.main.async(execute: {
                viewController.popupAlert(title: "RXSling", message: "Please check your internet connection", actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])})
        }else{
            DispatchQueue.main.async {
                if api == Constants.Api.updateProfilePic
                {
                    DispatchQueue.main.async(execute: {
                        showActivityIndicator(View: viewController.view, "Uploading profile picture. Please wait...")
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        showActivityIndicator(View: viewController.view, "Removing profile picture. Please wait...")
                    })
                }
            }
            let token = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
            print("TOKEN ---> \(token)")
            let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
            
            _ = HTTPRequest.sharedInstance.request(url: api, method: "POST", params: params, header: header, completion: { (response, error) in
                if error != nil
                {
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: viewController.view)
                        viewController.popupAlert(title: Constants.Alert.title, message: error?.description, actionTitles: ["Ok"], actions:[{action in},nil])
                    }
                    let data:T? = nil
                    completion(data!, error)
                    
                }else{
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: viewController.view)
                    }
                    guard let resultData = response else{ return }
                    let jsonData = try! JSONSerialization.data(withJSONObject: resultData, options: [])
                    let responseData = try! JSONDecoder().decode(modelType.self, from: jsonData)
                    print(responseData)
                    completion(responseData, nil)
                }
            })
        }
    }
    
    /*func uploadProflePic(viewController:UIViewController,view:UIView,urlTOUpLoad:URL,parameters:[String:Any],completion:@escaping (NSDictionary?,NSError?)->Void) {
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        //print(viewController.title)
        print(view)
        if (!networkConnection!)
        {
            DispatchQueue.main.async(execute: {
                viewController.popupAlert(title: "RXSling", message: "Please check your internet connection", actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])})
        }else{
            if let title = viewController.title{
                if title == "SHARE & INFO"
                {
                    DispatchQueue.main.async(execute: {
                        showActivityIndicator(View: view, "uploading_snt_pic")
                    })
                }
            }else{
                if UserDefaults.standard.value(forKey: "profilepic") != nil
                {
                    DispatchQueue.main.async(execute: {
                        showActivityIndicator(View: view, "uploading_profile_pic")
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        showActivityIndicator(View: view, "removing_profile_pic")
                    })
                }
            }


            var movieData: NSData?


            let token = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
            print("TOKEN ---> \(token)")
            var headers: HTTPHeaders?
            if(urlTOUpLoad.absoluteString == Constants.Api.updateProfilePic){
                headers = ["Authorization":"Bearer " + token]
                if UserDefaults.standard.value(forKey: "sntpic") != nil
                {
                    movieData = USERDEFAULTS.data(forKey: "sntpic")! as NSData
                }
            }else{
                headers = ["Authorization": token]
                if UserDefaults.standard.value(forKey: "profilepic") != nil
                {
                    movieData = USERDEFAULTS.data(forKey: "profilepic")! as NSData
                }
            }
            
            /*Alamofire.upload(multipartFormData:{ multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                if(movieData != nil){
                    multipartFormData.append(movieData! as Data, withName: "file",fileName: "file.png", mimeType: ".png")
                }
            },usingThreshold:UInt64.init(),to:urlTOUpLoad,method:.post,headers:headers,
              encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        guard let response = response.result.value as? NSDictionary  else {return }
                        var responseCode:Int = 0
                        print(urlTOUpLoad.absoluteString)
                        if(urlTOUpLoad.absoluteString == SNTBASEURL+SNTPIC) {//https://snt.rxprism.com/registry/api/v2/sntPic"){
                            responseCode = response["statusCode"] as! Int
                            if(responseCode == 102){
                                responseCode = 100
                            }
                        }else{
                            responseCode = response["code"] as! Int
                        }
                        //
                        if(responseCode == 100)
                        {
                            print(response)
                            DispatchQueue.main.async(execute: {
                                hideActivityIndicator(View: view)
                            })
                            completion(response,nil)
                        }
                        else{
                            completion(nil,nil)
                            DispatchQueue.main.async(execute: {
                                hideActivityIndicator(View: view)
                            })
                            viewController.popupAlert(title:"RXSling", message:  "unable_to_proceed_msg", actionTitles: ["Ok"], actions: [{action in},nil])
                        }
                    }
                case .failure(let encodingError):
                    hideActivityIndicator(View: view)
                    print("errror:\(encodingError)")
                    completion(nil,nil)
                    if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                        viewController.popupAlert(title: "RXSling", message: "please check your internet connection", actionTitles: ["Ok"], actions: [{action in},nil])
                        print(err)
                    }else{
                        viewController.popupAlert(title: "RXSling", message: "\(encodingError)", actionTitles: ["Ok"], actions: [{action in},nil])
                    }
                }
            })*/
        }
    }*/
}
