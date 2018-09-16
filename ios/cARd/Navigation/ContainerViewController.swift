//
//  ContainerViewController.swift
//  cARd
//
//  Created by Avery on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import UIKit

enum VCState{
    case AR
    case History
}



class ContainerViewController: UIViewController {

    
    var arVC : MainARViewController?
    var arvcCenterX: NSLayoutConstraint?
    var historyVC: HistoryListViewController?
    var historyCenterX: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let arvc = UIStoryboard(name: "MainAR", bundle: nil).instantiateViewController(withIdentifier: "MainARVC") as? MainARViewController {
            self.arVC = arvc
            self.addChildViewController(arvc)
           self.view.addSubview(arvc.view)
            arvc.didMove(toParentViewController: self)
            arvc.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.arvcCenterX = NSLayoutConstraint(item: arvc.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            self.view.addConstraints([
                NSLayoutConstraint(item: arvc.view, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: arvc.view, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0.0),
                self.arvcCenterX!,
                NSLayoutConstraint(item: arvc.view, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                ])
        }
        
        if let historyListVC = UIStoryboard(name: "Extras", bundle: nil).instantiateViewController(withIdentifier: "HistoryListVC") as? HistoryListViewController{
            self.historyVC = historyListVC
            self.addChildViewController(historyListVC)
            self.view.addSubview(historyListVC.view)
            historyListVC.didMove(toParentViewController: self)
            historyListVC.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.historyCenterX = NSLayoutConstraint(item: historyListVC.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 3.0, constant: 0.0)
            self.view.addConstraints([
                NSLayoutConstraint(item: historyListVC.view, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: historyListVC.view, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0.0),
                historyCenterX!,
                NSLayoutConstraint(item: historyListVC.view, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                ])
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(recognizer:)))
        self.view.addGestureRecognizer(panGesture)
        
    }
    
    func toggle(state: VCState){
        if let arvcCenterX = self.arvcCenterX, let historyCenterX = self.historyCenterX, let arvc = self.arVC, let historyVC = self.historyVC{
            UIView.animate(withDuration: 0.5) {
                switch state{
                case .AR:
                    print("Toggling AR View")
                    self.view.removeConstraint(arvcCenterX)
                    self.arvcCenterX = NSLayoutConstraint(item: arvc.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                    self.view.addConstraint(self.arvcCenterX!)
                    
                    self.view.removeConstraint(historyCenterX)
                    self.historyCenterX = NSLayoutConstraint(item: historyVC.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 3.0, constant: 0.0)
                    self.view.addConstraint(self.historyCenterX!)
                    arvc.view.center.x  = self.view.center.x
                    historyVC.view.center.x = self.view.center.x * 3
                    break
                case .History:
                    print("Toggling History View")
                    self.view.removeConstraint(arvcCenterX)
                    self.arvcCenterX = NSLayoutConstraint(item: arvc.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: -1.0, constant: 0.0)
                    self.view.addConstraint(self.arvcCenterX!)
                    
                    self.view.removeConstraint(historyCenterX)
                    self.historyCenterX = NSLayoutConstraint(item: historyVC.view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                    self.view.addConstraint(self.historyCenterX!)
                    arvc.view.center.x  = -self.view.center.x
                    historyVC.view.center.x = self.view.center.x
                    break
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            print("Began sliding VC")
        case .changed:
            let translation = recognizer.translation(in: view).x
            if let arVC = self.arVC, let historyVC = self.historyVC{
                arVC.view.center.x += translation
                historyVC.view.center.x += translation
                if arVC.view.frame.origin.x > 0 || historyVC.view.frame.origin.x + historyVC.view.frame.width < self.view.frame.width{
                    arVC.view.center.x -= translation
                    historyVC.view.center.x -= translation
                }
            }            
            recognizer.setTranslation(CGPoint.zero, in: view)
        case .ended:
            if abs(recognizer.velocity(in: view).x) > 200{
                if recognizer.velocity(in: view).x < -200{
                    toggle(state: .History)
                }else if recognizer.velocity(in: view).x > 200{
                    toggle(state: .AR)
                }
            }else{
                if let arvc = self.arVC {
                    if   arvc.view.center.x < 0{
                        toggle(state: .History)
                    }else{
                        toggle(state: .AR)
                    }
                }
            }
        default:
            break
        }
        
        
    }
    


}
