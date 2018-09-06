//
//  ParkingAnnotationViews.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/4/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit

@available(iOS 11.0, *)
class AvailableAnnotationView: MKMarkerAnnotationView {
    
    static let ReuseID = "availableAnnotation"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "available"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        displayPriority = .defaultLow
        markerTintColor = Theme.PRIMARY_COLOR
        glyphImage = UIImage(named: "parking")
    }
}

@available(iOS 11.0, *)
class UnavailableAnnotationView: MKMarkerAnnotationView {
    
    static let ReuseID = "unavailableAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "unavailable"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: DisplayConfiguration
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        glyphImage = UIImage(named: "parking")
    }
}




