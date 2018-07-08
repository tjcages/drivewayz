//
//  ParkingPreviewView.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class ParkingPreviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
        setupViews()
    }
    
    func setData(city: String, imageURL: String, price: String) {
        labelTitle.text = city
        imageView.loadImageUsingCacheWithUrlString(imageURL)
        labelPrice.text = price
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: -8).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: -4).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: 12).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
//        imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
        addSubview(labelTitle)
        labelTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        labelTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(labelPrice)
        labelPrice.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelPrice.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 2).isActive = true
        labelPrice.widthAnchor.constraint(equalToConstant: 90).isActive = true
        labelPrice.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileprofile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let labelTitle: UILabel = {
        let title = UILabel()
        title.text = "Name"
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor.white
        title.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        title.textAlignment = .center
        title.layer.cornerRadius = 5
        title.clipsToBounds = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        return title
    }()
    
    let labelPrice: UILabel = {
        let price = UILabel()
        price.text = "$12"
        price.font = UIFont.boldSystemFont(ofSize: 16)
        price.textColor = UIColor.white
        price.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        price.textAlignment = .center
        price.layer.cornerRadius = 5
        price.clipsToBounds = true
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
