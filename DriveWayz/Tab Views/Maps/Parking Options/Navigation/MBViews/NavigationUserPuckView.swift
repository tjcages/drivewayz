//
//  NavigationUserPuckView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/21/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import Turf
import Mapbox
import MapboxNavigation

public class NavigationUserPuckView: UIView, CourseUpdatable {
    
    var canAnimate: Bool = true
    var maxPitch: CGFloat = 40
    
    // Transforms the location of the user puck
    public func update(location: CLLocation, pitch: CGFloat, direction: CLLocationDegrees, animated: Bool, tracksUserCourse: Bool) {
        let duration: TimeInterval = animated ? 1 : 0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            let angle = tracksUserCourse ? 0 : CLLocationDegrees(direction - location.course)
            self.puckView.layer.setAffineTransform(CGAffineTransform.identity.rotated(by: -CGFloat(angle.toRadians())))
            
            var pitch = pitch.rounded()
            if pitch > self.maxPitch {
                pitch = self.maxPitch
            }
            var transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(CLLocationDegrees(pitch).toRadians()), 1.0, 0, 0)
            transform = CATransform3DScale(transform, tracksUserCourse ? 1 : 0.5, tracksUserCourse ? 1 : 0.5, 1)
            transform.m34 = -1.0 / 1000 // (-1 / distance to projection plane)
            self.layer.transform = transform
        
            self.layer.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    var puckView: UserPuckStyleKitView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        puckView = UserPuckStyleKitView(frame: bounds)
        puckView.backgroundColor = .clear
        addSubview(puckView)
        layer.zPosition = 1000
    }
}

class UserPuckStyleKitView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let ring = UIView(frame: rect)
        ring.backgroundColor = Theme.WHITE
        ring.layer.cornerRadius = rect.height/2
        ring.layer.borderWidth = 4
        ring.layer.borderColor = Theme.BLUE.cgColor
        ring.layer.shadowColor = Theme.BLACK.cgColor
        ring.layer.shadowOffset = CGSize(width: 0, height: 3)
        ring.layer.shadowRadius = 5
        ring.layer.shadowOpacity = 0.2
        layer.addSublayer(ring.layer)
        
        drawNavigation_puck()
    }
    
    func drawNavigation_puck() {
        
        let path3_fillPath = UIBezierPath()
        path3_fillPath.move(to: CGPoint(x: 39.2, y: 28.46))
        path3_fillPath.addCurve(to: CGPoint(x: 38.02, y: 27.69), controlPoint1: CGPoint(x: 39, y: 27.99), controlPoint2: CGPoint(x: 38.54, y: 27.68))
        path3_fillPath.addCurve(to: CGPoint(x: 36.8, y: 28.49), controlPoint1: CGPoint(x: 37.5, y: 27.7), controlPoint2: CGPoint(x: 37.02, y: 28.01))
        path3_fillPath.addLine(to: CGPoint(x: 27.05, y: 45.83))
        path3_fillPath.addCurve(to: CGPoint(x: 27.28, y: 47.26), controlPoint1: CGPoint(x: 26.83, y: 46.32), controlPoint2: CGPoint(x: 26.92, y: 46.89))
        path3_fillPath.addCurve(to: CGPoint(x: 28.71, y: 47.54), controlPoint1: CGPoint(x: 27.65, y: 47.64), controlPoint2: CGPoint(x: 28.21, y: 47.75))
        path3_fillPath.addLine(to: CGPoint(x: 37.07, y: 44.03))
        path3_fillPath.addCurve(to: CGPoint(x: 38.06, y: 44.02), controlPoint1: CGPoint(x: 37.39, y: 43.89), controlPoint2: CGPoint(x: 37.75, y: 43.89))
        path3_fillPath.addLine(to: CGPoint(x: 46.26, y: 47.34))
        path3_fillPath.addCurve(to: CGPoint(x: 47.71, y: 47.03), controlPoint1: CGPoint(x: 46.75, y: 47.54), controlPoint2: CGPoint(x: 47.32, y: 47.42))
        path3_fillPath.addCurve(to: CGPoint(x: 48, y: 45.59), controlPoint1: CGPoint(x: 48.09, y: 46.64), controlPoint2: CGPoint(x: 48.2, y: 46.07))
        path3_fillPath.addLine(to: CGPoint(x: 39.2, y: 28.46))
        path3_fillPath.close()
        path3_fillPath.usesEvenOddFillRule = true

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path3_fillPath.cgPath

        //change the fill color
        shapeLayer.fillColor = Theme.BLUE.cgColor
        shapeLayer.setAffineTransform(CGAffineTransform(translationX: -11/2, y: -11/2))
        
        layer.addSublayer(shapeLayer)
        
    }
}

