//
//  StackViewController.swift
//  RXSling Stage
//
//  Created by Vivek on 6/22/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
    
     @IBOutlet weak var stacksearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        stacksearchBar.delegate = self
        stacksearchBar.layer.borderWidth = 0.5
           stacksearchBar.returnKeyType = .default
         stacksearchBar.becomeFirstResponder()
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension StackViewController:UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == "" {
           
        } else {
            
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
