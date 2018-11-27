//
//  optionsCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/16/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class OptionsCell: UITableViewCell {
    
    var profileImageView: UIButton = {
        let imageView = UIButton()
        let image = UIImage(named: "feed")
        imageView.setImage(image, for: .normal)
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    var messageTextView: UILabel = {
        let view = UILabel()
        view.text = "Some sample text!"
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(messageTextView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        messageTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 24).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
