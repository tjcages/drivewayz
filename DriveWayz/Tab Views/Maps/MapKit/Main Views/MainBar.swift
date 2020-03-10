//
//  MapKitMainBar.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import GoogleMaps

protocol HandleMainScreenDelegate {
    func closeSearch(parking: Bool)
    func showWelcomeBanner()
    func openBookings()
}

var canPanMainView: Bool = true

extension MapKitViewController: HandleMainScreenDelegate {
    
    func setupLocator() {

        mapView.addSubview(locatorButton)
        locatorButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        locatorButton.widthAnchor.constraint(equalTo: locatorButton.heightAnchor).isActive = true
        locatorMainBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: mainBarController.view.topAnchor, constant: -16)
            locatorMainBottomAnchor.isActive = true
        
        mapView.addSubview(parkingRouteButton)
        parkingRouteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        parkingRouteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        parkingRouteButton.widthAnchor.constraint(equalTo: parkingRouteButton.heightAnchor).isActive = true
        parkingRouteButton.bottomAnchor.constraint(equalTo: parkingController.view.topAnchor, constant: -16).isActive = true
        
        mapView.addSubview(currentRouteButton)
        currentRouteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        currentRouteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        currentRouteButton.widthAnchor.constraint(equalTo: currentRouteButton.heightAnchor).isActive = true
        currentRouteButton.bottomAnchor.constraint(equalTo: currentBookingController.view.topAnchor, constant: -16).isActive = true
        
    }
    
    @objc func readjustMainBar() {
        mainBarBottomAnchor.constant = phoneHeight - mainBarNormalHeight
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupWelcomeBanner() {
        view.addSubview(welcomeBannerView.view)
        welcomeBannerView.view.anchor(top: nil, left: view.leftAnchor, bottom: mainBarController.view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -36, paddingRight: 0, width: 0, height: 0)
        welcomeBannerHeightAnchor = welcomeBannerView.view.heightAnchor.constraint(equalToConstant: 0)
            welcomeBannerHeightAnchor.isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleWelcomeBanner))
        welcomeBannerView.view.addGestureRecognizer(tap)
        locatorMainBottomAnchor.constant = -52
        
        view.layoutIfNeeded()
        showWelcomeBanner()
        
        delayWithSeconds(animationOut * 2) {
            if self.mainBarBottomAnchor.constant == 0 {
                self.delegate?.hideHamburger()
                self.welcomeBannerView.disappear()
                self.welcomeBannerHeightAnchor.constant = self.welcomeBannerView.view.frame.maxY
                UIView.animateInOut(withDuration: animationIn, animations: {
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.welcomeBannerView.expand()
                }
            }
        }
    }
    
    func showWelcomeBanner() {
        if welcomeBannerHeightAnchor != nil {
            locatorMainBottomAnchor.constant = -52
            welcomeBannerHeightAnchor.constant = 72
            UIView.animateOut(withDuration: animationOut, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.welcomeBannerView.appear()
            }
        }
    }
    
    @objc func handleWelcomeBanner() {
        if welcomeBannerHeightAnchor.constant == 72 {
            delegate?.hideHamburger()
            welcomeBannerView.disappear()
            welcomeBannerHeightAnchor.constant = welcomeBannerView.view.frame.maxY
            UIView.animateInOut(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                if self.mainBarBottomAnchor.constant == 0 {
                    self.welcomeBannerView.expand()
                }
            }
        } else {
            welcomeBannerView.minimize()
            welcomeBannerHeightAnchor.constant = 72
            UIView.animateInOut(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.welcomeBannerView.appear()
                self.delegate?.bringHamburger()
            }
        }
    }
    
    func hideWelcomeBanner() {
        if welcomeBannerHeightAnchor != nil {
            welcomeBannerView.minimize()
            welcomeBannerView.disappear()
            welcomeBannerHeightAnchor.constant = 0
            locatorMainBottomAnchor.constant = -16
            UIView.animateOut(withDuration: animationOut, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                //
            }
        }
    }
    
    @objc func mainBarPanned(sender: UIPanGestureRecognizer) {
        if canPanMainView {
            let translation = -sender.translation(in: view).y/1.5
            let percent = translation/120
            let velocity = -sender.velocity(in: view).y
            if sender.state == .changed {
                if velocity >= 1000 {
                    searchPressed()
                } else if translation >= -16 && translation < 120 {
                    mainBarController.container.alpha = 1 - percent
                    mainBarHeightAnchor.constant = mainBarNormalHeight + translation
                    mainBarController.transitionToSearch(percent: percent)
                    view.layoutIfNeeded()
                } else if translation >= 120 {
                    searchPressed()
                }
            } else if sender.state == .ended {
                if translation >= 160 || velocity >= 1000 {
                    searchPressed()
                } else {
                    closeSearch(parking: false)
                }
            }
        }
    }
    
    @objc func searchPressed() {
        canPanMainView = false
        hideWelcomeBanner()
        delegate?.hideHamburger()
        mainBarHeightAnchor.constant = phoneHeight
        mainBarController.centerCoordinate = mapView.projection.coordinate(for: mapView.center)
        UIView.animateOut(withDuration: animationOut, animations: {
            self.mainBarController.transitionToSearch(percent: 1)
            self.mainBarController.container.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            canPanMainView = true
        }
    }
    
    func closeSearch(parking: Bool) {
        if !parking, let userLocation = self.locationManager.location {
            let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel - 0.5)
            mapView.camera = camera
            CATransaction.begin()
            CATransaction.setValue(0.8, forKey: kCATransactionAnimationDuration)
            let camera2 = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
            mapView.animate(to: camera2)
            CATransaction.commit()
        }
        
        canPanMainView = false
        delegate?.bringHamburger()
        mainBarHeightAnchor.constant = mainBarNormalHeight
        UIView.animateOut(withDuration: animationOut, animations: {
            self.mainBarController.transitionToSearch(percent: 0)
            self.mainBarController.container.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            canPanMainView = true
        }
    }
 
}
