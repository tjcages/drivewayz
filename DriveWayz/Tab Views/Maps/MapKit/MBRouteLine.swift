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
    line.strokeColor = Theme.DARK_GRAY.cgColor
    
    return line
}()

var routeUnderLine: CAShapeLayer = {
    let line = CAShapeLayer()
    line.fillColor = UIColor.clear.cgColor
    line.lineJoin = CAShapeLayerLineJoin.round
    line.lineWidth = 4
    line.strokeColor = Theme.PRUSSIAN_BLUE.cgColor
    
    return line
}()

var routeWalkingLine: CAShapeLayer = {
    let line = CAShapeLayer()
    line.fillColor = UIColor.clear.cgColor
    line.lineJoin = CAShapeLayerLineJoin.round
    line.lineWidth = 6
    line.strokeColor = Theme.DARK_GRAY.cgColor
    line.lineDashPattern = [0, 16]
    line.lineCap = .round
    
    return line
}()

var routeWalkingUnderLine: CAShapeLayer = {
    let line = CAShapeLayer()
    line.fillColor = UIColor.clear.cgColor
    line.lineJoin = CAShapeLayerLineJoin.round
    line.lineWidth = 8
    line.strokeColor = Theme.DARK_GRAY.cgColor
    line.lineDashPattern = [0, 16]
    line.lineCap = .round
    
    return line
}()

var routeStartPin: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    view.backgroundColor = Theme.WHITE
    view.layer.cornerRadius = 9
    view.layer.borderColor = Theme.DARK_GRAY.cgColor
    view.layer.borderWidth = 7
    view.layer.shadowColor = Theme.DARK_GRAY.cgColor
    view.layer.shadowOpacity = 0.2
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 4

    return view
}()

var routeParkingPin: UIImageView = {
    let image = UIImage(named: "routeSelectedPin")
    let view = UIImageView(image: image)
    view.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
    view.contentMode = .scaleAspectFill
    
    return view
}()

var routeEndPin: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    view.backgroundColor = Theme.WHITE
    view.layer.cornerRadius = 1
    view.layer.borderColor = Theme.DARK_GRAY.cgColor
    view.layer.borderWidth = 7
    view.layer.shadowColor = Theme.DARK_GRAY.cgColor
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
                routeLine.path = route.polyline.accessibilityPath?.cgPath
                routeLine.path = linePath.cgPath
                routeUnderLine.path = linePath.cgPath
                routeStartPin.center = CGPoint(x: last.x, y: last.y)
                routeParkingPin.center = CGPoint(x: start.x, y: start.y - 26)
            } else {
                routeWalkingLine.path = route.polyline.accessibilityPath?.cgPath
                routeWalkingLine.path = linePath.cgPath
                routeWalkingUnderLine.path = linePath.cgPath
                routeEndPin.center = CGPoint(x: start.x, y: start.y)
                routeParkingPin.center = CGPoint(x: last.x, y: last.y - 26)
            }
            followQuicks()
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
        } else {
            followQuickEnd(center: routeParkingPin.center)
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
        lineDashAnimation.fromValue = 0
        lineDashAnimation.toValue = 16
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
