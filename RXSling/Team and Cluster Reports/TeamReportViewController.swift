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
    @IBOutlet weak var contentViewheightConstraint:NSLayoutConstraint!
    @IBOutlet weak var searchViewheightConstraint:NSLayoutConstraint!
    @IBOutlet weak var reportSearchBar: UISearchBar!
    @IBOutlet weak var reportsTable:UITableView!
    
    @IBOutlet weak var reportInfoLabel:UILabel!
    @IBOutlet weak var asOnDateLabel:UILabel!
    @IBOutlet weak var asOnDateLabelheightConstraint:NSLayoutConstraint!

    
    var teamReports:TeamReportModel!
    var clusterReports: ClusterReportModel!
    var originalTeamReports:TeamReportModel!
    var originalClusterReports: ClusterReportModel!
    
    var isTeamReport:Bool!
    var selectedSnt: SNTData?
    var fixedHeight: CGFloat = 55
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportBackImage.png")!)
        //  scroller.contentSize.height = 1.0
        self.title = isTeamReport ? "TEAM INFORMATION" : "MANAGER REPORT"
        self.reportInfoLabel.text = isTeamReport ? "Your Team Report" : "Your Cluster Report"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
        
        reportSearchBar.delegate = self
        reportSearchBar.layer.borderWidth = 0.5
        configureSearchBar()
        
        if let teamModel = teamReports {
            originalTeamReports = teamModel
        }
        if let clusterModel = clusterReports {
            originalClusterReports = clusterModel
        }
        
        if isTeamReport {
            asOnDateLabelheightConstraint.constant = 0
        } else {
            asOnDateLabelheightConstraint.constant = 20
            let date = Date(timeIntervalSince1970:(Double((clusterReports.data?.asonDate)!) / 1000.0))
            asOnDateLabel.text = "as on " + getDate(date: date)

        }
        contentViewheightConstraint.constant = 300 // calculate based on the array and search view constraints
        applyListViewHeightConstraint(sizeOfArray: isTeamReport ? ( teamReports.data?.count )! : ( clusterReports.data?.clusterReport?.count )!, isSearch: false)
        
        
    }
    
    func applyListViewHeightConstraint(sizeOfArray: Int, isSearch:Bool)  {
        DispatchQueue.main.async {
            
            if sizeOfArray == 0 {
                self.contentViewheightConstraint.constant = 300
                return
            }
            let rowsHeight = CGFloat(sizeOfArray * 35) + 35 // (extra row)
            var reportListViewHeight = rowsHeight
            
            if self.searchViewheightConstraint.constant == 40 {
                reportListViewHeight += 40
            }
            
            if !self.isTeamReport {
                 reportListViewHeight += 20
            }
            
            if reportListViewHeight + self.fixedHeight >=  self.view.frame.height {
                self.contentViewheightConstraint.constant = self.view.frame.height - (  self.fixedHeight + 20 )
            } else {
                self.contentViewheightConstraint.constant = reportListViewHeight + self.fixedHeight
            }
        }
    }

    override func viewDidLayoutSubviews() {
        reportsTable.reloadData()
    }
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchIconTapped(_ sender: UIButton) {
        reportSearchBar.becomeFirstResponder()
        searchViewheightConstraint.constant = (searchViewheightConstraint.constant == 40 ) ? 0 : 40
        
        if searchViewheightConstraint.constant == 0 {
            reportSearchBar.resignFirstResponder()
            reportSearchBar.text = ""
            teamReports = originalTeamReports
            reportsTable.reloadData()
        }
        applyListViewHeightConstraint(sizeOfArray: isTeamReport ? ( teamReports.data?.count )! : ( clusterReports.data?.clusterReport?.count )!, isSearch: false)
    }
    func configureSearchBar()  {
        
        let searchTextField:UITextField = (reportSearchBar.value(forKey: "searchField") as? UITextField)!
        searchTextField.tintColor = UIColor.white
        
        searchTextField.backgroundColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        searchTextField.rightViewMode = UITextField.ViewMode.always
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.textColor = UIColor.white
        reportSearchBar.barTintColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        reportSearchBar.tintColor = UIColor.white
        let image = UIImage()
        reportSearchBar.layer.borderColor = UIColor.clear.cgColor
        reportSearchBar.layer.borderWidth = 1
        reportSearchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        
        reportSearchBar.returnKeyType = .default
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

extension TeamReportViewController: UITableViewDelegate, UITableViewDataSource, TeamReportCellDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return  isTeamReport ? teamReports.data!.count  : clusterReports.data!.clusterReport!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! TeamReportCell
        cell.selectionStyle = .none
        cell.reportCellDelegate = self
        
        if indexPath.section == 0 {
            cell.configureFirstCell()
            return cell
        }
        
        if isTeamReport {
            cell.configureTheCellWith(team: teamReports.data![indexPath.row], indexPath: indexPath)
            if indexPath.row == teamReports.data!.count - 1 {
                cell.lineLbl.isHidden = true
            } else {
                cell.lineLbl.isHidden = false
            }
        } else {
            cell.configureTheCellWith(cluster: clusterReports.data!.clusterReport![indexPath.row], indexPath: indexPath)
            if indexPath.row == clusterReports.data!.clusterReport!.count - 1 {
                cell.lineLbl.isHidden = true
            } else {
                cell.lineLbl.isHidden = false
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  35 //UITableView.automaticDimension
    }
    
    // cell delegate methods
    func toggleNameAndEmail(index: Int) {
        
        if let userData = isTeamReport ? teamReports.data?[index].userData  : clusterReports.data?.clusterReport?[index].userData {
            if let boolValue = userData.isShownEmail {
                if isTeamReport {
                    self.teamReports.data?[index].userData?.isShownEmail = !boolValue
                }else {
                    self.clusterReports.data?.clusterReport?[index].userData?.isShownEmail = !boolValue
                }
            } else {
                if isTeamReport {
                    self.teamReports.data?[index].userData?.isShownEmail = false
                } else {
                    self.clusterReports.data?.clusterReport?[index].userData?.isShownEmail = false
                }
            }
            reportsTable.reloadData()
        } else {
            showActivityIndicator(View: self.view, Constants.Loader.reportDetails)
            let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
            let userEmail = isTeamReport ? teamReports.data?[index].repEmailId ?? "" : clusterReports.data?.clusterReport?[index].managerId ?? ""
            let parameters:[String : String] =
                ["emailId": userEmail,
                 "mobileNo": ""]
            _ = HTTPRequest.sharedInstance.request(url: Constants.Api.userInfo, method: "POST", params: parameters, header: header, completion: { (response, error) in
                DispatchQueue.main.async {
                    hideActivityIndicator(View: self.view)
                }
                if error != nil
                {
                    DispatchQueue.main.async {
                        self.popupAlert(title: Constants.Alert.title, message: error?.description, actionTitles: ["Ok"], actions:[{action in},nil])
                    }
                }else {
                    let jsonData = try! JSONSerialization.data(withJSONObject: response!, options: [])
                    let userInfo = try! JSONDecoder().decode(UserInfo.self, from: jsonData)
                    print(userInfo.data as Any)
                    if self.isTeamReport {
                        self.teamReports.data?[index].userData = userInfo.data
                        self.teamReports.data?[index].userData?.isShownEmail = false
                    } else {
                        self.clusterReports.data?.clusterReport?[index].userData = userInfo.data
                        self.clusterReports.data?.clusterReport?[index].userData?.isShownEmail = false
                    }
                    
                    DispatchQueue.main.async {
                        self.reportsTable.reloadData()
                    }
                    
                }
                
            })
        }
    }
    
    func moreBtnAction(index: Int) {
        if isTeamReport {
            if let _ = teamReports.data?[index].userData {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.segmentvc) as! SegmentedViewController
                vc.teamData = teamReports.data?[index]
                vc.selectedSnt = selectedSnt
                vc.isTeamReport = isTeamReport
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.getUserData(index: index)
            }
        } else {
            if let _ = clusterReports.data?.clusterReport?[index].userData {
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.segmentvc) as! SegmentedViewController
                    vc.clusterData = self.clusterReports.data?.clusterReport?[index]
                    
                    vc.selectedSnt = self.selectedSnt
                    vc.isTeamReport = self.isTeamReport
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self.getUserData(index: index)
            }
            
        }
    }
    
    
    func getUserData(index:Int) {
        showActivityIndicator(View: self.view, Constants.Loader.reportDetails)
        let header = "\(USERDEFAULTS.value(forKey: "TOKEN")!)"
        let userEmail = isTeamReport ? teamReports.data?[index].repEmailId ?? "" : clusterReports.data?.clusterReport?[index].managerId ?? ""
        let parameters:[String : String] =
            ["emailId": userEmail,
             "mobileNo": ""]
        _ = HTTPRequest.sharedInstance.request(url: Constants.Api.userInfo, method: "POST", params: parameters, header: header, completion: { (response, error) in
            DispatchQueue.main.async {
                hideActivityIndicator(View: self.view)
            }
            if error != nil
            {
                DispatchQueue.main.async {
                    self.popupAlert(title: Constants.Alert.title, message: error?.description, actionTitles: ["Ok"], actions:[{action in},nil])
                }
            }else {
                let jsonData = try! JSONSerialization.data(withJSONObject: response!, options: [])
                let userInfo = try! JSONDecoder().decode(UserInfo.self, from: jsonData)
                print(userInfo.data as Any)
                if self.isTeamReport {
                    self.teamReports.data?[index].userData = userInfo.data
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.segmentvc) as! SegmentedViewController
                        vc.teamData = self.teamReports.data?[index]
                        vc.selectedSnt = self.selectedSnt
                        vc.isTeamReport = self.isTeamReport
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    self.clusterReports.data?.clusterReport?[index].userData = userInfo.data
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboadId.segmentvc) as! SegmentedViewController
                        vc.clusterData = self.clusterReports.data?.clusterReport?[index]
                        vc.selectedSnt = self.selectedSnt
                        vc.isTeamReport = self.isTeamReport
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
               
            }
            
        })
    }
    
}

extension TeamReportViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            if isTeamReport {
                teamReports = originalTeamReports
            } else {
                clusterReports = originalClusterReports
            }
            removeTableBackgroundView()
            reportsTable.reloadData()
            applyListViewHeightConstraint(sizeOfArray: isTeamReport ? ( teamReports.data?.count )! : ( clusterReports.data?.clusterReport?.count )!, isSearch: false)

            return
        }
        
        if isTeamReport {
            let filteredData = teamReports.data?.filter({ (teamData) -> Bool in
                if let usrData = teamData.userData {
                    let fullName = ( usrData.firstName ?? "" ) + " " + ( usrData.lastName ?? "" )
                    return teamData.repEmailId!.lowercased().contains(searchText.lowercased()) || fullName.lowercased().contains(searchText.lowercased())
                    
                } else {
                    return teamData.repEmailId!.lowercased().contains(searchText.lowercased())
                }
            })
            teamReports.data = filteredData
            reportsTable.reloadData()
            
            applyListViewHeightConstraint(sizeOfArray: isTeamReport ? ( teamReports.data?.count )! : ( clusterReports.data?.clusterReport?.count )!, isSearch: true)
            
            if filteredData?.count == 0 {
                showNoRecordsFound()
            } else {
                removeTableBackgroundView()
            }
        } else {
            let filteredData = clusterReports.data?.clusterReport?.filter({ (teamData) -> Bool in
                if let usrData = teamData.userData {
                    let fullName = ( usrData.firstName ?? "" ) + " " + ( usrData.lastName ?? "" )
                    return teamData.managerId!.lowercased().contains(searchText.lowercased()) || fullName.lowercased().contains(searchText.lowercased())
                    
                } else {
                    return teamData.managerId!.lowercased().contains(searchText.lowercased())
                }
            })
            clusterReports.data?.clusterReport = filteredData
            reportsTable.reloadData()
            
            applyListViewHeightConstraint(sizeOfArray: isTeamReport ? ( teamReports.data?.count )! : ( clusterReports.data?.clusterReport?.count )!, isSearch: false)
            
            if filteredData?.count == 0 {
                showNoRecordsFound()
            } else {
                removeTableBackgroundView()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        reportSearchBar.resignFirstResponder()
        
        if isTeamReport {
            teamReports = originalTeamReports
        } else {
            clusterReports = originalClusterReports
        }
        
        searchViewheightConstraint.constant = (searchViewheightConstraint.constant == 40 ) ? 0 : 40
        
        removeTableBackgroundView()
        reportsTable.reloadData()
        
        applyListViewHeightConstraint(sizeOfArray: isTeamReport ? ( teamReports.data?.count )! : ( clusterReports.data?.clusterReport?.count )!, isSearch: false)
        
    }
    
    func showNoRecordsFound() {
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: Int(self.reportsTable.bounds.size.width), height: Int(self.reportsTable.bounds.size.height) - 20))
        label.backgroundColor = .clear
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No records found"
        reportsTable.backgroundView = label
        
    }
    func removeTableBackgroundView() {
        reportsTable.backgroundView = nil
    }
    
    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a ',' dd-MMM-yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        let dateString = formatter.string(from: Date())
        return dateString
    }
    
}
