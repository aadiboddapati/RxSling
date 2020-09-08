//
//  DoctorDetailInfoVC.swift
//  RXSling Stage
//
//  Created by Aadi on 03/09/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit



class DoctorDetailInfoVC: UIViewController {

    @IBOutlet weak var doctorDetailTableView: UITableView!
    @IBOutlet weak var doctorNameLbl:UILabel!
    
    var doctorsList: [DoctorList]?
    var doctorName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorDetailTableView.tableFooterView = UIView()
        doctorNameLbl.text = doctorName ?? ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension DoctorDetailInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return doctorsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        let doctorData = doctorsList![indexPath.row]
        
        if indexPath.section == 0 {
            cell.sentTimeLbl.text = "Sent Time"
            cell.viewedTimeLbl.text = "Viewed Time"
            cell.serialNumberLbl.text = "SL No"
            
            cell.sentTimeLbl.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            cell.viewedTimeLbl.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            cell.serialNumberLbl.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        } else {
            cell.serialNumberLbl.text = "\(indexPath.row + 1)"
            cell.configureCell(data: doctorData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
}

class InfoCell: UITableViewCell {
    
    @IBOutlet weak var serialNumberLbl:UILabel!
    @IBOutlet weak var sentTimeLbl:UILabel!
    @IBOutlet weak var viewedTimeLbl:UILabel!
    
    override func awakeFromNib() {
        sentTimeLbl.layer.addBorder(edge: .left, color: .rxGreen, thickness: 2)
        viewedTimeLbl.layer.addBorder(edge: .left, color: .rxGreen, thickness: 2)
    }

    
    func configureCell(data:DoctorList)  {
        
        sentTimeLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        viewedTimeLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        serialNumberLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        
        let (_, sentDate) = convertTimestampToDate(timestamp: data.CreatedDate ?? 0)
        sentTimeLbl.text = sentDate
        
        if let viewdDate = data.viewTimeStamp {
            if viewdDate != 0 {
                let (_, viewdDate) = convertTimestampToDate(timestamp: viewdDate)
                viewedTimeLbl.text = viewdDate
            } else {
                viewedTimeLbl.text = "Not Viewed"
            }
        } else {
            viewedTimeLbl.text = "Not Viewed"
        }
    }
    
    func convertTimestampToDate(timestamp:Double) -> (Date, String)  {
        
        let date = Date(timeIntervalSince1970: (Double( timestamp) / 1000.0))

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "hh:mm a, dd-MMM-yy"
        let dateString = dateFormatter.string(from: date)
        return (date , dateString)
    }

}
