//
//  CurrentRouteView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentRouteView: UIView {
    
    var slideLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1 min"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.1mi • 9:45pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var checkInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 4
        button.setTitle("Check in", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 4
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return button
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        line.backgroundColor = Theme.LINE_GRAY
        view.addSubview(line)
        
        return view
    }()
    
    var driveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.BLACK
        let image = UIImage(named: "purchaseCar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var separator: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Expand")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var parkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.LINE_GRAY
        let image = UIImage(named: "purchaseHome")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var separator2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Expand")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var walkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.LINE_GRAY
        let image = UIImage(named: "purchaseWalk")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to Mission Bay"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var parkingView = CurrentParkingView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        
        setupViews()
        setupRoute()
    }
    
    var exitRightAnchor: NSLayoutConstraint!
    var exitWidthAnchor: NSLayoutConstraint!
    var checkWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(slideLine)
        slideLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        slideLine.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 4)
        
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(checkInButton)
        addSubview(exitButton)
        
        mainLabel.topAnchor.constraint(equalTo: slideLine.bottomAnchor, constant: 8).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: checkInButton.leftAnchor, constant: -8).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: centerXAnchor, constant: -8).isActive = true
        subLabel.sizeToFit()
        
        exitButton.anchor(top: nil, left: nil, bottom: subLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 50)
        exitRightAnchor = exitButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
            exitRightAnchor.isActive = true
        exitWidthAnchor = exitButton.widthAnchor.constraint(equalToConstant: 64)
            exitWidthAnchor.isActive = true
        
        checkInButton.anchor(top: nil, left: nil, bottom: exitButton.bottomAnchor, right: exitButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 50)
        checkWidthAnchor = checkInButton.widthAnchor.constraint(equalToConstant: 110)
            checkWidthAnchor.isActive = true
        
    }
    
    func setupRoute() {
        
        addSubview(container)
        container.anchor(top: checkInButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(driveButton)
        addSubview(parkButton)
        addSubview(walkButton)
        addSubview(separator)
        addSubview(separator2)
        
        driveButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        driveButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        driveButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        driveButton.widthAnchor.constraint(equalTo: driveButton.heightAnchor).isActive = true
        
        separator.leftAnchor.constraint(equalTo: driveButton.rightAnchor, constant: 4).isActive = true
        separator.centerYAnchor.constraint(equalTo: driveButton.centerYAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        separator.heightAnchor.constraint(equalTo: separator.widthAnchor).isActive = true
        
        parkButton.leftAnchor.constraint(equalTo: separator.rightAnchor, constant: 4).isActive = true
        parkButton.centerYAnchor.constraint(equalTo: driveButton.centerYAnchor).isActive = true
        parkButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        parkButton.widthAnchor.constraint(equalTo: parkButton.heightAnchor).isActive = true
        
        separator2.leftAnchor.constraint(equalTo: parkButton.rightAnchor, constant: 4).isActive = true
        separator2.centerYAnchor.constraint(equalTo: driveButton.centerYAnchor).isActive = true
        separator2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        separator2.heightAnchor.constraint(equalTo: separator2.widthAnchor).isActive = true
        
        walkButton.leftAnchor.constraint(equalTo: separator2.rightAnchor, constant: 4).isActive = true
        walkButton.centerYAnchor.constraint(equalTo: driveButton.centerYAnchor).isActive = true
        walkButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        walkButton.widthAnchor.constraint(equalTo: walkButton.heightAnchor).isActive = true
     
        addSubview(destinationLabel)
        destinationLabel.centerYAnchor.constraint(equalTo: driveButton.centerYAnchor).isActive = true
        destinationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        destinationLabel.sizeToFit()
        
        addSubview(parkingView)
        parkingView.anchor(top: driveButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 32, paddingRight: 0, width: 0, height: 0)
        
        addSubview(spacer)
        spacer.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
    }
    
    func hideExit() {
        mainLabel.font = Fonts.SSPBoldH1
        mainLabel.text = "945 Dixie Dr"
        subLabel.text = "Arrived, on the left"
        layoutIfNeeded()
        
        exitRightAnchor.constant = 20
        exitWidthAnchor.constant = 28
        checkWidthAnchor.constant = 128
        UIView.animate(withDuration: animationIn) {
            self.exitButton.alpha = 0
            self.layoutIfNeeded()
        }
    }
    
    func showExit() {
        
        mainLabel.text = "1 min"
        subLabel.text = "0.1mi • 9:45pm"
        layoutIfNeeded()
        
        exitRightAnchor.constant = -20
        exitWidthAnchor.constant = 64
        checkWidthAnchor.constant = 110
        UIView.animate(withDuration: animationIn) {
            self.exitButton.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
