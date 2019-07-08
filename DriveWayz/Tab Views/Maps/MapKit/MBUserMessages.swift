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
        
        self.view.addSubview(drivewayzNewMessageButton)
        drivewayzNewMessageButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        drivewayzNewMessageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        drivewayzNewMessageButton.heightAnchor.constraint(equalTo: drivewayzNewMessageButton.widthAnchor).isActive = true
        switch device {
        case .iphone8:
            newMessageTopAnchor = drivewayzNewMessageButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28)
                newMessageTopAnchor.isActive = true
        case .iphoneX:
            newMessageTopAnchor = drivewayzNewMessageButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48)
                newMessageTopAnchor.isActive = true
        }
        drivewayzNewMessageButton.addTarget(self, action: #selector(drivewayzMessagePressed), for: .touchUpInside)
        
        drivewayzNewMessageButton.addSubview(drivewayzNewMessageNumber)
        drivewayzNewMessageNumber.centerYAnchor.constraint(equalTo: drivewayzNewMessageButton.bottomAnchor, constant: -4).isActive = true
        drivewayzNewMessageNumber.centerXAnchor.constraint(equalTo: drivewayzNewMessageButton.leftAnchor, constant: 4).isActive = true
        drivewayzNewMessageNumber.widthAnchor.constraint(equalToConstant: 20).isActive = true
        drivewayzNewMessageNumber.heightAnchor.constraint(equalTo: drivewayzNewMessageNumber.widthAnchor).isActive = true
        
    }
    
    @objc func drivewayzMessagePressed() {
        let secondVC = OpenMessageViewController()
        secondVC.delegate = self
        let navigation = UINavigationController(rootViewController: secondVC)
        navigation.navigationBar.isHidden = true
        navigation.transitioningDelegate = self
        navigation.modalPresentationStyle = .custom
        self.present(navigation, animated: true) {
            self.lightContentStatusBar()
            secondVC.openMessages()
        }
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = drivewayzNewMessageButton.center
        transition.circleColor = drivewayzNewMessageButton.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = drivewayzNewMessageButton.center
        transition.circleColor = drivewayzNewMessageButton.backgroundColor!
        delayWithSeconds(animationOut) {
            self.delegate?.defaultContentStatusBar()
        }
        
        return transition
    }
    
}
