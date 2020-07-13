//
//  Extensions.swift
//  RXSling
//
//  Created by Manish Ranjan on 27/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import Foundation
import UIKit

//MARK: UIImageView extension
extension UIImageView {
    
    //MARK: - Load image from url
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
//                else{
//                    
//                    DispatchQueue.main.async {
//                        self?.image = #imageLiteral(resourceName: "snt_error_image")
//                    }
//                }
            }else{
                
                DispatchQueue.main.async {
                    self?.image = #imageLiteral(resourceName: "snt_error_image")
                }
            }
            
        }
    }

}


//MARK: UIBarButtonItem extension
extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, image: UIImage) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}

var GREENCOLOUR :UIColor = UIColor(red:86/255, green: 142/255, blue: 51/255, alpha: 1.0)

extension UIColor{
    
    static let rxGreen = UIColor(red:86/255, green: 142/255, blue: 51/255, alpha: 1.0)
    static let rxYellow = UIColor(red:157/255, green: 140/255, blue: 90/255, alpha: 1.0)
    static let rxThickYellow = UIColor(red:255/255, green: 192/255, blue: 66/255, alpha: 1.0)

    static let rxYellowfade = UIColor(red:187/255, green: 170/255, blue: 112/255, alpha: 1.0)
    static let rxGray = UIColor(red:75/255, green: 80/255, blue: 62/255, alpha: 1.0)
    //101,93,93 82%
    static let rxdisabled = UIColor(red:101/255, green: 93/255, blue: 93/255, alpha: 1.0)
    static let rxenabled = UIColor(red:229/255, green: 184/255, blue: 81/255, alpha: 1.0)
}
 
extension String {
    var getBool: Bool {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return false
        }
    }
}
