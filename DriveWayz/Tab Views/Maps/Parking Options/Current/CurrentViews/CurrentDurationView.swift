//
//  CurrentDurationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/3/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class CurrentDurationView: UIView {

    var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:45pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH0
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7:00pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH0
        label.textAlignment = .right
        
        return label
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: -1.2, y: 1.2)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        alpha = 0
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(dayLabel)
        addSubview(fromLabel)
        addSubview(toLabel)
        addSubview(arrowButton)
        addSubview(line)
        
        dayLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        dayLabel.sizeToFit()
        
        fromLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4).isActive = true
        fromLabel.leftAnchor.constraint(equalTo: dayLabel.leftAnchor).isActive = true
        fromLabel.sizeToFit()
        
        toLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
        toLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        toLabel.sizeToFit()
        
        arrowButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        line.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
