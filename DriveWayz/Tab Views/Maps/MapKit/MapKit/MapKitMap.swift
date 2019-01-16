//
//  MapKitMap.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import MapKit
import Mapbox

extension MapKitViewController {
    
    func saveUserCurrentLocation() {
//        userLocation = self.mapView.userLocation.location
    }
    
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        
//    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKClusterAnnotation {
//            return ClusterAnnotationView(annotation: annotation, reuseIdentifier: ClusterAnnotationView.ReuseID)
//        } else {
//            guard let annotation = annotation as? MKPointAnnotation else { return nil }
//            var parkingType: String = "house"
//            var currentAvailable: Bool = true
//            if annotation.subtitle == "Destination" {
//                return DestinationAnnotationView(annotation: annotation, reuseIdentifier: DestinationAnnotationView.ReuseID)
//            }
//            if let subtitle = annotation.subtitle {
//                if subtitle != "" {
//                    if let string = annotation.subtitle {
//                        if let intFromString = Int(string) {
//                            if parkingSpots.count >= intFromString {
//                                let parking = parkingSpots[intFromString]
//                                parkingType = parking.parkingType!
//                                if parking.currentAvailable == true || parking.currentAvailable == nil {
//                                    currentAvailable = true
//                                } else {
//                                    currentAvailable = false
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            if parkingType == "parkingLot" {
//                if currentAvailable == false {
//                    return UnavailableLotAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
//                } else {
//                    return AvailableLotAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
//                }
//            } else if parkingType == "apartment" {
//                if currentAvailable == false {
//                    return UnavailableApartmentAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
//                } else {
//                    return AvailableApartmentAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
//                }
//            } else {
//                if currentAvailable == false {
//                    return UnavailableHouseAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
//                } else {
//                    return AvailableHouseAnnotationView(annotation: annotation, reuseIdentifier: UnavailableLotAnnotationView.ReuseID)
//                }
//            }
//        }
//    }
    
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let annotation = view.annotation else { return }
//        self.annotationSelected = annotation
//        if let cluster = annotation as? MKClusterAnnotation {
//            var zoomRect = MKMapRect.null
//            for annotation in cluster.memberAnnotations {
//                let annotationPoint = MKMapPoint(annotation.coordinate)
//                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
//                if MKMapRectEqualToRect(zoomRect, MKMapRect.null) {
//                    zoomRect = pointRect
//                } else {
//                    zoomRect = zoomRect.union(pointRect)
//                }
//            }
//            mapView.setVisibleMapRect(zoomRect, animated: true)
//        } else if let annotation = annotation as? MKPointAnnotation {
//            let location: CLLocationCoordinate2D = annotation.coordinate
//            var region = MKCoordinateRegion()
//            region.center = location
//            region.span.latitudeDelta = 0.001
//            region.span.longitudeDelta = 0.001
//            self.mapView.setRegion(region, animated: true)
//            if annotation.title == "Destination" { return }
//            if annotation.subtitle! != "" {
//                if let string = view.annotation!.subtitle, string != nil {
//                    if let intFromString = Int(string!) {
//                        if parkingSpots.count >= intFromString {
//                            let parking = parkingSpots[intFromString]
//                            self.informationViewController.setData(cityAddress: parking.parkingCity!, imageURL: parking.parkingImageURL!, parkingCost: parking.parkingCost!, formattedAddress: parking.parkingAddress!, timestamp: parking.timestamp!, id: parking.id!, parkingID: parking.parkingID!, parkingDistance: parking.parkingDistance!, rating: parking.rating!, message: parking.message!)
//                            self.purchaseViewController.setData(parkingCost: parking.parkingCost!, parkingID: parking.parkingID!, id: parking.id!)
//                            self.purchaseViewController.resetReservationButton()
//                        }
//                    }
//                }
//
//                self.purchaseViewController.view.alpha = 1
//                UIView.animate(withDuration: animationIn, animations: {
//                    //
//                }) { (success) in
//                    UIView.animate(withDuration: animationIn, animations: {
//                        self.purchaseViewAnchor.constant = 0
//                        self.view.layoutIfNeeded()
//                    }) { (success) in
//                        //
//                    }
//                }
//            }
//        }
//    }
    
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        self.purchaseButtonSwipedDown()
//        guard view.annotation != nil else { return }
//        UIView.animate(withDuration: animationIn) {
////            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//            self.swipeLabel.alpha = 0
//        }
//    }
//    
//    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//        views.forEach { $0.alpha = 0 }
//        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
//            views.forEach { $0.alpha = 1 }
//        }, completion: nil)
//    }
    
}
