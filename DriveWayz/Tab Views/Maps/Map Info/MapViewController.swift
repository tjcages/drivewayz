//
//  MapViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GeoFire
import Alamofire
import SwiftyJSON
import UserNotifications

struct Parking {
    var name: String
    var lattitude: Double
    var longitude: Double
}

var userEmail: String?
var couponActive: Int?

var currentButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = Theme.HARMONY_RED
    button.layer.shadowColor = Theme.DARK_GRAY.cgColor
    button.layer.shadowOffset = CGSize(width: 1, height: 1)
    button.layer.shadowRadius = 1
    button.layer.shadowOpacity = 0.8
    button.layer.cornerRadius = 5
    button.alpha = 0
    button.setTitle("Current Parking", for: .normal)
    button.titleLabel?.font = Fonts.SSPSemiBoldH5
    button.titleLabel?.textColor = Theme.WHITE
    
    return button
}()

protocol removePurchaseView {
    func currentParkingSender()
    func currentParkingDisappear()
    func purchaseButtonSwipedDown()
    func sendAvailability(availability: Bool)
    func showPurchaseStatus(status: Bool)
    func openMessages()
}

protocol controlHoursButton {
    func openHoursButton()
    func closeHoursButton()
//    func drawCurrentPath(dest: CLLocation, start: CLLocation, type: String, completion: Bool)
    func currentParkingDisappear()
    func hideNavigation()
}

protocol controlNewHosts {
    func sendNewHost()
}
