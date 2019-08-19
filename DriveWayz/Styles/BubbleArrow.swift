//
//  BubbleArrow.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BubbleArrow: UIView {
    
    var message: String = "" {
        didSet {
            self.label.text = self.message
            self.layoutIfNeeded()
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.STRAWBERRY_PINK
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    let triangleView: TriangleView = {
        let view = TriangleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.STRAWBERRY_PINK
        view.backgroundColor = UIColor.clear
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = ""
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(container)
        self.addSubview(triangleView)
        self.addSubview(label)
        
        container.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: triangleView.topAnchor).isActive = true
        
        triangleView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        triangleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        triangleView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        triangleView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        label.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        label.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
