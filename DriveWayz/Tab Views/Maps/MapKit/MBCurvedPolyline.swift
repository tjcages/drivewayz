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

var destinationA: Bool = true
var destinationB: Bool = false
var destinationC: Bool = true
var destinationD: Bool = false

extension MapKitViewController {

    func drawCurvedOverlay(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D) {
        if let line = quadPolyline, let shadowLine = quadPolylineShadow {
            line.removeFromSuperlayer()
            shadowLine.removeFromSuperlayer()
        }
        
        let start = self.mapView.convert(startCoordinate, toPointTo: self.view)
        let raise: CGFloat = 1.0
        var startPoint = CGPoint(x: start.x, y: start.y - raise)
        var endPoint = self.mapView.convert(endCoordinate, toPointTo: self.view)
        self.moveQuickControllers(startPoint: start)
        
        let distance = startCoordinate.distance(to: endCoordinate)
//        if distance >= 3218.69 {
        if distance >= -1 {
            return
        }
        
        let lineShadow = CAShapeLayer()
        let linePathShadow = UIBezierPath()
        linePathShadow.move(to: startPoint)
        linePathShadow.addLine(to: endPoint)
        
        lineShadow.strokeColor = Theme.DARK_GRAY.withAlphaComponent(0.1).cgColor
        lineShadow.fillColor = UIColor.clear.cgColor
        lineShadow.lineWidth = 6.0
        lineShadow.path = linePathShadow.cgPath
        lineShadow.lineCap = .round
        
        let width = start.x - endPoint.x
        let height = start.y - endPoint.y
        
        let gradient = CAGradientLayer()
        var startGradientPoint = CGPoint(x: 0, y: 0)
        
        if width <= 0 {
            if height >= 0 {
                startGradientPoint = CGPoint(x: start.x, y: endPoint.y)
            } else {
                startGradientPoint = CGPoint(x: start.x, y: start.y)
            }
            gradient.colors = [Theme.STRAWBERRY_PINK.cgColor,
                               Theme.LIGHT_ORANGE.cgColor]
        } else {
            if height >= 0 {
                startGradientPoint = CGPoint(x: endPoint.x, y: endPoint.y)
            } else {
                startGradientPoint = CGPoint(x: endPoint.x, y: start.y)
            }
            gradient.colors = [Theme.LIGHT_ORANGE.cgColor,
                               Theme.STRAWBERRY_PINK.cgColor]
        }
        gradient.frame = CGRect(x: startGradientPoint.x - 8, y: 0, width: abs(width) + 16, height: phoneHeight)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        
        startPoint.x = startPoint.x - gradient.frame.minX
        startPoint.y = startPoint.y - gradient.frame.minY
        endPoint.x = endPoint.x - gradient.frame.minX
        endPoint.y = endPoint.y - gradient.frame.minY
        
        linePath.move(to: startPoint)
        let controlPoint = calculateControlPoint(startPoint: startPoint, endPoint: endPoint)
        linePath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        line.strokeColor = Theme.WHITE.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 6.0
        line.path = linePath.cgPath
        line.lineCap = .round
        line.opacity = 0.8
        
        gradient.mask = line

        quadPolylineShadow = lineShadow
        quadPolyline = gradient
        if let gradient = quadPolyline, let shadowLine = quadPolylineShadow {
            self.mapView.layer.addSublayer(shadowLine)
            self.mapView.layer.addSublayer(gradient)
        }
    }
    
    func createCurve() {
        
    }
    
    func zoomToCurve(first: CLLocationCoordinate2D, second: CLLocationCoordinate2D) {
//        let long = [first.longitude, second.longitude].sorted()
//        let lat = [first.latitude, second.latitude].sorted()
//        if let leftLast = lat.last, let leftFirst = long.first, let rightFirst = lat.first, let rightLast = long.last {
//            let leftMost = CLLocation(latitude: leftLast, longitude: leftFirst)
//            let rightMost = CLLocation(latitude: rightFirst, longitude: rightLast)
//
//            let region = MGLCoordinateBounds(sw: leftMost.coordinate, ne: rightMost.coordinate)
//            self.mapView.userTrackingMode = .none
//            self.mapView.setVisibleCoordinateBounds(region, edgePadding: UIEdgeInsets(top: statusHeight + 40, left: 36, bottom: phoneHeight - 260, right: 36), animated: true)
//            delayWithSeconds(animationOut) {
//                self.drawCurvedOverlay(startCoordinate: first, endCoordinate: second)
//            }
//        }
    }

    private func calculateControlPoint(startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let thrustMultiplier: CGFloat = 1.5
        let controlPointX = (startPoint.x + endPoint.x) / 2.0
        let controlPointY = min(startPoint.y, endPoint.y) - (thrustMultiplier * abs(endPoint.y - startPoint.y))

        return CGPoint(x: controlPointX, y: controlPointY)
    }
    
    func moveQuickControllers(startPoint: CGPoint) {
        if self.quickParkingController.view.alpha == 0 {
            UIView.animate(withDuration: animationIn) {
                self.quickParkingController.view.alpha = 1
            }
        }
        if self.quickDestinationController.view.alpha == 0 {
            UIView.animate(withDuration: animationIn) {
                self.quickDestinationController.view.alpha = 1
            }
        }
        if startPoint.x >= phoneWidth/2 {
            let difference = abs(self.quickDestinationRightAnchor.constant - (startPoint.x - self.quickDestinationWidthAnchor.constant/2 - 16))
            self.quickDestinationRightAnchor.constant = startPoint.x - self.quickDestinationWidthAnchor.constant/2 - 16
            self.monitorDifference(difference: difference)
        } else {
            let difference = abs(self.quickDestinationRightAnchor.constant - (startPoint.x + self.quickDestinationWidthAnchor.constant/2 + 16))
            self.quickDestinationRightAnchor.constant = startPoint.x + self.quickDestinationWidthAnchor.constant/2 + 16
            self.monitorDifference(difference: difference)
        }
        if startPoint.y >= phoneHeight/4 {
            let difference = abs(self.quickDestinationTopAnchor.constant - (startPoint.y - 20))
            self.quickDestinationTopAnchor.constant = startPoint.y - 20
            self.monitorDifference(difference: difference)
        } else {
            let difference = abs(self.quickDestinationTopAnchor.constant - (startPoint.y + 20))
            self.quickDestinationTopAnchor.constant = startPoint.y + 20
            self.monitorDifference(difference: difference)
        }
        if let destinationCoor = DestinationAnnotationLocation?.coordinate {
            let destinationPoint = self.mapView.convert(destinationCoor, toPointTo: self.view)
            resetDestinationCoor()
            if destinationPoint.x >= phoneWidth/2 {
                let difference = abs(self.quickParkingRightAnchor.constant - (destinationPoint.x - self.quickParkingWidthAnchor.constant/2 - 16))
                self.quickParkingRightAnchor.constant = destinationPoint.x - self.quickParkingWidthAnchor.constant/2 - 16
                self.monitorDifference(difference: difference)
                destinationA = true
            } else {
                let difference = abs(self.quickParkingRightAnchor.constant - (destinationPoint.x + self.quickParkingWidthAnchor.constant/2 + 16))
                self.quickParkingRightAnchor.constant = destinationPoint.x + self.quickParkingWidthAnchor.constant/2 + 16
                self.monitorDifference(difference: difference)
                destinationB = true
            }
            if destinationPoint.y >= phoneHeight/4 {
                let difference = abs(self.quickParkingRightAnchor.constant - (destinationPoint.y - 20))
                self.quickParkingTopAnchor.constant = destinationPoint.y - 20
                self.monitorDifference(difference: difference)
                destinationC = true
            } else {
                let difference = abs(self.quickParkingRightAnchor.constant - (destinationPoint.y + 20))
                self.quickParkingTopAnchor.constant = destinationPoint.y + 20
                self.monitorDifference(difference: difference)
                destinationD = true
            }
//            if destinationA && destinationC {
//                quickParkingController.container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
//                print("AC")
//            } else if destinationA && destinationD {
//                quickParkingController.container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//                print("AD")
//            } else if destinationB && destinationC {
//                quickParkingController.container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
//                print("BC")
//            } else if destinationB && destinationD {
//                quickParkingController.container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//                print("BD")
//            }
        }
    }
    
    func resetDestinationCoor() {
        destinationA = false
        destinationB = false
        destinationC = false
        destinationD = false
    }

    func monitorDifference(difference: CGFloat) {
        if difference >= 40.0 {
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
}
