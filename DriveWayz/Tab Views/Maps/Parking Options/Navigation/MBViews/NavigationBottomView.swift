//
//  NavigationBottomView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationBottomView: UIView {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "13 min"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH00
        label.alpha = 0
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.8 mi • 9:45pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.alpha = 0
        
        return label
    }()
    
    var checkInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Check in", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.layer.cornerRadius = 4
        button.alpha = 0
        
        return button
    }()
    
    var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.layer.cornerRadius = 4
        button.alpha = 0
        
        return button
    }()
    
    var grayContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.STANDARD_GRAY
        let line = UIView(frame: CGRect(x: 0, y:0, width: phoneWidth, height: 1))
        line.backgroundColor = Theme.LINE_GRAY
        view.addSubview(line)
        view.alpha = 0
        
        return view
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        let image = UIImage(named: "car_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.alpha = 0
        
        return button
    }()
    
    var pinIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GRAY_WHITE_4
        let image = UIImage(named: "pin_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.alpha = 0
        
        return button
    }()
    
    var walkIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GRAY_WHITE_4
        let image = UIImage(named: "walk_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.alpha = 0
        
        return button
    }()
    
    var arrow: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var arrow2: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to Mission lot"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    lazy var locatorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        let image = UIImage(named: "my_location")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.cornerRadius = 28
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = Theme.BLACK.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        
        setupViews()
        setupButtons()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(container)
        addSubview(locatorButton)
        
        container.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 0)
            containerHeightAnchor.isActive = true
        
        locatorButton.anchor(top: nil, left: nil, bottom: container.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 56, height: 56)

        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(checkInButton)
        addSubview(exitButton)
        
        exitButton.anchor(top: container.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 72, height: 56)
        
        checkInButton.anchor(top: exitButton.topAnchor, left: nil, bottom: nil, right: exitButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 112, height: 56)
        
        mainLabel.anchor(top: container.topAnchor, left: leftAnchor, bottom: nil, right: checkInButton.leftAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        mainLabel.sizeToFit()
        
        subLabel.anchor(top: mainLabel.bottomAnchor, left: mainLabel.leftAnchor, bottom: nil, right: mainLabel.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        subLabel.sizeToFit()
        
    }
    
    func setupButtons() {
        
        addSubview(grayContainer)
        grayContainer.addSubview(carIcon)
        grayContainer.addSubview(arrow)
        grayContainer.addSubview(pinIcon)
        grayContainer.addSubview(arrow2)
        grayContainer.addSubview(walkIcon)
        grayContainer.addSubview(destinationLabel)
        
        grayContainer.anchor(top: exitButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        carIcon.anchor(top: grayContainer.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        arrow.centerYAnchor.constraint(equalTo: carIcon.centerYAnchor).isActive = true
        arrow.leftAnchor.constraint(equalTo: carIcon.rightAnchor, constant: 4).isActive = true
        arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pinIcon.anchor(top: carIcon.topAnchor, left: arrow.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        arrow2.centerYAnchor.constraint(equalTo: carIcon.centerYAnchor).isActive = true
        arrow2.leftAnchor.constraint(equalTo: pinIcon.rightAnchor, constant: 4).isActive = true
        arrow2.widthAnchor.constraint(equalTo: arrow2.heightAnchor).isActive = true
        arrow2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        walkIcon.anchor(top: carIcon.topAnchor, left: arrow2.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        destinationLabel.centerYAnchor.constraint(equalTo: carIcon.centerYAnchor).isActive = true
        destinationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        destinationLabel.leftAnchor.constraint(equalTo: walkIcon.rightAnchor, constant: 8).isActive = true
        destinationLabel.sizeToFit()
        
    }
    
    func showContainer() {
        containerHeightAnchor.constant = 128
        UIView.animateOut(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 1
            self.subLabel.alpha = 1
            self.exitButton.alpha = 1
            self.checkInButton.alpha = 1
            self.carIcon.alpha = 0
            self.arrow.alpha = 0
            self.pinIcon.alpha = 0
            self.arrow2.alpha = 0
            self.walkIcon.alpha = 0
            self.destinationLabel.alpha = 0
            self.grayContainer.alpha = 0
            self.container.alpha = 1
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func expandContainer() {
        containerHeightAnchor.constant = 208
        UIView.animateOut(withDuration: animationOut, animations: {
            self.carIcon.alpha = 1
            self.arrow.alpha = 1
            self.pinIcon.alpha = 1
            self.arrow2.alpha = 1
            self.walkIcon.alpha = 1
            self.destinationLabel.alpha = 1
            self.grayContainer.alpha = 1
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideContainer() {
        containerHeightAnchor.constant = 0
        UIView.animateOut(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
            self.exitButton.alpha = 0
            self.checkInButton.alpha = 0
            self.carIcon.alpha = 0
            self.arrow.alpha = 0
            self.pinIcon.alpha = 0
            self.arrow2.alpha = 0
            self.walkIcon.alpha = 0
            self.destinationLabel.alpha = 0
            self.grayContainer.alpha = 0
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
