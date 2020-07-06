//
//  FAQDataTableViewCell.swift
//  RXSling
//
//  Created by Divakara Y N. on 22/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: class {
    func tableViewCell(_ sender: FAQDataTableViewCell, didTouchWith touchResult: TouchResult)
}

class FAQDataTableViewCell: UITableViewCell {

    @IBOutlet weak var descritionLabel: ContextLabel!
    
     weak var delegate: TableViewCellDelegate?


       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }


       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)


           // Configure the view for the selected state
       }


       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           switch descritionLabel.touchState {
           case .began:
               break
           default:
               super.touchesBegan(touches, with: event)
           }
       }


       // MARK: - Methods

       func config(with text: String, textLinks: [TextLink]?) {
           descritionLabel.text = text
           descritionLabel.textLinks = textLinks
       }
}
