//
//  TeamReportCell.swift
//  RXSling Stage
//
//  Created by chiranjeevi macharla on 06/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

protocol TeamReportCellDelegate: NSObjectProtocol {
    func toggleNameAndEmail(index:Int)
    func moreBtnAction(index:Int)
}
class TeamReportCell: UITableViewCell {
    
    
    @IBOutlet weak var emailIdLbl:UILabel!
    @IBOutlet weak var sentLbl:UILabel!
    @IBOutlet weak var viewedLbl:UILabel!
    @IBOutlet weak var successLbl:UILabel!
    @IBOutlet weak var moreLbl:UILabel!
    @IBOutlet weak var lineLbl: UILabel!
    
    weak var reportCellDelegate: TeamReportCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Do any additional setup after loading the view.

    }
    
    func configureFirstCell()  {
        emailIdLbl.isUserInteractionEnabled = false
        moreLbl.isUserInteractionEnabled = false
        
        emailIdLbl.textColor = UIColor.rxThickYellow
        sentLbl.textColor = UIColor.rxThickYellow
        viewedLbl.textColor = UIColor.rxThickYellow
        successLbl.textColor = UIColor.rxThickYellow
        moreLbl.textColor = UIColor.rxThickYellow
        
        emailIdLbl.text = "Email ID"
        moreLbl.text = "More"
        viewedLbl.text = "Viewed"
        successLbl.text = "Success %"
        sentLbl.text = "Sent"
        
        addBoarders()


    }
    
    func configureTheCellWith(team data: inout TeamData, indexPath: IndexPath)  {
             emailIdLbl.textColor = .white
             sentLbl.textColor = .white
             viewedLbl.textColor = .white
             successLbl.textColor = .white
             emailIdLbl.isUserInteractionEnabled = true
             moreLbl.isUserInteractionEnabled = true
             
             emailIdLbl.tag = indexPath.row
             moreLbl.tag = indexPath.row
            
             setupLabelsTapgesture()
        
        if let name = data.userData?.firstName, let lastName = data.userData?.lastName {
            if data.userData!.isShownEmail == false {
                let fullName = name + " " + lastName
                 emailIdLbl.attributedText = underlinedString(str: fullName)
            } else {
                emailIdLbl.attributedText = underlinedString(str: data.repEmailId ?? "")
            }
        } else {
            emailIdLbl.attributedText = underlinedString(str: data.repEmailId ?? "")
        }
        
        sentLbl.text =  "\(data.sentCount ?? 0)"
        viewedLbl.text =  "\(data.viewedCount ?? 0)"
        
        if sentLbl.text == "0" ||  viewedLbl.text == "0" {
            successLbl.text = "0%"
            data.successRate = Double(0)
        } else {
            let percentage =  ( Double (data.viewedCount!) / Double ( data.sentCount! ) ) * 100
            successLbl.text = String(format: "%.1f%@", percentage, "%") // ceil(percentage*100)/100
            data.successRate = percentage
        }
        moreLbl.attributedText = Utility.attributedImage(image: UIImage(named: "moresmll")!)
        moreLbl.contentMode = .scaleAspectFit
        addBoarders()

    }
    
   func configureTheCellWith(cluster data: inout ClusterReportData, indexPath: IndexPath) {
        
             emailIdLbl.textColor = .white
             sentLbl.textColor = .white
             viewedLbl.textColor = .white
             successLbl.textColor = .white
             emailIdLbl.isUserInteractionEnabled = true
             moreLbl.isUserInteractionEnabled = true
             
             emailIdLbl.tag = indexPath.row
             moreLbl.tag = indexPath.row
            
             setupLabelsTapgesture()
    
    if let name = data.userData?.firstName, let lastName = data.userData?.lastName {
        if data.userData!.isShownEmail == false {
            let fullName = name + " " + lastName
             emailIdLbl.attributedText = underlinedString(str: fullName)
        } else {
            emailIdLbl.attributedText = underlinedString(str: data.managerId ?? "")
        }
    } else {
        emailIdLbl.attributedText = underlinedString(str: data.managerId ?? "")
    }
    
    sentLbl.text =  "\(data.sentCount ?? 0)"
    viewedLbl.text =  "\(data.viewedCount ?? 0)"
    
    if sentLbl.text == "0" ||  viewedLbl.text == "0" {
        successLbl.text = "0%"
        data.successRate = Double(0)
    } else {
        let percentage =  ( Double (data.viewedCount!) / Double ( data.sentCount! ) ) * 100
        successLbl.text = String(format: "%.1f%@", percentage, "%") // ceil(percentage*100)/100
        data.successRate = percentage
    }
    moreLbl.attributedText = Utility.attributedImage(image: UIImage(named: "moresmll")!)
    moreLbl.contentMode = .scaleAspectFit
    addBoarders()
    }
    
    
    @objc func emailLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        self.reportCellDelegate?.toggleNameAndEmail(index: index)
    }
    
    @objc func moreLabelTapped(_ sender: UITapGestureRecognizer) {
         guard let index = sender.view?.tag else { return }
        self.reportCellDelegate?.moreBtnAction(index: index)
    }
    
    func setupLabelsTapgesture() {
        
        emailIdLbl.gestureRecognizers?.removeAll()
        moreLbl.gestureRecognizers?.removeAll()
        
        let emailLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.emailLabelTapped(_:)))
        emailIdLbl.addGestureRecognizer(emailLabelTap)
        
        
        let moreLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.moreLabelTapped(_:)))
        moreLbl.addGestureRecognizer(moreLabelTap)
        
    }
    
    func addBoarders()  {
        
        sentLbl.layer.sublayers?.removeAll()
        viewedLbl.layer.sublayers?.removeAll()
        successLbl.layer.sublayers?.removeAll()
        moreLbl.layer.sublayers?.removeAll()
        
        sentLbl.layer.addBorder(edge: .left, color: GREENCOLOUR, thickness: 2)
        sentLbl.layer.addBorder(edge: .right, color: GREENCOLOUR, thickness: 2)
        viewedLbl.layer.addBorder(edge: .right, color: GREENCOLOUR, thickness: 2)
        moreLbl.layer.addBorder(edge: .left, color: GREENCOLOUR, thickness: 2)

    }

    func underlinedString(str: String) -> NSAttributedString {
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.white, .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: str,  attributes: yourAttributes)
        return attributeString
        
    }    
        override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
