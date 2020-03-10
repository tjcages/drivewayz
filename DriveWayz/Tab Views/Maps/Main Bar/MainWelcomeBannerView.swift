//
//  MainWelcomeBannerView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/3/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import SVGKit

class MainWelcomeBannerView: UIViewController {
    
    var drivewayzIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE_MED
        button.layer.cornerRadius = 20
        let image = SVGKImage(named: "DrivewayzLogo_white")?.uiImage
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.alpha = 0
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to Drivewayz"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH3
        label.alpha = 0
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Learn the basics", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString
        label.alpha = 0
        
        return label
    }()

    var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE_MED
        button.layer.cornerRadius = 16
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainExpandedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to \nDrivewayz"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPBoldH00
        label.alpha = 0
        label.numberOfLines = 2
        
        return label
    }()
    
    var subExpandedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        label.text = "Let us know where you’re \nheaded and we find you the \nbest parking options."
        label.alpha = 0
        label.numberOfLines = 3
        
        return label
    }()
    
    var privateIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Private_Parking_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var carIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Car_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BLUE_DARK
        view.clipsToBounds = true

        setupViews()
        setupExpanded()
    }
    
    func setupViews() {
        
        view.addSubview(drivewayzIcon)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        drivewayzIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        drivewayzIcon.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        mainLabel.bottomAnchor.constraint(equalTo: drivewayzIcon.centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: drivewayzIcon.rightAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: drivewayzIcon.centerYAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
    }
    
    var privateBottomAnchor: NSLayoutConstraint!
    var carRightAnchor: NSLayoutConstraint!
    var mainExpandedTopAnchor: NSLayoutConstraint!
    
    func setupExpanded() {
        
        view.addSubview(privateIllustration)
        view.addSubview(carIllustration)
        view.addSubview(exitButton)
        view.addSubview(mainExpandedLabel)
        view.addSubview(subExpandedLabel)
        
        exitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        mainExpandedTopAnchor = mainExpandedLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 48)
            mainExpandedTopAnchor.isActive = true
        mainExpandedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainExpandedLabel.sizeToFit()
        
        subExpandedLabel.topAnchor.constraint(equalTo: mainExpandedLabel.bottomAnchor, constant: 8).isActive = true
        subExpandedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subExpandedLabel.sizeToFit()
        
        let height = privateIllustration.image.size.height/privateIllustration.image.size.width * phoneWidth
        privateIllustration.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: height)
        privateBottomAnchor = privateIllustration.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 64)
            privateBottomAnchor.isActive = true
        
        carIllustration.widthAnchor.constraint(equalTo: privateIllustration.widthAnchor, multiplier: 0.45).isActive = true
        carIllustration.heightAnchor.constraint(equalTo: carIllustration.widthAnchor, multiplier: 0.294).isActive = true
        carRightAnchor = carIllustration.rightAnchor.constraint(equalTo: privateIllustration.rightAnchor, constant: -phoneWidth)
            carRightAnchor.isActive = true
        carIllustration.bottomAnchor.constraint(equalTo: privateIllustration.bottomAnchor).isActive = true
        
    }
    
    func appear() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.drivewayzIcon.alpha = 1
            self.mainLabel.alpha = 1
            self.subLabel.alpha = 1
        }) { (success) in
            self.carIllustration.alpha = 0
            self.carRightAnchor.constant = -phoneWidth
            self.view.layoutIfNeeded()
        }
    }
    
    func disappear() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.drivewayzIcon.alpha = 0
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
        }, completion: nil)
    }
    
    func expand() {
        lightContentStatusBar()
        mainExpandedTopAnchor.constant = 32
        privateBottomAnchor.constant = 0
        UIView.animateOut(withDuration: animationOut, animations: {
            self.exitButton.alpha = 1
            self.mainExpandedLabel.alpha = 1
            self.subExpandedLabel.alpha = 1
            self.privateIllustration.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.animateCar()
        }
    }
    
    func minimize() {
        defaultContentStatusBar()
        privateBottomAnchor.constant = 64
        UIView.animateOut(withDuration: animationOut, animations: {
            self.privateIllustration.alpha = 0
            self.exitButton.alpha = 0
            self.mainExpandedLabel.alpha = 0
            self.subExpandedLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mainExpandedTopAnchor.constant = 48
        }
    }
    
    func animateCar() {
        if carIllustration.alpha == 0 {
            carIllustration.alpha = 1
            carRightAnchor.constant = -120
            UIView.animateOut(withDuration: 1, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
