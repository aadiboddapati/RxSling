//
//  Utility.swift
//  RXSling
//
//  Created by Manish Ranjan on 27/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import Foundation
import UIKit

class Utility:NSObject{
    
    
    static func showAlertWith(message:String, inView vc: UIViewController) -> Void {
        
        let alert = UIAlertController(title: Constants.Alert.title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction (title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        alert.view.tintColor = .rxGreen
    
    }
    
    static func showAlertWithHandler(message:String, alertButtons:Int, buttonTitle:String, inView vc: UIViewController, completion: @escaping (Bool) -> ())
    {
        
        let alert = UIAlertController(title: Constants.Alert.title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: buttonTitle, style: .default, handler: { alert -> Void in
            
            completion(true)
            
        })
        
        if(alertButtons == 2){
            
            let no = UIAlertAction(title: "No", style: .default, handler: { alert -> Void in
                
                completion(false)
                
            })
            alert.addAction(no)
        }
        
        alert.addAction(yes)
        vc.present(alert, animated: true, completion: nil)
        alert.view.tintColor = .rxGreen
        
    }
   static func attributedImage(image:UIImage) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: "")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = image
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        return fullString
    }
    
    //Move below method to Global or Utility Class
   static func timeAgoSinceDate(_ apiDate:Double, currentDate:Date, numericDates:Bool) -> String {
        
        let fromDate = Date(timeIntervalSince1970:(apiDate / 1000.0))
        
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(fromDate)
        let latest = (earliest == now) ? fromDate : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    
    static func setBlurViewOn(_ view:UIView){
          
          let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
          let blurEffectView = UIVisualEffectView(effect: blurEffect)
          blurEffectView.frame = view.bounds
          blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //blurEffectView.roundCorners(corners: [.topLeft, .topRight], radius: 10, view: view)
          view.addSubview(blurEffectView)

      }
    
    static func addRightBorders(target:UIView) {
       let thickness: CGFloat = 2.0
       let rightBorder = CALayer()
       rightBorder.frame = CGRect(x:target.frame.size.height - thickness, y: 0, width: 1, height:target.frame.size.height)
        rightBorder.backgroundColor = GREENCOLOUR.cgColor
       target.layer.addSublayer(rightBorder)
    }
    
  
}

extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height )
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor;

        self.addSublayer(border)
    }

}
extension UIView {
     func roundCorners(corners:UIRectCorner, radius: CGFloat, view:UIView) {
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
}
