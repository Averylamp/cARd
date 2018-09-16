//
//  ProfileViewController.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var currentPositionsView: UIView!
    @IBOutlet weak var educationView: UIView!
    @IBOutlet weak var linkView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    var person: Person? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let imageView = profileImageView {
            imageView.sd_setImage(with: URL(string: "https://assets.vg247.com/current/2016/08/pikachu_surprise.jpg"), completed: nil)
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.linkedinBlue.cgColor
        
        backButton.addTarget(self, action: #selector(ProfileViewController.back), for: .touchUpInside)
    }
    
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
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
