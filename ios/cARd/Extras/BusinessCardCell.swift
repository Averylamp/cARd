//
//  BusinessCardCell.swift
//  cARd
//
//  Created by Ryan Sullivan on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

protocol BusinessCardCellDelegate: AnyObject {
    func didSelect(profile: Person)
}


class BusinessCardCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pictureView: UIImageView!
    
    @IBOutlet weak var pictureShadowView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var buttonScrollView: UIScrollView!
    @IBOutlet weak var buttonContentView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var person: Person? = nil
    var plinks: [String: String] = [:]
    
    weak var delegate: BusinessCardCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //configure()
    }
    
    func setupButtonStack() {
        for view in buttonStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for (key, value ) in plinks {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.setTitle("", for: .normal)
            button.backgroundColor = .white
            
            button.clipsToBounds = true
            button.layer.cornerRadius = button.frame.width/2
            button.layer.borderColor = UIColor.linkedinBlue.cgColor
            button.layer.borderWidth = 2
            button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            
            
            button.imageView?.contentMode = .scaleAspectFit
            let image = selectIconFor(type: key)
            button.setImage(image, for: .normal)
            button.tintColor = .linkedinBlue
            
            buttonStackView.addArrangedSubview(button)
        }
    }

    func selectIconFor(type: String) -> UIImage {
        let image = UIImage(named: type)
        return image?.withRenderingMode(.alwaysTemplate) ?? UIImage(named: "website") ?? UIImage()
    }
    
    func configure() {
        nameLabel.text = person?.name ?? "Name"
        timestampLabel.text = person?.timestamp.description ?? "Timestamp"
        plinks = person?.links ?? [:]
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.shadowOffset = CGSize(width: 1, height: 3)
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowPath = shadowPath.cgPath
        
        pictureView.image = person?.profileImage
        pictureView.contentMode = .scaleAspectFill
        pictureView.layer.cornerRadius = pictureView.frame.width/2
        pictureView.clipsToBounds = true
        pictureView.layer.borderWidth = 2
        pictureView.layer.borderColor = UIColor.linkedinBlue.cgColor
        
        setupButtonStack()
        buttonScrollView.contentSize = CGSize(width: plinks.count * 44 + (plinks.count - 1) * 15 + 15, height: 50)
        buttonScrollView.isScrollEnabled = true
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.widthAnchor.constraint(equalToConstant: CGFloat(plinks.count * 44 + (plinks.count - 1) * 15)).isActive = true
        buttonScrollView.showsHorizontalScrollIndicator = false
        
        if let view = buttonStackView.arrangedSubviews.first {
            buttonScrollView.scrollRectToVisible(view.frame, animated: false)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BusinessCardCell.didSelectProfile))
        self.containerView.addGestureRecognizer(tap)
    }
    
    @objc func didSelectProfile() {
        if let person = person {
            delegate?.didSelect(profile: person)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
}

extension BusinessCardCell: UIScrollViewDelegate {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
