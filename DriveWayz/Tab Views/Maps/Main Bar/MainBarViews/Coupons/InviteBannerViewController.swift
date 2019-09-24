//
//  InviteBannerViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class InviteBannerViewController: UIViewController {

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earn rewards!"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .right
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get discounts and credit"
        label.textColor = Theme.STRAWBERRY_PINK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var trophyGraphic: UIImageView = {
        let image = UIImage(named: "trophyGraphic")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var parkingController: ParkingCouponViewController = {
        let controller = ParkingCouponViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -60).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(trophyGraphic)
        trophyGraphic.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        trophyGraphic.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 56).isActive = true
        trophyGraphic.heightAnchor.constraint(equalToConstant: 80).isActive = true
        trophyGraphic.widthAnchor.constraint(equalTo: trophyGraphic.heightAnchor).isActive = true
        
        self.view.addSubview(parkingController.view)
        parkingController.view.topAnchor.constraint(equalTo: trophyGraphic.bottomAnchor, constant: 32).isActive = true
        parkingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        parkingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        parkingController.view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
