//
//  HelpWorksView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HelpWorksView: UIView {
    
    var index: Int = 0 {
        didSet {
            if index == 0 {
                oneLabel.text = "Determine when spots are empty"
                twoLabel.text = "Set your availability"
                threeLabel.text = "Monitor bookings"
            } else if index == 1 {
                oneLabel.text = "Monitor bookings"
                twoLabel.text = "Link bank account"
                threeLabel.text = "Transfer money"
            } else if index == 2 {
                oneLabel.text = "List your unused parking spaces with Drivewayz"
                twoLabel.text = "Monitor bookings"
                threeLabel.text = "Update information"
            }
        }
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How it works"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var oneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setTitle("1", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var twoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setTitle("2", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var threeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setTitle("3", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var oneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        
        return label
    }()
    
    var twoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        
        return label
    }()
    
    var threeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        line.backgroundColor = lineColor
        addSubview(line)

        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        addSubview(oneButton)
        addSubview(twoButton)
        addSubview(threeButton)
        
        oneButton.anchor(top: mainLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 48, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        twoButton.anchor(top: oneButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 48, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        threeButton.anchor(top: twoButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 48, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)

        addSubview(oneLabel)
        addSubview(twoLabel)
        addSubview(threeLabel)
        
        oneLabel.centerYAnchor.constraint(equalTo: oneButton.centerYAnchor).isActive = true
        oneLabel.leftAnchor.constraint(equalTo: oneButton.rightAnchor, constant: 16).isActive = true
        oneLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        oneLabel.sizeToFit()
        
        twoLabel.centerYAnchor.constraint(equalTo: twoButton.centerYAnchor).isActive = true
        twoLabel.leftAnchor.constraint(equalTo: twoButton.rightAnchor, constant: 16).isActive = true
        twoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        twoLabel.sizeToFit()
        
        threeLabel.centerYAnchor.constraint(equalTo: threeButton.centerYAnchor).isActive = true
        threeLabel.leftAnchor.constraint(equalTo: threeButton.rightAnchor, constant: 16).isActive = true
        threeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        threeLabel.sizeToFit()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
