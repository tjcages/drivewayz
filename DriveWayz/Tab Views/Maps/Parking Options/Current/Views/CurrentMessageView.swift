//
//  CurrentMessageView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentMessageView: UIView {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 8
        
        return view
    }()

    let triangleView: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.BLUE
        view.backgroundColor = UIColor.clear
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let us know when you’re \nparked in the shared space."
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(container)
        container.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 20, width: 300, height: 0)
        
        container.addSubview(triangleView)
        triangleView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -40).isActive = true
        triangleView.topAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        triangleView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        triangleView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        container.addSubview(mainLabel)
        mainLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.addSubview(closeButton)
        closeButton.anchor(top: container.topAnchor, left: nil, bottom: nil, right: container.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 20, height: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
