//
//  VerifyInstructionsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class VerifyInstructionsView: UIViewController {
    
    var delegate: HostVerifyDelegate?

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Driver instructions"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Does the space require additional information for a driver to park?"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var switchButton: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = Theme.BLUE
        view.tintColor = Theme.LINE_GRAY
        view.addTarget(self, action: #selector(switchPressed(sender:)), for: .valueChanged)
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)

        setupViews()
    }
        
    func setupViews() {
        
        view.addSubview(switchButton)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(informationIcon)
        
        switchButton.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        switchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()

        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: switchButton.leftAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        informationIcon.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        informationIcon.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 4).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true
        
    }
    
    @objc func switchPressed(sender: UISwitch) {
        if sender.isOn {
            isInstructions()
        } else {
            isPromotional()
        }
    }
    
    func isInstructions() {
        delegate?.changeMessage(promotional: false)
    }
    
    func isPromotional() {
        delegate?.changeMessage(promotional: true)
    }
    
    @objc func viewTapped() {
        if switchButton.isOn {
            switchButton.setOn(false, animated: true)
            isPromotional()
        } else {
            switchButton.setOn(true, animated: true)
            isInstructions()
        }
    }
    
}


