//
//  ListingInfoView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingInfoView: UIViewController {

    var spotsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Number of spots"
        
        return label
    }()
    
    var spotsSubLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "3"
        
        return label
    }()
    
    var spotsArrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var numbersLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Spot numbers"
        
        return label
    }()
    
    var numbersSubLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "20, 21, 22"
        
        return label
    }()
    
    var numbersArrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var gateLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Gate code"
        
        return label
    }()
    
    var gateSubLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "1234"
        
        return label
    }()
    
    var gateArrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()

    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(spotsLabel)
        view.addSubview(spotsSubLabel)
        view.addSubview(spotsArrowButton)
        
        spotsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        spotsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        spotsLabel.sizeToFit()
        
        spotsSubLabel.topAnchor.constraint(equalTo: spotsLabel.bottomAnchor).isActive = true
        spotsSubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        spotsSubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        spotsSubLabel.sizeToFit()
        
        spotsArrowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        spotsArrowButton.centerYAnchor.constraint(equalTo: spotsLabel.bottomAnchor).isActive = true
        spotsArrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        spotsArrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(numbersLabel)
        view.addSubview(numbersSubLabel)
        view.addSubview(numbersArrowButton)
        
        numbersLabel.topAnchor.constraint(equalTo: spotsSubLabel.bottomAnchor, constant: 20).isActive = true
        numbersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        numbersLabel.sizeToFit()
        
        numbersSubLabel.topAnchor.constraint(equalTo: numbersLabel.bottomAnchor).isActive = true
        numbersSubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        numbersSubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        numbersSubLabel.sizeToFit()
        
        numbersArrowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        numbersArrowButton.centerYAnchor.constraint(equalTo: numbersLabel.bottomAnchor).isActive = true
        numbersArrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        numbersArrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(gateLabel)
        view.addSubview(gateSubLabel)
        view.addSubview(gateArrowButton)
        
        gateLabel.topAnchor.constraint(equalTo: numbersSubLabel.bottomAnchor, constant: 20).isActive = true
        gateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        gateLabel.sizeToFit()
        
        gateSubLabel.topAnchor.constraint(equalTo: gateLabel.bottomAnchor).isActive = true
        gateSubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        gateSubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        gateSubLabel.sizeToFit()
        
        gateArrowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        gateArrowButton.centerYAnchor.constraint(equalTo: gateLabel.bottomAnchor).isActive = true
        gateArrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        gateArrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(line)
        line.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }

}
