//
//  ContainerViewController.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let arvc = UIStoryboard(name: "MainAR", bundle: nil).instantiateViewController(withIdentifier: "MainARVC") as? MainARViewController {
            self.addChildViewController(arvc)
           self.view.addSubview(arvc.view)
            arvc.didMove(toParentViewController: self)
            arvc.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraints([
                NSLayoutConstraint(item: arvc.view, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: arvc.view, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: arvc.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: arvc.view, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                ])
        }
        
        if let historyListVC = UIStoryboard(name: "Extras", bundle: nil).instantiateViewController(withIdentifier: "HistoryListVC") as? HistoryListViewController{
            self.addChildViewController(historyListVC)
            self.view.addSubview(historyListVC.view)
            historyListVC.didMove(toParentViewController: self)
            historyListVC.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraints([
                NSLayoutConstraint(item: historyListVC.view, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: historyListVC.view, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: historyListVC.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 3.0, constant: 0.0),
                NSLayoutConstraint(item: historyListVC.view, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                ])
        }
    }
    


}
