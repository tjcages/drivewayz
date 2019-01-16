//
//  MBAnnotations.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation

extension MapKitViewController {

    func observeAllParking() {
        let ref = Database.database().reference().child("ParkingSpots")
        ref.observe(.childAdded, with: { (snapshot) in
            let parkingID = [snapshot.key]
            self.fetchParking(parkingID: parkingID)
        }, withCancel: nil)
        ref.observe(.childRemoved, with: { (snapshot) in
            self.parkingSpotsDictionary.removeValue(forKey: snapshot.key)
        }, withCancel: nil)
    }
    
    private func fetchParking(parkingID: [String]) {
        for parking in parkingID {
            let parkingID = parking
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
            ref.observe(.value, with: { (snapshot) in
                if var dictionary = snapshot.value as? [String:AnyObject] {
                    let parking = ParkingSpots(dictionary: dictionary)
                    let parkingID = dictionary["parkingID"] as! String
                    self.parkingSpotsDictionary[parkingID] = parking
                }
            }) { (error) in
                print("done")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.parkingSpots = Array(self.parkingSpotsDictionary.values)
            self.organizeParkingLocation()
        }
    }
    
    func organizeParkingLocation() {
        print(parkingSpots.count)
        for i in 0..<parkingSpots.count {
            let parking = self.parkingSpots[i]
            let location = parking.latitude
            print(location)
        }
    }
    
}
