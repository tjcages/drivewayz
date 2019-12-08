//
//  BookingsContainerView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class BookingsContainerView: UIView {

    var current: Bool = true {
        didSet {
            if current {
                setCurrent()
            } else {
                setPrevious()
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tyler"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var starView: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.totalStars = 1
        view.settings.updateOnTouch = false
        view.settings.starSize = 14
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.WHITE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.semanticContentAttribute = .forceRightToLeft
        view.clipsToBounds = true
        view.text = "  •  4.91"
        view.settings.textFont = Fonts.SSPRegularH3
        view.settings.textColor = Theme.WHITE
        view.settings.textMargin = 8
        view.settings.filledImage = UIImage(named: "Star Filled White")?.withRenderingMode(.alwaysTemplate)
        
        return view
    }()
    
    var licenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "317-ZFA"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wed 18, Nov 2019"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var paymentAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$8.80"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        
        return button
    }()

    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "3:20pm to 5:40pm"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.HOST_BLUE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 45)
        
        addSubview(nameLabel)
        addSubview(starView)
        addSubview(licenseLabel)
        
        nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        nameLabel.sizeToFit()
        
        starView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 4).isActive = true
        starView.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        starView.sizeToFit()
        
        licenseLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        licenseLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        licenseLabel.sizeToFit()
        
        addSubview(dateLabel)
        addSubview(informationIcon)
        addSubview(paymentAmount)
        addSubview(timeLabel)
        
        dateLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        dateLabel.sizeToFit()
        
        informationIcon.centerYAnchor.constraint(equalTo: paymentAmount.centerYAnchor).isActive = true
        informationIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true
        
        paymentAmount.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16).isActive = true
        paymentAmount.rightAnchor.constraint(equalTo: informationIcon.leftAnchor, constant: -2).isActive = true
        paymentAmount.sizeToFit()
        
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        timeLabel.sizeToFit()
        
    }
    
    func setCurrent() {
        backgroundColor = Theme.HOST_BLUE
        container.backgroundColor = Theme.BLUE
        nameLabel.textColor = Theme.WHITE
        licenseLabel.textColor = Theme.WHITE
        starView.settings.textColor = Theme.WHITE
        starView.settings.filledImage = UIImage(named: "Star Filled White")?.withRenderingMode(.alwaysTemplate)
    }
    
    func setPrevious() {
        backgroundColor = Theme.OFF_WHITE
        container.backgroundColor = Theme.HOST_BLUE
        nameLabel.textColor = Theme.DARK_GRAY
        starView.tintColor = Theme.DARK_GRAY
        licenseLabel.textColor = Theme.DARK_GRAY
        starView.settings.textColor = Theme.DARK_GRAY
        starView.settings.filledImage = UIImage(named: "Star Filled Black")?.withRenderingMode(.alwaysTemplate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
