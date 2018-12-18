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
        
        let topColor = Theme.SEA_BLUE
        let bottomColor = Theme.WHITE
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
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
    
    @objc func mixColors() -> CAGradientLayer {
        
        let topColor = Theme.PACIFIC_BLUE
        let bottomColor = Theme.SEA_BLUE
//        let bottomColor = UIColor(red: 34/255, green: 48/255, blue: 70/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        return gradientLayer
    }
    
    @objc func startColors() -> CAGradientLayer {
        
        let topColor = Theme.PACIFIC_BLUE
        let bottomColor = Theme.PRUSSIAN_BLUE
//        let bottomColor = UIColor(red: 17/255, green: 98/255, blue: 145/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        return gradientLayer
    }
    
    @objc func lightBlurColor() -> CAGradientLayer {
        
        let topColor = Theme.WHITE.withAlphaComponent(0)
        let bottomColor = Theme.WHITE
        let middleColor = Theme.WHITE
        let moreMiddleColor = Theme.WHITE
        
        let gradientColors: [CGColor] = [topColor.cgColor, middleColor.cgColor, moreMiddleColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        return gradientLayer
    }
    
    @objc func mediumBlurColor() -> CAGradientLayer {
        
        let topColor = Theme.WHITE.withAlphaComponent(0)
        let bottomColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        let middleColor = Theme.WHITE.withAlphaComponent(0.6)
        
        let gradientColors: [CGColor] = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        return gradientLayer
    }
    
    @objc func darkBlurColor() -> CAGradientLayer {
        
        let topColor = Theme.BLACK.withAlphaComponent(0.3)
        let bottomColor = Theme.BLACK.withAlphaComponent(0)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        return gradientLayer
    }
    
    @objc func purpleColor() -> CAGradientLayer {
        
        let topColor = Theme.SEA_BLUE
        let bottomColor = Theme.PURPLE
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        return gradientLayer
    }
    
    @objc func customColor(topColor: UIColor, bottomColor: UIColor) -> CAGradientLayer {
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        return gradientLayer
    }
    
    
}

extension UIImageView
{
    @objc func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
