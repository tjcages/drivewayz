//
//  MBRouteLine.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import MapboxDirections

var routeTimer: Timer?
var routeLineIndex: Int = 0

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
    line.strokeColor = Theme.LIGHT_GRAY.darker(by: 10)!.cgColor
    
    return line
}()

var routeStartPin: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    view.backgroundColor = Theme.WHITE
    view.layer.cornerRadius = 9
    view.layer.borderColor = Theme.DARK_GRAY.cgColor
    view.layer.borderWidth = 7

    return view
}()

var routeParkingPin: UIImageView = {
    let image = UIImage(named: "routeSelectedPin")
    let view = UIImageView(image: image)
    view.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
    view.contentMode = .scaleAspectFill
    
    return view
}()

extension MapKitViewController: CAAnimationDelegate {
    
    func createRouteLine(route: Route) {
        guard let coordinates = route.coordinates else { return }
        var points: [CGPoint] = []
        for coordinate in coordinates {
            let point = mapView.convert(coordinate, toPointTo: mapView)
            points.append(point)
        }
        let linePath = UIBezierPath()
        if points.count > 0, let start = points.first, let last = points.last {
            linePath.move(to: start)
            for point in points {
                linePath.addLine(to: point)
            }
            routeLine.path = linePath.cgPath
            routeUnderLine.path = linePath.cgPath
            routeStartPin.center = CGPoint(x: last.x + 3, y: last.y + 6)
            routeParkingPin.center = CGPoint(x: start.x, y: start.y - 26)
        }
    }
    
    func animateRouteLine() {
        var animations = [CABasicAnimation]()
        
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
        
        let group = CAAnimationGroup()
        group.duration = 4.0
        group.repeatCount = .greatestFiniteMagnitude
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.animations = animations
        
        routeLine.add(group, forKey: nil)
    }
    
    func animateRouteUnderLine() {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        // animation set up here, I've included a few properties as an example
        animation.duration = 0.5
        animation.fromValue = 1
        animation.toValue = 0
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.isRemovedOnCompletion = true
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.animations = [animation]
        
        routeUnderLine.add(group, forKey: nil)
    }

    func removeRouteLine() {
        mapBoxRoute = nil
        routeUnderLine.path = nil
        routeLine.path = nil
        
        routeUnderLine.removeFromSuperlayer()
        routeLine.removeFromSuperlayer()
        routeStartPin.removeFromSuperview()
        routeParkingPin.removeFromSuperview()
        routeUnderLine.removeAllAnimations()
        routeLine.removeAllAnimations()
    }
    
}
