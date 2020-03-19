//
//  CurrentBottomView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/3/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class CurrentBottomView: UIView {
    
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
        label.text = "to Ballast Point"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 min walk • 0.1mi"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        
        return label
    }()
    
    var changeDestinationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .right
        button.alpha = 0
        
        return button
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.setTitle("End booking", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 2
        button.alpha = 0
//        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Theme.STANDARD_GRAY
        translatesAutoresizingMaskIntoConstraints = false
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        line.backgroundColor = Theme.LINE_GRAY
        addSubview(line)
        
        setupViews()
    }
    
    var distanceTopAnchor: NSLayoutConstraint!
    var mainTopAnchor: NSLayoutConstraint!
    var mainBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(carIcon)
        addSubview(arrow)
        addSubview(pinIcon)
        addSubview(arrow2)
        addSubview(walkIcon)
        addSubview(destinationLabel)
        
        carIcon.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
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
        
        addSubview(distanceLabel)
        addSubview(changeDestinationButton)
        addSubview(mainButton)
        
        distanceTopAnchor = distanceLabel.topAnchor.constraint(equalTo: carIcon.bottomAnchor, constant: 40)
            distanceTopAnchor.isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        distanceLabel.sizeToFit()
        
        changeDestinationButton.centerYAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: 4).isActive = true
        changeDestinationButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        changeDestinationButton.sizeToFit()
        
        mainButton.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        mainTopAnchor = mainButton.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 20)
            mainTopAnchor.isActive = true
        mainBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: cancelBottomHeight)
            mainBottomAnchor.isActive = false
        
    }
    
    func show() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.destinationLabel.alpha = 1
        }, completion: nil)
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33) {
                self.carIcon.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33) {
                self.pinIcon.alpha = 1
                self.arrow.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33) {
                self.walkIcon.alpha = 1
                self.arrow2.alpha = 1
            }
        }) { (success) in
            //
        }
    }
    
    func showExpanded() {
        distanceTopAnchor.constant = 8
        mainTopAnchor.isActive = false
        mainBottomAnchor.isActive = true
        UIView.animateOut(withDuration: animationOut, animations: {
            self.distanceLabel.alpha = 1
            self.changeDestinationButton.alpha = 1
            self.mainButton.alpha = 1
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideExpanded() {
        mainTopAnchor.isActive = true
        mainBottomAnchor.isActive = false
        UIView.animateOut(withDuration: animationIn, animations: {
            self.distanceLabel.alpha = 0
            self.changeDestinationButton.alpha = 0
            self.mainButton.alpha = 0
            self.layoutIfNeeded()
        }) { (success) in
            self.distanceTopAnchor.constant = 40
            self.layoutIfNeeded()
        }
    }
    
    func showDuration() {
        UIView.transition(with: mainButton, duration: animationIn, options: [.curveEaseIn], animations: {
            self.mainButton.setTitle("", for: .normal)
            self.mainButton.backgroundColor = Theme.BLACK
            self.mainButton.setTitleColor(Theme.WHITE, for: .normal)
            
            self.distanceLabel.alpha = 0
            self.changeDestinationButton.alpha = 0
            self.carIcon.alpha = 0
            self.arrow.alpha = 0
            self.pinIcon.alpha = 0
            self.arrow2.alpha = 0
            self.walkIcon.alpha = 0
            self.destinationLabel.alpha = 0
        }) { (success) in
            UIView.transition(with: self.mainButton, duration: animationIn, options: [.curveEaseOut], animations: {
                self.mainButton.setTitle("Save duration", for: .normal)
            }) { (succes) in
                //
            }
        }
    }
    
    func hideDuration() {
        UIView.transition(with: mainButton, duration: animationIn, options: [.curveEaseIn], animations: {
            self.mainButton.setTitle("", for: .normal)
            self.mainButton.backgroundColor = Theme.LINE_GRAY
            self.mainButton.setTitleColor(Theme.BLACK, for: .normal)
            
            self.distanceLabel.alpha = 1
            self.changeDestinationButton.alpha = 1
            self.carIcon.alpha = 1
            self.arrow.alpha = 1
            self.pinIcon.alpha = 1
            self.arrow2.alpha = 1
            self.walkIcon.alpha = 1
            self.destinationLabel.alpha = 1
        }) { (success) in
            UIView.transition(with: self.mainButton, duration: animationIn, options: [.curveEaseOut], animations: {
                self.mainButton.setTitle("End booking", for: .normal)
            }) { (succes) in
                //
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
