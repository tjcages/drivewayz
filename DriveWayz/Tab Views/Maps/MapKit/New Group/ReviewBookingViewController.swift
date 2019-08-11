//
//  ReviewBookingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/23/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos
import StoreKit

class ReviewBookingViewController: UIViewController {
    
    var delegate: handleMinimizingFullController?
    var selectedParking: String? {
        didSet {
            guard let parkingID = self.selectedParking else { return }
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let parking = ParkingSpots(dictionary: dictionary)
                    if let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType {
                        if let number = Int(numberSpots) {
                            let wordString = number.asWord
                            let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter())"
                            self.parkingSpotLabel.text = descriptionAddress
                            self.parkingSpotWidthAnchor.constant = descriptionAddress.width(withConstrainedHeight: 25, font: Fonts.SSPSemiBoldH4) + 16
                            self.view.layoutIfNeeded()
                        }
                        if let firstImage = parking.firstImage, firstImage != "" {
                            self.spotImageView.loadImageUsingCacheWithUrlString(firstImage) { (bool) in
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var spotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 70
        imageView.clipsToBounds = true
        
        return imageView
    }()

    var parkingSpotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        label.backgroundColor = Theme.GREEN_PIGMENT
        label.layer.cornerRadius = 18
        label.clipsToBounds = true
        label.textAlignment = .center
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 0
        view.settings.updateOnTouch = true
        view.settings.fillMode = StarFillMode.full
        view.settings.starSize = 36
        view.settings.starMargin = 6
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var leaveAReviewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Leave a review?", for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.setTitleColor(Theme.BLUE.withAlphaComponent(0.5), for: .highlighted)
        button.addTarget(self, action: #selector(leaveAReviewPressed), for: .touchUpInside)
        
        return button
    }()
    
    var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = Theme.BLUE
        button.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        button.alpha = 0.5
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var message: UITextView = {
        let field = UITextView()
        field.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        field.text = "Enter your review"
        field.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        field.font = Fonts.SSPRegularH4
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 4
        field.tintColor = Theme.PACIFIC_BLUE
        field.isScrollEnabled = false
        field.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
        field.keyboardAppearance = .dark
        field.alpha = 0
        
        return field
    }()
    
    var characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PACIFIC_BLUE
        label.font = Fonts.SSPRegularH5
        label.text = "0/160"
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    var whatHappenedLabel: UILabel = {
        let label = UILabel()
        label.text = "What happened?"
        label.textColor = Theme.BLUE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Please let us know where we can improve in the future"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH4
        label.numberOfLines = 2
        
        return label
    }()

    var informationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("The spot information was incorrect", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandInformationButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var appButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("The app did not work", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandAppButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var refundButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("I need a refund", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandRefundButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var otherButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Other", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        return button
    }()
    
    var expandOtherButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.HARMONY_RED, for: .normal)
        button.setTitleColor(Theme.HARMONY_RED.withAlphaComponent(0.5), for: .highlighted)
        button.alpha = 0
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        button.addSubview(view)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        message.delegate = self
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4

        setupViews()
        setupInfo()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var containerTopAnchor: NSLayoutConstraint!
    var leaveAReviewAnchor: NSLayoutConstraint!
    var regularReviewAnchor: NSLayoutConstraint!
    var regularDoneButtonAnchor: NSLayoutConstraint!
    var hideDoneButtonAnchor: NSLayoutConstraint!
    
    var parkingSpotWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerTopAnchor = container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            containerTopAnchor.isActive = true
        container.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 380)
            containerHeightAnchor.isActive = true
        
        container.addSubview(spotImageView)
        regularReviewAnchor = spotImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32)
            regularReviewAnchor.isActive = true
        leaveAReviewAnchor = spotImageView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -18)
            leaveAReviewAnchor.isActive = false
        spotImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        spotImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        spotImageView.heightAnchor.constraint(equalTo: spotImageView.widthAnchor).isActive = true
        
        container.addSubview(parkingSpotLabel)
        parkingSpotLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        parkingSpotLabel.centerYAnchor.constraint(equalTo: spotImageView.bottomAnchor).isActive = true
        parkingSpotWidthAnchor = parkingSpotLabel.widthAnchor.constraint(equalToConstant: (parkingSpotLabel.text?.width(withConstrainedHeight: 25, font: Fonts.SSPSemiBoldH4))! + 24)
            parkingSpotWidthAnchor.isActive = true
        parkingSpotLabel.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor, constant: -60).isActive = true
        parkingSpotLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        container.addSubview(stars)
        stars.didFinishTouchingCosmos = {rating in self.setRating()}
        stars.topAnchor.constraint(equalTo: parkingSpotLabel.bottomAnchor, constant: 32).isActive = true
        stars.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        stars.sizeToFit()
        
        container.addSubview(leaveAReviewButton)
        leaveAReviewButton.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 8).isActive = true
        leaveAReviewButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        leaveAReviewButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        leaveAReviewButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        container.addSubview(doneButton)
        regularDoneButtonAnchor = doneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            regularDoneButtonAnchor.isActive = true
        hideDoneButtonAnchor = doneButton.bottomAnchor.constraint(equalTo: container.topAnchor)
            hideDoneButtonAnchor.isActive = false
        doneButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        doneButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        container.addSubview(message)
        message.topAnchor.constraint(equalTo: leaveAReviewButton.topAnchor, constant: 24).isActive = true
        message.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        message.widthAnchor.constraint(equalTo: container.widthAnchor, constant: -24).isActive = true
        message.heightAnchor.constraint(equalToConstant: 138).isActive = true
        
        container.addSubview(characterLabel)
        characterLabel.rightAnchor.constraint(equalTo: message.rightAnchor, constant: -2).isActive = true
        characterLabel.leftAnchor.constraint(equalTo: message.leftAnchor).isActive = true
        characterLabel.bottomAnchor.constraint(equalTo: message.topAnchor, constant: -2).isActive = true
        characterLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    }
    
    func setupInfo() {
        
        container.addSubview(whatHappenedLabel)
        whatHappenedLabel.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 32).isActive = true
        whatHappenedLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        whatHappenedLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        whatHappenedLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: whatHappenedLabel.bottomAnchor, constant: 2).isActive = true
        infoLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        infoLabel.sizeToFit()
        
        container.addSubview(informationButton)
        informationButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12).isActive = true
        informationButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        informationButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        informationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandInformationButton)
        expandInformationButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        expandInformationButton.centerYAnchor.constraint(equalTo: informationButton.centerYAnchor).isActive = true
        expandInformationButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandInformationButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(appButton)
        appButton.topAnchor.constraint(equalTo: informationButton.bottomAnchor).isActive = true
        appButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        appButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        appButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandAppButton)
        expandAppButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        expandAppButton.centerYAnchor.constraint(equalTo: appButton.centerYAnchor).isActive = true
        expandAppButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandAppButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(refundButton)
        refundButton.topAnchor.constraint(equalTo: appButton.bottomAnchor).isActive = true
        refundButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        refundButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        refundButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandRefundButton)
        expandRefundButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        expandRefundButton.centerYAnchor.constraint(equalTo: refundButton.centerYAnchor).isActive = true
        expandRefundButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandRefundButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(otherButton)
        otherButton.topAnchor.constraint(equalTo: refundButton.bottomAnchor).isActive = true
        otherButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        otherButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        otherButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(expandOtherButton)
        expandOtherButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24).isActive = true
        expandOtherButton.centerYAnchor.constraint(equalTo: otherButton.centerYAnchor).isActive = true
        expandOtherButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandOtherButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(cancelButton)
        cancelButton.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
    }

    func setRating() {
        self.doneButton.alpha = 1
        self.doneButton.isUserInteractionEnabled = true
    }
    
    @objc func leaveAReviewPressed() {
        self.leaveAReviewAnchor.isActive = true
        self.regularReviewAnchor.isActive = false
        self.containerHeightAnchor.constant = 320
        self.containerTopAnchor.constant = -88
        UIView.animate(withDuration: animationIn, animations: {
            self.spotImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.leaveAReviewButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.message.becomeFirstResponder()
            UIView.animate(withDuration: animationIn, animations: {
                self.message.alpha = 1
                self.characterLabel.alpha = 1
            })
        }
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
        if stars.rating >= 4 {
            self.removeReview(close: true)
            delayWithSeconds(animationIn) {
                let appStoreReview = UserDefaults.standard.bool(forKey: "AppStoreReview")
                if appStoreReview == false {
                    if #available( iOS 10.3,*){
                        SKStoreReviewController.requestReview()
                        UserDefaults.standard.set(true, forKey: "AppStoreReview")
                    }
                }
            }
        } else if stars.rating <= 2  && stars.rating >= 0 {
            self.removeReview(close: false)
            self.getInformationReview()
        } else {
            self.removeReview(close: true)
            self.restartReview()
        }
    }
    
    func removeReview(close: Bool) {
        self.doneButton.alpha = 0.5
        self.doneButton.isUserInteractionEnabled = false
        guard var message = self.message.text, let parkingID = selectedParking else { return }
        if message == "Enter your review" { message = "" }
        if close == true {
            self.delegate?.reviewOptionsDismissed()
        }
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                guard let name = dictionary["name"] as? String else { return }
                let timestamp = Date().timeIntervalSince1970
                let messageRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Reviews").childByAutoId()
                messageRef.updateChildValues(["name": name, "driverID": userID, "parkingID": parkingID, "timestamp": timestamp, "message": message, "rating": self.stars.rating])
                let hostRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                hostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        if let totalRating = dictionary["totalRating"] as? Double {
                            hostRef.updateChildValues(["totalRating": self.stars.rating + totalRating])
                        } else {
                            hostRef.updateChildValues(["totalRating": self.stars.rating])
                        }
                        self.message.text = ""
                        self.doneButton.alpha = 1.0
                        self.doneButton.isUserInteractionEnabled = true
                        
                        if let parkingUserID = dictionary["id"] as? String {
                            let nameArray = name.split(separator: " ")
                            if let firstName = nameArray.first {
                                var title = ""
                                var subtitle = ""
                                let rating = String(format:"%.0f", self.stars.rating)
                                if self.stars.rating >= 4.0 {
                                    title = "Congratulations!"
                                    subtitle = "You got a \(rating) star rating from \(String(firstName))"
                                    let notificationRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Notifications").childByAutoId()
                                    notificationRef.updateChildValues(["image": "leftReviewGood", "title": title, "subtitle": subtitle, "timestamp": Date().timeIntervalSince1970])
                                } else if self.stars.rating <= 2.0 {
                                    title = "\(String(firstName)) gave you a \(rating) star rating"
                                    subtitle = "We will reach out to see why"
                                    let notificationRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Notifications").childByAutoId()
                                    notificationRef.updateChildValues(["image": "leftReviewPoor", "title": title, "subtitle": subtitle, "timestamp": Date().timeIntervalSince1970])
                                } else {
                                    title = "\(String(firstName)) gave you a \(rating) star rating"
                                    subtitle = "We will reach out if this continues"
                                    let notificationRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("Notifications").childByAutoId()
                                    notificationRef.updateChildValues(["image": "leftReviewPoor", "title": title, "subtitle": subtitle, "timestamp": Date().timeIntervalSince1970])
                                }
                                let sender = PushNotificationSender()
                                sender.sendPushNotification(toUser: parkingUserID, title: title, subtitle: subtitle)
                            }
                        }
                    }
                })
            }
        }
    }
    
    @objc func cancelButtonPressed() {
        self.delegate?.reviewOptionsDismissed()
    }
    
    func getInformationReview() {
        self.hideDoneButtonAnchor.isActive = true
        self.regularDoneButtonAnchor.isActive = false
        self.leaveAReviewAnchor.isActive = true
        self.regularReviewAnchor.isActive = false
        self.containerHeightAnchor.constant = 388
        self.containerTopAnchor.constant = 0
        UIView.animate(withDuration: animationIn, animations: {
            self.message.alpha = 0
            self.characterLabel.alpha = 0
            self.stars.alpha = 0
            self.leaveAReviewButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.cancelButton.alpha = 1
            })
        }
    }
    
    @objc func restartReview() {
        self.leaveAReviewAnchor.isActive = false
        self.regularReviewAnchor.isActive = true
        self.hideDoneButtonAnchor.isActive = false
        self.regularDoneButtonAnchor.isActive = true
        self.containerHeightAnchor.constant = 380
        self.containerTopAnchor.constant = 0
        UIView.animate(withDuration: animationIn, animations: {
            self.stars.alpha = 1
            self.message.alpha = 0
            self.characterLabel.alpha = 0
            self.cancelButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.spotImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.leaveAReviewButton.alpha = 1
            })
        }
    }
    
}


extension ReviewBookingViewController: UITextViewDelegate {
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.message.text == "Enter your review" {
            self.message.text = ""
            self.message.textColor = Theme.BLACK
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.message.text == "" {
            self.message.text = "Enter your review"
            self.message.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text?.count)! + text.count - range.length
        if (newLength <= 160) {
            self.characterLabel.textColor = Theme.PACIFIC_BLUE
            self.characterLabel.text = "\(newLength)/160"
            return true
        } else {
            self.characterLabel.textColor = Theme.HARMONY_RED
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
