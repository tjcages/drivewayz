//
//  MainTypeCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MainTypeCell: UITableViewCell {
    
    var descriptionText: String?
    var option: MainType? {
        didSet {
            if let option = self.option {
                mainLabel.text = option.type
                descriptionText = option.description
                
                if let image = option.image {
                    mainGraphic.image = image
                    amenitiesButton.alpha = 0
                    mainGraphic.alpha = 1
                } else if let image = option.amenity?.withRenderingMode(.alwaysTemplate) {
                    amenitiesButton.setImage(image, for: .normal)
                    amenitiesButton.alpha = 1
                    mainGraphic.alpha = 0
                }
            }
        }
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 4
        label.text = "More details"
        
        return label
    }()
    
    var mainGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        
        return view
    }()
    
    var amenitiesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 28
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.alpha = 0
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainGraphic)
        addSubview(amenitiesButton)
        addSubview(mainLabel)
        addSubview(subLabel)
        
        mainGraphic.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 56, height: 56)
        
        amenitiesButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 56, height: 56)
        
        mainLabel.topAnchor.constraint(equalTo: mainGraphic.topAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: mainGraphic.rightAnchor, constant: 16).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func setSubLabel() {
        self.subLabel.text = ""
        UIView.animate(withDuration: animationIn, animations: {
            self.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
            self.layoutIfNeeded()
        }) { (success) in
            self.subLabel.text = self.descriptionText
            UIView.animate(withDuration: animationIn) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func moreDetails() {
        backgroundColor = .clear
        subLabel.text = "More details"
        
    }
    
    func selectAmenity() {
        backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        amenitiesButton.backgroundColor = Theme.DARK_GRAY
        amenitiesButton.tintColor = Theme.WHITE
        amenitiesButton.layer.shadowOpacity = 0.2
    }
    
    func unselectAmenity() {
        backgroundColor = .clear
        amenitiesButton.backgroundColor = lineColor
        amenitiesButton.tintColor = Theme.DARK_GRAY
        amenitiesButton.layer.shadowOpacity = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
