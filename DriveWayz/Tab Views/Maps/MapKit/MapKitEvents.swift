//
//  MapKitEvents.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation

extension MapKitViewController {

    func setupEvents() {
        
        self.view.addSubview(eventsController.view)
        eventsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        eventsController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        eventsControllerAnchor = eventsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 150)
        eventsControllerAnchor.isActive = true
        eventsHeightAnchor = eventsController.view.heightAnchor.constraint(equalToConstant: 150)
        eventsHeightAnchor.isActive = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(eventsControllerPanned(sender:)))
        let panGesture2 = UIPanGestureRecognizer(target: self, action: #selector(eventsControllerPanned(sender:)))
        eventsController.view.addGestureRecognizer(panGesture)
        checkEventsController.view.addGestureRecognizer(panGesture2)
        
        self.view.addSubview(checkEventsController.view)
        checkEventsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        checkEventsWidthAnchor = checkEventsController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width - 24)
        checkEventsWidthAnchor.isActive = true
        checkEventsHeightAnchor = checkEventsController.view.heightAnchor.constraint(equalToConstant: 70)
        checkEventsHeightAnchor.isActive = true
        checkEventsBottomAnchor = checkEventsController.view.bottomAnchor.constraint(equalTo: eventsController.view.topAnchor, constant: 4)
        checkEventsBottomAnchor.isActive = false
        checkEventsAnchor = checkEventsController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 70)
        checkEventsAnchor.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventsControllerOpenTapped))
        checkEventsController.view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(giftButton)
        self.view.bringSubviewToFront(eventsController.view)
        giftRightAnchor = giftButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -16)
        giftRightAnchor.isActive = true
        giftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        giftButton.heightAnchor.constraint(equalTo: giftButton.widthAnchor).isActive = true
        giftBottomAnchor = giftButton.bottomAnchor.constraint(equalTo: checkEventsController.view.topAnchor, constant: -12)
        giftBottomAnchor.isActive = false
        switch device {
        case .iphone8:
            giftOnlyBottomAnchor = giftButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12)
            giftOnlyBottomAnchor.isActive = true
        case .iphoneX:
            giftOnlyBottomAnchor = giftButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24)
            giftOnlyBottomAnchor.isActive = true
        }
        
    }
    
    func openSpecificEvent() {
        self.checkEventsController.view.alpha = 0
        self.view.bringSubviewToFront(fullBackgroundView)
        self.view.bringSubviewToFront(eventsController.view)
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0.4
            switch device {
            case .iphone8:
                self.mainBarTopAnchor.constant = 80
            case .iphoneX:
                self.mainBarTopAnchor.constant = 100
            }
            self.eventsHeightAnchor.constant = self.view.frame.height
            self.giftBottomAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }
    }
    
    func closeSpecificEvent() {
        UIView.animate(withDuration: animationOut) {
            switch device {
            case .iphone8:
                self.mainBarTopAnchor.constant = 100
            case .iphoneX:
                self.mainBarTopAnchor.constant = 120
            }
            self.eventsHeightAnchor.constant = 150
            self.checkEventsController.view.alpha = 1
            self.giftBottomAnchor.constant = 40
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func eventsControllerPanned(sender: UIPanGestureRecognizer) {
        if self.checkEventsWidthAnchor.constant != self.view.frame.width - 24 && self.checkEventsController.view.alpha == 1 {
            if sender.state == .changed {
                let location = sender.location(in: self.view).y
                let difference = self.view.frame.height - location
                if difference < 50 {
                    self.eventsControllerHidden()
                } else {
                    self.eventsControllerAnchor.constant = 120 - difference
                    if self.eventsControllerAnchor.constant <= 0 {
                        self.eventsControllerAnchor.constant = 0
                    }
                    self.view.layoutIfNeeded()
                }
            } else if sender.state == .ended {
                if self.eventsControllerAnchor.constant > 40 {
                    self.eventsControllerHidden()
                } else {
                    self.eventsControllerOpenTapped()
                }
            }
        } else if self.eventsHeightAnchor.constant == self.view.frame.height && self.checkEventsController.view.alpha == 0 {
            if sender.state == .began {
                let location = sender.location(in: self.view).y
                self.previousEventLocation = location
            } else if sender.state == .changed {
                let location = sender.location(in: self.view).y
                let difference = location - self.previousEventLocation
                if difference > 60 {
                    self.eventsController.backgroundTouched()
                    self.eventsControllerOpenTapped()
                }
            }
        }
    }
    
    @objc func eventsControllerOpenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventsControllerHidden))
        self.checkEventsController.view.addGestureRecognizer(tapGesture)
        self.checkEventsController.changeToCurrentEvents()
        UIView.animate(withDuration: animationIn) {
            self.giftRightAnchor.constant = 60
            self.checkEventsAnchor.isActive = false
            self.checkEventsBottomAnchor.isActive = true
            self.checkEventsHeightAnchor.constant = 40
            self.checkEventsWidthAnchor.constant = 205
            self.eventsControllerAnchor.constant = 0
            self.giftBottomAnchor.constant = 40
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func eventsControllerHidden() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventsControllerOpenTapped))
        checkEventsController.view.addGestureRecognizer(tapGesture)
        self.giftOnlyBottomAnchor.isActive = false
        self.giftBottomAnchor.isActive = true
        self.checkEventsController.changeToBanner()
        UIView.animate(withDuration: animationIn) {
            self.giftRightAnchor.constant = -16
            self.checkEventsAnchor.isActive = true
            self.checkEventsAnchor.constant = -12
            self.checkEventsBottomAnchor.isActive = false
            self.checkEventsHeightAnchor.constant = 70
            self.checkEventsWidthAnchor.constant = self.view.frame.width - 24
            self.eventsControllerAnchor.constant = 150
            self.giftBottomAnchor.constant = -12
            self.view.layoutIfNeeded()
        }
    }
    
    func takeAwayEvents() {
        self.giftOnlyBottomAnchor.isActive = false
        self.giftBottomAnchor.isActive = true
        self.checkEventsAnchor.constant = 70
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
}
