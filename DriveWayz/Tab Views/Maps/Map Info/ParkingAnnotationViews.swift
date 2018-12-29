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

//class DestinationAnnotationView: MKMarkerAnnotationView {
//
//    static let ReuseID = "availableAnnotation"
//
//    /// - Tag: ClusterIdentifier
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        clusteringIdentifier = "available"
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForDisplay() {
//        super.prepareForDisplay()
//        transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        displayPriority = .defaultLow
//        markerTintColor = Theme.PACIFIC_BLUE
//        glyphImage = UIImage(named: "destinationIcon")
//    }
//}

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

class DestinationAnnotationView : MKAnnotationView {
    
    static let ReuseID = "availableAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        self.canShowCallout = true
        self.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        self.layer.shadowColor = Theme.DARK_GRAY.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.6
        
        let view = UIView(frame: self.frame)
        view.backgroundColor = Theme.PURPLE
        view.layer.cornerRadius = 7.5
        self.addSubview(view)
        
        let whiteView = UIView(frame: CGRect(x: 7.5/2, y: 7.5/2, width: 7.5, height: 7.5))
        whiteView.backgroundColor = Theme.WHITE
        whiteView.layer.cornerRadius = 7.5/2
        self.addSubview(whiteView)
        
        DispatchQueue.main.async {
            self.swell(view: view, whiteView: whiteView)
        }
    }
    
    func swell(view: UIView, whiteView: UIView) {
        UIView.animate(withDuration: 4, delay: 0, options: .curveEaseIn, animations: {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            whiteView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (finished) -> Void in
            self.shrink(view: view, whiteView: whiteView)
        }
    }
    
    func shrink(view: UIView, whiteView: UIView) {
        UIView.animate(withDuration: 6, delay: 0, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            whiteView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished) -> Void in
            self.swell(view: view, whiteView: whiteView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}



