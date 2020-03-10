//
//  BookingOptionsCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

struct BookingOptions {
    var mainText: String?
    var subText: String?
    var iconImage: UIImage?
}

class BookingOptionsCell: UITableViewCell {
    
    var option: BookingOptions? {
        didSet {
            if let option = self.option {
                if let text = option.mainText {
                    mainLabel.text = text
                }
                if let subText = option.subText {
                    subLabel.text = subText
                    openSubText()
                } else {
                    closeSubText()
                }
                if let image = option.iconImage {
                    iconButton.setImage(image, for: .normal)
                    messageLeftAnchor.constant = 60
                    arrowButton.alpha = 0
                    layoutIfNeeded()
                } else {
                    messageLeftAnchor.constant = 20
                    arrowButton.alpha = 1
                    layoutIfNeeded()
                }
            }
        }
    }
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var subLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.GREEN
        view.alpha = 0
        
        return view
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    var messageTopAnchor: NSLayoutConstraint!
    var messageLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(iconButton)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(arrowButton)
        
        iconButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        iconButton.heightAnchor.constraint(equalTo: iconButton.widthAnchor).isActive = true
        iconButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        messageTopAnchor = mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            messageTopAnchor.isActive = true
        messageLeftAnchor = mainLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
            messageLeftAnchor.isActive = true
        mainLabel.sizeToFit()
        
        subLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 12).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    func openSubText() {
        messageTopAnchor.constant = -10
        subLabel.alpha = 1
        layoutIfNeeded()
    }
    
    func closeSubText() {
        messageTopAnchor.constant = 0
        subLabel.alpha = 0
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
