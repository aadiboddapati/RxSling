//
//  TeamCustomerInfoCell.swift
//  RXSling
//
//  Created by chiranjeevi macharla on 13/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class TeamCustomerInfoCell: UITableViewCell {

    @IBOutlet weak var customerLbl:UILabel!
    @IBOutlet weak var sentTimeLabel: UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var lineLbl:UILabel!

    @IBOutlet weak var statusImageView:UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customerLbl.layer.addBorder(edge: .right, color: GREENCOLOUR, thickness: 2)
        sentTimeLabel.layer.addBorder(edge: .right, color: GREENCOLOUR, thickness: 2)
    }
    
    func configureCell(report:Report)  {
        
        customerLbl.attributedText = underlinedString(str: report.DoctorMobNo ?? "")
        
        if report.ContentViewed != nil {
            statusImageView.tintColor = .rxenabled
        } else {
            statusImageView.tintColor = .rxGray
        }
        // statusLabel.attributedText = ""
        if #available(iOS 13.0, *) {
            sentTimeLabel.text = getSentTimeInfo(report: report)
        } else {
             sentTimeLabel.text = getSentTimeForPreviousVersion(report: report)
        }
    }
    
    func underlinedString(str: String) -> NSAttributedString {
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.white, .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: str,  attributes: yourAttributes)
        return attributeString
        
    }

    @available(iOS 13.0, *)
    func getSentTimeInfo(report:Report) -> String {
        
        let date = Date(timeIntervalSince1970: (Double(report.CreatedDate!) / 1000.0))
         let formatter = RelativeDateTimeFormatter()
         formatter.localizedString(from: DateComponents(day: -1)) // "1 day ago"
         formatter.localizedString(from: DateComponents(hour: 2)) // "in 2 hours"
         formatter.localizedString(from: DateComponents(minute: 45)) // "in 45 minutes"
         formatter.dateTimeStyle = .named
         formatter.localizedString(from: DateComponents(day: -1))
         
         return formatter.string(for: date) ?? ""
    }
    
    func getSentTimeForPreviousVersion(report:Report) -> String {
        return Utility.timeAgoSinceDate(Double(report.CreatedDate!), currentDate: Date(), numericDates: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
