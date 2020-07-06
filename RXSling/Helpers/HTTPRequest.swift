//
//  HTTPRequest.swift
//  VDetail
//
//  Created by Vinod Kumar on 10/09/18.
//  Copyright © 2018 Vinod Kumar. All rights reserved.
//

import UIKit
import Alamofire

class HTTPRequest: NSObject {
    static let sharedInstance = HTTPRequest()
    override init() {

    }

    func request(url:String, method: String, params: [String: String], header:String, completion:@escaping (NSDictionary?, NSError?) -> Void ) -> URLSessionTask{
        var responseResultData: NSDictionary = NSDictionary()

        let nsURL = NSURL(string:url)
        let request = NSMutableURLRequest(url: nsURL! as URL)
        if method == "POST" {
            // convert key, value pairs into param string
            let postString = params.map { "\($0.0)=\($0.1.addingPercentEncoding(withAllowedCharacters: .queryValueAllowed)!)" }.joined(separator: "&")
            print("PARAMS -> \(params)")
            request.httpMethod = "POST"
            print("postString:-> \(postString)")
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData!//postString.data(using: String.Encoding.utf8)
            request.timeoutInterval = 30
            
                if(header != "")
                {
                    request.setValue("\(header)", forHTTPHeaderField: "token")
                }
        }
        else if method == "GET" {
            // let postString = params.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
            request.httpMethod = "GET"
            if(header != "")
            {
                request.setValue("\(header)", forHTTPHeaderField: "Authorization")
            }
        }
        else if method == "PUT" {
            let putString = params.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
            request.httpMethod = "PUT"
            request.httpBody = putString.data(using: String.Encoding.utf8)
        }
        else if method == "DELETE"
        {
            request.httpMethod = "DELETE"
        }


        let task = URLSession.shared.dataTask(with: (request as URLRequest) as URLRequest) {
            (data, response, error) in
            if error != nil
            {
                print("error=\(String(describing: error))")
                completion(nil, error! as NSError)
                return
            }
            // You can print out response object
          //  let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print("responseString = \(responseString)")
//            if let responseString = responseString {
//                //  print("responseString = \(responseString)")
//            }
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            //print("Response - > \(response.debugDescription)")
            do {
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                //print("ACTUAL RESPONSE --> \(String(describing: myJSON))")
                responseResultData = myJSON!
                completion(responseResultData, nil)
            } catch {
                print(error)
            }

        }
        task.resume()
        return task

    }
    
    
    func newRequest(url:String, method: String, params: [String: Any], header:String, completion:@escaping (NSDictionary?, NSError?) -> Void ) -> URLSessionTask{
            var responseResultData: NSDictionary = NSDictionary()

            let nsURL = NSURL(string:url)
            let request = NSMutableURLRequest(url: nsURL! as URL)
            if method == "POST" {
        
                request.httpMethod = "POST"
                let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
                
                let jsonString = String(data: jsonData!, encoding: .utf8)
                print("JSON String : \(jsonString ?? "not found")")
               
                request.httpBody = jsonData!//postString.data(using: String.Encoding.utf8)
                request.timeoutInterval = 30
                
                    if(header != "")
                    {
                        request.setValue("\(header)", forHTTPHeaderField: "token")
                    }
            }
         

            let task = URLSession.shared.dataTask(with: (request as URLRequest) as URLRequest) {
                (data, response, error) in
                if error != nil
                {
                    print("error=\(String(describing: error))")
                    completion(nil, error! as NSError)
                    return
                }
              
                print("Response - > \(response.debugDescription)")
                do {
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print("ACTUAL RESPONSE --> \(String(describing: myJSON))")
                    responseResultData = myJSON!
                    completion(responseResultData, nil)
                } catch {
                    print(error)
                }

            }
            task.resume()
            return task

        }
}

extension CharacterSet {
    static let queryValueAllowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&+="))
}


//MARK: - Network Manager
class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    private let modelData: Codable? = nil
    
    //MARK: Call Api with Alamofire
    func callApiWithAlamofire<T : Codable>(_ api : String, params : [String : Any]?, header: String?, modelType:T.Type,  completion: @escaping (T, Error?) -> ()) {
        
        let headers: HTTPHeaders = [
            .init(name: "token", value: header!)
        
        ]
        print("=================")
        print("Api: \(api)")
        print("Params: \(params!)")
        print("headers: \(headers)")
        print("=================")
        
        
        
        AF.request(api, method: .post, parameters: params, encoding: URLEncoding.default, headers:headers).responseData { (response) in
            
            print("=================")
            print("Status code: \(String(describing: response.response?.statusCode))")
            print("=================")
            
            switch response.result {
            case .success:
                guard let data = response.value else { return}
                let jsonString = String(data: data, encoding: .utf8)
                print("JSON String : \(jsonString ?? "not found")")
                
                do {

                    let data = try JSONDecoder().decode(modelType.self, from: data)
                    
                    completion(data , nil)
                    
                    
                }catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                    
                }
                
            case .failure:
                
                let data:T? = nil
                completion(data!, response.error)
                
                
            }
        }
    }
    
}
