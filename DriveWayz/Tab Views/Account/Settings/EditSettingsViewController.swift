//
//  UserEmailViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class EditSettingsViewController: UIViewController {
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var subDetailLabel: UITextField = {
        let label = UITextField()
        label.text = ""
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.placeholder = ""
        label.textAlignment = .center
        
        return label
    }()
    
    var subLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var updateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH2
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.alpha = 1
        
        return button
    }()
    
    func setData(title: String, subtitle: String) {
        detailLabel.text = title
        subDetailLabel.placeholder = title
        subDetailLabel.text = subtitle
        subDetailLabel.becomeFirstResponder()
        updateButton.setTitle("Update \(title.lowercased())", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
     
        self.view.addSubview(detailLabel)
        detailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        detailLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(subDetailLabel)
        subDetailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        subDetailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        subDetailLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 24).isActive = true
        subDetailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(subLine)
        subLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        subLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        subLine.topAnchor.constraint(equalTo: subDetailLabel.bottomAnchor, constant: 12).isActive = true
        subLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(updateButton)
        updateButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        updateButton.widthAnchor.constraint(equalToConstant: phoneWidth - 72).isActive = true
        updateButton.topAnchor.constraint(equalTo: subLine.bottomAnchor, constant: 80).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
