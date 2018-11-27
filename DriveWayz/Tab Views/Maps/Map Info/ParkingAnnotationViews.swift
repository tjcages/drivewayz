//
//  ParkingAnnotationViews.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/4/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit

//AVAILABLE PARKING
class AvailableHouseAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = Theme.WHITE
        glyphTintColor = Theme.SEA_BLUE
        glyphImage = UIImage(named: "parking")
    }
}

class AvailableApartmentAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = Theme.WHITE
        glyphTintColor = Theme.SEA_BLUE
        glyphImage = UIImage(named: "apartmentIcon")
    }
}

class AvailableLotAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = Theme.WHITE
        glyphTintColor = Theme.SEA_BLUE
        glyphImage = UIImage(named: "parkingIcon")
    }
}

class DestinationAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = Theme.PACIFIC_BLUE
        glyphImage = UIImage(named: "destinationIcon")
    }
}

//UNAVAILABLE PARKING
class UnavailableHouseAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        glyphImage = UIImage(named: "parking")
    }
}

class UnavailableApartmentAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        glyphImage = UIImage(named: "apartmentIcon")
    }
}

class UnavailableLotAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        glyphImage = UIImage(named: "parkingIcon")
    }
}


class ClusterAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = Theme.PURPLE
        glyphTintColor = Theme.WHITE
        UIFont.systemFont(ofSize: 60, weight: .bold)
        glyphImage = UIImage(named: "parking")
    }
}





