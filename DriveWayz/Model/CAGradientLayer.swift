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
        
        let topColor = UIColor(red: 88/255, green: 130/255, blue: 220/255, alpha: 1)
        let bottomColor = UIColor(red: 230/255, green: 118/255, blue: 108/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        return gradientLayer
    }
    
    @objc func redColor() -> CAGradientLayer {
        
        let topColor = UIColor(red: 230/255, green: 118/255, blue: 108/255, alpha: 1)
        let bottomColor = UIColor(red: 88/255, green: 130/255, blue: 220/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        return gradientLayer
    }
    
    @objc func greyColor() -> CAGradientLayer {
        
        let topColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        let bottomColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
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
