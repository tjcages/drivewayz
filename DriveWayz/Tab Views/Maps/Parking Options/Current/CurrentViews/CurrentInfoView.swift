//
//  CurrentInfoView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/3/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class CurrentInfoView: UIView {

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Economy lot"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:45pm to 7:00pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 min walk"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(timeLabel)
        addSubview(distanceLabel)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        timeLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        timeLabel.sizeToFit()
        
        distanceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        distanceLabel.sizeToFit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
