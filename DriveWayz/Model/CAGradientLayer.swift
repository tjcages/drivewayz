//
//  CAGradientLayer.swift
//  
//
//  Created by Tyler Jordan Cagle on 9/6/17.
//
//

import UIKit
import Foundation

extension CAGradientLayer {
    
    @objc func blueColor() -> CAGradientLayer {
        
        let topColor = Theme.PRIMARY_DARK_COLOR
        let bottomColor = Theme.PRIMARY_COLOR
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        return gradientLayer
    }
    
    @objc func blurColor() -> CAGradientLayer {
        
        let topColor = UIColor.clear
        let bottomColor = Theme.DARK_GRAY
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        return gradientLayer
    }
}

extension UIImageView
{
    @objc func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
