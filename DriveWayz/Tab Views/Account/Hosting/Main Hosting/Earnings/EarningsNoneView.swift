//
//  EarningsNoneView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EarningsNoneView: UIView {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 3
        label.text = "Share Drivewayz with a \nfriend and earn your \nfirst $5 "
        
        return label
    }()
    
    var mainGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "hostInvite")
        view.image = image
        
        return view
    }()
    
    lazy var learnLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .right
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "arrow-right")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.WHITE
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var learnView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        backgroundColor = Theme.HOST_GREEN
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(mainGraphic)
        
        addSubview(learnView)
        addSubview(arrowButton)
        addSubview(learnLabel)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: mainGraphic.rightAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        mainGraphic.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 64, height: 64)
        mainGraphic.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        
        arrowButton.anchor(top: nil, left: nil, bottom: learnView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 16, width: 28, height: 28)
        
        learnLabel.centerYAnchor.constraint(equalTo: arrowButton.centerYAnchor).isActive = true
        learnLabel.rightAnchor.constraint(equalTo: arrowButton.leftAnchor, constant: -4).isActive = true
        learnLabel.sizeToFit()
        
        learnView.anchor(top: learnLabel.topAnchor, left: learnLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -4, paddingLeft: -20, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
