//
//  TeamReportViewController.swift
//  RXSling Stage
//
//  Created by chiranjeevi macharla on 06/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class TeamReportViewController: UIViewController {

    var backButton : UIBarButtonItem!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        //  scroller.contentSize.height = 1.0
        self.title = "TEAM REPORT DETAILS"
        self.navigationController?.navigationBar.isHidden = false
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
