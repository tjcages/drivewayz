//
//  EarningsSelectView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EarningsSelectView: UIView {
    
    var date: Date? {
        didSet {
            formatter.dateFormat = "E MMM d, yyyy"
            if let date = date {
                let string = formatter.string(from: date)
                subLabel.text = string
            }
        }
    }
    
    let triangleView: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.BLACK
        view.backgroundColor = UIColor.clear
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Transfer"
        
        return label
    }()
    
    var profitLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "$10.14"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Wed. Nov. 12, 2019"
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        backgroundColor = Theme.BLACK
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(triangleView)
        triangleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        triangleView.topAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        triangleView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        triangleView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        addSubview(mainLabel)
        addSubview(profitLabel)
        addSubview(subLabel)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        mainLabel.sizeToFit()
        
        profitLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profitLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        profitLabel.sizeToFit()
        
        subLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
