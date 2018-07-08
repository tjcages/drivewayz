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
        
        let topColor = UIColor(red: 87/255, green: 159/255, blue: 179/255, alpha: 1)
        let middleColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
        let bottomColor = UIColor(red: 247/255, green: 89/255, blue: 89/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 0.6, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        return gradientLayer
    }
    
    @objc func redColor() -> CAGradientLayer {
        
        let topColor = UIColor(red: 222/255, green: 143/255, blue: 128/255, alpha: 1)
        let bottomColor = UIColor(red: 152/255, green: 142/255, blue: 166/255, alpha: 1)
        
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
