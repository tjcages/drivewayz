//
//  ActiveCouponViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ActiveCouponViewController: UIViewController {
    
    var couponLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Park today and recieve 10% off!"
        label.font = Fonts.SSPRegularH6
        
        return label
    }()
    
    var couponButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "saleIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.alpha = 0.8
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.GREEN_PIGMENT
        view.layer.cornerRadius = 3
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(couponLabel)
        couponLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        couponLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        couponLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        couponLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -2).isActive = true
        
        self.view.addSubview(couponButton)
        couponButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        couponButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        couponButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4).isActive = true
        couponButton.centerYAnchor.constraint(equalTo: couponLabel.centerYAnchor).isActive = true
        
    }

}
