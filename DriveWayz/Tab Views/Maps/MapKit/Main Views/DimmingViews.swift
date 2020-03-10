//
//  MapKitParking.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
//import Mapbox

extension MapKitViewController {
    
    func setupDimmingViews() {
        
        view.addSubview(fullBackgroundView)
        fullBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fullBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -1).isActive = true
        fullBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 2).isActive = true
        fullBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(parkingBackButtonPressed))
        fullBackgroundView.addGestureRecognizer(tap)
        
    }

}
