//
//  LocationMapView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationMapView: UIViewController {
    
    var finalCoordinate: CLLocationCoordinate2D?
    var shouldMonitor: Bool = true
    
    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 37.8249, longitude: -122.4194, zoom: 12.0)
        let view = GMSMapView(frame: .zero, camera: camera)
        view.delegate = self
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMyLocationEnabled = true
        view.padding = UIEdgeInsets(top: 32, left: 8, bottom: 224, right: 8)
        
        return view
    }()

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        label.alpha = 0
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 3
        label.text = "Confirm the location of the parking spot."
        label.alpha = 0
        
        return label
    }()

    var mapPin = MapDropPin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupViews()
    }
    
    var containerTopAnchor: NSLayoutConstraint!
    var containerBottomAnchor: NSLayoutConstraint!
    
    func setupMap() {
        
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        mapView.addSubview(mapPin)
        mapPin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapPin.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -112).isActive = true
        mapPin.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mapPin.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        // Load the map style to be applied to Google Maps
        if let path = Bundle.main.path(forResource: "GoogleMapDropStyle", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                do {
                    // Set the map style by passing a valid JSON string.
                    if let jsonString = jsonToString(json: jsonResult as AnyObject) {
                        mapView.mapStyle = try GMSMapStyle(jsonString: jsonString)
//                        mapStyle = mapView.mapStyle
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            } catch {
                // handle error
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
        
    }
    
    func setupViews() {
        
        view.addSubview(container)
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerTopAnchor = container.topAnchor.constraint(equalTo: view.topAnchor)
            containerTopAnchor.isActive = true
        containerBottomAnchor = container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -208)
            containerBottomAnchor.isActive = true
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        mainLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -112).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func zoomToAddress(address: String, street: String) {
        mainLabel.text = street
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                return
            }
            let camera = GMSCameraUpdate.setTarget(location.coordinate, zoom: 19.0)
            self.mapView.animate(with: camera)
        }
    }

    func showMap() {
        containerTopAnchor.isActive = false
        containerBottomAnchor.isActive = true
        UIView.animate(withDuration: animationOut * 2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.mainLabel.alpha = 1
                self.subLabel.alpha = 1
            }
        }
    }
    
    func hideMap() {
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
        }) { (success) in
            self.containerTopAnchor.isActive = true
            self.containerBottomAnchor.isActive = false
            UIView.animate(withDuration: animationOut * 2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
               self.view.layoutIfNeeded()
            }) { (success) in
               //
            }
        }
    }
    
}


extension LocationMapView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapPin.placePin()
        
        if shouldMonitor {
            let x = mapPin.center.x
            let y = mapPin.frame.maxY
            let point = CGPoint(x: x, y: y)
            
            let coordinate = mapView.projection.coordinate(for: point)
            finalCoordinate = coordinate
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapPin.pinMoving()
    }
    
}
