//
//  ReviewsCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/25/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class ReviewsCell: UICollectionViewCell {
    
    var title: String = "" {
        didSet {
            self.reviewLabel.text = "\"\(self.title)\""
            if self.title == "" || self.title == "Enter your review" {
                self.stars.alpha = 1
                self.nameLabel.alpha = 1
                self.reviewLabel.alpha = 0
            } else {
                self.stars.alpha = 0
                self.nameLabel.alpha = 0
                self.reviewLabel.alpha = 1
            }
        }
    }
    
    var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.LIGHT_GRAY.withAlphaComponent(0.1), bottomColor: Theme.LIGHT_GRAY.withAlphaComponent(0.4))
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 300)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        
        return label
    }()
    
    var starImageView: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        
        return button
    }()
    
    var date: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPRegularH4
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = StarFillMode.precise
        view.settings.starSize = 24
        view.settings.starMargin = 6
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.WHITE.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.WHITE.withAlphaComponent(0.1)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Theme.WHITE
        self.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.cornerRadius = 8
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(cellView)
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(reviewLabel)
        self.addSubview(date)
        self.addSubview(starImageView)
        self.addSubview(stars)
        self.addSubview(nameLabel)
        
        starImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16).isActive = true
        starImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 16).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        starImageView.widthAnchor.constraint(equalTo: starImageView.heightAnchor).isActive = true
        
        date.leftAnchor.constraint(equalTo: starImageView.rightAnchor, constant: 16).isActive = true
        date.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        date.heightAnchor.constraint(equalToConstant: 20).isActive = true
        date.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -16).isActive = true
        
        reviewLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 16).isActive = true
        reviewLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -16).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 12).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -20).isActive = true
        
        stars.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 12).isActive = true
        stars.centerXAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        stars.sizeToFit()
        
        nameLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 12).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

