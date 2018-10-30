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
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background4")
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.PACIFIC_BLUE
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = Theme.DARK_GRAY
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let reviewLabel: UITextView = {
        let reviewLabel = UITextView()
        reviewLabel.textAlignment = .left
        reviewLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        reviewLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        reviewLabel.text = "There have not been any reviews for this spot yet."
        reviewLabel.isEditable = false
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return reviewLabel
    }()
    
    var date: UITextField = {
        let label = UITextField()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = Theme.PACIFIC_BLUE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 15
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.settings.emptyBorderColor = Theme.DARK_GRAY
        view.settings.filledBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
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
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        cellView.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 5).isActive = true
        imageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        cellView.addSubview(userName)
        userName.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        userName.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 5).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        cellView.addSubview(date)
        date.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
        date.centerYAnchor.constraint(equalTo: userName.centerYAnchor).isActive = true
        date.heightAnchor.constraint(equalToConstant: 20).isActive = true
        date.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        cellView.addSubview(stars)
        stars.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        stars.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10).isActive = true
        stars.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        cellView.addSubview(reviewLabel)
        reviewLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
        reviewLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: stars.topAnchor, constant: -5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

