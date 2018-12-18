//
//  AccountViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin

var database: Database!
var storage: Storage!
var lattitudeConstant: Double = 0
var longitudeConstant: Double = 0
var formattedAddress: String = ""
var cityAddress: String = ""
var parkingSpotImage: UIImage?
var parking: Int = 0

protocol controlsBankAccount {
    func setupBankAccount()
}

protocol sendNewParking {
    func setupAddAVehicle()
    func setupAddAParkingSpot()
}

protocol controlsAccountViews {
    func removeOptionsFromView()
    func changeCurrentView(height: CGFloat)
    func removeAnalyticsController()
    func bringUpcomingViewController()
    func hideUpcomingViewController()
}

extension UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}
