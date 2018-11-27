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
    
    let cellView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 235, height: 160)
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 1)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let reviewLabel: UITextView = {
        let reviewLabel = UITextView()
        reviewLabel.textAlignment = .left
        reviewLabel.isScrollEnabled = false
        reviewLabel.textColor = Theme.BLACK
        reviewLabel.font = Fonts.SSPLightH3
        reviewLabel.text = "There have not been any reviews for this spot yet."
        reviewLabel.isEditable = false
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return reviewLabel
    }()
    
    var date: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPLightH4
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 20
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.SEA_BLUE
        view.settings.emptyBorderColor = Theme.OFF_WHITE
        view.settings.filledBorderColor = Theme.SEA_BLUE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(cellView)
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        cellView.addSubview(reviewLabel)
        cellView.addSubview(stars)
        cellView.addSubview(date)
        
        reviewLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        reviewLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 5).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: stars.topAnchor, constant: -10).isActive = true
        
        date.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 12).isActive = true
        date.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        date.heightAnchor.constraint(equalToConstant: 20).isActive = true
        date.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        stars.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20).isActive = true
        stars.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 120).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

