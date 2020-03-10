//
//  NavigationPopupView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/25/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class NavigationPopupView: UIView {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "car_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Park here"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var arrow: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        layer.shadowColor = Theme.BLACK.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(container)
        container.addSubview(carIcon)
        
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
        
        carIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        carIcon.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        carIcon.widthAnchor.constraint(equalTo: carIcon.heightAnchor).isActive = true
        carIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(mainLabel)
        addSubview(arrow)
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: container.rightAnchor, constant: 16).isActive = true
        mainLabel.sizeToFit()
        
        arrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
        arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
