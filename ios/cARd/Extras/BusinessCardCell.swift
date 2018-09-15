//
//  BusinessCardCell.swift
//  cARd
//
//  Created by Ryan Sullivan on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

class BusinessCardCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var buttonScrollView: UIScrollView!
    @IBOutlet weak var buttonStackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
