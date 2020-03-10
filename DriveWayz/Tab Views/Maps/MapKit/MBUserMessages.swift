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
//        let tap = UITapGestureRecognizer(target: self, action: #selector(drivewayzMessagePressed))
//        mainBarController.contactBannerController.view.addGestureRecognizer(tap)
    }
    
    @objc func drivewayzMessagePressed() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let controller = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.setData(userID: userID)
        controller.sendingFromDrivewayz = false
        controller.gradientController.setExitButton()
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true) {
            lightContentStatusBar()
            delayWithSeconds(1, completion: {
                let ref = Database.database().reference().child("users").child(userID)
                ref.child("PersonalMessages").removeValue()
                
                let timestamp = Date().timeIntervalSince1970
                ref.child("previousMessages").updateChildValues(["timestamp": timestamp])
            })
        }
    }
    
    func observeUserDrivewayzMessages() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.child("PersonalMessages").observe(.childAdded) { (snapshot) in
//            self.mainBarController.setupContact(0, last: false)
//            self.mainBarController.contactBannerController.currentMessage()
            UIView.animate(withDuration: animationIn, animations: {
//                self.mainBarController.contactBannerController.view.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: { (success) in
//                self.lowestHeight = 380
//                switch device {
//                case .iphone8:
//                    self.minimizedHeight = 220
//                case .iphoneX:
//                    self.minimizedHeight = 234
//                }
                if self.mainViewState == .mainBar {
                    self.mainViewState = .mainBar
//                    self.mainBarTopAnchor.constant = self.lowestHeight
                }
                UIView.animate(withDuration: animationOut, animations: {
                    self.view.layoutIfNeeded()
                })
            })
        }
        ref.child("previousMessages").observe(.childAdded) { (snapshot) in
//            self.mainBarController.setupContact(2, last: false)
//            self.mainBarController.contactBannerController.previousMessage()
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (success) in
//                self.lowestHeight = 380
//                switch device {
//                case .iphone8:
//                    self.minimizedHeight = 150
//                case .iphoneX:
//                    self.minimizedHeight = 164
//                }
                if self.mainViewState == .mainBar {
                    self.mainViewState = .mainBar
//                    self.mainBarBottomAnchor.constant = self.lowestHeight
                }
                UIView.animate(withDuration: animationOut, animations: {
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
    
    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .present
//        transition.startingPoint = self.mainBarController.contactBannerController.newMessageButton.center
//        transition.circleColor = Theme.DARK_GRAY
//
//        return transition
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .dismiss
//        transition.startingPoint = self.mainBarController.contactBannerController.newMessageButton.center
//        transition.circleColor = Theme.DARK_GRAY
//        delayWithSeconds(animationOut) {
//            self.delegate?.defaultContentStatusBar()
//        }
//
//        return transition
//    }
//
}
