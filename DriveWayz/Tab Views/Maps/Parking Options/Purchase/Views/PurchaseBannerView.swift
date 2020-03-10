//
//  PurchaseBannerView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PurchaseBannerView: UIView {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mission Bay"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "•  15 min trip"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var driveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 1
        let image = UIImage(named: "purchaseCar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var walkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 1
        let image = UIImage(named: "purchaseWalk")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var separator: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Expand")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0

        return view
    }()
    
    var driveExpandedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 1
        let image = UIImage(named: "purchaseCar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var driveMainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drive to parking spot"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var driveSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "15 min"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var expandedSeparator: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Expand")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var walkExpandedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 1
        let image = UIImage(named: "purchaseWalk")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var walkMainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Walk to Mission Bay"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var walkSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "8 min"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var expandedSeparator2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Expand")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var arriveExpandedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 1
        let image = UIImage(named: "purchaseArrive")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var arriveMainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Arrive by 9:45pm"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var hideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hide", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .right
        button.isUserInteractionEnabled = false
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.BLUE
        
        setupViews()
        setupExpanded()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(subLabel)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        sizeToFit()
        
        subLabel.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 8).isActive = true
        subLabel.sizeToFit()
        
        addSubview(driveButton)
        addSubview(walkButton)
        addSubview(separator)
        
        walkButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        walkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        walkButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        walkButton.widthAnchor.constraint(equalTo: walkButton.heightAnchor).isActive = true
        
        separator.rightAnchor.constraint(equalTo: walkButton.leftAnchor, constant: -4).isActive = true
        separator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        separator.heightAnchor.constraint(equalTo: separator.widthAnchor).isActive = true
        
        driveButton.rightAnchor.constraint(equalTo: separator.leftAnchor, constant: -4).isActive = true
        driveButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        driveButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        driveButton.widthAnchor.constraint(equalTo: driveButton.heightAnchor).isActive = true
        
    }
    
    func setupExpanded() {
        
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(driveExpandedButton)
        container.addSubview(driveMainLabel)
        container.addSubview(driveSubLabel)
        container.addSubview(expandedSeparator)
        
        driveExpandedButton.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        driveExpandedButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        driveExpandedButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        driveExpandedButton.widthAnchor.constraint(equalTo: driveExpandedButton.heightAnchor).isActive = true
        
        driveMainLabel.topAnchor.constraint(equalTo: driveExpandedButton.topAnchor, constant: -4).isActive = true
        driveMainLabel.leftAnchor.constraint(equalTo: driveExpandedButton.rightAnchor, constant: 20).isActive = true
        driveMainLabel.sizeToFit()
        
        driveSubLabel.topAnchor.constraint(equalTo: driveMainLabel.bottomAnchor).isActive = true
        driveSubLabel.leftAnchor.constraint(equalTo: driveExpandedButton.rightAnchor, constant: 20).isActive = true
        driveSubLabel.sizeToFit()
        
        expandedSeparator.topAnchor.constraint(equalTo: driveExpandedButton.bottomAnchor, constant: 4).isActive = true
        expandedSeparator.centerXAnchor.constraint(equalTo: driveExpandedButton.centerXAnchor).isActive = true
        expandedSeparator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        expandedSeparator.heightAnchor.constraint(equalTo: expandedSeparator.widthAnchor).isActive = true
        
        container.addSubview(walkExpandedButton)
        container.addSubview(walkMainLabel)
        container.addSubview(walkSubLabel)
        container.addSubview(expandedSeparator2)
        
        walkExpandedButton.topAnchor.constraint(equalTo: expandedSeparator.bottomAnchor, constant: 4).isActive = true
        walkExpandedButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        walkExpandedButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        walkExpandedButton.widthAnchor.constraint(equalTo: walkExpandedButton.heightAnchor).isActive = true
        
        walkMainLabel.topAnchor.constraint(equalTo: walkExpandedButton.topAnchor, constant: -4).isActive = true
        walkMainLabel.leftAnchor.constraint(equalTo: walkExpandedButton.rightAnchor, constant: 20).isActive = true
        walkMainLabel.sizeToFit()
        
        walkSubLabel.topAnchor.constraint(equalTo: walkMainLabel.bottomAnchor).isActive = true
        walkSubLabel.leftAnchor.constraint(equalTo: walkExpandedButton.rightAnchor, constant: 20).isActive = true
        walkSubLabel.sizeToFit()
        
        expandedSeparator2.topAnchor.constraint(equalTo: walkExpandedButton.bottomAnchor, constant: 4).isActive = true
        expandedSeparator2.centerXAnchor.constraint(equalTo: walkExpandedButton.centerXAnchor).isActive = true
        expandedSeparator2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        expandedSeparator2.heightAnchor.constraint(equalTo: expandedSeparator2.widthAnchor).isActive = true
        
        container.addSubview(arriveExpandedButton)
        container.addSubview(arriveMainLabel)
        
        arriveExpandedButton.topAnchor.constraint(equalTo: expandedSeparator2.bottomAnchor, constant: 4).isActive = true
        arriveExpandedButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        arriveExpandedButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        arriveExpandedButton.widthAnchor.constraint(equalTo: arriveExpandedButton.heightAnchor).isActive = true
        
        arriveMainLabel.centerYAnchor.constraint(equalTo: arriveExpandedButton.centerYAnchor).isActive = true
        arriveMainLabel.leftAnchor.constraint(equalTo: arriveExpandedButton.rightAnchor, constant: 20).isActive = true
        arriveMainLabel.sizeToFit()
        
        container.addSubview(hideButton)
        hideButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        hideButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        hideButton.sizeToFit()
        
    }
    
    func expandBanner() {
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
            self.walkButton.alpha = 0
            self.driveButton.alpha = 0
            self.separator.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.container.alpha = 1
            }
        }
    }
    
    func minimizeBanner() {
        UIView.animate(withDuration: animationIn, animations: {
            self.container.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.mainLabel.alpha = 1
                self.subLabel.alpha = 1
                self.walkButton.alpha = 1
                self.driveButton.alpha = 1
                self.separator.alpha = 1
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
