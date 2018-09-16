//
//  HistoryListViewController.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardTableView.separatorStyle = .none
        cardTableView.allowsSelection = false
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        NotificationCenter.default.addObserver(forName: Notification.Name(Constants.NewPersonNotification), object: nil, queue: nil) { (notification) in
            self.cardTableView.reloadData()
        }
    }
    
    
    
    
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        if let name = nameTextField.text, name.count > 0{
            ServerManager.sharedInstance.searchByName(name: name) { (person) in
                self.cardTableView.reloadData()
            }
        }
    }
    
    
}

extension HistoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension HistoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Business Card", for: indexPath) as? BusinessCardCell {
            let person = ServerManager.sharedInstance.profiles[indexPath.row]
            cell.person = person

        
//            let person = Person(name: "Pikachu")
//            person.phoneNumber = "0000000000"
//            person.links["devpost"] = "Dev"
//            person.links["facebook"] = "Fac"
//            person.links["email"] = "Em"
//            person.links["linkedin"] = "Lin"
//            person.links["phone-call"] = "PC"
//            person.links["phone-facetime"] = "PF"
//            person.links["phone-text"] = "PT"
//            person.links["twitter"] = "twit"
//            person.links["website"] = "web"
//            cell.person = person
//
//            cell.person = person
            cell.delegate = self
            cell.configure()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServerManager.sharedInstance.profiles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    
    
    
}

extension HistoryListViewController: BusinessCardCellDelegate {
    func didSelect(profile: Person) {
        let storyboard = UIStoryboard(name: "Extras", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "Profile VC")
        if let pvc = profileVC as? ProfileViewController {
            pvc.person = profile
        }
        
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
}
