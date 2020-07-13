//
//  TeamCustomerInfoViewController.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 10/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class TeamCustomerInfoViewController: UIViewController {
    var backButton : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        

        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
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
