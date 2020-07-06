//
//  SplashScreenViewController.swift
//  RXSling
//
//  Created by Divakara Y N. on 23/03/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.view.backgroundColor = .black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.perform(#selector(doLogin), with: nil, afterDelay: 2.0)
    }


    @objc func doLogin(){
        
        if(UserDefaults.standard.bool(forKey: "ISLOGIN") == true){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! ViewController
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
}
