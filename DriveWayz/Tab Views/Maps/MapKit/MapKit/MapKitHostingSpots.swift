//
//  MapKitParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
import Mapbox

extension MapKitViewController {
    
    func setupViewController() {
        
        self.view.addSubview(fullBackgroundView)
        fullBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fullBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -1).isActive = true
        fullBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 2).isActive = true
        fullBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 1).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(parkingBackButtonPressed))
        fullBackgroundView.addGestureRecognizer(tap)
        
        self.view.addSubview(darkBlurView)
        darkBlurView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        darkBlurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        darkBlurView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        darkBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(purchaseViewController.view)
        self.addChild(purchaseViewController)
        purchaseViewController.didMove(toParent: self)
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(purchaseButtonSwiped))
        gestureRecognizer.direction = .up
        purchaseViewController.view.addGestureRecognizer(gestureRecognizer)
        let gestureRecognizer2 = UISwipeGestureRecognizer(target: self, action: #selector(purchaseButtonSwipedDownSender))
        gestureRecognizer2.direction = .down
        purchaseViewController.view.addGestureRecognizer(gestureRecognizer2)
        
        purchaseViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        purchaseViewAnchor = purchaseViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 240)
        purchaseViewAnchor.isActive = true
        purchaseViewController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        hoursButtonAnchor = purchaseViewController.view.heightAnchor.constraint(equalToConstant: 220)
        hoursButtonAnchor.isActive = true
        
        self.view.addSubview(informationViewController.view)
        self.addChild(informationViewController)
        informationViewController.didMove(toParent: self)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(informationButtonSwiped))
        gesture.direction = .down
        informationViewController.view.addGestureRecognizer(gesture)
        informationViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationViewController.view.topAnchor.constraint(equalTo: purchaseViewController.view.bottomAnchor, constant: 35).isActive = true
        informationViewController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        informationViewController.view.heightAnchor.constraint(equalToConstant: self.view.frame.height - 30).isActive = true
        
        self.view.addSubview(swipeLabel)
        swipeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        swipeLabel.bottomAnchor.constraint(equalTo: purchaseViewController.view.topAnchor, constant: -20).isActive = true
        swipeLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        swipeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(speechSearchResults.view)
        speechSearchResults.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        speechSearchResults.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        speechSearchResults.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        speechSearchResults.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
    }
    
    @objc func purchaseButtonSwiped() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = -self.view.frame.height
//            self.diamondTopAnchor.constant = 40
            self.fullBackgroundView.alpha = 1
            self.swipeLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = true
        }
        UserDefaults.standard.set(true, forKey: "swipeTutorialCompleted")
        UserDefaults.standard.synchronize()
    }
    
    @objc func purchaseButtonSwipedDownSender() {
        self.purchaseButtonSwipedDown()
    }
    
    func purchaseButtonSwipedDown() {
        self.mapView.deselectAnnotation(annotationSelected, animated: true)
        purchaseViewController.minimizeHours()
        purchaseViewController.currentSender()
        purchaseViewController.checkButtonSender()
        UserDefaults.standard.set(true, forKey: "swipeTutorialCompleted")
        UserDefaults.standard.synchronize()
//        self.diamondTopAnchor.constant = 0
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.purchaseViewAnchor.constant = 240
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = false
            self.mapView.deselectAnnotation(MGLPointAnnotation(), animated: true)
        }
    }
    
    @objc func informationButtonSwiped() {
//        self.diamondTopAnchor.constant = 0
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: 0.5, animations: {
            self.purchaseViewAnchor.constant = 0
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            informationScrollView.isScrollEnabled = false
        }
        if isNavigating == false {
            UIView.animate(withDuration: animationIn) {
                self.navigationLabel.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func openHoursButton() {
        self.hoursButtonAnchor.constant = 340
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0.6
            self.view.layoutIfNeeded()
        }
    }
    
    func closeHoursButton() {
        self.hoursButtonAnchor.constant = 220
        UIView.animate(withDuration: animationIn) {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func sendAvailability(availability: Bool) {
        purchaseViewController.setAvailability(available: availability)
    }
    
}
