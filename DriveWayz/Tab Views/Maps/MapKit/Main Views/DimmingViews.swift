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
    
    func setupDimmingViews() {
        
        self.view.addSubview(fullBackgroundView)
        fullBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fullBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -1).isActive = true
        fullBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 2).isActive = true
        fullBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 1).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(parkingBackButtonPressed))
        fullBackgroundView.addGestureRecognizer(tap)
        
    }

}
