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

    func drawCurvedOverlay(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D) {
        
        if let line = quadPolyline, let shadowLine = quadPolylineShadow {
            line.removeFromSuperlayer()
            shadowLine.removeFromSuperlayer()
        }
        
        let start = self.mapView.convert(startCoordinate, toPointTo: self.view)
        let raise: CGFloat = 1.0
        let startPoint = CGPoint(x: start.x, y: start.y - raise)
        let endPoint = self.mapView.convert(endCoordinate, toPointTo: self.view)
        let controlPoint = calculateControlPoint(startPoint: startPoint, endPoint: endPoint)

        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addQuadCurve(to: endPoint, controlPoint: controlPoint)

        line.strokeColor = Theme.PACIFIC_BLUE.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 6.0
        line.path = linePath.cgPath
        line.lineCap = .round
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 260)
        gradient.colors = [Theme.PACIFIC_BLUE.cgColor,
                           Theme.PURPLE.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.mask = line

        let lineShadow = CAShapeLayer()
        let linePathShadow = UIBezierPath()
        linePathShadow.move(to: startPoint)
        linePathShadow.addLine(to: endPoint)
        
        lineShadow.strokeColor = Theme.DARK_GRAY.withAlphaComponent(0.3).cgColor
        lineShadow.fillColor = UIColor.clear.cgColor
        lineShadow.lineWidth = 6.0
        lineShadow.path = linePathShadow.cgPath
        lineShadow.lineCap = .round

        quadPolylineShadow = lineShadow
        quadPolyline = gradient
        if let gradient = quadPolyline, let shadowLine = quadPolylineShadow {
            self.view.layer.addSublayer(shadowLine)
            self.view.layer.addSublayer(gradient)
        }
    }
    
    func createCurve() {
        
    }
    
    func zoomToCurve(first: CLLocationCoordinate2D, second: CLLocationCoordinate2D) {
        let long = [first.longitude, second.longitude].sorted()
        let lat = [first.latitude, second.latitude].sorted()
        if let leftLast = lat.last, let leftFirst = long.first, let rightFirst = lat.first, let rightLast = long.last {
            let leftMost = CLLocation(latitude: leftLast, longitude: leftFirst)
            let rightMost = CLLocation(latitude: rightFirst, longitude: rightLast)
            
            let region = MGLCoordinateBounds(sw: leftMost.coordinate, ne: rightMost.coordinate)
            self.mapView.userTrackingMode = .none
            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: 40, left: 36, bottom: phoneHeight - 260, right: 36), animated: true)
            delayWithSeconds(animationOut) {
                self.drawCurvedOverlay(startCoordinate: first, endCoordinate: second)
            }
        }
    }

    private func calculateControlPoint(startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let thrustMultiplier: CGFloat = 1.5
        let controlPointX = (startPoint.x + endPoint.x) / 2.0
        let controlPointY = min(startPoint.y, endPoint.y) - (thrustMultiplier * abs(endPoint.y - startPoint.y))

        return CGPoint(x: controlPointX, y: controlPointY)
    }

}
