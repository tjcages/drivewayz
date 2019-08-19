//
//  MessageOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/12/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class MessageOptionsViewController: UIViewController {
    
    var userId: String = ""
    var delegate: handSendButton?
    
    var spotTaken: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Spot is taken", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = Fonts.SSPLightH5
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
        button.titleLabel?.font = Fonts.SSPLightH5
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
        button.titleLabel?.font = Fonts.SSPLightH5
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
        button.titleLabel?.font = Fonts.SSPLightH5
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
        button.titleLabel?.font = Fonts.SSPLightH5
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
        button.titleLabel?.font = Fonts.SSPLightH5
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
        button.titleLabel?.font = Fonts.SSPLightH5
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
        button.titleLabel?.font = Fonts.SSPLightH5
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var needRefund: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Need a refund", for: .normal)
        button.backgroundColor = Theme.WHITE
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.layer.borderColor = Theme.BLACK.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = Fonts.SSPLightH5
        button.tag = 0
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var extraOptions: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Not what you're looking for?", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(sendDifferentOptions(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var sendCommunications: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ask for open communications", for: .normal)
        button.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.7)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = Fonts.SSPLightH5
        
        return button
    }()
    
    var sendCommunicationsTargetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openCommunicationsSender(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPLightH5
        label.textAlignment = .center
        label.text = "In order to speak freely with the host you must first ask their permission for open communications."
        label.numberOfLines = 3
        
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
        
        view.backgroundColor = Theme.DARK_GRAY
        
        spotTakenWidth = (spotTaken.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPLightH5))! + 20
        cantFindWidth = (cantFind.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPLightH5))! + 20
        pictureNotShowingWidth = (pictureNotShowing.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPLightH5))! + 20
        incorrectTimeWidth = (incorrectTime.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPLightH5))! + 20
        carTowedWidth = (carTowed.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPLightH5))! + 20
        damagedCarWidth = (damagedCar.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPLightH5))! + 20
        leaveEarlyWidth = (leaveEarly.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPLightH5))! + 20
        wrongLocationWidth = (wrongLocation.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPLightH5))! + 20
        
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
        scrollView.contentSize = CGSize(width: pictureNotShowingWidth! + incorrectTimeWidth! + carTowedWidth! + damagedCarWidth! + 48, height: self.view.frame.height)
        
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
        
        firstStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 22).isActive = true
        firstStackView.widthAnchor.constraint(equalToConstant: spotTakenWidth! + cantFindWidth! + 8).isActive = true
        firstStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        firstStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        secondStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        secondStackView.widthAnchor.constraint(equalToConstant: pictureNotShowingWidth! + incorrectTimeWidth! + 8).isActive = true
        secondStackView.topAnchor.constraint(equalTo: firstStackView.bottomAnchor, constant: 8).isActive = true
        secondStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        thirdStackView.leftAnchor.constraint(equalTo: firstStackView.rightAnchor, constant: 8).isActive = true
        thirdStackView.widthAnchor.constraint(equalToConstant: leaveEarlyWidth! + wrongLocationWidth! + 8).isActive = true
        thirdStackView.topAnchor.constraint(equalTo: firstStackView.topAnchor).isActive = true
        thirdStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        fourthStackView.leftAnchor.constraint(equalTo: secondStackView.rightAnchor, constant: 8).isActive = true
        fourthStackView.widthAnchor.constraint(equalToConstant: carTowedWidth! + damagedCarWidth! + 8).isActive = true
        fourthStackView.topAnchor.constraint(equalTo: secondStackView.topAnchor).isActive = true
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
        
        self.view.addSubview(extraOptions)
        extraOptions.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        extraOptions.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        extraOptions.topAnchor.constraint(equalTo: fourthStackView.bottomAnchor, constant: 8).isActive = true
        extraOptions.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(sendCommunications)
        sendCommunicationsAnchor = sendCommunications.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
            sendCommunicationsAnchor.isActive = true
        sendCommunicationsWidth = sendCommunications.widthAnchor.constraint(equalToConstant: 280)
            sendCommunicationsWidth.isActive = true
        sendCommunications.bottomAnchor.constraint(equalTo: extraOptions.topAnchor, constant: -15).isActive = true
        sendCommunications.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(sendCommunicationsTargetButton)
        sendCommunicationsTargetButton.leftAnchor.constraint(equalTo: sendCommunications.leftAnchor).isActive = true
        sendCommunicationsTargetButton.rightAnchor.constraint(equalTo: sendCommunications.rightAnchor).isActive = true
        sendCommunicationsTargetButton.topAnchor.constraint(equalTo: sendCommunications.topAnchor).isActive = true
        sendCommunicationsTargetButton.bottomAnchor.constraint(equalTo: sendCommunications.bottomAnchor).isActive = true
        
        self.view.addSubview(informationLabel)
        informationLabel.centerXAnchor.constraint(equalTo: sendCommunications.centerXAnchor).isActive = true
        informationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        informationLabel.bottomAnchor.constraint(equalTo: sendCommunications.topAnchor, constant: -8).isActive = true
        informationLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
    
    }
    
    @objc func sendDifferentOptions(sender: UIButton) {
        if extraOptions.titleLabel?.text == "Not what you're looking for?" {
            self.extraOptions.setTitle("Back to regular options", for: .normal)
            UIView.animate(withDuration: animationIn, animations: {
                self.spotTaken.alpha = 0
                self.cantFind.alpha = 0
                self.pictureNotShowing.alpha = 0
                self.incorrectTime.alpha = 0
                self.carTowed.alpha = 0
                self.damagedCar.alpha = 0
                self.leaveEarly.alpha = 0
                self.wrongLocation.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.sendCommunicationsAnchor.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            self.bringBackFirstOptions()
        }
    }
    
    func bringBackFirstOptions() {
        self.extraOptions.setTitle("Not what you're looking for?", for: .normal)
        UIView.animate(withDuration: animationIn, animations: {
            self.sendCommunicationsAnchor.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.spotTaken.alpha = 1
                self.cantFind.alpha = 1
                self.pictureNotShowing.alpha = 1
                self.incorrectTime.alpha = 1
                self.carTowed.alpha = 1
                self.damagedCar.alpha = 1
                self.leaveEarly.alpha = 1
                self.wrongLocation.alpha = 1
            })
        }
    }
    
    var lastButton: UIButton!
    
    @objc func optionsButtonPressed(sender: UIButton) {
        if sender.backgroundColor == Theme.WHITE {
            UIView.animate(withDuration: 0.1) {
                sender.backgroundColor = Theme.SEA_BLUE
                sender.setTitleColor(Theme.WHITE, for: .normal)
                sender.layer.borderColor = Theme.SEA_BLUE.cgColor
                sender.tag = 1
                if self.lastButton != nil {
                    self.lastButton.backgroundColor = Theme.WHITE
                    self.lastButton.setTitleColor(Theme.BLACK, for: .normal)
                    self.lastButton.layer.borderColor = Theme.BLACK.cgColor
                    self.lastButton.tag = 0
                }
                self.lastButton = sender
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
        if sender == self.spotTaken {
            self.delegate?.setMessage(message: "The spot I purchased is currently taken")
        } else if sender == self.cantFind {
            self.delegate?.setMessage(message: "I cannot find the parking spot")
        } else if sender == self.pictureNotShowing {
            self.delegate?.setMessage(message: "Your spot's picture does not clearly show the space")
        } else if sender == self.incorrectTime {
            self.delegate?.setMessage(message: "I need to purchase more time")
        } else if sender == self.leaveEarly {
            self.delegate?.setMessage(message: "I have to leave the space early")
        } else if sender == self.wrongLocation {
            self.delegate?.setMessage(message: "This space's address was incorrect")
        } else if sender == self.carTowed {
            self.delegate?.setMessage(message: "My car was towed while parking in your spot")
        } else if sender == self.damagedCar {
            self.delegate?.setMessage(message: "My car was damaged while parking in your spot")
        }
        if spotTaken.tag == 0, cantFind.tag == 0, pictureNotShowing.tag == 0, incorrectTime.tag == 0, carTowed.tag == 0, damagedCar.tag == 0, leaveEarly.tag == 0, wrongLocation.tag == 0 {
            self.delegate?.hideSendButton()
        } else {
            self.delegate?.bringSendButton()
        }
    }
    
    @objc func openCommunicationsSender(sender: UIButton) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUser)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let name = dictionary["name"] as? String {
                    var fullNameArr = name.split(separator: " ")
                    let firstName: String = String(fullNameArr[0])
                    let properties = ["text": "\(firstName) has requested open communications with you. Please allow or deny.", "communicationsStatus": "closed"] as [String : AnyObject]
                    self.sendMessageWithProperties(properties: properties)
                    UIView.animate(withDuration: 0.1) {
                        self.sendCommunications.setTitle("Pending...", for: .normal)
                        self.sendCommunications.backgroundColor = Theme.DARK_GRAY
                        self.sendCommunicationsWidth.constant = 180
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    private func sendMessageWithProperties(properties: [String: AnyObject]) {
        let ref = Database.database().reference()
        let toID = self.userId
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let childRef = ref.child("messages").childByAutoId()
        var values = ["toID": toID, "fromID": fromID, "timestamp": timestamp] as [String : Any]
        
        properties.forEach({values[$0] = $1})
        childRef.updateChildValues(values) { (error, ralf) in
            if error != nil {
                print(error ?? "")
                return
            }
            if let messageId = childRef.key {
                let vals = [messageId: 1] as [String: Int]
                
                let userMessagesRef = ref.child("user-messages").child(fromID).child(toID)
                userMessagesRef.updateChildValues(vals)
                
                let recipientUserMessagesRef = ref.child("user-messages").child(toID).child(fromID)
                recipientUserMessagesRef.updateChildValues(vals)
            }
        }
    }
    
    func resetOptions() {
        self.bringBackFirstOptions()
        UIView.animate(withDuration: 0.1) {
            if self.lastButton != nil {
                self.lastButton.backgroundColor = Theme.WHITE
                self.lastButton.setTitleColor(Theme.BLACK, for: .normal)
                self.lastButton.layer.borderColor = Theme.BLACK.cgColor
                self.lastButton.tag = 0
                self.lastButton = nil
            }
        }
    }
    
    func removeCommunicationsTarget() {
        self.sendCommunicationsTargetButton.alpha = 0
    }

}
