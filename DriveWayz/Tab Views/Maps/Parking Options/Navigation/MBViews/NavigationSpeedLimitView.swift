//
//  NavigationSpeedLimitView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/22/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class NavigationSpeedLimitView: UIView {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 7
        view.layer.borderColor = Theme.BLACK.cgColor
        view.layer.borderWidth = 2
        
        return view
    }()
    
    var speedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SPEED"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var limitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LIMIT"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "45"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH00
        label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        label.textAlignment = .center
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        alpha = 0
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        layer.cornerRadius = 8
        layer.shadowColor = Theme.BLACK.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        
        container.addSubview(speedLabel)
        container.addSubview(limitLabel)
        container.addSubview(valueLabel)
        
        speedLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        speedLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        speedLabel.sizeToFit()
        
        limitLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        limitLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: -6).isActive = true
        limitLabel.sizeToFit()
        
        valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        valueLabel.topAnchor.constraint(equalTo: limitLabel.bottomAnchor, constant: -6).isActive = true
        valueLabel.sizeToFit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
