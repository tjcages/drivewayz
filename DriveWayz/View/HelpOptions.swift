//
//  HelpOptionCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HelpOptionCell: UICollectionViewCell {
    
    // The "call back" action to open our ViewController
    var moreTapAction : (()->())?
    
    var mainOption: QuickTopicsStruct? {
        didSet {
            if let option = self.mainOption {
                mainLabel.text = option.title
                subLabel.text = option.subtitle
                
                let page = option.page
                if page == "start" {
                    mainGraphic.image = UIImage(named: "plantGraphic")
                } else if page == "hosting" {
                    mainGraphic.image = UIImage(named: "houseGraphic")
                } else if page == "FAQ" {
                    mainGraphic.image = UIImage(named: "planeGraphic")
                }
            }
        }
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    var mainGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.WHITE
        layer.shadowColor = Theme.BLACK.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.cornerRadius = 4
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainGraphic)
        addSubview(mainLabel)
        addSubview(subLabel)
        
        mainGraphic.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 64, height: 64)
        mainGraphic.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: mainGraphic.bottomAnchor, constant: 8).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        subLabel.sizeToFit()
        
    }
    
    @objc func morePressed() {
        moreTapAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HelpCell: UITableViewCell {
    
    var mainOption: QuestionTopicsStruct? {
        didSet {
            if let option = self.mainOption {
                titleLabel.text = option.title
            }
        }
    }
    
    var answer: String?
    var subOption: QuestionsStruct? {
        didSet {
            if let option = self.subOption {
                titleLabel.text = option.title
                answer = option.key
            }
        }
    }
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        view.numberOfLines = 2
        
        return view
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        addSubview(titleLabel)
        addSubview(arrowButton)
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: arrowButton.leftAnchor, constant: -8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


