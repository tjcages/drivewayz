//
//  RecentParkingCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/27/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Cosmos

class RecentParkingCell: UICollectionViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 235, height: 160)
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
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
        imageView.backgroundColor = Theme.PRIMARY_COLOR
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var reviewLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "Address"
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var hoursLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Hours spent"
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var costLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Total cost"
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var priceLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.textColor = Theme.PRIMARY_COLOR
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "- hourly cost"
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var rating: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.starSize = 15
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.settings.emptyBorderColor = Theme.DARK_GRAY
        view.settings.filledBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
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
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        cellView.addSubview(reviewLabel)
        reviewLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 5).isActive = true
        reviewLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -5).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor).isActive = true
        
        cellView.addSubview(hoursLabel)
        hoursLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5).isActive = true
        hoursLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -5).isActive = true
        hoursLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        hoursLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cellView.addSubview(costLabel)
        costLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5).isActive = true
        costLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -5).isActive = true
        costLabel.topAnchor.constraint(equalTo: hoursLabel.bottomAnchor, constant: 0).isActive = true
        costLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cellView.addSubview(priceLabel)
        priceLabel.leftAnchor.constraint(equalTo: costLabel.leftAnchor, constant: 5).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -5).isActive = true
        priceLabel.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 0).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cellView.addSubview(rating)
        rating.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        rating.widthAnchor.constraint(equalTo: cellView.widthAnchor, constant: -100).isActive = true
        rating.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5).isActive = true
        rating.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
