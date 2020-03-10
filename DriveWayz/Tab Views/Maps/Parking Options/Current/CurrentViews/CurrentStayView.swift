//
//  CurrentStayView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/4/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class CurrentStayView: UIView {

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How long do you plan on staying?"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 3
        label.text = "Set your parking duration and we will notify you once your time runs out."
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        alpha = 0
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(subLabel)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
