//
//  ReservationsCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation
import Cosmos

class ReservationsView: UITableViewCell {
    
    var region: MGLCoordinateBounds?
    var route: MGLPolyline?
    var parking: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?
    
    var secondaryType: String = "driveway" {
        didSet {
            if secondaryType == "driveway" {
                let image = UIImage(named: "Residential Home Driveway")
                self.profileImageView.image = image
            } else if secondaryType == "parking lot" {
                let image = UIImage(named: "Parking Lot")
                self.profileImageView.image = image
            } else if secondaryType == "apartment" {
                let image = UIImage(named: "Apartment Parking")
                self.profileImageView.image = image
            } else if secondaryType == "alley" {
                let image = UIImage(named: "Alley Parking")
                self.profileImageView.image = image
            } else if secondaryType == "garage" {
                let image = UIImage(named: "Parking Garage")
                self.profileImageView.image = image
            } else if secondaryType == "gated spot" {
                let image = UIImage(named: "Gated Spot")
                self.profileImageView.image = image
            } else if secondaryType == "street spot" {
                let image = UIImage(named: "Street Parking")
                self.profileImageView.image = image
            } else if secondaryType == "underground spot" {
                let image = UIImage(named: "UnderGround Parking")
                self.profileImageView.image = image
            } else if secondaryType == "condo" {
                let image = UIImage(named: "Residential Home Driveway")
                self.profileImageView.image = image
            } else if secondaryType == "circular" {
                let image = UIImage(named: "Other Parking")
                self.profileImageView.image = image
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var dateLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        
        return view
    }()
    
    lazy var mapView: MGLMapView = {
        let view = MGLMapView(frame: CGRect(x: 0, y: 0, width: 400, height: 45))
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsUserLocation = true
        view.showsScale = false
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.logoView.isHidden = true
        view.attributionButton.isHidden = true
        view.isUserInteractionEnabled = false
        view.showsUserLocation = false
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5.0
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.starSize = 16
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5.0"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH6
        
        return label
    }()
    
    var paymentLabel: UILabel = {
        let view = UILabel()
        view.text = "Payment"
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        view.textAlignment = .right
        
        return view
    }()
    
    var paymentAmount: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPSemiBoldH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        view.textAlignment = .right
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mapView.delegate = self
        
        self.backgroundColor = UIColor.clear
        
        addSubview(container)
        addSubview(mapView)
        addSubview(dateLabel)
        addSubview(profileImageView)
        addSubview(userName)
        addSubview(stars)
        addSubview(starsLabel)
        addSubview(paymentLabel)
        addSubview(paymentAmount)
        
        let url = URL(string: "mapbox://styles/tcagle717/cjjnibq7002v22sowhbsqkg22")
        mapView.styleURL = url
        
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        dateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        mapView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        mapView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        mapView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6).isActive = true
        mapView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -70).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 14).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        userName.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userName.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        userName.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -2).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stars.leftAnchor.constraint(equalTo: userName.leftAnchor, constant: -2).isActive = true
        stars.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: -4).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 16).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 88).isActive = true
        
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 4).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        paymentLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        paymentLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        paymentLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -2).isActive = true
        paymentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        paymentAmount.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        paymentAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        paymentAmount.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: -2).isActive = true
        paymentAmount.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ReservationsView: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 3
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return Theme.BLUE
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.8
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // For better performance, always try to reuse existing annotations.
        if let title = annotation.title, title == "Destination" {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "destinationMapHistory")
            
            // If there is no reusable annotation image available, initialize a new one.
            if(annotationImage == nil) {
                annotationImage = MGLAnnotationImage(image: UIImage(named: "destinationMapHistory")!, reuseIdentifier: "destinationMapHistory")
            }
            
            return annotationImage
        } else {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotationMapHistory")
            
            // If there is no reusable annotation image available, initialize a new one.
            if(annotationImage == nil) {
                annotationImage = MGLAnnotationImage(image: UIImage(named: "annotationMapHistory")!, reuseIdentifier: "annotationMapHistory")
            }
            
            return annotationImage
        }
    }
    
    func drawRoute(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) {
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
        let directions = Directions.shared
        let waypoints = [
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: fromLocation.latitude, longitude: fromLocation.longitude), name: "Start"),
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: toLocation.latitude, longitude: toLocation.longitude), name: "Destination"),
        ]
        let options = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .walking)
        options.includesSteps = true
        
        _ = directions.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            if let route = routes?.first {
                if route.coordinateCount > 0 {
                    
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    routeLine.title = "reservationsMapViewPolyline"
                    let ne = routeLine.overlayBounds.ne
                    let sw = routeLine.overlayBounds.sw
                    let region = MGLCoordinateBounds(sw: sw, ne: ne)
                    self.mapView.addAnnotation(routeLine)
                    self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32), animated: false)
                    
                    delayWithSeconds(animationOut, completion: {
                        let marker = MGLPointAnnotation()
                        marker.coordinate = toLocation
                        marker.title = "Destination"
                        self.mapView.addAnnotation(marker)
                        
                        let marker2 = MGLPointAnnotation()
                        marker2.coordinate = fromLocation
                        self.mapView.addAnnotation(marker2)
                        
                        self.region = region
                        self.route = routeLine
                        self.parking = marker2.coordinate
                        self.destination = marker.coordinate
                    })
                }
            }
        }
    }
    
}
