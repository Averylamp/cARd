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
    @IBOutlet weak var linkTableView: UITableView!
    
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
        
        linkTableView.delegate = self
        linkTableView.dataSource = self
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

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person?.links.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Link Cell") as? LinkTableViewCell, let person = person {
            for (n, key) in person.links.keys.enumerated() {
                if n == indexPath.item {
                    cell.linkText = person.links[key] ?? ""
                    cell.linkType = key
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
