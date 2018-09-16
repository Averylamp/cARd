//
//  HistoryListViewController.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController {

    @IBOutlet weak var cardTableView: UITableView!
    
    var cardCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardTableView.separatorStyle = .none
        cardTableView.allowsSelection = false
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
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
        
            let person = Person(name: "Pikachu")
            person.phoneNumber = "0000000000"
            person.links["devpost"] = [""]
            person.links["facebook"] = [""]
            person.links["linkedin"] = [""]
            person.links["phoneCall"] = [""]
            person.links["phoneFacetime"] = [""]
            person.links["phoneText"] = [""]
            person.links["twitter"] = [""]
            person.links["website"] = [""]
            
            cell.person = person
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
