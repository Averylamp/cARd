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
    
    let person: Person? = nil
    let links: [String] = ["facebook", "linkedin", "email", "phone call", "link", "link 2"]
    var plinks: [LinkType: String] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        pictureView.image = UIImage(named: "pikachu")
        pictureView.contentMode = .scaleAspectFill
        pictureView.layer.cornerRadius = pictureView.frame.width/2
        pictureView.clipsToBounds = true
        pictureView.layer.borderWidth = 2
        pictureView.layer.borderColor = UIColor.linkedinBlue.cgColor
        
        setupButtonStack()
        buttonScrollView.contentSize = CGSize(width: links.count * 44 + (links.count - 1) * 15 + 15, height: 50)
        buttonScrollView.isScrollEnabled = true
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.widthAnchor.constraint(equalToConstant: CGFloat(links.count * 44 + (links.count - 1) * 15)).isActive = true
        buttonScrollView.showsHorizontalScrollIndicator = false
        
    }
    
    func setupButtonStack() {
        for view in buttonStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for key in plinks.keys {
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
            
            button.imageView?.contentMode = .scaleAspectFill
            let image = selectIconFor(type: key)
            button.setImage(image, for: .normal)
            button.tintColor = .linkedinBlue
            
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    func selectIconFor(link: String) -> UIImage {
        var image = UIImage(named: "link")
        if link.range(of: "facebook") != nil {
            image = UIImage(named: "facebook")
        } else if link.range(of: "linkedin") != nil {
            image = UIImage(named: "linkedin")
        } else if link.range(of: "call") != nil {
            image = UIImage(named: "phone")
        } else if link.range(of: "mail") != nil {
            image = UIImage(named: "email")
        }
        
        return image?.withRenderingMode(.alwaysTemplate) ?? UIImage()
    }

    func selectIconFor(type: LinkType) -> UIImage {
        var image = UIImage(named: "link")
        switch type {
            case .devpost:
                image = UIImage(named: "link")
            case .facebook:
                image = UIImage(named: "facebook")
            case .linkedin:
                image = UIImage(named: "linkedin")
            case .phoneCall:
                image = UIImage(named: "phone")
            case .phoneFacetime:
                image = UIImage(named: "link")
            case .phoneText:
                image = UIImage(named: "phone")
            case .twitter:
                image = UIImage(named: "link")
            case .website:
                image = UIImage(named: "link")
        }
        
        return image?.withRenderingMode(.alwaysTemplate) ?? UIImage()
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
