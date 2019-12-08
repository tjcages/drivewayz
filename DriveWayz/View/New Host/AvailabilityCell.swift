//
//  AvailabilityCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AvailabilityCell: UITableViewCell {
    
    var dateFormatter = DateFormatter()
    
    var dates: [Date] = [] {
        didSet {
            if dates.count == 0 {
                cellUnavailable()
                subLabel.text = "Unavailable"
                additionalLabel.text = ""
            } else if dates.count == 2 {
                cellSelected()
                let from = dateFormatter.string(from: dates[0])
                let to = dateFormatter.string(from: dates[1])
                subLabel.text = "\(from) • \(to)"
                additionalLabel.text = ""
            } else if dates.count == 4 {
                cellSelected()
                let from = dateFormatter.string(from: dates[2])
                let to = dateFormatter.string(from: dates[3])
                subLabel.text = "\(from) • \(to)"
                let from2 = dateFormatter.string(from: dates[0])
                let to2 = dateFormatter.string(from: dates[1])
                additionalLabel.text = "\(from2) • \(to2)"
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH4
        label.text = "No time range set"
        
        return label
    }()
    
    var additionalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var checkmark: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.isChecked = true
        check.borderStyle = .roundedSquare(radius: 16)
        check.checkedBorderColor = .clear
        check.checkboxBackgroundColor = .clear
        check.checkmarkColor = Theme.LIGHT_GRAY
        check.backgroundColor = lineColor
        check.layer.cornerRadius = 16
        check.clipsToBounds = true
        check.isUserInteractionEnabled = false
        
        return check
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "h:mma"
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 0, height: 0)

        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(additionalLabel)
        
        mainLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        subLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        subLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        subLabel.sizeToFit()
        
        additionalLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        additionalLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        additionalLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        additionalLabel.sizeToFit()
        
        addSubview(checkmark)
        checkmark.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkmark.widthAnchor.constraint(equalTo: checkmark.heightAnchor).isActive = true
        checkmark.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
    func cellSelected() {
        UIView.animate(withDuration: animationIn) {
            self.backgroundColor = Theme.OFF_WHITE
            self.container.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
            self.container.layer.shadowOpacity = 0
            self.checkmark.backgroundColor = Theme.BLUE
            self.checkmark.checkmarkColor = Theme.WHITE
            self.subLabel.textColor = Theme.BLUE
        }
    }
    
    func cellUnselected() {
        UIView.animate(withDuration: animationIn) {
            self.backgroundColor = .clear
            self.container.backgroundColor = Theme.WHITE
            self.container.layer.shadowOpacity = 0.2
            self.checkmark.backgroundColor = lineColor
            self.checkmark.checkmarkColor = Theme.LIGHT_GRAY
            self.subLabel.textColor = Theme.BLUE
        }
    }
    
    func cellUnavailable() {
        UIView.animate(withDuration: animationIn) {
            self.backgroundColor = Theme.OFF_WHITE
            self.container.backgroundColor = lineColor
            self.container.layer.shadowOpacity = 0
            self.checkmark.backgroundColor = Theme.BLUE
            self.checkmark.checkmarkColor = Theme.WHITE
            self.subLabel.textColor = Theme.PRUSSIAN_BLUE
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

