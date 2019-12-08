//
//  BubbleArrow.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BubbleArrow: UIView {
    
    var message: String = "" {
        didSet {
            self.label.text = self.message
            self.layoutIfNeeded()
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.STRAWBERRY_PINK
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    let triangleView: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.STRAWBERRY_PINK
        view.backgroundColor = UIColor.clear
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        return view
    }()
    
    let horizontalTriangleView: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.STRAWBERRY_PINK
        view.backgroundColor = UIColor.clear
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        return view
    }()
    
    let label: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.isSelectable = false
        label.backgroundColor = .clear
        label.isScrollEnabled = false
        label.isEditable = false
        label.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    var triangleLeftAnchor: NSLayoutConstraint!
    var triangleRightAnchor: NSLayoutConstraint!
    var triangleCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(container)
        addSubview(triangleView)
        addSubview(horizontalTriangleView)
        addSubview(label)
        
        container.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: triangleView.topAnchor).isActive = true
        
        triangleLeftAnchor = triangleView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16)
            triangleLeftAnchor.isActive = true
        triangleRightAnchor = triangleView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16)
            triangleRightAnchor.isActive = true
        triangleCenterAnchor = triangleView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            triangleCenterAnchor.isActive = false
        triangleView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        triangleView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        triangleView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        horizontalTriangleView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        horizontalTriangleView.rightAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        horizontalTriangleView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        horizontalTriangleView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        label.topAnchor.constraint(equalTo: container.topAnchor, constant: 4).isActive = true
        label.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        label.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4).isActive = true
        
    }
    
    func leftTriangle() {
        triangleLeftAnchor.isActive = true
        triangleRightAnchor.isActive = false
        triangleCenterAnchor.isActive = false
    }
    
    func rightTriangle() {
        triangleLeftAnchor.isActive = false
        triangleRightAnchor.isActive = true
        triangleCenterAnchor.isActive = false
    }
    
    func centerTriangle() {
        triangleLeftAnchor.isActive = false
        triangleRightAnchor.isActive = false
        triangleCenterAnchor.isActive = true
    }
    
    func horizontalTriangle() {
        horizontalTriangleView.alpha = 1
        triangleView.alpha = 0
    }
    
    func verticalTriangle() {
        horizontalTriangleView.alpha = 0
        triangleView.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
