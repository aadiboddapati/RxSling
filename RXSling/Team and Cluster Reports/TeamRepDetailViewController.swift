//
//  ClusterReportViewController.swift
//  RXSling Stage
//
//  Created by chiranjeevi macharla on 06/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class TeamRepDetailViewController: UIViewController {
    var backButton : UIBarButtonItem!
    
    
    @IBOutlet weak var repNameLbl:UILabel!
    @IBOutlet weak var repMobileLbl:UILabel!
    @IBOutlet weak var repEmailLbl:UILabel!
    @IBOutlet weak var contentTitleLbl:UILabel!
    @IBOutlet weak var contentDescriptionLbl:UILabel!
    @IBOutlet weak var sentCountLbl:UILabel!
    @IBOutlet weak var viewedCountLbl:UILabel!
    @IBOutlet weak var SuccessLbl:UILabel!
    
    var teamData: TeamData!
    var clusterData: ClusterData!
    var selectedSnt: SNTData?
    var isTeamReport:Bool!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        //  scroller.contentSize.height = 1.0
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        isTeamReport ? self.updateTeamData(data: teamData) : self.updateClusterData(data: clusterData)
    }
    
    func updateTeamData(data:TeamData)  {
        
        self.repNameLbl.text = ( data.userData?.firstName ?? "" )  + " " +  ( data.userData?.lastName ?? "" )
        self.repMobileLbl.text = data.userData?.mobileNo ?? ""
        self.repEmailLbl.text = data.userData?.emailId ?? ""
        self.contentTitleLbl.text = selectedSnt?.title ?? ""
        self.contentDescriptionLbl.text = selectedSnt?.desc ?? ""
        self.sentCountLbl.text = "\(data.sentCount ?? 0)"
        self.viewedCountLbl.text = "\(data.viewedCount ?? 0)"
        if sentCountLbl.text == "0" ||  viewedCountLbl.text == "0" {
            SuccessLbl.text = "0 %"
        } else {
            let percentage =  ( Double (data.viewedCount!) / Double ( data.sentCount! ) ) * 100
            SuccessLbl.text = String(format: "%.2f %@", percentage, "%") // ceil(percentage*100)/100
        }
        
        
    }
    
    func updateClusterData(data: ClusterData) {
        
        
    }
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        
    }
    @IBAction func whatsAppButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func copyReportButtonAction(_ sender: UIButton) {
        
    }
    @IBAction  func emailButtonAction(_ sender: UIButton) {
        
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
