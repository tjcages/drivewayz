//
//  MBCoreMotion.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

extension MapKitViewController {
    
    func setupCoreMotion() {
//        DispatchQueue.main.async {
//        delayWithSeconds(2) {
//            self.motionManager = CMMotionActivityManager()
//            self.motionManager.startActivityUpdates(to: .main, withHandler: { (activity) in
//                guard let activity = activity else { return }
//                if activity.automotive {
//                    print("car")
//                } else if activity.walking {
//                    print("walking")
//                }
//            })
//        }
//        }
//        motionTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(resetMotionTimer), userInfo: nil, repeats: true)
    }
    
    @objc func resetMotionTimer() {
        self.shouldUpdatePolyline = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if isCurrentlyBooked && self.shouldUpdatePolyline {
//            self.shouldUpdatePolyline = false
//            print("updating")
////            self.drawCurrentParkingPolyline()
//        }
    }
    
}
