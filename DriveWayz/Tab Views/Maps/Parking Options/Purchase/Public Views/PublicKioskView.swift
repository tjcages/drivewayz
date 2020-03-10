//
//  PublicKioskView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/6/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class PublicKioskView: UIView {

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pay at kiosk"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "We are currently working to implement payment processing with ACE parking."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 4
        
        return label
    }()
    
    var whyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Why can't I pay in-app?", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(informationLabel)
        addSubview(whyButton)
        addSubview(line)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        informationLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        informationLabel.sizeToFit()
        
        whyButton.anchor(top: informationLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        whyButton.sizeToFit()
        
        line.anchor(top: whyButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
