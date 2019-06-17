//
//  MBPolylineRoute.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import Mapbox

extension MapKitViewController: MGLMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
//        addPolyline(to: mapView.style!)
//        animatePolyline()
    }
    
    func addPolyline(to style: MGLStyle) {
        if isCurrentlyBooked == false {
            self.shouldShowOverlay = true
            let stamp = Date().timeIntervalSince1970
            let source = MGLShapeSource(identifier: "\(stamp)", shape: nil, options: nil)
            style.addSource(source)
            polylineSource = source
            
            // Add a layer to style our polyline.
            let layer = MGLLineStyleLayer(identifier: "\(stamp)", source: source)
            layer.lineJoin = NSExpression(forConstantValue: "round")
            layer.lineCap = NSExpression(forConstantValue: "round")
            layer.lineColor = NSExpression(forConstantValue: Theme.PRUSSIAN_BLUE)
            layer.lineOpacity = NSExpression(forConstantValue: 0.4)
            layer.lineDashPattern = NSExpression(forConstantValue: [0, 1.5])
            layer.lineGradient = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($lineProgress, 'linear', nil, %@)", [
                0: Theme.LIGHT_ORANGE,
                0.3: Theme.STRAWBERRY_PINK,
                ])
            
            // The line width should gradually increase based on the zoom level.
            layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [14: 5, 18: 20])
            
            style.addLayer(layer)
            self.polylineLayer = layer
        } else {
            self.shouldShowOverlay = true
            let stamp = Date().timeIntervalSince1970
            let source = MGLShapeSource(identifier: "\(stamp)", shape: nil, options: nil)
            style.addSource(source)
            polylineSource = source
            
            // Add a layer to style our polyline.
            let layer = MGLLineStyleLayer(identifier: "\(stamp)", source: source)
            layer.lineJoin = NSExpression(forConstantValue: "round")
            layer.lineCap = NSExpression(forConstantValue: "round")
            layer.lineColor = NSExpression(forConstantValue: Theme.BLUE)
            layer.lineOpacity = NSExpression(forConstantValue: 0.8)
            layer.lineGradient = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($lineProgress, 'linear', nil, %@)", [
                0: Theme.PACIFIC_BLUE,
                0.1: Theme.STRAWBERRY_PINK,
                ])
            
            // The line width should gradually increase based on the zoom level.
            layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [14: 5, 18: 20])
            
            style.addLayer(layer)
            self.polylineLayer = layer
            self.animateFirstPolyline()
        }
    }
    
    func animateFirstPolyline() {
        if self.polylineFirstTimer != nil { self.polylineFirstTimer!.invalidate() }
        if self.shouldShowOverlay == true {
            currentFirstIndex = 1
            let timestep = Double(Double(1.0) / Double(self.parkingCoordinates.count))
            
            // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
            polylineFirstTimer = Timer.scheduledTimer(timeInterval: timestep, target: self, selector: #selector(firstTick), userInfo: nil, repeats: true)
        }
    }
    
    @objc func firstTick() {
        if currentFirstIndex > self.parkingCoordinates.count {
            polylineFirstTimer?.invalidate()
            polylineFirstTimer = nil
            
            if isCurrentlyBooked == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.animateFirstPolyline()
                }
            }
            
            return
        }
        
        // Create a subarray of locations up to the current index.
        let coordinates = Array(self.parkingCoordinates[0..<currentFirstIndex])
        
        // Update our MGLShapeSource with the current locations.
        updateFirstPolylineWithCoordinates(coordinates: coordinates)
        
        currentFirstIndex += 1
        
        if let layer = self.polylineLayer {
            let percent = CGFloat(currentFirstIndex) / CGFloat(self.parkingCoordinates.count)
            layer.lineOpacity = NSExpression(forConstantValue: 0.4 + 0.6 * percent)
        }
    }
    
    func updateFirstPolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        if self.shouldShowOverlay == true {
            var mutableCoordinates = coordinates
            
            let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
            
            // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
            polylineSource?.shape = polyline
        }
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        if annotation.title == "ParkingUnder" {
            return 0.8
        } else if annotation.title == "ParkingOver" {
            return 1
        } else {
            return 0.2
        }
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        if annotation.title == "ParkingUnder" {
            return 10
        } else if annotation.title == "ParkingOver" {
            return 6
        } else {
            return 6
        }
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        if annotation.title == "ParkingUnder" {
            return Theme.OFF_WHITE
        } else if annotation.title == "ParkingOver" {
            return Theme.BLUE
        } else {
            return Theme.PRUSSIAN_BLUE
        }
    }
    
}
