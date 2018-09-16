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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var currentPositionsView: UIView!
    @IBOutlet weak var currentPositionLabel: UILabel!
    
    @IBOutlet weak var educationView: UIView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkTableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    var person: Person? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let imageView = profileImageView {
            imageView.image = person?.profileImage
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = UIColor.linkedinBlue.cgColor
        
        backButton.addTarget(self, action: #selector(ProfileViewController.back), for: .touchUpInside)
        
        linkTableView.delegate = self
        linkTableView.dataSource = self
        linkTableView.isScrollEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        linkTableView.translatesAutoresizingMaskIntoConstraints = false
       // linkTableView.heightAnchor.constraint(equalToConstant: CGFloat((person?.links.keys.count ?? 0) * 64))
        
        scrollView.contentSize = contentView.frame.size
        configure()
    }
    
    func configure() {
        if let person = person, let information = person.information {
            nameLabel.text = person.name
            if let desc = information["description"]?.stringValue {
                descriptionLabel.text = desc
            }
            if let jobs = information["positions_list"]?.arrayValue, let current_job = jobs.first?.dictionary, let title = current_job["title"]?.stringValue {
                currentPositionLabel.text = title
            }
            if let schools = information["education_list"]?.arrayValue, let school = schools.first?.dictionary {
                if let schoolName = school["school_name"]?.stringValue {
                    schoolLabel.text = schoolName
                }
                if let degreeName = school["degree_name"]?.stringValue {
                    degreeLabel.text = degreeName
                }
            }
            
        }
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
                    cell.linkText = person.links[key] ?? "Hello"
                    cell.linkType = key
                    cell.updateLabel()
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
