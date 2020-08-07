//
//  DashboardTableCell.swift
//  RXSling
//
//  Created by Manish Ranjan on 27/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

protocol DashboardCellDelegate {
    
    func didTapPlay(snt: SNTData)
    func didTapShare(snt: SNTData)
    func didTapReport(snt: SNTData)
    func didTapReportDetail(snt: SNTData)
    
}


class DashboardTableCell: UITableViewCell {
    
    @IBOutlet weak var sntBackgroundView:UIView!
    @IBOutlet weak var sntImage:UIImageView!
    @IBOutlet weak var sntImageTopBlurView:UIView!
    @IBOutlet weak var sntImageTopBlurViewLabel:UILabel!
    @IBOutlet weak var sntTitle:UILabel!
    @IBOutlet weak var sntDescription:UILabel!
    @IBOutlet weak var sntPlayBtn:UIButton!
    @IBOutlet weak var sntShareBtn:UIButton!
    @IBOutlet weak var reportButton:UIButton!
    
    var snt: SNTData!
    var cellDelegate: DashboardCellDelegate?

    @IBAction func reportTapped(_ sender: UIButton) {
        cellDelegate?.didTapReport(snt: snt)
    }
    @IBAction func reportDetailTapped(_ sender: UIButton) {
        cellDelegate?.didTapReportDetail(snt: snt)
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
           cellDelegate?.didTapPlay(snt: snt)
        let oldColor = sender.backgroundColor
          UIView.animate(withDuration: 0.5, animations: {
              sender.backgroundColor = UIColor(red: 99/255, green: 127/255, blue: 89/255, alpha: 0.5)
                }, completion: { _ in
                  UIView.animate(withDuration: 0.5) {
                      sender.backgroundColor = oldColor
                  }
          })
       }
    
    @IBAction func shareTapped(_ sender: UIButton) {
      //  let oldColor = sender.backgroundColor
        
        sender.setTitleColor( UIColor(red: 99/255, green: 127/255, blue: 89/255, alpha: 0.5), for:  UIControl.State.selected)
        
//        UIView.animate(withDuration: 0.5, animations: {
//            sender.backgroundColor = UIColor(red: 99/255, green: 127/255, blue: 89/255, alpha: 0.1)
//            }, completion: { _ in
//                UIView.animate(withDuration: 0.5) {
//                    sender.backgroundColor = oldColor
//                }
//        })
        cellDelegate?.didTapShare(snt: snt)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        sntImageTopBlurView.backgroundColor = .clear
        
        Utility.setBlurViewOn(sntImageTopBlurView)
        sntImageTopBlurView.bringSubviewToFront(sntImageTopBlurViewLabel)
        
        sntBackgroundView.clipsToBounds = true
        sntBackgroundView.layer.borderColor = GREENCOLOUR.cgColor
        sntBackgroundView.layer.borderWidth = 2
        sntBackgroundView.layer.cornerRadius = 10
        sntBackgroundView.backgroundColor = .clear
        
        sntImage.contentMode = .scaleAspectFill
        sntImage.layer.cornerRadius = 10
        
        reportButton.tintColor = UIColor.red
      
        
    }  
   
    func setSntDetailsToCell(_ sntData: SNTData){
        
        snt = sntData
        sntImage.image = #imageLiteral(resourceName: "snt_default_image")
        sntImage.load(url: URL(string: snt.thumbnailURL)!)
        sntTitle.text = snt.title
        sntDescription.text = snt.desc
        sntImageTopBlurViewLabel.text = Utility.timeAgoSinceDate(snt.createdDate, currentDate: Date(), numericDates: true)
         let selfReport = UserDefaults.standard.bool(forKey: "USER_SELFREPORT")
     
        if (snt.showReport == true && selfReport == true){
         reportButton.isHidden = false
         } else {
             reportButton.isHidden = true
        }
        
        sntPlayBtn.setTitle("Play".localizedString(), for: .normal)
        sntShareBtn.setTitle("Share".localizedString() , for: .normal)
        reportButton.isHidden = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        reportButton.tintColor = UIColor.black
    }
    
}
