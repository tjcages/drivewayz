//
//  optionsCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/16/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import UIKit


class OptionsCell: DatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let feed = datasourceItem as? Threads else { return }
            
            let attributedText = NSMutableAttributedString(string: feed.username, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .semibold)])
            let userSpace = "  \(feed.date)\n"
            attributedText.append(NSAttributedString(string: userSpace, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedStringKey.foregroundColor : Theme.DARK_GRAY.withAlphaComponent(0.7)]))
            let range = NSMakeRange(0, attributedText.string.count)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: range)
            attributedText.append(NSAttributedString(string: feed.message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
            
            messageTextView.attributedText = attributedText
        }
    }
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_image")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    var messageTextView: UITextView = {
        let view = UITextView()
        view.text = "Some sample text!"
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.backgroundColor = UIColor.clear
        view.allowsEditingTextAttributes = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var threadLine: UIView = {
        let threadLine = UIView()
        threadLine.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.6)
        
        return threadLine
    }()
    
    var threadLine2: UIView = {
        let threadLine2 = UIView()
        threadLine2.translatesAutoresizingMaskIntoConstraints = false
        threadLine2.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.6)
        
        return threadLine2
    }()
    
    var threadLine3: UIView = {
        let threadLine3 = UIView()
        threadLine3.translatesAutoresizingMaskIntoConstraints = false
        threadLine3.layer.cornerRadius = 2
        threadLine3.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.6)
        
        return threadLine3
    }()
    
    var threadLine4: UIView = {
        let threadLine4 = UIView()
        threadLine4.translatesAutoresizingMaskIntoConstraints = false
        threadLine4.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.6)
        
        return threadLine4
    }()
    
    var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.layer.cornerRadius = 10
        whiteView.backgroundColor = Theme.WHITE
        whiteView.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.2).cgColor
        whiteView.layer.borderWidth = 0.5
        
        return whiteView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.clear
        
        addSubview(threadLine)
        addSubview(threadLine4)
        addSubview(threadLine2)
        addSubview(threadLine3)
        addSubview(profileImageView)
        addSubview(messageTextView)
        addSubview(whiteView)
        
        threadLine.anchor(topAnchor, left: leftAnchor, bottom: threadLine2.bottomAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 2, heightConstant: 0)
        
        threadLine4.anchor(threadLine.bottomAnchor, left: leftAnchor, bottom: whiteView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 2, heightConstant: 0)
        
        threadLine2.leftAnchor.constraint(equalTo: threadLine.leftAnchor).isActive = true
        threadLine2.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor).isActive = true
        threadLine2.widthAnchor.constraint(equalToConstant: 18).isActive = true
        threadLine2.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        threadLine3.leftAnchor.constraint(equalTo: threadLine2.rightAnchor, constant: 2).isActive = true
        threadLine3.centerYAnchor.constraint(equalTo: threadLine2.centerYAnchor).isActive = true
        threadLine3.widthAnchor.constraint(equalToConstant: 4).isActive = true
        threadLine3.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        profileImageView.anchor(topAnchor, left: threadLine3.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        
        messageTextView.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        sendSubview(toBack: whiteView)
        whiteView.anchor(topAnchor, left: profileImageView.leftAnchor, bottom: messageTextView.bottomAnchor, right: messageTextView.rightAnchor, topConstant: 4, leftConstant: -4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
}
