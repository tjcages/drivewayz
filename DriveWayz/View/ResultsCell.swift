//
//  ResultsCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/29/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class ResultsCell: UITableViewCell {
    
    var fullAddress: String?
    
    var pinImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "locationParkingIcon")
        imageView.image = image
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.PACIFIC_BLUE
//        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 25
        
        return imageView
    }()
    
    var nameTextView: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPLightH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = Theme.WHITE
        
        addSubview(pinImageView)
        addSubview(nameTextView)
        
        pinImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        pinImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pinImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        nameTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: pinImageView.rightAnchor, constant: 8).isActive = true
        nameTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        nameTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
