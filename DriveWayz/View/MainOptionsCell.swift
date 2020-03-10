//
//  MainOptionsCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import UIImageColors

struct MainOption {
    let mainText: String
    let subText: String
    let graphic: UIImage?
    let option: DiscountOptions
}

class MainOptionsCell: UICollectionViewCell {
    
    // The "call back" action to open our ViewController
    var moreTapAction : (()->())?
    var discountOption: DiscountOptions = .code
    
    var mainOption: MainOption? {
        didSet {
            if let option = self.mainOption {
                mainLabel.text = option.mainText
                subLabel.text = option.subText
                mainGraphic.image = option.graphic
            }
        }
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()
    
    var mainGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    lazy var learnLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(morePressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "arrow-right")?.withRenderingMode(.alwaysTemplate)
        //        button.transform = CGAffineTransform(scaleX: -0.7, y: 0.7)
        button.tintColor = Theme.BLUE
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(morePressed), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.WHITE
        layer.shadowColor = Theme.BLACK.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(mainGraphic)
        
        addSubview(arrowButton)
        addSubview(learnLabel)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 92).isActive = true
        subLabel.sizeToFit()
        
        mainGraphic.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 12, paddingRight: 0, width: 64, height: 64)
        
        arrowButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 24, height: 24)
        
        learnLabel.centerYAnchor.constraint(equalTo: arrowButton.centerYAnchor).isActive = true
        learnLabel.rightAnchor.constraint(equalTo: arrowButton.leftAnchor, constant: -4).isActive = true
        learnLabel.sizeToFit()
        
    }
    
    @objc func morePressed() {
        moreTapAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

