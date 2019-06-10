//
//  NoParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NoParkingViewController: UIViewController {
    
    var noParkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.text = "There's no parking in this area"
        
        return label
    }()
    
    var contributeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.text = "Help contribute to your parking community by becoming a host today"
        label.numberOfLines = 2
        
        return label
    }()
    
    var noParkingGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "noParkingGraphic")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var becomeAHostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Become a host", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        //        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.4
//        button.addTarget(self, action: #selector(becomeAHost(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(noParkingLabel)
        noParkingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        noParkingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        noParkingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 18).isActive = true
        noParkingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(contributeLabel)
        contributeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        contributeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        contributeLabel.topAnchor.constraint(equalTo: noParkingLabel.bottomAnchor, constant: -8).isActive = true
        contributeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(noParkingGraphic)
        noParkingGraphic.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noParkingGraphic.topAnchor.constraint(equalTo: contributeLabel.bottomAnchor, constant: -12).isActive = true
        noParkingGraphic.widthAnchor.constraint(equalToConstant: 200).isActive = true
        noParkingGraphic.heightAnchor.constraint(equalTo: noParkingGraphic.widthAnchor).isActive = true
        
        self.view.addSubview(becomeAHostButton)
        becomeAHostButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        becomeAHostButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        becomeAHostButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -36).isActive = true
        becomeAHostButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}
