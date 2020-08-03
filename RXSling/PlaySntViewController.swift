//
//  PlaySntViewController.swift
//  RXSling
//
//  Created by Manish Ranjan on 27/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
import WebKit

class PlaySntViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var retryButton: UIButton!
    
    
    var loadUrl:String?
    var backButton : UIBarButtonItem!
    //playUrl?k=acesskey
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PREVIEW"
        
        errorLabel.isHidden = true
        retryButton.isHidden = true
        webview.isOpaque = false
        webview.backgroundColor = .clear
        webview.navigationDelegate = self
      
        self.navigationItem.setHidesBackButton(true, animated: false)
                      self.navigationController?.navigationBar.topItem?.hidesBackButton = true
                      self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
                      self.navigationItem.leftBarButtonItem = backButton
                      self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
                      self.navigationController?.navigationBar.isExclusiveTouch = true
                      self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        
            webview.customUserAgent = "iOS11_IPAD-MOBILE_SAFARI"

               }
        
       showActivityIndicator(View: self.view, Constants.Loader.loadingShowNtell)
        
        checkInternet()

        
    }
    
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
             super.viewDidAppear(animated)
       
//             self.navigationController?.navigationBar.isHidden = false
//          self.navigationItem.setHidesBackButton(false, animated: false)
//    self.navigationController?.navigationBar.topItem?.hidesBackButton = false
    }
    override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
      
                 //      self.navigationController?.navigationBar.isHidden = false
         
            }
 
    
    //MARK: - Check Internet
    func checkInternet(){
        
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        
        if networkConnection == true{
            
            loadWebView()
        }
        else{
            
            
            DispatchQueue.main.async {
                hideActivityIndicator(View: self.view)

                self.showWebViewError(true)
                
                Utility.showAlertWith(message: Constants.Alert.internetNotFound, inView: self)

                
            }
            
        }
        
    }
    
    //MARK: - Retry Pressed
    @IBAction func retryBtnPressed(_ sender: UIButton) {
        print("Retry pressed")
        self.showWebViewError(false)

        showActivityIndicator(View: self.view, Constants.Loader.loadingShowNtell)
        checkInternet()
    }
    
   
    
    //MARK: Load Webview
    func loadWebView(){
        
        guard let loadUrl = loadUrl else {
            return
        }
        
        print("=======\nUrl to load: \(loadUrl)\n=======")
        
        let url = URL.init(string: loadUrl)
        let request = URLRequest(url: url!)
        webview.load(request)
        
    }
    
   //MARK: - Show error to reload
    func showWebViewError(_ webLoaded: Bool){
        
        switch webLoaded {
        case true:
            webview.isHidden = true
            errorLabel.isHidden = false
            retryButton.isHidden = false
            
        case false:
            webview.isHidden = false
            errorLabel.isHidden = true
            retryButton.isHidden = true
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension PlaySntViewController: WKNavigationDelegate{
    
    // show indicator
       func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
           
           
       }
       
       // hide indicator
       func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)  {
           
           hideActivityIndicator(View: self.view)

       }
       
       
       // hide indicator - show error message
       func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
           
        hideActivityIndicator(View: self.view)

           showWebViewError(true)
           
       }
}
