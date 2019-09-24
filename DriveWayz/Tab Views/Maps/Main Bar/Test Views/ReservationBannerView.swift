//
//  ReservationBannerView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ReservationBannerView: UIViewController {
    
    var reservationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Schedule your next parking"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Learn more"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get 10% off your booking for reserving ahead of time."
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        label.alpha = 0
        
        return label
    }()
    
    var reservationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "calendar")
//        button.tintColor = Theme.WHITE
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "arrow-right")?.withRenderingMode(.alwaysTemplate)
//        button.transform = CGAffineTransform(scaleX: -0.7, y: 0.7)
        button.tintColor = Theme.WHITE
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    var discountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN_PIGMENT
        button.layer.cornerRadius = 12
        button.setTitle("10%", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.isUserInteractionEnabled = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.PRUSSIAN_BLUE
        
        setupViews()
    }
    
    var reservationViewMainTopAnchor: NSLayoutConstraint!
    var reservationViewSubTopAnchor: NSLayoutConstraint!
    var reservationViewMainLeftAnchor: NSLayoutConstraint!
    var reservationViewSubLeftAnchor: NSLayoutConstraint!
    var reservationButtonTopAnchor: NSLayoutConstraint!
    
    var mainLeftAnchor: NSLayoutConstraint!
    var subLabelLeftAnchor: NSLayoutConstraint!
    var subLabelBottomAnchor: NSLayoutConstraint!
    var arrowRightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(reservationView)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(informationLabel)
        view.addSubview(reservationButton)
        view.addSubview(arrowButton)
        view.addSubview(discountButton)
        
        reservationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        reservationButtonTopAnchor = reservationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
            reservationButtonTopAnchor.isActive = true
        reservationButton.widthAnchor.constraint(equalTo: reservationButton.heightAnchor).isActive = true
        reservationButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        mainLeftAnchor = mainLabel.leftAnchor.constraint(equalTo: reservationButton.rightAnchor, constant: 32)
            mainLeftAnchor.isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        mainLabel.sizeToFit()
        
        subLabelLeftAnchor = subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor)
            subLabelLeftAnchor.isActive = true
        subLabel.rightAnchor.constraint(equalTo: arrowButton.leftAnchor, constant: -4).isActive = true
        subLabelBottomAnchor = subLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
            subLabelBottomAnchor.isActive = true
        subLabel.sizeToFit()
        
        informationLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        informationLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        informationLabel.sizeToFit()
        
        arrowButton.centerYAnchor.constraint(equalTo: subLabel.centerYAnchor).isActive = true
        arrowRightAnchor = arrowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
            arrowRightAnchor.isActive = false
        arrowButton.heightAnchor.constraint(equalTo: arrowButton.widthAnchor).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        reservationView.anchor(top: nil, left: nil, bottom: subLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -4, paddingRight: 0, width: 0, height: 0)
        
        reservationViewMainLeftAnchor = reservationView.leftAnchor.constraint(equalTo: subLabel.leftAnchor, constant: -12)
            reservationViewMainLeftAnchor.isActive = true
        reservationViewSubLeftAnchor = reservationView.leftAnchor.constraint(equalTo: subLabel.leftAnchor, constant: -12)
            reservationViewSubLeftAnchor.isActive = false
        reservationViewMainTopAnchor = reservationView.topAnchor.constraint(equalTo: subLabel.topAnchor, constant: -4)
            reservationViewMainTopAnchor.isActive = true
        reservationViewSubTopAnchor = reservationView.topAnchor.constraint(equalTo: subLabel.topAnchor, constant: -4)
            reservationViewSubTopAnchor.isActive = false
        
        discountButton.centerXAnchor.constraint(equalTo: reservationButton.rightAnchor, constant: 0).isActive = true
        discountButton.bottomAnchor.constraint(equalTo: reservationButton.bottomAnchor).isActive = true
        discountButton.widthAnchor.constraint(equalToConstant: 38).isActive = true
        discountButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    func expandBanner() {
        reservationViewMainTopAnchor.isActive = false
        reservationViewSubTopAnchor.isActive = true
        reservationViewMainLeftAnchor.isActive = false
        reservationViewSubLeftAnchor.isActive = true
        subLabelLeftAnchor.isActive = false
        arrowRightAnchor.isActive = true
        mainLeftAnchor.constant = 20
        subLabelBottomAnchor.constant = -20
        reservationButtonTopAnchor.constant = 20
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.font = Fonts.SSPSemiBoldH2
            self.subLabel.font = Fonts.SSPRegularH4
            self.subLabel.textColor = Theme.DARK_GRAY
            self.arrowButton.tintColor = Theme.DARK_GRAY
            self.discountButton.alpha = 0
            self.reservationView.alpha = 1
            self.subLabel.text = "Reserve your spot"
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.informationLabel.alpha = 1
            })
        }
    }
    
    func closeBanner() {
        reservationViewMainTopAnchor.isActive = true
        reservationViewSubTopAnchor.isActive = false
        reservationViewMainLeftAnchor.isActive = true
        reservationViewSubLeftAnchor.isActive = false
        subLabelLeftAnchor.isActive = true
        arrowRightAnchor.isActive = false
        mainLeftAnchor.constant = 32
        subLabelBottomAnchor.constant = -12
        reservationButtonTopAnchor.constant = 8
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.alpha = 0
            self.subLabel.font = Fonts.SSPRegularH5
            self.subLabel.textColor = Theme.WHITE
            self.arrowButton.tintColor = Theme.WHITE
            self.informationLabel.alpha = 0
            self.reservationView.alpha = 0
            self.subLabel.text = "Learn more"
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mainLabel.font = Fonts.SSPSemiBoldH3
//            self.mainLabel.textColor = Theme.DARK_GRAY
            UIView.animate(withDuration: animationIn, animations: {
                self.mainLabel.alpha = 1
                self.discountButton.alpha = 1
            })
        }
    }

}
