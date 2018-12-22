//
//  MapKitNetworkConnection.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation

extension MapKitViewController {
    
    func setupNetworkConnection() {
        
        self.view.addSubview(networkConnection)
        networkConnection.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        networkConnection.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        networkTopAnchor = networkConnection.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -80)
        networkTopAnchor.isActive = true
        networkConnection.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func checkNetwork() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let status = previousNetworkReachabilityStatus.rawValue
            if status == 0 {
                self.networkConnection.setTitle("We can't seem to find a network connection", for: .normal)
                self.view.layoutIfNeeded()
                self.networkConnection.backgroundColor = Theme.HARMONY_RED
                switch device {
                case .iphone8:
                    self.networkTopAnchor.constant = -20
                case .iphoneX:
                    self.networkTopAnchor.constant = 0
                }
                self.takeAwayEvents()
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        NotificationCenter.default.addObserver(forName: NetworkReachabilityChanged, object: nil, queue: nil, using: {
            (notification) in
            if let userInfo = notification.userInfo {
                if let reachableStatus = userInfo["reachabilityStatus"] as? String {
                    if reachableStatus == "Connection Status : Not Reachable" {
                        self.networkConnection.setTitle("We can't seem to find a network connection", for: .normal)
                        self.view.layoutIfNeeded()
                        self.networkConnection.backgroundColor = Theme.HARMONY_RED
                        switch device {
                        case .iphone8:
                            self.networkTopAnchor.constant = -20
                        case .iphoneX:
                            self.networkTopAnchor.constant = 0
                        }
                        self.takeAwayEvents()
                        UIView.animate(withDuration: animationIn, animations: {
                            self.view.layoutIfNeeded()
                        })
                    } else {
                        self.networkConnection.setTitle("Successfully connected", for: .normal)
                        self.view.layoutIfNeeded()
                        self.networkConnection.backgroundColor = Theme.GREEN_PIGMENT
                        switch device {
                        case .iphone8:
                            self.networkTopAnchor.constant = -20
                        case .iphoneX:
                            self.networkTopAnchor.constant = 0
                        }
                        UIView.animate(withDuration: animationIn, animations: {
                            self.view.layoutIfNeeded()
                        }, completion: { (success) in
                            self.eventsController.checkEvents()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                UIView.animate(withDuration: animationOut, animations: {
                                    self.networkTopAnchor.constant = -80
                                    self.view.layoutIfNeeded()
                                })
                            }
                        })
                    }
                }
            }
        })
    }
    
    @objc func removeNetworkNotification(sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: animationOut, animations: {
            self.networkTopAnchor.constant = -80
            self.view.layoutIfNeeded()
        })
    }
    
}
