//
//  MySideMenuNavigationController.swift
//  VDetail
//
//  Created by Vinod Kumar on 24/09/18.
//  Copyright © 2018 Vinod Kumar. All rights reserved.
//

import Foundation
import SideMenu
class MySideMenuNavigationController: SideMenuNavigationController {

    let customSideMenuManager = SideMenuManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        //self.navigationController?.navigationBar.tintColor = GREENCOLOUR
       // self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = GREENCOLOUR
       // self.navigationController?.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        sideMenuManager = customSideMenuManager
        SideMenuManager.default.menuFadeStatusBar = false
       // SideMenuManager.default.menuAnimationBackgroundColor = GREENCOLOUR
    }
    
}

