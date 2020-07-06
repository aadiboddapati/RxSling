//
//  Global.swift
//  RXSling
//
//  Created by Divakara Y N. on 23/03/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration


var USERDEFAULTS = UserDefaults.standard

var isFirstTimeLogin = false
var activityIndicator: UIActivityIndicatorView?;
var strLabel = UILabel()

var effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.regular))

func showActivityIndicator(View:UIView,_ title: String) {
    UIApplication.shared.beginIgnoringInteractionEvents()
    
    strLabel.removeFromSuperview()
    effectView.removeFromSuperview()
    strLabel = UILabel(frame: CGRect(x: 70, y: 0, width: View.frame.width - 110, height: 70))
    strLabel.text = title
    strLabel.font = .systemFont(ofSize: 14, weight: .medium)
    strLabel.textColor = UIColor.black
    strLabel.lineBreakMode = .byWordWrapping
    strLabel.numberOfLines = 2
   if UIDevice.current.userInterfaceIdiom == .pad {
    effectView.frame = CGRect(x: 80, y: (View.frame.height/2)-10, width:  View.frame.width - 160, height: 75)
   } else {
    effectView.frame = CGRect(x: 20, y: (View.frame.height/2)-10, width:  View.frame.width - 40, height: 75) }
    effectView.backgroundColor = UIColor.white
    effectView.layer.cornerRadius = 2
    effectView.layer.masksToBounds = true
    
    activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator?.color = .rxGreen
    activityIndicator?.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
    
    activityIndicator?.startAnimating()
    effectView.contentView.addSubview(activityIndicator!)
    effectView.contentView.addSubview(strLabel)
    
    View.addSubview(effectView)
}
func hideActivityIndicator(View:UIView){
    DispatchQueue.main.async {
        UIApplication.shared.endIgnoringInteractionEvents()
        strLabel.removeFromSuperview()
        if((activityIndicator) != nil)
        {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            effectView.removeFromSuperview()
            activityIndicator = nil
            effectView = UIVisualEffectView()
        }
    }
}

func getDeviceID() -> String{
    let deviceToken = ""
    if let deviceToken = UIDevice.current.identifierForVendor?.uuidString {
        print("Device Token -> \(deviceToken)")
    }
    return deviceToken
}

func getAppVersion() -> String{
    var appVersion: String = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]{
        appVersion = String("\(version)")
        print("App Version -> \(appVersion)")
    }
    return appVersion
}

func showBarButtonItem(){
    let attributes = [NSAttributedString.Key.font:  UIFont(name: "Helvetica-Bold", size: 15.0)!, NSAttributedString.Key.foregroundColor: UIColor(red:86/255, green: 142/255, blue: 51/255, alpha: 1.0)]
    UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    UINavigationBar.appearance().tintColor = .rxGreen
}

func hideBarBUttomItem(){
    let attributes = [NSAttributedString.Key.font:  UIFont(name: "Helvetica-Bold", size: 0.1)!, NSAttributedString.Key.foregroundColor: UIColor(red:86/255, green: 142/255, blue: 51/255, alpha: 1.0)]
    UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
}

@IBDesignable public class ovalButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height/2
        layer.backgroundColor = UIColor(red:86/255, green: 142/255, blue: 51/255, alpha: 1.0).cgColor
        clipsToBounds = true
    }
}

@IBDesignable
class TextField: UITextField,UITextFieldDelegate {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    @IBInspectable var placeHolderText: String?
    @IBInspectable var borderColor: UIColor? = UIColor.white{
      
        
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
        
       
    }
    
    @IBInspectable var backgroundColour: UIColor? = UIColor.clear{
        didSet {
            layer.backgroundColor = borderColor?.cgColor
        }
    }
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        //        layer.backgroundColor = UIColor.clear.cgColor
        //        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.2
        layer.cornerRadius = 12
        layer.masksToBounds = true
        if let _ = placeHolderText
        {
            let attributedPlaceholder = NSMutableAttributedString(string: placeHolderText!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
            self.attributedPlaceholder = attributedPlaceholder
        }
        if let _ = borderColor{
            self.layer.borderColor = borderColor?.cgColor
        }
        if let _ = backgroundColour{
            self.layer.backgroundColor = backgroundColour?.cgColor
        }
    }
}

func showToast(message:String,view:UIView)
{
    let text = message + "\n"
    let size = text.size(withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12.5)])
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 130, y: view.frame.size.height-100, width: 260, height: size.height))
    toastLabel.backgroundColor = UIColor.black
    toastLabel.textColor = UIColor.white
    toastLabel.font = UIFont.systemFont(ofSize: 12.5)
    toastLabel.numberOfLines = 0
    toastLabel.lineBreakMode = .byWordWrapping
    toastLabel.textAlignment = NSTextAlignment.center;
    view.addSubview(toastLabel)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = size.height/2;
    toastLabel.clipsToBounds  =  true
    UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
        
        toastLabel.alpha = 0.0
        
    }, completion: nil)
    
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let trimeedStr = testStr.trimmingCharacters(in: .whitespacesAndNewlines)
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: trimeedStr)
}

func isValidPassword(testStr:String) -> Bool{
    print("validate Password: \(testStr)")
    let trimeedStr = testStr.trimmingCharacters(in: .whitespacesAndNewlines)
    let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%?&#^])[A-Za-z\\d@$!%?&#^]{8,}$"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    print(passwordTest.evaluate(with: trimeedStr))
    return passwordTest.evaluate(with: trimeedStr)
}

public extension UIDevice {
  static let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    func mapToDevice(identifier: String) -> String {
      #if os(iOS)
      switch identifier {
      case "iPod5,1":                                 return "iPod Touch 5"
      case "iPod7,1":                                 return "iPod Touch 6"
      case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
      case "iPhone4,1":                               return "iPhone 4s"
      case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
      case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
      case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
      case "iPhone7,2":                               return "iPhone 6"
      case "iPhone7,1":                               return "iPhone 6 Plus"
      case "iPhone8,1":                               return "iPhone 6s"
      case "iPhone8,2":                               return "iPhone 6s Plus"
      case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
      case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
      case "iPhone8,4":                               return "iPhone SE"
      case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
      case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
      case "iPhone10,3", "iPhone10,6":                return "iPhone X"
      case "iPhone11,2":                              return "iPhone XS"
      case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
      case "iPhone11,8":                              return "iPhone XR"
      case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
      case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
      case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
      case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
      case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
      case "iPad6,11", "iPad6,12":                    return "iPad 5"
      case "iPad7,5", "iPad7,6":                      return "iPad 6"
      case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
      case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
      case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
      case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
      case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
      case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
      case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
      case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
      case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
      case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
      case "AppleTV5,3":                              return "Apple TV"
      case "AppleTV6,2":                              return "Apple TV 4K"
      case "AudioAccessory1,1":                       return "HomePod"
      case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
      default:                                        return identifier
      }
      #elseif os(tvOS)
      switch identifier {
      case "AppleTV5,3": return "Apple TV 4"
      case "AppleTV6,2": return "Apple TV 4K"
      case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
      default: return identifier
      }
      #endif
    }
    
    return mapToDevice(identifier: identifier)
  }()
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.x, y: -origin.y,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return rotatedImage ?? self
        }
        
        
        return self
    }
    
    
    func resizeImageWith(image:UIImage, targetSize:CGSize) -> UIImage? {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        let widthRatio = contextSize.height/UIScreen.main.bounds.size.height
        let heightRatio = contextSize.width/UIScreen.main.bounds.size.width
        
        let width = (targetSize.width)*widthRatio
        let height = (targetSize.height)*heightRatio
        let x = (contextSize.width/2) - width/2
        let y = (contextSize.height/2) - height/2
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        return image
        
        //  return newImage
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        print("rect:\(rect)")
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}

