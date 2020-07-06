//
//  HelpViewController.swift
//  ParrotNote
//
//  Created by Divakara Y N. on 6/14/19.
//  Copyright © 2019 Vinod Kumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {

    var backButton : UIBarButtonItem!
    @objc var proceedButton : UIBarButtonItem!
    
    
    @IBOutlet weak var helpTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "HELP"
        self.navigationController?.navigationBar.tintColor = GREENCOLOUR
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        
        helpTableView.rowHeight = 844
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        showBarButtonItem()
        
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        let viewFN = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        viewFN.backgroundColor = UIColor.clear
        viewFN.tintColor = GREENCOLOUR
        let button1 = UIButton(frame: CGRect(x: 0, y: 8, width: 70, height: 20))
        button1.setTitle("PROCEED", for: .normal)
        button1.setTitleColor(GREENCOLOUR, for: .normal)
        button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button1.addTarget(self, action: #selector(self.proceedButtonTapped), for: UIControl.Event.touchUpInside)
        viewFN.addSubview(button1)
        
        if !isFirstTimeLogin{
            self.navigationItem.leftBarButtonItem = self.backButton
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewFN)
        }
        
        helpTableView.delegate = self
        helpTableView.dataSource = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "HELP"

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBarBUttomItem()
        self.navigationController?.navigationBar.isHidden = false
        if UIDevice.current.userInterfaceIdiom == .pad {
           // self.view.backgroundColor = UIColor(red: 0.45, green: 0.67, blue: 0.30, alpha: 0.5)
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        } else {
                   self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
         
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 25/255, blue: 14/255, alpha: 1.0)
    }
    override func viewWillDisappear(_ animated: Bool) {
        hideBarBUttomItem()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    
    @objc func backButtonTapped(){
        //if !isFirstTimeLogin{
            self.navigationController?.popViewController(animated: true)
        //}
    }
    @objc func proceedButtonTapped(sender: UIButton!){
        DispatchQueue.main.async {
            isFirstTimeLogin = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HELP", for: indexPath) as! HelpTableViewCell
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


class HelpTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
