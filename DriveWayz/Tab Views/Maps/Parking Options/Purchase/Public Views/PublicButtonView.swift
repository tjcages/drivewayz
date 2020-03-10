//
//  PublicButtonView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/10/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class PublicButtonView: UIView {
    
    var line: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Start Navigation", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 2
//        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 min walk • 0.1 mi"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        let image = UIImage(named: "car_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var walkIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        let image = UIImage(named: "walk_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var arrow: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to Mission Bay"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var changeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .right
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(line)
        addSubview(mainButton)
        addSubview(distanceLabel)
        addSubview(carIcon)
        addSubview(arrow)
        addSubview(walkIcon)
        addSubview(destinationLabel)
        addSubview(changeButton)
        
        mainButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: cancelBottomHeight).isActive = true
        mainButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        distanceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -20).isActive = true
        distanceLabel.sizeToFit()
        
        carIcon.anchor(top: nil, left: distanceLabel.leftAnchor, bottom: distanceLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 32, height: 32)
        
        arrow.centerYAnchor.constraint(equalTo: carIcon.centerYAnchor).isActive = true
        arrow.leftAnchor.constraint(equalTo: carIcon.rightAnchor, constant: 4).isActive = true
        arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        walkIcon.anchor(top: nil, left: arrow.rightAnchor, bottom: distanceLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 10, paddingRight: 0, width: 32, height: 32)
        
        destinationLabel.anchor(top: carIcon.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        destinationLabel.sizeToFit()
        
        changeButton.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 4).isActive = true
        changeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        changeButton.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
