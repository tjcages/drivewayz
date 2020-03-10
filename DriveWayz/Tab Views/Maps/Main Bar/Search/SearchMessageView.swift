//
//  SearchMessageView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/4/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class SearchMessageView: UIView {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.COOL_1_MED
        view.layer.cornerRadius = 8
        
        return view
    }()

    let triangleView: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.COOL_1_MED
        view.backgroundColor = UIColor.clear
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Swipe down to search \nusing the map."
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
//        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        button.isUserInteractionEnabled = false
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 14, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(triangleView)
        triangleView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        triangleView.topAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        triangleView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        triangleView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        container.addSubview(mainLabel)
        mainLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.addSubview(closeButton)
        closeButton.anchor(top: mainLabel.topAnchor, left: nil, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 20, height: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
