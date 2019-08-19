//
//  HandleMainViews.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

enum MainViewState {
    case none
    case mainBar
    case parking
    case duration
    case payment
    case currentBooking
}

extension MapKitViewController {
    
    func reloadRequestedViews() {
        // Show disabled state
        self.mainBarTopAnchor.constant = 0
        self.parkingControllerBottomAnchor.constant = 420
        self.durationControllerBottomAnchor.constant = 500
        self.confirmControllerBottomAnchor.constant = 380
        self.currentBottomHeightAnchor.constant = 0
        
        self.locatorMainBottomAnchor.isActive = true
        self.locatorParkingBottomAnchor.isActive = false
        
        switch mainViewState {
        case .none:
            // Hide all views
            self.mainBarTopAnchor.constant = 0
            self.parkingControllerBottomAnchor.constant = 420
            self.durationControllerBottomAnchor.constant = 500
            self.confirmControllerBottomAnchor.constant = 380
            self.currentBottomHeightAnchor.constant = 0
            
            self.locatorMainBottomAnchor.isActive = true
            self.locatorParkingBottomAnchor.isActive = false
            
            self.locatorButton.alpha = 0
            self.currentSearchRegion.alpha = 0
            
        case .mainBar:
            // Show main bar
            self.mainBarController.scrollView.setContentOffset(.zero, animated: true)
            self.mainBarTopAnchor.constant = self.lowestHeight
            self.parkingControllerBottomAnchor.constant = 420
            self.durationControllerBottomAnchor.constant = 500
            self.confirmControllerBottomAnchor.constant = 380
            self.currentBottomHeightAnchor.constant = 0
            
            self.locatorMainBottomAnchor.isActive = true
            self.locatorParkingBottomAnchor.isActive = false
            
            self.locatorButton.alpha = 0
            self.currentSearchRegion.alpha = 0
            
        case .parking:
            // Show parking options
            self.mainBarTopAnchor.constant = 0
            self.parkingControllerBottomAnchor.constant = 0
            self.durationControllerBottomAnchor.constant = 500
            self.confirmControllerBottomAnchor.constant = 380
            self.currentBottomHeightAnchor.constant = 0
            
            self.parkingBackButtonBookAnchor.isActive = true
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.parkingBackButtonConfirmAnchor.isActive = false
            
            self.locatorMainBottomAnchor.isActive = false
            self.locatorParkingBottomAnchor.isActive = true
            
            
        case .duration:
            // Show duration options
            self.mainBarTopAnchor.constant = 0
            self.parkingControllerBottomAnchor.constant = 420
            self.durationControllerBottomAnchor.constant = 0
            self.confirmControllerBottomAnchor.constant = 380
            self.currentBottomHeightAnchor.constant = 0
            
            self.parkingBackButtonBookAnchor.isActive = false
            self.parkingBackButtonPurchaseAnchor.isActive = true
            self.parkingBackButtonConfirmAnchor.isActive = false
            
            self.locatorMainBottomAnchor.isActive = false
            self.locatorParkingBottomAnchor.isActive = true
            
            self.locatorButton.alpha = 0
            self.currentSearchRegion.alpha = 0
            
        case .payment:
            // Show payment options
            self.mainBarTopAnchor.constant = 0
            self.parkingControllerBottomAnchor.constant = 420
            self.durationControllerBottomAnchor.constant = 500
            self.confirmControllerBottomAnchor.constant = 0
            self.currentBottomHeightAnchor.constant = 0
            
            self.parkingBackButtonBookAnchor.isActive = false
            self.parkingBackButtonPurchaseAnchor.isActive = false
            self.parkingBackButtonConfirmAnchor.isActive = true
            
            self.locatorMainBottomAnchor.isActive = false
            self.locatorParkingBottomAnchor.isActive = true
            
            self.locatorButton.alpha = 0
            self.currentSearchRegion.alpha = 0
            
        case .currentBooking:
            // Show current booking
            self.removeAllHostLocations()
            self.mainBarTopAnchor.constant = 0
            self.parkingControllerBottomAnchor.constant = 420
            self.durationControllerBottomAnchor.constant = 500
            self.confirmControllerBottomAnchor.constant = 380
            self.currentBottomHeightAnchor.constant = self.lowestHeight
            
            self.locatorMainBottomAnchor.isActive = false
            self.locatorParkingBottomAnchor.isActive = true
            
            self.locatorButton.alpha = 1
            
        }
        
        UIView.animate(withDuration: animationOut, animations: {
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringHamburger()
            self.delegate?.defaultContentStatusBar()
        }
    }
    
    func setupMainViews() {
        setupMainBar()
        setupParking()
        setupDuration()
        setupPayment()
        setupCurrent()
    }
    
    func setupMainBar() {
        self.view.addSubview(mainBarController.view)
        mainBarController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mainBarController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mainBarTopAnchor = mainBarController.view.heightAnchor.constraint(equalToConstant: self.lowestHeight)
            mainBarTopAnchor.isActive = true
        mainBarController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(mainBarIsScrolling(sender:)))
        mainBarController.view.addGestureRecognizer(pan)
        mainBarController.searchController.searchButton.addTarget(self, action: #selector(mainBarWillOpen), for: .touchUpInside)
        mainBarController.searchController.microphoneButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
    }
    
    func setupParking() {
        self.view.addSubview(parkingController.view)
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkingControllerBottomAnchor = parkingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 420)
            parkingControllerBottomAnchor.isActive = true
        parkingControllerHeightAnchor = parkingController.view.heightAnchor.constraint(equalToConstant: 372)
            parkingControllerHeightAnchor.isActive = true
        parkingController.timeButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        parkingController.timeLabel.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        parkingController.mainButton.addTarget(self, action: #selector(bookSpotPressed), for: .touchUpInside)
    }
    
    func setupDuration() {
        self.view.addSubview(durationController.view)
        durationController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        durationController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        durationControllerBottomAnchor = durationController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 500)
            durationControllerBottomAnchor.isActive = true
        switch device {
        case .iphone8:
            durationController.view.heightAnchor.constraint(equalToConstant: 412).isActive = true
        case .iphoneX:
            durationController.view.heightAnchor.constraint(equalToConstant: 440).isActive = true
        }
    }
    
    func setupPayment() {
        self.view.addSubview(confirmPaymentController.view)
        confirmPaymentController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        confirmPaymentController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        confirmControllerBottomAnchor = confirmPaymentController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 380)
            confirmControllerBottomAnchor.isActive = true
        confirmPaymentController.view.heightAnchor.constraint(equalToConstant: 284).isActive = true
        confirmPaymentController.monitorCurrentParking()
        confirmPaymentController.changeButton.addTarget(self, action: #selector(changeFinalDates), for: .touchUpInside)
    }
    
    func setupCurrent() {
        self.view.addSubview(currentBottomController.view)
        currentBottomController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        currentBottomController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentBottomController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentBottomHeightAnchor = currentBottomController.view.heightAnchor.constraint(equalToConstant: 0)
            currentBottomHeightAnchor.isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(bottomPanned(sender:)))
        currentBottomController.view.addGestureRecognizer(pan)
    }
    
    
}
