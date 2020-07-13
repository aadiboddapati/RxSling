//
//  SegmentedViewController.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 10/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {
    
    @IBOutlet weak var segmntCntrl: UISegmentedControl!
    @IBOutlet weak var containerView:UIView!
    
    var teamData: TeamData!
    var clusterData: ClusterData!
    var selectedSnt: SNTData?
    var isTeamReport:Bool!
    
    var backButton : UIBarButtonItem!
    
    private lazy var teamRepVC: TeamRepDetailViewController = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamrepdetailsvc) as! TeamRepDetailViewController
        viewController.teamData = self.teamData
        viewController.clusterData = self.clusterData
        viewController.selectedSnt = self.selectedSnt
        viewController.isTeamReport = self.isTeamReport
        
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var teamTrendVC: TeamTrendViewController = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamtrendvc) as! TeamTrendViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var teamCustomerInfoVC: TeamCustomerInfoViewController = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.teamcustomerinfovc) as! TeamCustomerInfoViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "REP DETAILED REPORT"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        updateView()
        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmenteAction(_ sender: UISegmentedControl)  {
        updateView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView() {
        
        switch segmntCntrl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: teamTrendVC)
            remove(asChildViewController: teamCustomerInfoVC)
            add(asChildViewController: teamRepVC)
        case 1:
            remove(asChildViewController: teamRepVC)
            remove(asChildViewController: teamCustomerInfoVC)
            add(asChildViewController: teamTrendVC)
        case 2:
            remove(asChildViewController: teamTrendVC)
            remove(asChildViewController: teamRepVC)
            add(asChildViewController: teamCustomerInfoVC)
        default:
            print("")
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
