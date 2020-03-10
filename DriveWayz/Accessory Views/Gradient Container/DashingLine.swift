//
//  DashingLine.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/23/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class DashingLine: CAShapeLayer {
    
    var defaultColor: UIColor = Theme.BLACK
    var defaultWidth: CGFloat = 2
    var travelDistance = phoneWidth
    
    override init() {
        super.init()
        
        createLine()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLine() {

    }
    
    func animate() {
        // 1)
        let bezPath = UIBezierPath()
        bezPath.move(to: CGPoint(x: 0, y: 0))
        let distance = travelDistance
        bezPath.addLine(to: CGPoint(x: distance, y: 0))
        
        // 2)
        lineWidth = defaultWidth
        lineCap = CAShapeLayerLineCap.round
        strokeColor = defaultColor.cgColor
        path = bezPath.cgPath
        
        // 1)
        let duration: CFTimeInterval = 1.2
        
        // 2)
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.fromValue = 0
        end.toValue = 1.0175
        end.beginTime = 0
        end.duration = duration * 0.75
        end.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        end.fillMode = CAMediaTimingFillMode.forwards
        
        // 3)
        let begin = CABasicAnimation(keyPath: "strokeStart")
        begin.fromValue = 0
        begin.toValue = 1.0175
        begin.beginTime = duration * 0.15
        begin.duration = duration * 0.85
        begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        begin.fillMode = CAMediaTimingFillMode.backwards
        
        // 4)
        let group = CAAnimationGroup()
        group.animations = [end, begin, end]
        group.duration = duration
        group.repeatCount = .infinity
        
        // 5)
        strokeEnd = 0
        strokeStart = 0
        
        // 6)
        add(group, forKey: "move")
    }
    
    func endAnimate() {
        removeAnimation(forKey: "move")
    }
    
}
