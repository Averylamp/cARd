//
//  LinkTableViewCell.swift
//  cARd
//
//  Created by Ryan Sullivan on 9/16/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var linkLabel: UILabel!
    
    var linkText: String = ""
    var linkType: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        linkLabel.text = linkText
        
        linkButton.backgroundColor = .white
        
        linkButton.clipsToBounds = true
        linkButton.layer.cornerRadius = linkButton.frame.width/2
        linkButton.layer.borderColor = UIColor.linkedinBlue.cgColor
        linkButton.layer.borderWidth = 2
        linkButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        linkButton.imageView?.contentMode = .scaleAspectFit
        let image = selectIconFor(type: linkType)
        linkButton.setImage(image, for: .normal)
        linkButton.setTitle("", for: .normal)
        linkButton.tintColor = .linkedinBlue
    }

    func selectIconFor(type: String) -> UIImage {
        let image = UIImage(named: type)
        
        return image?.withRenderingMode(.alwaysTemplate) ?? UIImage(named: "pikachu") ?? UIImage()
    }
    
    func updateLabel() {
        linkLabel.text = linkText
        let image = selectIconFor(type: linkType)
        linkButton.setImage(image, for: .normal)
        linkButton.setTitle("", for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
