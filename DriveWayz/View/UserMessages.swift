//
//  UserMessages.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit

class UserMessages: UITableViewCell {
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background4")
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        
        return imageView
    }()
    
    var hostTextView: UILabel = {
        let view = UILabel()
        view.text = "Host"
        view.font = UIFont.systemFont(ofSize: 18, weight: .light)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var dateTextView: UILabel = {
        let view = UILabel()
        view.text = "10/10/18"
        view.font = UIFont.systemFont(ofSize: 16, weight: .light)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.textAlignment = .right
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(hostTextView)
        addSubview(dateTextView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        hostTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        hostTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        hostTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        hostTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -82).isActive = true
        
        dateTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dateTextView.leftAnchor.constraint(equalTo: hostTextView.rightAnchor, constant: 4).isActive = true
        dateTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        dateTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
