//
//  MBRouteLine.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import MapKit

var routeTimer: Timer?
var routeLineIndex: Int = 0

var followEnd: Bool = true

var routeLine: CAShapeLayer = {
    let line = CAShapeLayer()
    line.fillColor = UIColor.clear.cgColor
    line.lineJoin = CAShapeLayerLineJoin.round
    line.lineWidth = 4
    line.strokeColor = Theme.BLACK.cgColor
    line.lineCap = .round
    
    return line
}()

var routeUnderLine: CAShapeLayer = {
    let line = CAShapeLayer()
    line.fillColor = UIColor.clear.cgColor
    line.lineJoin = CAShapeLayerLineJoin.round
    line.lineWidth = 4
    line.strokeColor = Theme.GRAY_WHITE_1.withAlphaComponent(0.6).cgColor
    
    return line
}()

var routeWalkingLine: CAShapeLayer = {
    let line = CAShapeLayer()
    line.fillColor = UIColor.clear.cgColor
    line.lineJoin = CAShapeLayerLineJoin.round
    line.lineWidth = 6
    line.strokeColor = Theme.BLACK.cgColor
    line.lineDashPattern = [0, 16]
    line.lineCap = .round
    
    return line
}()

var routeWalkingUnderLine: CAShapeLayer = {
    let line = CAShapeLayer()
    line.fillColor = UIColor.clear.cgColor
    line.lineJoin = CAShapeLayerLineJoin.round
    line.lineWidth = 8
    line.strokeColor = Theme.BLACK.cgColor
    line.lineDashPattern = [0, 16]
    line.lineCap = .round
    
    return line
}()

var routeStartPin: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    view.backgroundColor = Theme.WHITE
    view.layer.cornerRadius = 9
    view.layer.borderColor = Theme.BLACK.cgColor
    view.layer.borderWidth = 7
    view.layer.shadowColor = Theme.BLACK.cgColor
    view.layer.shadowOpacity = 0.2
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 4

    return view
}()

var routeEndPin: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    view.backgroundColor = Theme.WHITE
    view.layer.cornerRadius = 1
    view.layer.borderColor = Theme.BLACK.cgColor
    view.layer.borderWidth = 7
    view.layer.shadowColor = Theme.BLACK.cgColor
    view.layer.shadowOpacity = 0.2
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 4

    return view
}()

extension MapKitViewController: CAAnimationDelegate {
    
    func createRouteLine(route: MKRoute, driving: Bool) {
        let poly = route.polyline
        var points: [CGPoint] = []
        for mapPoint in UnsafeBufferPointer(start: poly.points(), count: poly.pointCount) {
            let coordinate = mapPoint.coordinate
            let point = mapView.projection.point(for: coordinate)
            points.append(point)
        }
        let linePath = UIBezierPath()
        if points.count > 0, let start = points.first, let last = points.last {
            linePath.move(to: start)
            for point in points {
                linePath.addLine(to: point)
            }
            if driving {
                // Build route line and place pins for driving
                routeLine.path = route.polyline.accessibilityPath?.cgPath
                routeLine.path = linePath.cgPath
                routeUnderLine.path = linePath.cgPath
                routeStartPin.center = CGPoint(x: last.x, y: last.y)
            } else {
                // Build route line and place pins for walking
                routeWalkingLine.path = route.polyline.accessibilityPath?.cgPath
                routeWalkingLine.path = linePath.cgPath
                routeWalkingUnderLine.path = linePath.cgPath
                if userEnteredDestination { routeEndPin.center = CGPoint(x: last.x, y: last.y) }
            }
            followMarkers()
            followQuicks()
        }
    }
    
    func followMarkers() {
        let adjustment: CGFloat = 32
        if let location = firstLocation, let view = firstSpotView {
            let projection = mapView.projection.point(for: location.coordinate)
            let adjustedPoint = CGPoint(x: projection.x, y: projection.y - adjustment)
            view.center = adjustedPoint
            
            if !userEnteredDestination { routeEndPin.center = projection }
            if !followEnd { followQuickEnd(center: adjustedPoint)}
        }
        if let location = secondLocation, let view = secondSpotView {
            let projection = mapView.projection.point(for: location.coordinate)
            let adjustedPoint = CGPoint(x: projection.x, y: projection.y - adjustment)
            view.center = adjustedPoint
            
            if !userEnteredDestination { routeEndPin.center = projection }
            if !followEnd { followQuickEnd(center: adjustedPoint)}
        }
        if let location = thirdLocation, let view = thirdSpotView {
            let projection = mapView.projection.point(for: location.coordinate)
            let adjustedPoint = CGPoint(x: projection.x, y: projection.y - adjustment)
            view.center = adjustedPoint
            
            if !userEnteredDestination { routeEndPin.center = projection }
            if !followEnd { followQuickEnd(center: adjustedPoint)}
        }
    }
    
    func monitorRouteLines() {
        if !exactRouteLine {
            if let start = quadStartCoordinate, let end = quadEndCoordinate {
                let startCoor = CLLocation(latitude: start.latitude, longitude: start.longitude)
                let endCoor = CLLocation(latitude: end.latitude, longitude: end.longitude)
                drawCurvedOverlay(startCoordinate: startCoor, endCoordinate: endCoor)
            }
        } else {
            if let route = mapBoxRoute {
                createRouteLine(route: route, driving: true)
            }
        }
        if let route = mapBoxWalkingRoute {
            createRouteLine(route: route, driving: false)
        }
    }
    
    func followQuicks() {
        followQuickParking(center: routeStartPin.center)
        if followEnd {
            followQuickEnd(center: routeEndPin.center)
        }
        
        if quickParkingView.alpha == 0 {
            UIView.animate(withDuration: animationIn) {
                self.quickParkingView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.quickParkingView.alpha = 1
            }
        }
        if quickDurationView.alpha == 0 {
            UIView.animate(withDuration: animationIn) {
                self.quickDurationView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.quickDurationView.alpha = 1
            }
        }
    }
    
    func followQuickParking(center: CGPoint) {
        if center.x >= phoneWidth/2 {
            let difference = abs(self.quickParkingRightAnchor.constant - (center.x - self.quickParkingWidthAnchor.constant/2 + 20))
            self.quickParkingRightAnchor.constant = center.x - self.quickParkingWidthAnchor.constant/2 + 20
            self.monitorDifference(difference: difference)
        } else {
            let difference = abs(self.quickParkingRightAnchor.constant - (center.x + self.quickParkingWidthAnchor.constant/2 - 20))
            self.quickParkingRightAnchor.constant = center.x + self.quickParkingWidthAnchor.constant/2 - 20
            self.monitorDifference(difference: difference)
        }
        let height = (phoneHeight - parkingNormalHeight)/2
        if center.y >= height {
            let difference = abs(self.quickParkingTopAnchor.constant - (center.y - 40))
            self.quickParkingTopAnchor.constant = center.y - 40
            self.monitorDifference(difference: difference)
        } else {
            let difference = abs(self.quickParkingTopAnchor.constant - (center.y + 40))
            self.quickParkingTopAnchor.constant = center.y + 40
            self.monitorDifference(difference: difference)
        }
//        return CGPoint(x: x, y: y)
    }
    
    func followQuickEnd(center: CGPoint) {
        if center.x >= phoneWidth/2 {
            let difference = abs(self.quickDestinationRightAnchor.constant - (center.x - self.quickDestinationWidthAnchor.constant/2 + 20))
            self.quickDestinationRightAnchor.constant = center.x - self.quickDestinationWidthAnchor.constant/2 + 20
            self.monitorDifference(difference: difference)
        } else {
            let difference = abs(self.quickDestinationRightAnchor.constant - (center.x + self.quickDestinationWidthAnchor.constant/2 - 20))
            self.quickDestinationRightAnchor.constant = center.x + self.quickDestinationWidthAnchor.constant/2 - 20
            self.monitorDifference(difference: difference)
        }
        let height = (phoneHeight - parkingNormalHeight)/2
        if center.y >= height {
            let difference = abs(self.quickDestinationTopAnchor.constant - (center.y - 40))
            self.quickDestinationTopAnchor.constant = center.y - 40
            self.monitorDifference(difference: difference)
        } else {
            let difference = abs(self.quickDestinationTopAnchor.constant - (center.y + 40))
            self.quickDestinationTopAnchor.constant = center.y + 40
            self.monitorDifference(difference: difference)
        }
//        return CGPoint(x: x, y: y)
    }
    
    func animateRouteLine() {
        var animations = [CABasicAnimation]()
        let group = CAAnimationGroup()
        
        let animation1 = CABasicAnimation(keyPath: "strokeStart")
        // animation set up here, I've included a few properties as an example
        animation1.duration = 1.0
        animation1.fromValue = 1
        animation1.toValue = 0
        animations.append(animation1)
        
        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        animation2.duration = 1.0
        animation2.fromValue = 1
        animation2.toValue = 0
        // setting beginTime is the key to chaining these
        animation2.beginTime = 3.0
        animations.append(animation2)
        
        group.duration = 4.0
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.repeatCount = .greatestFiniteMagnitude
        group.animations = animations
        
        routeLine.add(group, forKey: "routeLine")
    }
    
    func animateWalkingLine() {
        var animations = [CABasicAnimation]()
        let group = CAAnimationGroup()
        
        let lineDashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        lineDashAnimation.fromValue = 16
        lineDashAnimation.toValue = 0
        lineDashAnimation.duration = 1.0
        lineDashAnimation.beginTime = 2.0
        
//            lineDashAnimation.repeatCount = Float.greatestFiniteMagnitude
        animations.append(lineDashAnimation)
        
        group.duration = 3.0
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        group.repeatCount = .greatestFiniteMagnitude
        group.animations = animations
        
        routeWalkingLine.add(group, forKey: "routeWalkingLine")
        routeWalkingUnderLine.add(group, forKey: "routeWalkingUnderLine")
    }
    
    func animateInRouteLine() {
        let animation = CABasicAnimation(keyPath: "opacity")
        // animation set up here, I've included a few properties as an example
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.isRemovedOnCompletion = true
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.animations = [animation]
        
        routeLine.add(group, forKey: "routeLine2")
        routeWalkingLine.add(group, forKey: "routeWalkingLine2")
    }
    
    func animateRouteUnderLine() {
        let animation = CABasicAnimation(keyPath: "opacity")
        // animation set up here, I've included a few properties as an example
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.isRemovedOnCompletion = true
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.animations = [animation]
        
        routeUnderLine.add(group, forKey: "routeUnderLine2")
        routeWalkingUnderLine.add(group, forKey: "routeWalkingUnderLine2")
    }
    
}
