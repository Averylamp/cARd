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
    @IBOutlet weak var buttonContentView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    let links: [String] = ["Lol", "Wow", "Much Testing"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.shadowOffset = CGSize(width: 2, height: 5)
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: containerView.bounds.width-20, height: containerView.bounds.height))
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowPath = shadowPath.cgPath
        
        pictureView.backgroundColor = .red
        pictureView.layer.cornerRadius = pictureView.frame.width/2
        pictureView.clipsToBounds = true
        pictureView.layer.borderWidth = 1
        pictureView.layer.borderColor = UIColor.darkGray.cgColor
        
        buttonScrollView.contentSize = buttonContentView.frame.size
        
        setupButtonStack()
    }
    
    func setupButtonStack() {
        for view in buttonStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for link in links {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            button.setTitle("", for: .normal)
            button.backgroundColor = .orange
            
            button.clipsToBounds = true
            button.layer.cornerRadius = button.frame.width/2
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 2
            
            buttonStackView.addArrangedSubview(button)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
