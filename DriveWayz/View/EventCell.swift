//
//  EventCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/14/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit
import UIImageColors

class EventCell: UICollectionViewCell {
    
//    var image: UIImage? {
//        didSet {
//            image?.getColors({ (colors) in
//                let primaryString = "\(String(describing: colors?.primary))"
//                let values = primaryString.replacingOccurrences(of: "Optional(UIExtendedSRGBColorSpace ", with: "", options: .literal, range: nil)
//                let rgbValues = values.replacingOccurrences(of: " 1)", with: "", options: .literal, range: nil)
//                let rgb = rgbValues.split(separator: " ")
//                let formatter = NumberFormatter()
//                if let r = rgb.first, let g = rgb.dropFirst().first, let b = rgb.dropFirst().dropFirst().first {
//                    if let rDouble = formatter.number(from: String(r)), let gDouble = formatter.number(from: String(g)), let bDouble = formatter.number(from: String(b)) {
//                        if Double(truncating: rDouble) < 0.9 && Double(truncating: gDouble) < 0.7 && Double(truncating: bDouble) < 0.7 {
//                            let background = self.gradientColor(topColor: colors?.primary ?? Theme.DARK_GRAY, bottomColor: colors?.secondary ?? Theme.OFF_WHITE)
//                            background.frame = CGRect(x: 0, y: 0, width: 300, height: 180)
//                            background.zPosition = -10
//                            self.darkView.layer.addSublayer(background)
//                            self.layoutIfNeeded()
//                        } else {
//                            let background = self.gradientColor(topColor: Theme.DARK_GRAY, bottomColor: Theme.DARK_GRAY.withAlphaComponent(0.6))
//                            background.frame = CGRect(x: 0, y: 0, width: 300, height: 180)
//                            background.zPosition = -10
//                            self.darkView.layer.addSublayer(background)
//                            self.layoutIfNeeded()
//                        }
//                    }
//                }
//            })
//        }
//    }
//
//    func gradientColor(topColor: UIColor, bottomColor: UIColor) -> CAGradientLayer {
//        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
//
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        gradientLayer.colors = gradientColors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//
//        return gradientLayer
//    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Theme.LINE_GRAY
        let image = UIImage(named: "stock_stadium")
        view.image = image
        
        return view
    }()
    
//    var darkView: UIView = {
//        let dark = UIView()
//        dark.backgroundColor = Theme.DARK_GRAY
//        dark.alpha = 0.2
//        dark.translatesAutoresizingMaskIntoConstraints = false
//
//        return dark
//    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.text = "Order food while you ride"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        label.text = "Local restaurants, delivered at Uber speed."
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 2
        
        return label
    }()
    
//    var date: UILabel = {
//        let label = UILabel()
//        label.text = ""
//        label.font = Fonts.SSPRegularH5
//        label.textColor = Theme.WHITE
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isUserInteractionEnabled = false
//
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(backgroundImageView)
        addSubview(cellView)
        addSubview(mainLabel)
        addSubview(subLabel)
        
        backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        cellView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

