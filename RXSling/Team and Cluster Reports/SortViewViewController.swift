//
//  SortViewViewController.swift
//  RXSling Stage
//
//  Created by chiranjeevi macharla on 21/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

protocol SortProtocol: NSObjectProtocol {
    func passData(sortType: SortType)
}

enum SortType {
    case success
    case viewed
    case sent
}

class SortViewViewController: UIViewController {
    
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var viewedButton: UIButton!
    @IBOutlet weak var sentButton: UIButton!
    
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var viewedView: UIView!
    @IBOutlet weak var sentView: UIView!
    
    var selectedSortType:SortType = .success
    
    
    weak var sortDelegate:SortProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.successViewTapped(_:)))
        successView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.viewedViewTapped(_:)))
        viewedView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.sentViewTapped(_:)))
        sentView.addGestureRecognizer(tap3)
        
        updateSelection(sort: selectedSortType)
        
        
    }
    
    @IBAction func cancelButtonAction(_ sender:  UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        sortDelegate?.passData(sortType: selectedSortType)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func successViewTapped(_ gesture: UITapGestureRecognizer) {
        selectedSortType = .success
        updateSelection(sort: selectedSortType)
    }
    
    @objc func viewedViewTapped(_ gesture: UITapGestureRecognizer) {
        selectedSortType = .viewed
        updateSelection(sort: selectedSortType)
    }
    
    @objc func sentViewTapped(_ gesture: UITapGestureRecognizer) {
        selectedSortType = .sent
        updateSelection(sort: selectedSortType)
    }
    
    func updateSelection(sort: SortType) {
        
        switch sort {
        case .success:
            self.successButton.setImage(UIImage(named: "new_round_radio_button")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.successButton.tintColor = .rxGreen
            self.viewedButton.setImage(UIImage(named: "new_round_radio_button_unchecked")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.viewedButton.tintColor = .rxGreen
            self.sentButton.setImage(UIImage(named: "new_round_radio_button_unchecked")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.sentButton.tintColor = .rxGreen
        case .viewed:
            self.successButton.setImage(UIImage(named: "new_round_radio_button_unchecked")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.successButton.tintColor = .rxGreen
            self.viewedButton.setImage(UIImage(named: "new_round_radio_button")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.viewedButton.tintColor = .rxGreen
            self.sentButton.setImage(UIImage(named: "new_round_radio_button_unchecked")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.sentButton.tintColor = .rxGreen
        case .sent:
            self.successButton.setImage(UIImage(named: "new_round_radio_button_unchecked")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.successButton.tintColor = .rxGreen
            self.viewedButton.setImage(UIImage(named: "new_round_radio_button_unchecked")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.viewedButton.tintColor = .rxGreen
            self.sentButton.setImage(UIImage(named: "new_round_radio_button")!.withRenderingMode(.alwaysTemplate), for: .normal)
            self.sentButton.tintColor = .rxGreen
        }
    }
    
}

