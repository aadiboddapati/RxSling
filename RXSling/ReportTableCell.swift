//
//  ReportTableCell.swift
//  RXSling Stage
//
//  Created by Vivek on 6/5/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit
protocol ReportCellDelegate {
    
    func didTapInfo(reportsnt: Report)
    func didTapNumber(number: String)
}

class ReportTableCell: UITableViewCell {
    
    var reportcellDelegate: ReportCellDelegate?
    var snt: Report!
    
    @IBOutlet weak var customerNumberBtn:UIButton!
    @IBOutlet weak var sentTimeLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var statusView:UIImageView!
    @IBOutlet weak var libeView: UIView!
    
    @IBAction func infoTapped(_ sender: UIButton) {
        reportcellDelegate?.didTapInfo(reportsnt: snt)
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        print(sender.titleLabel?.text)
        let indexPath: IndexPath!
        //        let cell = sender.superview?.superview?.superview?.superview
        //    indexPath = self.tblView.indexPath(for: cell!)! as IndexPath?
        reportcellDelegate?.didTapNumber(number: (sender.titleLabel?.text)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @available(iOS 13.0, *)
    func setreportDetailsToCell(_ sntData: Report, lastIndex: Int, byNumber: Bool, toggleClicked: Bool){
        snt = sntData
        
        if sntData.ContentViewed != nil {
            
            statusView.tintColor = UIColor.rxenabled
        } else {
            statusView.tintColor = UIColor.rxGray
        }
        if ( lastIndex == 1) {
            libeView.isHidden = true
        } else {
            libeView.isHidden = false
        }
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        if (byNumber == true) {
            if (sntData.displayByNumber == true) {
                let attributeString1 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                 attributes: yourAttributes)
                customerNumberBtn.setAttributedTitle(attributeString1, for: UIControl.State.normal)
            } else {
                if sntData.CustomerName != nil {
                    let attributeString2 = NSMutableAttributedString(string: sntData.CustomerName ?? "",
                                                                     attributes: yourAttributes)
                    customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)
                } else if sntData.centralContatName != nil{
                    let attributeString2 = NSMutableAttributedString(string: sntData.centralContatName ?? "",
                                                                     attributes: yourAttributes)
                    customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)

                } else {
                    if (toggleClicked == true) {
                        
                        let attributeString2 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                         attributes: yourAttributes)
                        customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)
                        DispatchQueue.main.async {
                            
                            self.reportcellDelegate?.didTapNumber(number: sntData.DoctorMobNo ?? "")
                        }
                    } else {
                        let attributeString2 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                         attributes: yourAttributes)
                        customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)
                    }
                }
            }
            
        } else {
            if (sntData.displayByNumber == true ) {
                let attributeString3 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                 attributes: yourAttributes)
                customerNumberBtn.setAttributedTitle(attributeString3, for: UIControl.State.normal)
                //   customerNumberBtn.setTitle(sntData.DoctorMobNo ?? "", for: UIControl.State.normal)
            } else {
                if sntData.CustomerName != nil {
                    let attributeString4 = NSMutableAttributedString(string: sntData.CustomerName ?? "", attributes: yourAttributes)
                    customerNumberBtn.setAttributedTitle(attributeString4, for: UIControl.State.normal)
                } else if sntData.centralContatName != nil{
                    let attributeString2 = NSMutableAttributedString(string: sntData.centralContatName ?? "",
                                                                     attributes: yourAttributes)
                    customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)

                } else {
                    if (toggleClicked == true) {
                        
                        let attributeString2 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                         attributes: yourAttributes)
                        customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)
                        DispatchQueue.main.async {
                            
                            self.reportcellDelegate?.didTapNumber(number: sntData.DoctorMobNo ?? "")
                        }
                    } else {
                        let attributeString2 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                         attributes: yourAttributes)
                        customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)
                    }
                }
                //    customerNumberBtn.setTitle(sntData.CustomerName ?? "", for: UIControl.State.normal)
                
            }
        }
        
        let date = Date(timeIntervalSince1970: (Double(sntData.CreatedDate!) / 1000.0))
        
        let formatter = RelativeDateTimeFormatter()
        
        formatter.localizedString(from: DateComponents(day: -1)) // "1 day ago"
        formatter.localizedString(from: DateComponents(hour: 2)) // "in 2 hours"
        formatter.localizedString(from: DateComponents(minute: 45)) // "in 45 minutes"
        formatter.dateTimeStyle = .named
        formatter.localizedString(from: DateComponents(day: -1))
        
        sentTimeLabel.text = formatter.string(for: date)
        
    }
    
    func setDetailsToCell(_ sntData: Report, lastIndex: Int, byNumber: Bool, toggleClicked: Bool){
        snt = sntData
        
        
        if sntData.ContentViewed != nil {
            statusView.tintColor = UIColor.rxenabled
        } else {
            statusView.tintColor = UIColor.rxdisabled
        }
        
        if ( lastIndex == 1) {
            libeView.isHidden = true
        } else {
            libeView.isHidden = false
        }
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        if (byNumber == true) {
            if (sntData.displayByNumber == true) {
                let attributeString1 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                 attributes: yourAttributes)
                customerNumberBtn.setAttributedTitle(attributeString1, for: UIControl.State.normal)
            } else {
                if sntData.CustomerName != nil {
                    let attributeString2 = NSMutableAttributedString(string: sntData.CustomerName ?? "",
                                                                     attributes: yourAttributes)
                    customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)
                } else if sntData.centralContatName != nil{
                    let attributeString2 = NSMutableAttributedString(string: sntData.centralContatName ?? "",
                                                                     attributes: yourAttributes)
                    customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)

                } else {
                    if (toggleClicked == true) {
                        
                        let attributeString2 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                         attributes: yourAttributes)
                        customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)
                        DispatchQueue.main.async {
                            //    guard let phonenumber = number else {return}
                            //      showToast(message: "There is no contact available for this Number '\(phonenumber)' ", view: self.view.)
                            self.reportcellDelegate?.didTapNumber(number: sntData.DoctorMobNo ?? "")
                        }
                    } else {
                        let attributeString2 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                         attributes: yourAttributes)
                        customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)
                    }
                }
            }
            
        } else {
            if (sntData.displayByNumber == true) {
                let attributeString3 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "",
                                                                 attributes: yourAttributes)
                customerNumberBtn.setAttributedTitle(attributeString3, for: UIControl.State.normal)
                //   customerNumberBtn.setTitle(sntData.DoctorMobNo ?? "", for: UIControl.State.normal)
            } else {
                if sntData.CustomerName != nil {
                    let attributeString4 = NSMutableAttributedString(string: sntData.CustomerName ?? "", attributes: yourAttributes)
                    customerNumberBtn.setAttributedTitle(attributeString4, for: UIControl.State.normal)
                } else if sntData.centralContatName != nil{
                    let attributeString2 = NSMutableAttributedString(string: sntData.centralContatName ?? "",
                                                                     attributes: yourAttributes)
                    customerNumberBtn.setAttributedTitle(attributeString2, for: UIControl.State.normal)

                } else {
                    if (toggleClicked == true) {
                        
                        let attributeString4 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "", attributes: yourAttributes)
                        customerNumberBtn.setAttributedTitle(attributeString4, for: UIControl.State.normal)
                        DispatchQueue.main.async {
                            //    guard let phonenumber = number else {return}
                            //      showToast(message: "There is no contact available for this Number '\(phonenumber)' ", view: self.view.)
                            self.reportcellDelegate?.didTapNumber(number: sntData.DoctorMobNo ?? "")
                        }
                    } else {
                        let attributeString4 = NSMutableAttributedString(string: sntData.DoctorMobNo ?? "", attributes: yourAttributes)
                        customerNumberBtn.setAttributedTitle(attributeString4, for: UIControl.State.normal)
                    }
                }
                
            }
        }
        
        
        
        
        
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: (Double(sntData.CreatedDate!) / 1000.0))
        print("date - \(date)")
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
        let day = components.day!
        if abs(day) < 2 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            //  sentTimeLabel.text = formatter.string(from: date)
        } else if day > 1 {
            //  sentTimeLabel.text = "In \(day) days"
        } else {
            //  sentTimeLabel.text = "\(-day) days ago"
        }
        
        sentTimeLabel.text = Utility.timeAgoSinceDate(Double(sntData.CreatedDate!), currentDate: Date(), numericDates: true)
        
        
        
    }
    
    
    
}
