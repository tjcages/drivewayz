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
