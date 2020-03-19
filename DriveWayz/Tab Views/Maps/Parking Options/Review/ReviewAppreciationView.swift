//
//  ReviewAppreciationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/16/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class ReviewAppreciationView: UIView {

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Feedback sumbitted"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Theme.BLACK
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 45/2
        layer.shadowColor = Theme.BLACK.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        alpha = 0
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainLabel.sizeToFit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
