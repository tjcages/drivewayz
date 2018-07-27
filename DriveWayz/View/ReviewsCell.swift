//
//  ReviewsCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/25/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class ReviewsCell: UICollectionViewCell {
    
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
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let reviewLabel: UITextView = {
        let reviewLabel = UITextView()
        reviewLabel.textAlignment = .left
        reviewLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        reviewLabel.font = UIFont.systemFont(ofSize: 12)
        reviewLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        reviewLabel.isEditable = false
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return reviewLabel
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
        
        cellView.addSubview(reviewLabel)
        reviewLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5).isActive = true
        reviewLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -5).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

