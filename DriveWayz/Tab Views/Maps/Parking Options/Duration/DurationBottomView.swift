//
//  DurationBottomView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class DurationBottomView: UIViewController {
    
    var delegate: handleDuration?
    var buttonHeight: CGFloat = 44.0
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .center
        view.distribution = UIStackView.Distribution.fillEqually
        
        return view
    }()
    
    lazy var highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = buttonHeight/2
        
        return view
    }()
    
    var parkNowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "setTimeIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.setTitle("Park Now", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var reserveSpotButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "calendarIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.setTitle("Reserve", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.OFF_WHITE
        
        setupViews()
    }
    
    var highlightParkCenterAnchor: NSLayoutConstraint!
    var highlightReserveCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(highlightView)
        view.addSubview(parkNowButton)
        view.addSubview(reserveSpotButton)
        
        parkNowButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -4).isActive = true
        parkNowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight).isActive = true
        parkNowButton.widthAnchor.constraint(equalTo: highlightView.widthAnchor).isActive = true
        parkNowButton.heightAnchor.constraint(equalTo: highlightView.heightAnchor).isActive = true
        
        reserveSpotButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 4).isActive = true
        reserveSpotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight).isActive = true
        reserveSpotButton.widthAnchor.constraint(equalTo: highlightView.widthAnchor).isActive = true
        reserveSpotButton.heightAnchor.constraint(equalTo: highlightView.heightAnchor).isActive = true
        
        highlightView.widthAnchor.constraint(equalToConstant: 148).isActive = true
        highlightView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        highlightView.centerYAnchor.constraint(equalTo: parkNowButton.centerYAnchor).isActive = true
        highlightParkCenterAnchor = highlightView.centerXAnchor.constraint(equalTo: parkNowButton.centerXAnchor)
            highlightParkCenterAnchor.isActive = true
        highlightReserveCenterAnchor = highlightView.centerXAnchor.constraint(equalTo: reserveSpotButton.centerXAnchor)
            highlightReserveCenterAnchor.isActive = false
        
    }
    
    @objc func buttonPressed(sender: UIButton) {
        if sender == parkNowButton {
            parkNow = true
            delegate?.parkNowPressed()
            highlightParkCenterAnchor.isActive = true
            highlightReserveCenterAnchor.isActive = false
            UIView.animate(withDuration: animationIn) {
                self.parkNowButton.setTitleColor(Theme.WHITE, for: .normal)
                self.parkNowButton.tintColor = Theme.WHITE
                self.reserveSpotButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.reserveSpotButton.tintColor = Theme.DARK_GRAY
                self.view.layoutIfNeeded()
            }
        } else {
            parkNow = false
            delegate?.reservePressed()
            highlightParkCenterAnchor.isActive = false
            highlightReserveCenterAnchor.isActive = true
            UIView.animate(withDuration: animationIn) {
                self.reserveSpotButton.setTitleColor(Theme.WHITE, for: .normal)
                self.reserveSpotButton.tintColor = Theme.WHITE
                self.parkNowButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.parkNowButton.tintColor = Theme.DARK_GRAY
                self.view.layoutIfNeeded()
            }
        }
    }

}
