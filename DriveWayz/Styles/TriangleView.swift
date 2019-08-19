//
//  TriangleView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    
    var color = Theme.WHITE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
}
