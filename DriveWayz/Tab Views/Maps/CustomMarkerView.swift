 //
//  CustomMarkerView.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

 import Foundation
 import UIKit
 
 class CustomMarkerView: UIView {
    var parkingImageView: UIImageView!
    var borderColor: UIColor!
    var parkingImageURL: String!
    
    init(frame: CGRect, parkingImageURL: String, borderColor: UIColor, tag: Int) {
        super.init(frame: frame)
        self.parkingImageURL = parkingImageURL
        self.borderColor = borderColor
        self.tag = tag
        setupViews()
    }
    
    func setupViews() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.layer.borderColor = borderColor?.cgColor
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        if borderColor == Theme.PRIMARY_COLOR {
            view.backgroundColor = Theme.OFF_WHITE
        } else {
            view.backgroundColor = Theme.PRIMARY_COLOR
        }
        
        self.addSubview(view)
        
        parkingImageView = UIImageView()
        let myImage = UIImage(named: "Home")
        let tintableImage = myImage?.withRenderingMode(.alwaysTemplate)
        parkingImageView.image = tintableImage
        parkingImageView.tintColor = borderColor
        parkingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(parkingImageView)
        parkingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        parkingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        parkingImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        parkingImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let arrow = UILabel()
        arrow.text = "▾"
        arrow.font = UIFont.systemFont(ofSize: 24)
        arrow.textColor = borderColor
        arrow.textAlignment = .center
        arrow.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(arrow)
        arrow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        arrow.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 }
