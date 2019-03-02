//
//  ParkingAnnotationViews.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/4/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
import Mapbox

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

class DestinationAnnotationView : MGLAnnotationView, CAAnimationDelegate {
    
    static let ReuseID = "availableAnnotation"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        layer.backgroundColor = Theme.WHITE.cgColor
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 6
        layer.borderColor = Theme.PURPLE.cgColor
        layer.removeAllAnimations()

//        swell()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation {
            if let value = animation.toValue as? Int {
                if value == 2 {
                    layer.removeAllAnimations()
                    self.shrink()
                } else if value == 5 {
                    self.swell()
                }
            }
        }
    }
    
    func swell() {
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = 5
        animation.toValue = 2
        animation.duration = 4
        animation.delegate = self
        layer.add(animation, forKey: "borderWidth")
    }
    
    func shrink() {
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = 2
        animation.toValue = 5
        animation.duration = 6
        animation.delegate = self
        layer.add(animation, forKey: "borderWidth")
    }
    
}

class MBDrivewayAnnotationView : MGLAnnotationView {
    
    static let ReuseID = "availableAnnotation"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        layer.backgroundColor = Theme.BLACK.cgColor
//        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = Theme.PURPLE.cgColor
        addPikeOnView(side: .Bottom, size: 20)
        
    }
    
}



class MBXAnnotationView: MGLAnnotationView {
    
    var imageView: UIImageView!
    
    override init(annotation: MGLAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let image = UIImage(named: "marker")
        imageView = UIImageView(image: image)
        addSubview(imageView)
        frame = imageView.frame
        
        isDraggable = true
        centerOffset = CGVector(dx: 0.5, dy: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)
        
        switch dragState {
        case .starting:
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
                self.transform = self.transform.scaledBy(x: 2, y: 2)
            })
        case .ending:
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
                self.transform = CGAffineTransform.identity
            })
        default:
            break
        }
    }
}

class MBXClusterView: MGLAnnotationView {
    
    var imageView: UIImageView!
    
    override init(annotation: MGLAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let image = UIImage(named: "cluster")
        imageView = UIImageView(image: image)
        addSubview(imageView)
        frame = imageView.frame
        
        centerOffset = CGVector(dx: 0.5, dy: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
}




