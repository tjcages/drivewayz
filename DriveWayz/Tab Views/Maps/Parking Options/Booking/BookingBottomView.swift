//
//  BookingBottomView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/15/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class BookingBottomView: UIView {
    
    var line: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Book Private", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 2
        
        return button
    }()
    
    var timeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    var timeIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "clock_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        
        return button
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 hours"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    lazy var timeArrow: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Expand")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "card_lined")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(paymentButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var profileIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookingProfile")
        button.setImage(image, for: .normal)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    var paymentRightAnchor: NSLayoutConstraint!
    var paymentWidthAnchor: NSLayoutConstraint!
    var profileLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(line)
        addSubview(mainButton)
        
        mainButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: cancelBottomHeight).isActive = true
        mainButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        addSubview(timeButton)
        timeButton.addSubview(timeIcon)
        timeButton.addSubview(timeLabel)
        timeButton.addSubview(timeArrow)
        
        timeButton.anchor(top: nil, left: leftAnchor, bottom: mainButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 16, paddingRight: 0, width: 112, height: 32)
        
        timeIcon.anchor(top: nil, left: timeButton.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
        timeIcon.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: timeIcon.rightAnchor, constant: 8).isActive = true
        timeLabel.sizeToFit()
        
        timeArrow.anchor(top: nil, left: nil, bottom: nil, right: timeButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 18, height: 18)
        timeArrow.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor, constant: 2).isActive = true
        
        addSubview(paymentButton)
        addSubview(profileIcon)
        
        paymentButton.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        paymentRightAnchor = paymentButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
            paymentRightAnchor.isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentWidthAnchor = paymentButton.widthAnchor.constraint(equalToConstant: 32)
            paymentWidthAnchor.isActive = true
        
        profileLeftAnchor = profileIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
            profileLeftAnchor.isActive = false
        profileIcon.bottomAnchor.constraint(equalTo: paymentButton.bottomAnchor).isActive = true
        profileIcon.rightAnchor.constraint(equalTo: paymentButton.leftAnchor, constant: -4).isActive = true
        profileIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        profileIcon.widthAnchor.constraint(equalTo: profileIcon.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
