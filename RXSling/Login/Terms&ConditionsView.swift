//
//  Terms&ConditionsView.swift
//  ParrotNote
//
//  Created by Vinod Kumar on 30/04/19.
//  Copyright © 2019 Vinod Kumar. All rights reserved.
//

import UIKit
import WebKit
class Terms_ConditionsView: UIViewController,WKNavigationDelegate {
    var popupWebView: WKWebView?
    var backButton : UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var slingImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TERMS AND CONDITIONS".localizedString()
        self.navigationController?.navigationBar.tintColor = GREENCOLOUR
        self.navigationItem.rightBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        webView.uiDelegate = self
        webView.isOpaque = false
        if UIDevice.current.userInterfaceIdiom == .pad {
          //  self.view.backgroundColor = UIColor(red: 0.45, green: 0.67, blue: 0.30, alpha: 0.5)
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        }
        
        //let url = Bundle.main.url(forResource: "termsandconditions", withExtension: "html")
        self.webView.load(URLRequest(url: URL(string: "\(Constants.Api.termsAndConditionsUrl)")!))
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
    }
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async {
            showActivityIndicator(View: self.view, "Loading. Please wait...")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hideActivityIndicator(View: self.view)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBarBUttomItem()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         self.navigationController?.navigationBar.isHidden = false
        
//         self.navigationItem.title = "TERMS AND CONDITIONS"
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_3_320X480.png")!)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }

}

extension Terms_ConditionsView: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        popupWebView?.backgroundColor = UIColor.white
        showBarButtonItem()
        self.webView.addSubview(popupWebView!)
        return popupWebView!
    }

    func webViewDidClose(_ webView: WKWebView) {
        if webView == popupWebView {
            popupWebView?.removeFromSuperview()
            popupWebView = nil
        }
    }
}

