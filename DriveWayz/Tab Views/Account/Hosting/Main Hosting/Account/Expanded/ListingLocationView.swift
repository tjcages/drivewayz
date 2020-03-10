//
//  ListingLocationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ListingLocationView: UIViewController {

    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Location"
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "945 Diamond St. San Diego, CA"
        
        return label
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()

    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 32.799940, longitude: -117.253710, zoom: 18.0)
        let view = GMSMapView(frame: .zero, camera: camera)
        view.delegate = self
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false

        return view
    }()
    
    var mapPin = MapDropPin()
    
    var listedLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Listed on Nov. 4, 2019"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(informationLabel)
        view.addSubview(arrowButton)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        informationLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: arrowButton.leftAnchor, constant: -16).isActive = true
        informationLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        setupMap()
        
        view.addSubview(listedLabel)
        listedLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20).isActive = true
        listedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        listedLabel.sizeToFit()
        
    }

}

extension ListingLocationView: GMSMapViewDelegate {
    
    func setupMap() {

        view.addSubview(mapView)
        mapView.anchor(top: informationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 180)
        
        mapView.addSubview(mapPin)
        mapPin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapPin.centerYAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true
        mapPin.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mapPin.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        // Load the map style to be applied to Google Maps
        if let path = Bundle.main.path(forResource: "GoogleMapStyle", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                do {
                    // Set the map style by passing a valid JSON string.
                    if let jsonString = jsonToString(json: jsonResult as AnyObject) {
                        mapView.mapStyle = try GMSMapStyle(jsonString: jsonString)
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
    
}
