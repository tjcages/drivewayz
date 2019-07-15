//
//  MBUserMessages.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit


extension MapKitViewController: UIViewControllerTransitioningDelegate {
    
    func setupUserMessages() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(drivewayzMessagePressed))
        mainBarController.contactBannerController.view.addGestureRecognizer(tap)
        
    }
    
    @objc func drivewayzMessagePressed() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let secondVC = DrivewayzMessagesViewController()
        secondVC.setData(userID: userID)
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
        self.present(secondVC, animated: true) {
            self.lightContentStatusBar()
            secondVC.openMessageBar()
            delayWithSeconds(1, completion: {
                let ref = Database.database().reference().child("users").child(userID).child("PersonalMessages")
                ref.removeValue()
            })
        }
    }
    
    func observeUserDrivewayzMessages() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("PersonalMessages")
        ref.observe(.childAdded) { (snapshot) in
            self.mainBarController.contactBannerHeightAnchor.constant = 70
            self.mainBarController.searchButtonTopAnchor.constant = 16
            UIView.animate(withDuration: animationIn, animations: {
                self.mainBarController.contactBannerController.view.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.lowestHeight = 424
                switch device {
                case .iphone8:
                    self.minimizedHeight = 220
                case .iphoneX:
                    self.minimizedHeight = 234
                }
                self.mainBarTopAnchor.constant = self.lowestHeight
                UIView.animate(withDuration: animationOut, animations: {
                    self.view.layoutIfNeeded()
                })
            })
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.mainBarController.contactBannerHeightAnchor.constant = 0
            self.mainBarController.searchButtonTopAnchor.constant = 34
            UIView.animate(withDuration: animationIn, animations: {
                self.mainBarController.contactBannerController.view.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.lowestHeight = 354
                switch device {
                case .iphone8:
                    self.minimizedHeight = 150
                case .iphoneX:
                    self.minimizedHeight = 164
                }
                self.mainBarTopAnchor.constant = self.lowestHeight
                UIView.animate(withDuration: animationOut, animations: {
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = self.mainBarController.contactBannerController.newMessageButton.center
        transition.circleColor = Theme.DARK_GRAY
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = self.mainBarController.contactBannerController.newMessageButton.center
        transition.circleColor = Theme.DARK_GRAY
        delayWithSeconds(animationOut) {
            self.delegate?.defaultContentStatusBar()
        }
        
        return transition
    }
    
}
