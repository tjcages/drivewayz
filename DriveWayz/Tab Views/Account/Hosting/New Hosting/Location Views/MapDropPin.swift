//
//  MapDropPin.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MapDropPin: UIView {

    let shadowHeight: CGFloat = 4
    let shadowWidth: CGFloat = 7
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var circle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 14
        view.layer.borderColor = Theme.DARK_GRAY.cgColor
        
        return view
    }()
    
    lazy var shadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.6
        let ovalView = OvalView(frame: CGRect(x: 0, y: shadowHeight/2, width: shadowWidth, height: shadowHeight))
        ovalView.backgroundColor = Theme.DARK_GRAY
        view.addSubview(ovalView)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        setupViews()
    }
    
    var circleBottomAnchor: NSLayoutConstraint!
    var lineHeightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        addSubview(shadow)
        addSubview(line)
        addSubview(circle)
        
        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleBottomAnchor = circle.topAnchor.constraint(equalTo: topAnchor)
            circleBottomAnchor.isActive = true
        circle.widthAnchor.constraint(equalTo: circle.heightAnchor).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        line.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        line.topAnchor.constraint(equalTo: circle.centerYAnchor).isActive = true
        line.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        lineHeightAnchor = line.heightAnchor.constraint(equalToConstant: 38)
            lineHeightAnchor.isActive = true
        line.widthAnchor.constraint(equalToConstant: 4).isActive = true
        
        shadow.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        shadow.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadow.widthAnchor.constraint(equalToConstant: shadowWidth).isActive = true
        shadow.heightAnchor.constraint(equalToConstant: shadowHeight).isActive = true
        
    }
    
    func pinMoving() {
        if !lineHeightAnchor.isActive {
            lineHeightAnchor.isActive = true
            circleBottomAnchor.constant = -16
            layoutIfNeeded()
        }
    }
    
    func placePin() {
        lineHeightAnchor.isActive = false
        circleBottomAnchor.constant = 0
        UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class OvalView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutOvalMask()
    }

    private func layoutOvalMask() {
        let mask = self.shapeMaskLayer()
        let bounds = self.bounds
        if mask.frame != bounds {
            mask.frame = bounds
            mask.path = CGPath(ellipseIn: bounds, transform: nil)
        }
    }

    private func shapeMaskLayer() -> CAShapeLayer {
        if let layer = self.layer.mask as? CAShapeLayer {
            return layer
        }
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.red.cgColor
        self.layer.mask = layer
        return layer
    }

}
