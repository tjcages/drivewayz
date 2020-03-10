//
//  BookingSpotView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import SVGKit

enum SpotType {
    case Private
    case Free
    case Public
}

class BookingSpotView: UITableViewCell {
    
    var carHeight: CGFloat = 30
    var carWidth: CGFloat = 64
    var spotType: SpotType = .Public
    
    var didSelect: Bool = false {
        didSet {
            if didSelect {
                selectedView()
            } else {
                unselectedView()
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    var carView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        return view
    }()
    
    var carIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Half_Car_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        let image = UIImage(named: "kiosk_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.GRAY_WHITE_3
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    var moreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "More options"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        
        return label
    }()
    
    var bookingView = BookingView()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        setupViews()

    }
    
    var containerTopAnchor: NSLayoutConstraint!
    
    var iconCenterAnchor: NSLayoutConstraint!
    var iconLeftAnchor: NSLayoutConstraint!
    var iconRightAnchor: NSLayoutConstraint!
    
    var carLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(moreLabel)
        addSubview(container)
        
        moreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        moreLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        moreLabel.sizeToFit()
        
        container.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerTopAnchor = container.topAnchor.constraint(equalTo: topAnchor)
            containerTopAnchor.isActive = true
        
        container.addSubview(iconButton)
        container.addSubview(carView)
        carView.addSubview(carIllustration)
        
        carView.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        carHeight = carIllustration.image.size.height/carIllustration.image.size.width * carWidth
        carIllustration.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: carWidth, height: carHeight)
        carIllustration.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 8).isActive = true
        carLeftAnchor = carIllustration.leftAnchor.constraint(equalTo: carView.leftAnchor, constant: -carWidth)
            carLeftAnchor.isActive = true
        
        iconCenterAnchor = iconButton.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            iconCenterAnchor.isActive = true
        iconLeftAnchor = iconButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20)
            iconLeftAnchor.isActive = true
        iconRightAnchor = iconButton.rightAnchor.constraint(equalTo: carIllustration.rightAnchor)
            iconRightAnchor.isActive = false
        iconButton.widthAnchor.constraint(equalTo: iconButton.heightAnchor).isActive = true
        iconButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        container.addSubview(bookingView)
        bookingView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        bookingView.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        bookingView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        bookingView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        addSubview(line)
        line.anchor(top: nil, left: bookingView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    func selectedView() {
        containerTopAnchor.constant = 0
        carLeftAnchor.constant = 0
        iconCenterAnchor.constant = -6
        iconLeftAnchor.isActive = false
        iconRightAnchor.isActive = true
        UIView.animateOut(withDuration: animationIn, animations: {
            self.bookingView.availabilityLabel.alpha = 1
            self.bookingView.aceButton.alpha = 1
            self.moreLabel.alpha = 0
            self.bookingView.costLabel.font = Fonts.SSPSemiBoldH3
            self.iconButton.tintColor = Theme.BLUE_DARK
            self.iconButton.backgroundColor = Theme.BLUE_MED.withAlphaComponent(0.4)
            self.backgroundColor = Theme.BLUE_LIGHT.withAlphaComponent(0.5)
            self.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func unselectedView() {
        containerTopAnchor.constant = 0
        carLeftAnchor.constant = -carWidth
        iconCenterAnchor.constant = 0
        iconLeftAnchor.isActive = true
        iconRightAnchor.isActive = false
        UIView.animateOut(withDuration: animationIn, animations: {
            self.bookingView.availabilityLabel.alpha = 0
            self.bookingView.aceButton.alpha = 0
            self.bookingView.costLabel.font = Fonts.SSPRegularH3
            self.moreLabel.alpha = 0
            self.iconButton.tintColor = Theme.GRAY_WHITE_3
            self.iconButton.backgroundColor = Theme.STANDARD_GRAY
            self.backgroundColor = Theme.WHITE
            self.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    func showMoreOptions() {
        containerTopAnchor.constant = 50
        UIView.animateOut(withDuration: animationIn, animations: {
            self.moreLabel.alpha = 1
            self.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

