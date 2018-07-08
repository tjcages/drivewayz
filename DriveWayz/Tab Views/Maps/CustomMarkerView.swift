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
        parkingImageView = UIImageView()
        parkingImageView.loadImageUsingCacheWithUrlString(parkingImageURL)
        parkingImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        parkingImageView.layer.cornerRadius = 25
        parkingImageView.layer.borderColor = borderColor?.cgColor
        parkingImageView.layer.borderWidth = 4
        parkingImageView.clipsToBounds = true
        let arrow = UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
        arrow.text = "▾"
        arrow.font = UIFont.systemFont(ofSize: 24)
        arrow.textColor = borderColor
        arrow.textAlignment = .center
        
        self.addSubview(parkingImageView)
        self.addSubview(arrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 }
