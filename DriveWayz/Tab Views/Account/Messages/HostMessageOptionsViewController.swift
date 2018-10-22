//
//  HostMessageOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/18/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class HostMessageOptionsViewController: UIViewController {

    var userId: String = ""
    var delegate: setTextField?
    
    var needToLeave: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Need to leave", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var parkedIncorrectly: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Parked incorrectly", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var leftSomething: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Left something?", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var wrongVehicle: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Wrong vehicle info", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var tooLong: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("There longer than paid", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var confirmTheyLeft: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Need to confirm they left", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var carTowed: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Car was towed", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var propertyDamaged: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Property was damaged", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.text = "Quick options"
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotTakenWidth = (needToLeave.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        cantFindWidth = (parkedIncorrectly.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        pictureNotShowingWidth = (leftSomething.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        incorrectTimeWidth = (wrongVehicle.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        carTowedWidth = (tooLong.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        damagedCarWidth = (propertyDamaged.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        leaveEarlyWidth = (confirmTheyLeft.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        wrongLocationWidth = (carTowed.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        
        setupStackViews()
        setupViews()
    }
    
    let firstStackView = UIView()
    let secondStackView = UIView()
    let thirdStackView = UIView()
    let fourthStackView = UIView()
    
    var spotTakenWidth: CGFloat?
    var cantFindWidth: CGFloat?
    var pictureNotShowingWidth: CGFloat?
    var incorrectTimeWidth: CGFloat?
    var carTowedWidth: CGFloat?
    var damagedCarWidth: CGFloat?
    var leaveEarlyWidth: CGFloat?
    var wrongLocationWidth: CGFloat?
    
    func setupStackViews() {
        
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdStackView.translatesAutoresizingMaskIntoConstraints = false
        fourthStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.contentSize = CGSize(width: spotTakenWidth! + cantFindWidth! + pictureNotShowingWidth! + incorrectTimeWidth! + carTowedWidth! + damagedCarWidth! + leaveEarlyWidth! + wrongLocationWidth! + 200, height: self.view.frame.height)
        
        scrollView.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8).isActive = true
        informationLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        scrollView.addSubview(firstStackView)
        scrollView.addSubview(secondStackView)
        scrollView.addSubview(thirdStackView)
        scrollView.addSubview(fourthStackView)
        
        scrollView.addSubview(needToLeave)
        scrollView.addSubview(parkedIncorrectly)
        scrollView.addSubview(leftSomething)
        scrollView.addSubview(wrongVehicle)
        scrollView.addSubview(tooLong)
        scrollView.addSubview(propertyDamaged)
        scrollView.addSubview(confirmTheyLeft)
        scrollView.addSubview(carTowed)
        
        firstStackView.leftAnchor.constraint(equalTo: informationLabel.rightAnchor, constant: 4).isActive = true
        firstStackView.widthAnchor.constraint(equalToConstant: spotTakenWidth! + cantFindWidth! + 8).isActive = true
        firstStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        firstStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        secondStackView.leftAnchor.constraint(equalTo: firstStackView.rightAnchor, constant: 8).isActive = true
        secondStackView.widthAnchor.constraint(equalToConstant: pictureNotShowingWidth! + incorrectTimeWidth! + 8).isActive = true
        secondStackView.topAnchor.constraint(equalTo: firstStackView.topAnchor).isActive = true
        secondStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        thirdStackView.leftAnchor.constraint(equalTo: secondStackView.rightAnchor, constant: 8).isActive = true
        thirdStackView.widthAnchor.constraint(equalToConstant: leaveEarlyWidth! + wrongLocationWidth! + 8).isActive = true
        thirdStackView.topAnchor.constraint(equalTo: firstStackView.topAnchor).isActive = true
        thirdStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        fourthStackView.leftAnchor.constraint(equalTo: thirdStackView.rightAnchor, constant: 8).isActive = true
        fourthStackView.widthAnchor.constraint(equalToConstant: carTowedWidth! + damagedCarWidth! + 8).isActive = true
        fourthStackView.topAnchor.constraint(equalTo: firstStackView.topAnchor).isActive = true
        fourthStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    var sendCommunicationsAnchor: NSLayoutConstraint!
    var sendCommunicationsWidth: NSLayoutConstraint!
    
    func setupViews() {
        
        needToLeave.widthAnchor.constraint(equalToConstant: spotTakenWidth!).isActive = true
        needToLeave.leftAnchor.constraint(equalTo: firstStackView.leftAnchor).isActive = true
        needToLeave.topAnchor.constraint(equalTo: firstStackView.topAnchor).isActive = true
        needToLeave.bottomAnchor.constraint(equalTo: firstStackView.bottomAnchor).isActive = true
        
        parkedIncorrectly.rightAnchor.constraint(equalTo: firstStackView.rightAnchor).isActive = true
        parkedIncorrectly.widthAnchor.constraint(equalToConstant: cantFindWidth!).isActive = true
        parkedIncorrectly.topAnchor.constraint(equalTo: firstStackView.topAnchor).isActive = true
        parkedIncorrectly.bottomAnchor.constraint(equalTo: firstStackView.bottomAnchor).isActive = true
        
        leftSomething.widthAnchor.constraint(equalToConstant: pictureNotShowingWidth!).isActive = true
        leftSomething.leftAnchor.constraint(equalTo: secondStackView.leftAnchor).isActive = true
        leftSomething.topAnchor.constraint(equalTo: secondStackView.topAnchor).isActive = true
        leftSomething.bottomAnchor.constraint(equalTo: secondStackView.bottomAnchor).isActive = true
        
        wrongVehicle.rightAnchor.constraint(equalTo: secondStackView.rightAnchor).isActive = true
        wrongVehicle.widthAnchor.constraint(equalToConstant: incorrectTimeWidth!).isActive = true
        wrongVehicle.topAnchor.constraint(equalTo: secondStackView.topAnchor).isActive = true
        wrongVehicle.bottomAnchor.constraint(equalTo: secondStackView.bottomAnchor).isActive = true
        
        confirmTheyLeft.widthAnchor.constraint(equalToConstant: leaveEarlyWidth!).isActive = true
        confirmTheyLeft.leftAnchor.constraint(equalTo: thirdStackView.leftAnchor).isActive = true
        confirmTheyLeft.topAnchor.constraint(equalTo: thirdStackView.topAnchor).isActive = true
        confirmTheyLeft.bottomAnchor.constraint(equalTo: thirdStackView.bottomAnchor).isActive = true
        
        carTowed.rightAnchor.constraint(equalTo: thirdStackView.rightAnchor).isActive = true
        carTowed.widthAnchor.constraint(equalToConstant: wrongLocationWidth!).isActive = true
        carTowed.topAnchor.constraint(equalTo: thirdStackView.topAnchor).isActive = true
        carTowed.bottomAnchor.constraint(equalTo: thirdStackView.bottomAnchor).isActive = true
        
        tooLong.widthAnchor.constraint(equalToConstant: carTowedWidth!).isActive = true
        tooLong.leftAnchor.constraint(equalTo: fourthStackView.leftAnchor).isActive = true
        tooLong.topAnchor.constraint(equalTo: fourthStackView.topAnchor).isActive = true
        tooLong.bottomAnchor.constraint(equalTo: fourthStackView.bottomAnchor).isActive = true
        
        propertyDamaged.rightAnchor.constraint(equalTo: fourthStackView.rightAnchor).isActive = true
        propertyDamaged.widthAnchor.constraint(equalToConstant: damagedCarWidth!).isActive = true
        propertyDamaged.topAnchor.constraint(equalTo: fourthStackView.topAnchor).isActive = true
        propertyDamaged.bottomAnchor.constraint(equalTo: fourthStackView.bottomAnchor).isActive = true
        
    }

    var lastButton: UIButton!
    
    @objc func optionsButtonPressed(sender: UIButton) {
        if sender.backgroundColor == Theme.WHITE {
            UIView.animate(withDuration: 0.1) {
                sender.backgroundColor = Theme.PRIMARY_DARK_COLOR
                sender.setTitleColor(Theme.WHITE, for: .normal)
                sender.layer.borderColor = Theme.PRIMARY_DARK_COLOR.cgColor
                sender.tag = 1
                if self.lastButton != nil {
                    self.lastButton.backgroundColor = Theme.WHITE
                    self.lastButton.setTitleColor(Theme.BLACK, for: .normal)
                    self.lastButton.layer.borderColor = Theme.BLACK.cgColor
                    self.lastButton.tag = 0
                }
                self.lastButton = sender
            }
            if sender == self.needToLeave {
                self.delegate?.setTextField(message: "The spot I purchased is currently taken")
            } else if sender == self.parkedIncorrectly {
                self.delegate?.setTextField(message: "I cannot find the parking spot")
            } else if sender == self.leftSomething {
                self.delegate?.setTextField(message: "Your spot's picture does not clearly show the space")
            } else if sender == self.wrongVehicle {
                self.delegate?.setTextField(message: "I need to purchase more time")
            } else if sender == self.confirmTheyLeft {
                self.delegate?.setTextField(message: "I have to leave the space early")
            } else if sender == self.carTowed {
                self.delegate?.setTextField(message: "This space's address was incorrect")
            } else if sender == self.tooLong {
                self.delegate?.setTextField(message: "My car was towed while parking in your spot")
            } else if sender == self.propertyDamaged {
                self.delegate?.setTextField(message: "My car was damaged while parking in your spot")
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                sender.backgroundColor = Theme.WHITE
                sender.setTitleColor(Theme.BLACK, for: .normal)
                sender.layer.borderColor = Theme.BLACK.cgColor
                sender.tag = 0
                self.lastButton = nil
            }
        }
    }

}
