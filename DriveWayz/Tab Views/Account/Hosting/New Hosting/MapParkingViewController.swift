//
//  MapParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit

class MapParkingViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var typeOfParking = "house"
    
    var latitude: Double?
    var longitude: Double?
    var dynamicPrice: CGFloat = 1.5
    
    var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.mapType = .standard
        view.showsUserLocation = true
        
        return view
    }()
    
    var mapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH4
        label.text = "This is what people will see when looking for your parking space"
        label.numberOfLines = 2
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self

        setupViews()
        locationAuthStatus()
    }
    
    func setupViews() {
        
        self.view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        
        self.view.addSubview(mapLabel)
        mapLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        mapLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        mapLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 12).isActive = true
        mapLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupAddressMarker(address: String, title: String, city: String, state: String) {
        self.removeAllMarkers()
        let geoCoder = CLGeocoder()
        let marker = MKPointAnnotation()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("Becoming a host could not find a location")
                    return
            }
            marker.title = title
            marker.coordinate = location.coordinate
            self.mapView.addAnnotation(marker)
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            let dynamicLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            dynamicPricing.getDynamicPricing(place: dynamicLocation, state: state, city: city, overallDestination: location.coordinate) { (dynamicPrice: CGFloat) in
                self.dynamicPrice = dynamicPrice
            }
        }
    }
    
    func removeAllMarkers() {
        let markers = self.mapView.annotations
        self.mapView.removeAnnotations(markers)
    }

}


extension MapParkingViewController: CLLocationManagerDelegate {
    func locationAuthStatus() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        let location = mapView.userLocation.coordinate
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
}


extension MapParkingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else { return nil }
        if typeOfParking == "house" {
            return AvailableHouseAnnotationView(annotation: annotation, reuseIdentifier: AvailableHouseAnnotationView.ReuseID)
        } else if typeOfParking == "parking lot" {
            return AvailableLotAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
        } else if typeOfParking == "apartment" {
            return AvailableApartmentAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
        } else {
            return AvailableHouseAnnotationView(annotation: annotation, reuseIdentifier: AvailableHouseAnnotationView.ReuseID)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let location = view.annotation?.coordinate {
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
}
