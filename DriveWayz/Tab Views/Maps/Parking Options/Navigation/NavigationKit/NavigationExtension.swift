//
//  TestingNavigationViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
//import Mapbox

protocol handleCurrentNavView {
    func closeCurrentBooking()
    func changeInstructionsHeight(height: CGFloat)
    func setFinalDestination(address: String)
}

extension NavigationMapBox: handleCurrentNavView {
    
    func setupNavigation() {
        
//        navigationMapController.view.addSubview(locatorButton)
//        navigationMapController.view.addSubview(voiceButton)
//        navigationMapController.view.addSubview(routeButton)
//        navigationMapController.view.addSubview(walkingLocatorButton)
//        navigationMapController.view.addSubview(fullBackgroundView)
//
//        fullBackgroundView.topAnchor.constraint(equalTo: navigationMapController.view.topAnchor).isActive = true
//        fullBackgroundView.leftAnchor.constraint(equalTo: navigationMapController.view.leftAnchor).isActive = true
//        fullBackgroundView.rightAnchor.constraint(equalTo: navigationMapController.view.rightAnchor).isActive = true
//        fullBackgroundView.bottomAnchor.constraint(equalTo: navigationMapController.view.bottomAnchor).isActive = true
        
        // Setup main bottom and navigation instructions views
//        navigationMapController.view.addSubview(navigationInstructions.view)
//        navigationMapController.view.addSubview(navigationBottom.view)
//
//        navigationMapController.addChild(navigationBottom)
//        currentBottomHeightAnchor = navigationBottom.view.topAnchor.constraint(equalTo: navigationInstructions.view.bottomAnchor, constant: currentBookingHeight)
//            currentBottomHeightAnchor.isActive = true
//        navigationBottom.view.leftAnchor.constraint(equalTo: navigationMapController.view.leftAnchor).isActive = true
//        navigationBottom.view.rightAnchor.constraint(equalTo: navigationMapController.view.rightAnchor).isActive = true
//        navigationBottom.view.heightAnchor.constraint(equalToConstant: phoneHeight - 116 - statusHeight).isActive = true
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(currentViewIsScrolling(sender:)))
//        navigationBottom.view.addGestureRecognizer(pan)
//        navigationBottom.durationController.checkInButton.addTarget(self, action: #selector(checkInButtonPressed), for: .touchUpInside)
//        navigationBottom.durationController.issueButton.addTarget(self, action: #selector(endNavigationPressed(sender:)), for: .touchUpInside)
        
//        navigationInstructions.view.topAnchor.constraint(equalTo: navigationMapController.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
//        durationLeftAnchor = navigationInstructions.view.leftAnchor.constraint(equalTo: navigationMapController.view.leftAnchor, constant: 8)
//            durationLeftAnchor.isActive = true
//        durationRightAnchor = navigationInstructions.view.rightAnchor.constraint(equalTo: navigationMapController.view.rightAnchor, constant: -8)
//            durationRightAnchor.isActive = true
//        durationHeightAnchor = navigationInstructions.view.heightAnchor.constraint(equalToConstant: 140)
//            durationHeightAnchor.isActive = true

        
//        navigationMapController.view.layoutIfNeeded()
        
//        locatorButton.rightAnchor.constraint(equalTo: navigationMapController.view.rightAnchor, constant: -12).isActive = true
//        locatorButton.bottomAnchor.constraint(equalTo: navigationBottom.view.topAnchor, constant: -16).isActive = true
        locatorButton.heightAnchor.constraint(equalTo: locatorButton.widthAnchor).isActive = true
        locatorButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
//        voiceButton.rightAnchor.constraint(equalTo: navigationMapController.view.rightAnchor, constant: -20).isActive = true
//        voiceButton.topAnchor.constraint(equalTo: navigationInstructions.view.bottomAnchor, constant: 16).isActive = true
        voiceButton.heightAnchor.constraint(equalTo: voiceButton.widthAnchor).isActive = true
        voiceButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
//        routeButton.rightAnchor.constraint(equalTo: navigationMapController.view.rightAnchor, constant: -20).isActive = true
        routeButton.topAnchor.constraint(equalTo: voiceButton.bottomAnchor, constant: 16).isActive = true
        routeButton.heightAnchor.constraint(equalTo: routeButton.widthAnchor).isActive = true
        routeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
//        walkingLocatorButton.rightAnchor.constraint(equalTo: navigationMapController.view.rightAnchor, constant: -12).isActive = true
//        walkingLocatorButton.bottomAnchor.constraint(equalTo: navigationBottom.view.topAnchor, constant: -16).isActive = true
        walkingLocatorButton.heightAnchor.constraint(equalTo: locatorButton.widthAnchor).isActive = true
        walkingLocatorButton.widthAnchor.constraint(equalToConstant: 56).isActive = true

        
        let speakingBool = UserDefaults.standard.bool(forKey: "annotatesSpokenInstructions")
        if !speakingBool {
            self.voiceGuidancePressed(sender: voiceButton)
            self.annotatesSpokenInstructions = false
        } else {
            self.annotatesSpokenInstructions = true
        }
        
        delayWithSeconds(animationIn) {
            UIView.animate(withDuration: animationOut, animations: {
//                self.navigationInstructions.view.alpha = 1
//                self.navigationInstructions.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    @objc func routeButtonAction() {
//        navigationMapView.tracksUserCourse = false
//        let start = routeProgress.currentLeg.source
//        let end = routeProgress.currentLeg.destination
//        let coordinateBounds = MGLCoordinateBounds(sw: start.coordinate, ne: end.coordinate)
//        let insets = UIEdgeInsets(top: statusHeight + 64, left: 72, bottom: lowestHeight + 64, right: 72)
//        let routeCamera = self.navigationMapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
//        self.navigationMapView.setCamera(routeCamera, animated: true)
    }
    
    @objc func locatorButtonAction() {
//        navigationMapView.tracksUserCourse = true
//        navigationMapView.recenterMap()
    }
    
    @objc func voiceGuidancePressed(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = Theme.WHITE
            sender.tintColor = Theme.BLUE
            self.annotatesSpokenInstructions = false
            UserDefaults.standard.set(false, forKey: "annotatesSpokenInstructions")
            UserDefaults.standard.synchronize()
            self.speechSynth.stopSpeaking(at: .word)
        } else {
            sender.isSelected = true
            sender.backgroundColor = Theme.BLUE
            sender.tintColor = Theme.WHITE
            self.annotatesSpokenInstructions = true
            UserDefaults.standard.set(true, forKey: "annotatesSpokenInstructions")
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc func currentViewIsScrolling(sender: UIPanGestureRecognizer) {
        let translation = -sender.translation(in: self.view).y
        let state = sender.state
        let percentage = translation/(phoneHeight/3)
        if state == .changed {
            if percentage >= 0 && percentage <= 1 && previousBookingPercentage != 1.0 {
                changeScrollAmount(percentage: percentage)
            }
        } else if state == .ended {
            if previousBookingPercentage >= 0.25 {
                openCurrentBooking()
            } else {
                closeCurrentBooking()
            }
        }
    }
    
    func changeScrollAmount(percentage: CGFloat) {
        previousBookingPercentage = percentage
        
        currentBottomHeightAnchor.constant = currentBookingHeight - currentBookingHeight * percentage
        durationLeftAnchor.constant = 8 - 8 * percentage
        durationRightAnchor.constant = -8 + 8 * percentage
//        navigationInstructions.view.layer.cornerRadius = 4 - 4 * percentage
        
        fullBackgroundView.alpha = 0 + percentage
//        navigationMapController.view.layoutIfNeeded()
    }
    
    func openCurrentBooking() {
//        navigationBottom.scrollView.isScrollEnabled = true
        previousBookingPercentage = 1.0
        currentBottomHeightAnchor.constant = 0
        durationLeftAnchor.constant = 0
        durationRightAnchor.constant = 0
        
        lightContentStatusBar()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 1
//            self.navigationInstructions.view.layer.cornerRadius = 0
//            self.navigationMapController.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func closeCurrentBooking() {
//        navigationBottom.scrollView.setContentOffset(.zero, animated: true)
        previousBookingPercentage = 0.0
        currentBottomHeightAnchor.constant = currentBookingHeight
        durationLeftAnchor.constant = 8
        durationRightAnchor.constant = -8
        
        defaultContentStatusBar()
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
//            self.navigationInstructions.view.layer.cornerRadius = 4
//            self.navigationMapController.view.layoutIfNeeded()
        }) { (success) in
//            self.navigationBottom.scrollView.isScrollEnabled = false
        }
    }
    
    @objc func currentDurationTapped() {
        if previousBookingPercentage == 1.0 {
            closeCurrentBooking()
        } else {
            openCurrentBooking()
        }
    }
    
    func setFinalDestination(address: String) {
//        navigationInstructions.finalAddress = address
    }
    
    func changeInstructionsHeight(height: CGFloat) {
        if durationHeightAnchor != nil {
            durationHeightAnchor.constant = height
            UIView.animate(withDuration: animationIn) {
//                self.navigationMapController.view.layoutIfNeeded()
            }
        }
    }
    
}
