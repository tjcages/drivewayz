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
    
    var image: UIImage? {
        didSet {
            image?.getColors({ (colors) in
                let primaryString = "\(String(describing: colors?.primary))"
                let values = primaryString.replacingOccurrences(of: "Optional(UIExtendedSRGBColorSpace ", with: "", options: .literal, range: nil)
                let rgbValues = values.replacingOccurrences(of: " 1)", with: "", options: .literal, range: nil)
                let rgb = rgbValues.split(separator: " ")
                let formatter = NumberFormatter()
                if let r = rgb.first, let g = rgb.dropFirst().first, let b = rgb.dropFirst().dropFirst().first {
                    if let rDouble = formatter.number(from: String(r)), let gDouble = formatter.number(from: String(g)), let bDouble = formatter.number(from: String(b)) {
                        if Double(truncating: rDouble) < 0.9 && Double(truncating: gDouble) < 0.7 && Double(truncating: bDouble) < 0.7 {
                            let background = self.gradientColor(topColor: colors?.primary ?? Theme.DARK_GRAY, bottomColor: colors?.secondary ?? Theme.OFF_WHITE)
                            background.frame = CGRect(x: 0, y: 0, width: 300, height: 180)
                            background.zPosition = -10
                            self.darkView.layer.addSublayer(background)
                            self.layoutIfNeeded()
                        } else {
                            let background = self.gradientColor(topColor: Theme.DARK_GRAY, bottomColor: Theme.DARK_GRAY.withAlphaComponent(0.6))
                            background.frame = CGRect(x: 0, y: 0, width: 300, height: 180)
                            background.zPosition = -10
                            self.darkView.layer.addSublayer(background)
                            self.layoutIfNeeded()
                        }
                    }
                }
            })
        }
    }
    
    func gradientColor(topColor: UIColor, bottomColor: UIColor) -> CAGradientLayer {
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        return gradientLayer
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var darkView: UIView = {
        let dark = UIView()
        dark.backgroundColor = Theme.DARK_GRAY
        dark.alpha = 0.2
        dark.translatesAutoresizingMaskIntoConstraints = false
        
        return dark
    }()
    
    let eventLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        label.text = "Event"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    var date: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = Theme.DARK_GRAY.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 4
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(cellView)
        cellView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(darkView)
        self.addSubview(eventLabel)
        cellView.addSubview(date)
        
        cellView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        backgroundImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: cellView.rightAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: cellView.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor).isActive = true
        
        darkView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true
        darkView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
        darkView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
        darkView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        
        date.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 16).isActive = true
        date.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -12).isActive = true
        date.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8).isActive = true
        date.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        eventLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        eventLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        eventLabel.bottomAnchor.constraint(equalTo: date.topAnchor, constant: -6).isActive = true
        eventLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

