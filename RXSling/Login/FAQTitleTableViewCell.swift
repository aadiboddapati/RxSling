//
//  FAQTitleTableViewCell.swift
//  ParrotNote
//
//  Created by Vinod Kumar on 25/02/19.
//  Copyright © 2019 Vinod Kumar. All rights reserved.
//

import UIKit

class FAQTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
