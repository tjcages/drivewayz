//
//  BookingSpotView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingSpotView: UITableViewCell {
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 29
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        view.backgroundColor = Theme.OFF_WHITE
        view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Private"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Private driveway"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$9.38"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var subCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$10.72"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var subCostLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE
        
        return view
    }()
    
    var saleIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "saleIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(scaleX: -0.7, y: 0.7)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var pinIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "mapPin")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var pinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH5
        label.alpha = 0
        
        return label
    }()

    var aceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        button.setTitle("ACE", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.isUserInteractionEnabled = false
        button.isHidden = true
        
        return button
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationFilledIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        button.alpha = 0
        button.isHidden = true
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(spotIcon)
        spotIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spotIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 58).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(aceButton)
        addSubview(pinIcon)
        addSubview(pinLabel)
        
        mainLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
        aceButton.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: -4).isActive = true
        aceButton.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 8).isActive = true
        aceButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aceButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        pinIcon.anchor(top: nil, left: mainLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 14, height: 14)
        pinIcon.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        
        pinLabel.leftAnchor.constraint(equalTo: pinIcon.rightAnchor, constant: 2).isActive = true
        pinLabel.centerYAnchor.constraint(equalTo: pinIcon.centerYAnchor).isActive = true
        pinLabel.sizeToFit()
        
        addSubview(costLabel)
        addSubview(subCostLabel)
        
        costLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
        costLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        costLabel.sizeToFit()
        
        subCostLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
        subCostLabel.rightAnchor.constraint(equalTo: costLabel.rightAnchor).isActive = true
        subCostLabel.sizeToFit()
        
        addSubview(saleIcon)
        saleIcon.anchor(top: nil, left: nil, bottom: nil, right: costLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 16, height: 16)
        saleIcon.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor).isActive = true
        
        addSubview(informationIcon)
        informationIcon.anchor(top: nil, left: nil, bottom: nil, right: costLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 20, height: 20)
        informationIcon.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor).isActive = true
        
        addSubview(subCostLine)
        subCostLine.anchor(top: nil, left: subCostLabel.leftAnchor, bottom: nil, right: subCostLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        subCostLine.centerYAnchor.constraint(equalTo: subCostLabel.centerYAnchor).isActive = true
        
    }
    
    func selectedView() {
        backgroundColor = Theme.HOST_BLUE
        pinIcon.alpha = 1
        pinLabel.alpha = 1
        aceButton.alpha = 0
        UIView.animate(withDuration: animationIn) {
            self.spotIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.saleIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            self.saleIcon.alpha = 1
            self.informationIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.informationIcon.alpha = 1
        }
    }
    
    func unselectedView() {
        backgroundColor = Theme.WHITE
        saleIcon.alpha = 0
        informationIcon.alpha = 0
        pinIcon.alpha = 0
        pinLabel.alpha = 0
        aceButton.alpha = 1
        saleIcon.transform = CGAffineTransform(scaleX: -0.7, y: 0.7)
        informationIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: animationIn) {
            self.spotIcon.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
