//
//  MBCluser.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/11/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import Intents
import Contacts
import GoogleMapsUtils

extension MapKitViewController: GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
          zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.animate(with: update)
        
        return true
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      if let poiItem = marker.userData as? ClusterItem {
        if let lot = poiItem.lot, let location = lot.location {
            lookUpLocation(location: location) { (placemark) in
                searchingPlacemark = placemark
                self.userEnteredDestination = false
                self.openBookings()
            }
        }
      }
      return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func lookUpLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                    completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
             // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
    
    func setupClusering() {
        // Set up the cluster manager with the supplied algorithm and renderer
        let iconGenerator = MapClusterIconGenerator()
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        renderer.animatesClusters = false
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)

        // Call cluster() after items have been added to perform the clustering and rendering on map
        clusterManager.cluster()
    }

    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        switch object {
        case let clusterItem as ClusterItem:
            
            let marker = SpotMarker(position: clusterItem.position)
            marker.title = clusterItem.name
            marker.lot = clusterItem.lot
            
            return marker
        default:
            return nil
        }
    }
    
}

class SpotView: UIView {
    
    public var availabilityLikelihood: CGFloat = 0.2 {
        didSet {
            changeAvailability()
        }
    }
    
    public var spotSelected: Bool = false {
        didSet {
            if spotSelected {
                markerSelected()
            } else {
                markerUnselected()
            }
        }
    }
    
    public var lot: ParkingLot? {
        didSet {
            if let lot = lot, let availability = lot.availabilityLikelihood {
                availabilityLikelihood = availability
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private var pinShape: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "mapMarker")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private var selectedPinShape: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "mapMarkerSelected")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.alpha = 0
        
        return button
    }()
    
    private var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "car_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private var backgroundLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        
        return view
    }()
    
    private var availabilityLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WARM_2_MED
        
        return view
    }()
    
    private var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 4
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowOpacity = 0.2
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        clipsToBounds = false
        
        setupViews()
    }
    
    private var containerBottomAnchor: NSLayoutConstraint!
    private var carIconTopAnchor: NSLayoutConstraint!
    private var availabilityRightAnchor: NSLayoutConstraint!
    
    private func setupViews() {
        
        addSubview(container)
        addSubview(selectedView)
        
        container.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        containerBottomAnchor = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12)
            containerBottomAnchor.isActive = true
        
        selectedView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        selectedView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 8, height: 8)
        
        container.addSubview(pinShape)
        container.addSubview(selectedPinShape)
        container.addSubview(backgroundLine)
        container.addSubview(carIcon)
        
        pinShape.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        selectedPinShape.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        carIcon.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        carIconTopAnchor = carIcon.topAnchor.constraint(equalTo: container.topAnchor, constant: 18)
            carIconTopAnchor.isActive = true
        carIcon.heightAnchor.constraint(equalTo: carIcon.widthAnchor).isActive = true
        carIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        backgroundLine.anchor(top: carIcon.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 22, height: 4)
        backgroundLine.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        backgroundLine.addSubview(availabilityLine)
        availabilityLine.anchor(top: backgroundLine.topAnchor, left: backgroundLine.leftAnchor, bottom: backgroundLine.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        availabilityRightAnchor = availabilityLine.rightAnchor.constraint(equalTo: backgroundLine.rightAnchor, constant: -20)
            availabilityRightAnchor.isActive = true
        
        layoutIfNeeded()
        
    }
    
    private func changeAvailability() {
        availabilityRightAnchor.constant = -20 * availabilityLikelihood
        UIView.animate(withDuration: animationIn) {
            if self.availabilityLikelihood >= 0.75 {
                self.availabilityLine.backgroundColor = Theme.GREEN
            } else if self.availabilityLikelihood < 0.75 && self.availabilityLikelihood > 0.25 {
                self.availabilityLine.backgroundColor = Theme.WARM_2_MED
            } else {
                self.availabilityLine.backgroundColor = Theme.WARM_1_MED
            }
            self.layoutIfNeeded()
        }
    }
    
    public func markerSelected() {
        containerBottomAnchor.constant = 0
        UIView.animate(withDuration: animationIn) {
            self.selectedView.alpha = 1
            self.selectedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.pinShape.alpha = 0
            self.selectedPinShape.alpha = 1
            self.carIcon.tintColor = Theme.WHITE
            self.layoutIfNeeded()
        }
    }
    
    public func markerUnselected() {
        containerBottomAnchor.constant = 12
        UIView.animate(withDuration: animationIn) {
            self.selectedView.alpha = 0
            self.selectedView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.pinShape.alpha = 1
            self.selectedPinShape.alpha = 0
            self.carIcon.tintColor = Theme.BLACK
            self.layoutIfNeeded()
        }
    }
    
    public func hideAvailability() {
        carIconTopAnchor.constant = 22
        UIView.animateOut(withDuration: animationIn, animations: {
            self.backgroundLine.alpha = 0
            self.availabilityLine.alpha = 0
            self.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SpotMarker: GMSMarker {
    
    public var availabilityLikelihood: CGFloat = 0.2 {
        didSet {
            spotView.availabilityLikelihood = availabilityLikelihood
        }
    }
    
    public var lot: ParkingLot? {
        didSet {
            if let lot = lot {
                spotView.lot = lot
            }
        }
    }
    
    private var spotView: SpotView = {
        let view = SpotView(frame: CGRect(x: 0, y: 0, width: 76, height: 82))
        
        return view
    }()
    
    init(position: CLLocationCoordinate2D) {
        super.init()
        self.position = position

        iconView = spotView
        appearAnimation = .pop
        
    }
    
}

class MapClusterIconGenerator: GMUDefaultClusterIconGenerator {

    override func icon(forSize size: UInt) -> UIImage {
        let image = textToImage(drawText: String(size) as NSString,
                                inImage: UIImage(named: "clusterMapMarker")!,
                                font: Fonts.SSPSemiBoldH4)
        return image
    }

    private func textToImage(drawText text: NSString, inImage image: UIImage, font: UIFont) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        let textColor = Theme.BLACK
        let attributes=[
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: textStyle,
            NSAttributedString.Key.foregroundColor: textColor]

        // vertically center (depending on font)
        let textH = font.lineHeight
        let textY = (image.size.height-textH)/3 + 3
        let textRect = CGRect(x: 0, y: textY, width: image.size.width, height: textH)
        text.draw(in: textRect.integral, withAttributes: attributes)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }

}

// Point of Interest Item which implements the GMUClusterItem protocol.
class ClusterItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var lot: ParkingLot?

    init(position: CLLocationCoordinate2D, name: String, lot: ParkingLot) {
        self.position = position
        self.name = name
        self.lot = lot
    }
}
