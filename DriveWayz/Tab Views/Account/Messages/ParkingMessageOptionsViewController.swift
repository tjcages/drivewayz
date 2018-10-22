//
//  ParkingMessageOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/18/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingMessageOptionsViewController: UIViewController {

    var userId: String = ""
    var delegate: setTextField?
    
    var spotTaken: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Spot is taken", for: .normal)
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
    
    var cantFind: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Can't find spot", for: .normal)
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
    
    var pictureNotShowing: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Bad picture", for: .normal)
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
    
    var incorrectTime: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Time was incorrect", for: .normal)
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
    
    var leaveEarly: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Had to leave early", for: .normal)
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
    
    var wrongLocation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Wrong location", for: .normal)
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
    
    var damagedCar: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Vehicle was damaged", for: .normal)
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
        
        spotTakenWidth = (spotTaken.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        cantFindWidth = (cantFind.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        pictureNotShowingWidth = (pictureNotShowing.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        incorrectTimeWidth = (incorrectTime.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        carTowedWidth = (carTowed.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        damagedCarWidth = (damagedCar.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        leaveEarlyWidth = (leaveEarly.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        wrongLocationWidth = (wrongLocation.titleLabel?.text?.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 16, weight: .light)))! + 20
        
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
        
        scrollView.addSubview(spotTaken)
        scrollView.addSubview(cantFind)
        scrollView.addSubview(pictureNotShowing)
        scrollView.addSubview(incorrectTime)
        scrollView.addSubview(carTowed)
        scrollView.addSubview(damagedCar)
        scrollView.addSubview(leaveEarly)
        scrollView.addSubview(wrongLocation)
        
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
        
        spotTaken.widthAnchor.constraint(equalToConstant: spotTakenWidth!).isActive = true
        spotTaken.leftAnchor.constraint(equalTo: firstStackView.leftAnchor).isActive = true
        spotTaken.topAnchor.constraint(equalTo: firstStackView.topAnchor).isActive = true
        spotTaken.bottomAnchor.constraint(equalTo: firstStackView.bottomAnchor).isActive = true
        
        cantFind.rightAnchor.constraint(equalTo: firstStackView.rightAnchor).isActive = true
        cantFind.widthAnchor.constraint(equalToConstant: cantFindWidth!).isActive = true
        cantFind.topAnchor.constraint(equalTo: firstStackView.topAnchor).isActive = true
        cantFind.bottomAnchor.constraint(equalTo: firstStackView.bottomAnchor).isActive = true
        
        pictureNotShowing.widthAnchor.constraint(equalToConstant: pictureNotShowingWidth!).isActive = true
        pictureNotShowing.leftAnchor.constraint(equalTo: secondStackView.leftAnchor).isActive = true
        pictureNotShowing.topAnchor.constraint(equalTo: secondStackView.topAnchor).isActive = true
        pictureNotShowing.bottomAnchor.constraint(equalTo: secondStackView.bottomAnchor).isActive = true
        
        incorrectTime.rightAnchor.constraint(equalTo: secondStackView.rightAnchor).isActive = true
        incorrectTime.widthAnchor.constraint(equalToConstant: incorrectTimeWidth!).isActive = true
        incorrectTime.topAnchor.constraint(equalTo: secondStackView.topAnchor).isActive = true
        incorrectTime.bottomAnchor.constraint(equalTo: secondStackView.bottomAnchor).isActive = true
        
        leaveEarly.widthAnchor.constraint(equalToConstant: leaveEarlyWidth!).isActive = true
        leaveEarly.leftAnchor.constraint(equalTo: thirdStackView.leftAnchor).isActive = true
        leaveEarly.topAnchor.constraint(equalTo: thirdStackView.topAnchor).isActive = true
        leaveEarly.bottomAnchor.constraint(equalTo: thirdStackView.bottomAnchor).isActive = true
        
        wrongLocation.rightAnchor.constraint(equalTo: thirdStackView.rightAnchor).isActive = true
        wrongLocation.widthAnchor.constraint(equalToConstant: wrongLocationWidth!).isActive = true
        wrongLocation.topAnchor.constraint(equalTo: thirdStackView.topAnchor).isActive = true
        wrongLocation.bottomAnchor.constraint(equalTo: thirdStackView.bottomAnchor).isActive = true
        
        carTowed.widthAnchor.constraint(equalToConstant: carTowedWidth!).isActive = true
        carTowed.leftAnchor.constraint(equalTo: fourthStackView.leftAnchor).isActive = true
        carTowed.topAnchor.constraint(equalTo: fourthStackView.topAnchor).isActive = true
        carTowed.bottomAnchor.constraint(equalTo: fourthStackView.bottomAnchor).isActive = true
        
        damagedCar.rightAnchor.constraint(equalTo: fourthStackView.rightAnchor).isActive = true
        damagedCar.widthAnchor.constraint(equalToConstant: damagedCarWidth!).isActive = true
        damagedCar.topAnchor.constraint(equalTo: fourthStackView.topAnchor).isActive = true
        damagedCar.bottomAnchor.constraint(equalTo: fourthStackView.bottomAnchor).isActive = true
        
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
            if sender == self.spotTaken {
                self.delegate?.setTextField(message: "The spot I purchased is currently taken")
            } else if sender == self.cantFind {
                self.delegate?.setTextField(message: "I cannot find the parking spot")
            } else if sender == self.pictureNotShowing {
                self.delegate?.setTextField(message: "Your spot's picture does not clearly show the space")
            } else if sender == self.incorrectTime {
                self.delegate?.setTextField(message: "I need to purchase more time")
            } else if sender == self.leaveEarly {
                self.delegate?.setTextField(message: "I have to leave the space early")
            } else if sender == self.wrongLocation {
                self.delegate?.setTextField(message: "This space's address was incorrect")
            } else if sender == self.carTowed {
                self.delegate?.setTextField(message: "My car was towed while parking in your spot")
            } else if sender == self.damagedCar {
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
