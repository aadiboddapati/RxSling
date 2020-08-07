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
    
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var sentTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var customerInfoTblView:UITableView!
    @IBOutlet weak var contentViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var searchViewheightConstraint:NSLayoutConstraint!
    @IBOutlet weak var customerSearchBar:UISearchBar!
    @IBOutlet weak var staticCustomerDetailsLabel:UILabel!
    var reportList: [Report]?
    var originalReportList:[Report]?
    var teamData: TeamData!
    var clusterData: ClusterReportData!
    var selectedSnt: SNTData?
    var isTeamReport:Bool!
    
    var searchViewheight: CGFloat = 60
    var minimumTableViewHeight: CGFloat = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear //UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        sentTimeLabel.layer.addBorder(edge: .left, color: GREENCOLOUR, thickness: 2)
        statusLabel.layer.addBorder(edge: .left, color: GREENCOLOUR, thickness: 2)

        configureSearchBar()
        contentViewHeightConstraint.constant = 200
        searchViewheightConstraint.constant = 0
        
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidLayoutSubviews() {
//        customerInfoTblView.reloadData()
//    }
    override func viewWillAppear(_ animated: Bool) {
        print(self.view.frame)
        if let _ = reportList {
            originalReportList = reportList
            removeTableBackgroundView()
            searchButton.isHidden = false
            customerInfoTblView.reloadData()
            applyHeightConstraint(sizeOfArray: reportList?.count ?? 0, isSearch: false)
        } else {
            searchButton.isHidden = true
            showNoRecordsFound()
        }
        
        staticCustomerDetailsLabel.text = "Customer Details".localizedString()
        customerLbl.text = "Customer".localizedString()
        sentTimeLabel.text = "Sent Time".localizedString()
        statusLabel.text = "Status".localizedString()
    }
    func configureSearchBar()  {
        
        let searchTextField:UITextField = (customerSearchBar.value(forKey: "searchField") as? UITextField)!
        searchTextField.tintColor = UIColor.white
        
        searchTextField.backgroundColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        searchTextField.rightViewMode = UITextField.ViewMode.always
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.textColor = UIColor.white
        customerSearchBar.barTintColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        customerSearchBar.tintColor = UIColor.white
        let image = UIImage()
        customerSearchBar.layer.borderColor = UIColor.clear.cgColor
        customerSearchBar.layer.borderWidth = 1
        customerSearchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        customerSearchBar.delegate = self
        customerSearchBar.returnKeyType = .default
    }
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func searchIconTapped(_ sender: UIButton) {
        customerSearchBar.becomeFirstResponder()
        searchViewheightConstraint.constant = (searchViewheightConstraint.constant == 40 ) ? 0 : 40
        
        if searchViewheightConstraint.constant == 0 {
            customerSearchBar.resignFirstResponder()
            customerSearchBar.text = ""
            removeTableBackgroundView()
            reportList = originalReportList
            customerInfoTblView.reloadData()
        }
        applyHeightConstraint(sizeOfArray: reportList?.count ?? 0, isSearch: (searchViewheightConstraint.constant == 0) ? false : true)
        
        
    }
    
    
    func applyHeightConstraint(sizeOfArray: Int, isSearch:Bool)  {
        DispatchQueue.main.async {
            if (isSearch == true) {
                
                if sizeOfArray == 0 {
                    self.contentViewHeightConstraint.constant = 200
                    return
                }
                let rowsHeight = CGFloat(sizeOfArray * 40)
                let reportListViewHeight = rowsHeight + self.minimumTableViewHeight + ( isSearch ? self.searchViewheight : CGFloat(0) ) + 40 // (40 customer details label height)
                
                if reportListViewHeight >= ( self.view.frame.height - self.searchViewheight ) {
                    self.contentViewHeightConstraint.constant = self.view.frame.height - (  self.searchViewheight )
                }else {
                    self.contentViewHeightConstraint.constant = reportListViewHeight
                    
                }
                
            } else {
                
                if sizeOfArray == 0 {
                    self.contentViewHeightConstraint.constant = 200
                    return
                }
                let rowsHeight = CGFloat(sizeOfArray * 40)
                let reportListViewHeight = rowsHeight + self.minimumTableViewHeight + 40 // (40 customer details height)
                if reportListViewHeight >= ( self.view.frame.height - self.minimumTableViewHeight ) {
                    self.contentViewHeightConstraint.constant = self.view.frame.height - self.searchViewheight
                }else {
                    self.contentViewHeightConstraint.constant = reportListViewHeight
                }
            }
        }
    }
    
}

extension TeamCustomerInfoViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCustomerInfoCell", for: indexPath) as! TeamCustomerInfoCell
        cell.selectionStyle = .none
        let templateImage = cell.statusImageView.image?.withRenderingMode(.alwaysTemplate)
        cell.statusImageView.image = templateImage
        cell.configureCell(report: reportList![indexPath.row])
        
        if indexPath.row == reportList!.count - 1 {
            cell.lineLbl.isHidden = true
        } else {
            cell.lineLbl.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func showNoRecordsFound() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: Int(self.customerInfoTblView.bounds.size.width), height: Int(self.customerInfoTblView.bounds.size.height)))
        label.backgroundColor = .clear
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No records found".localizedString()
        customerInfoTblView.backgroundView = label
        
    }
    func removeTableBackgroundView() {
        customerInfoTblView.backgroundView = nil
    }
    
    
}
extension TeamCustomerInfoViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            reportList = originalReportList
            removeTableBackgroundView()
            customerInfoTblView.reloadData()
            applyHeightConstraint(sizeOfArray: reportList?.count ?? 0, isSearch: true)
            return
        }
        
        let filteredData = reportList?.filter({ (report) -> Bool in
            return (report.DoctorMobNo ?? "").lowercased().contains(searchText.lowercased())
        })
        
        reportList = filteredData
        customerInfoTblView.reloadData()
        applyHeightConstraint(sizeOfArray: filteredData?.count ?? 0, isSearch: true)

        if filteredData?.count == 0 {
            showNoRecordsFound()
        } else {
            removeTableBackgroundView()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        reportList = originalReportList
        searchViewheightConstraint.constant = (searchViewheightConstraint.constant == 40 ) ? 0 : 40
        
        removeTableBackgroundView()
        customerInfoTblView.reloadData()
        
        applyHeightConstraint(sizeOfArray: reportList?.count ?? 0, isSearch: true)
        
    }
}

