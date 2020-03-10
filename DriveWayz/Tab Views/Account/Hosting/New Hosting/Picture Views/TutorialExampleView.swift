//
//  TutorialExampleView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class TutorialExampleView: UIViewController {
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        label.numberOfLines = 2
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 2
        
        return label
    }()
    
    var exampleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.setTitle("Example", for: .normal)
        button.setTitleColor(Theme.GRAY_WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 12
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(imageView)
        view.addSubview(mainLabel)
        view.addSubview(informationLabel)
        view.addSubview(exampleButton)
        
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.62).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 56).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        informationLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        informationLabel.sizeToFit()
        
        exampleButton.anchor(top: nil, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 68, height: 24)
        
    }

}
