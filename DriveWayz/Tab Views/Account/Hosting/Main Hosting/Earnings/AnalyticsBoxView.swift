//
//  AnalyticsBoxView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AnalyticsBoxView: UIView {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
//        view.layer.cornerRadius = 8
//        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 3)
//        view.layer.shadowRadius = 6
//        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var earningsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH0
        
        return label
    }()

    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.numberOfLines = 2
        
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 18
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 6, width: 0, height: 0)
        
        addSubview(earningsLabel)
        addSubview(mainLabel)
        addSubview(nextButton)
        
        earningsLabel.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        earningsLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        earningsLabel.sizeToFit()
        
        mainLabel.topAnchor.constraint(equalTo: earningsLabel.bottomAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: earningsLabel.leftAnchor).isActive = true
        mainLabel.sizeToFit()
        
        nextButton.anchor(top: container.topAnchor, left: nil, bottom: nil, right: container.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 36, height: 36)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
