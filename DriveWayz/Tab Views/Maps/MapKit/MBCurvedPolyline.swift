//
//  MBCurvedPolyline.swift
//  Drivewayz
//
//  Created by Tyler Jordan Cagle on 12/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Mapbox

var quadPolyline: CAGradientLayer?
var quadPolylineShadow: CAShapeLayer?

extension MapKitViewController {

    func drawCurvedOverlay(startCoordinate: CLLocation, endCoordinate: CLLocation) {
        quadStartCoordinate = startCoordinate.coordinate
        quadEndCoordinate = endCoordinate.coordinate
        DestinationAnnotationLocation = endCoordinate
        
        let start = mapView.projection.point(for: startCoordinate.coordinate)
        let raise: CGFloat = 1.0
        let startPoint = CGPoint(x: start.x, y: start.y - raise)
        let endPoint = mapView.projection.point(for: endCoordinate.coordinate)
        
        let linePathShadow = UIBezierPath()
        linePathShadow.move(to: startPoint)
        linePathShadow.addLine(to: endPoint)
        
        routeUnderLine.path = linePathShadow.cgPath
        
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        let controlPoint = calculateControlPoint(startPoint: startPoint, endPoint: endPoint)
        linePath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        routeLine.path = linePath.cgPath
        routeParkingPin.center = CGPoint(x: startPoint.x, y: startPoint.y - 26)
        routeStartPin.center = CGPoint(x: endPoint.x, y: endPoint.y)
        if mainViewState != .parking {
            routeEndPin.center = routeParkingPin.center
        }
        
        mapView.addSubview(routeStartPin)
        mapView.addSubview(routeParkingPin)

        mapView.layer.insertSublayer(routeUnderLine, below: routeStartPin.layer)
        mapView.layer.insertSublayer(routeLine, below: routeStartPin.layer)
        
        mapView.bringSubviewToFront(quickDurationView)
        mapView.bringSubviewToFront(quickParkingView)
        
        followQuicks()
    }

    private func calculateControlPoint(startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let thrustMultiplier: CGFloat = 0.5
        let controlPointX = (startPoint.x + endPoint.x) / 2.0
        let controlPointY = min(startPoint.y, endPoint.y) - (thrustMultiplier * abs(endPoint.y - startPoint.y))

        return CGPoint(x: controlPointX, y: controlPointY)
    }

    func monitorDifference(difference: CGFloat) {
        if difference >= 30.0 {
            UIView.animate(withDuration: animationOut) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
}
