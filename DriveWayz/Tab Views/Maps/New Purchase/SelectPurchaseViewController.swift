//
//  SelectPurchaseViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import UserNotifications
import Alamofire
import GooglePlaces

protocol handleReservations {
    func reserveCheckPressed(from: String, to: String, hour: Double, fromTimestamp: Date, toTimestamp: Date)
    func hideParkNow()
    func bringParkNow()
}

class SelectPurchaseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, STPPaymentContextDelegate, UNUserNotificationCenterDelegate, handleReservations {
    
    var parkingCost: String?
    var delegate: controlHoursButton?
    var saveDelegate: controlSaveLocation?
    var fromDateTimestampValue: Date?
    var toDateTimestampValue: Date?
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
//        view.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()
    
    var segmentControlView: UIView = {
        let segmentControlView = UIView()
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.backgroundColor = UIColor.clear
        
        return segmentControlView
    }()
    
    var currentSegment: UIButton = {
        let info = UIButton()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = UIColor.clear
        info.setTitle("Park now", for: .normal)
        info.titleLabel?.font = Fonts.SSPSemiBoldH2
        info.setTitleColor(Theme.BLACK, for: .normal)
        info.titleLabel?.textAlignment = .center
        info.addTarget(self, action: #selector(currentPressed(sender:)), for: .touchUpInside)
        
        return info
    }()
    
    var reserveSegment: UIButton = {
        let availability = UIButton()
        availability.translatesAutoresizingMaskIntoConstraints = false
        availability.backgroundColor = UIColor.clear
        availability.setTitle("Reserve", for: .normal)
        availability.titleLabel?.font = Fonts.SSPLightH2
        availability.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.4), for: .normal)
        availability.titleLabel?.textAlignment = .center
        availability.addTarget(self, action: #selector(reservePressed(sender:)), for: .touchUpInside)
        
        return availability
    }()
    
    var selectionLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.PACIFIC_BLUE
        
        return line
    }()
    
    lazy var reserveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Book Spot", for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH3
        button.backgroundColor = Theme.SEA_BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.addTarget(self, action: #selector(handleRequestRideButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Payment", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentMode = .center
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH5
        button.addTarget(self, action: #selector(handlePaymentButtonTapped), for: .touchUpInside)

        return button
    }()
    
    var costButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.SEA_BLUE.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        
        return button
    }()

    var hoursButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitle("1 hour", for: .normal)
        button.setImage(UIImage(named: "hourParkingIcon"), for: .normal)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.addTarget(self, action: #selector(hourButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.SEA_BLUE
        label.backgroundColor = UIColor.clear
        label.font = Fonts.SSPSemiBoldH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "8:00 am"
        label.alpha = 0
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.5)
        label.backgroundColor = UIColor.clear
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "to"
        label.alpha = 0
        
        return label
    }()
    
    var timeToPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.SEA_BLUE
        picker.frame = CGRect(x: 0, y: 0, width: 400, height: 380)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(Theme.SEA_BLUE, forKeyPath: "textColor")
        picker.alpha = 0
        
        return picker
    }()
    
    var line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return line
    }()
    
    var line2: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        line.alpha = 0
        
        return line
    }()
    
    lazy var reserveController: ReserveViewController = {
        let controller = ReserveViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Reserve"
        controller.view.layer.cornerRadius = 5
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    var reserveFromLabel: UIButton = {
        let button = UIButton()
        button.setTitle("8:00 am Wednesday 08", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentMode = .center
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH3
        button.titleLabel?.numberOfLines = 2
        button.alpha = 0
        button.addTarget(self, action: #selector(reservePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var reserveToLabel: UIButton = {
        let button = UIButton()
        button.setTitle("9:00 am Thursday 09", for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentMode = .center
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH3
        button.titleLabel?.numberOfLines = 2
        button.alpha = 0
        button.addTarget(self, action: #selector(reservePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var reserveCostLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.SEA_BLUE.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.alpha = 0
        
        return button
    }()
    
    var toReserveLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.5)
        label.backgroundColor = UIColor.clear
        label.font = Fonts.SSPLightH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "to"
        label.alpha = 0
        
        return label
    }()
    
    let exitButton: UIButton = {
        let exitButton = UIButton()
        let image = UIImage(named: "Expand")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        exitButton.setImage(tintedImage, for: .normal)
        exitButton.tintColor = Theme.BLACK
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitHoursButton(sender:)), for: .touchUpInside)
        exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        exitButton.alpha = 0
        
        return exitButton
    }()
    
    var slideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.alpha = 0.9
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var couponStaus: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("", for: .normal)
        view.titleLabel?.textColor = Theme.WHITE
        view.titleLabel?.font = Fonts.SSPSemiBoldH5
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.numberOfLines = 2
        view.backgroundColor = Theme.HARMONY_RED.withAlphaComponent(0.6)
        view.alpha = 0
        view.layer.cornerRadius = 5
        view.isUserInteractionEnabled = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeToPicker.delegate = self
        self.timeToPicker.dataSource = self
        
        let red: CGFloat = 0
        self.activityIndicator.style = red < 0.5 ? .white : .gray
        self.activityIndicator.alpha = 0
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(reserveSwiped(sender:)))
        leftGesture.direction = .left
        viewContainer.addGestureRecognizer(leftGesture)
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(currentSwiped(sender:)))
        rightGesture.direction = .right
        viewContainer.addGestureRecognizer(rightGesture)
        
        setupViews()
        setupExtraViews()
        setTimes()
        checkForCoupons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.didMove(toParent: self)
    }
    
    func setAvailability(available: Bool) {
        if available == true {
            self.unavailable.alpha = 0
        } else {
            self.unavailable.alpha = 1
        }
    }
    
    func setData(parkingCost: String, parkingID: String, id: String) {
        self.parkingCost = parkingCost
        self.costButton.setTitle(parkingCost, for: .normal)
        self.costButton.setTitle(parkingCost, for: .highlighted)
        self.reserveCostLabel.setTitle(parkingCost, for: .normal)
        self.reserveCostLabel.setTitle(parkingCost, for: .highlighted)
        self.reserveController.setData(parkingID: parkingID)
        
        let noHour = parkingCost.replacingOccurrences(of: "/hour", with: "", options: .regularExpression, range: nil)
        let noDollar = noHour.replacingOccurrences(of: "[$]", with: "", options: .regularExpression, range: nil)
        self.price = Double(noDollar.replacingOccurrences(of: "[.]", with: "", options: .regularExpression, range: nil))!
        
        self.id = id
        self.parkingId = parkingID
        self.cost = Double(noDollar)!
    }
    
    var currentSegmentAnchor: NSLayoutConstraint!
    var reserveSegmentAnchor: NSLayoutConstraint!
    var viewContainerHeightAnchor: NSLayoutConstraint!
    var reserveWidthAnchor: NSLayoutConstraint!
    var costButtonHeightAnchor: NSLayoutConstraint!
    var reserveCostButtonHeightAnchor: NSLayoutConstraint!
    var exitButtonHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(viewContainer)
        viewContainerHeightAnchor = viewContainer.heightAnchor.constraint(equalToConstant: 220)
            viewContainerHeightAnchor.isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        viewContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(slideView)
        slideView.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        slideView.bottomAnchor.constraint(equalTo: viewContainer.topAnchor, constant: -8).isActive = true
        slideView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        slideView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(segmentControlView)
        segmentControlView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 5).isActive = true
        segmentControlView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor).isActive = true
        segmentControlView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor).isActive = true
        segmentControlView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        segmentControlView.addSubview(currentSegment)
        currentSegment.leftAnchor.constraint(equalTo: segmentControlView.leftAnchor).isActive = true
        currentSegment.rightAnchor.constraint(equalTo: segmentControlView.centerXAnchor, constant: 20).isActive = true
        currentSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        
        segmentControlView.addSubview(reserveSegment)
        reserveSegment.rightAnchor.constraint(equalTo: segmentControlView.rightAnchor).isActive = true
        reserveSegment.leftAnchor.constraint(equalTo: segmentControlView.centerXAnchor, constant: -20).isActive = true
        reserveSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reserveSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionLine.topAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: self.view.frame.width / 4 + 20).isActive = true
        currentSegmentAnchor = selectionLine.centerXAnchor.constraint(equalTo: currentSegment.centerXAnchor)
            currentSegmentAnchor.isActive = true
        reserveSegmentAnchor = selectionLine.centerXAnchor.constraint(equalTo: reserveSegment.centerXAnchor)
            reserveSegmentAnchor.isActive = false
        
        self.view.addSubview(reserveButton)
        reserveButton.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -24).isActive = true
        reserveButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 12).isActive = true
        reserveWidthAnchor = reserveButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -72)
            reserveWidthAnchor.isActive = true
        reserveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.bottomAnchor.constraint(equalTo: reserveButton.topAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        paymentButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 12).isActive = true
        paymentButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        self.view.addSubview(costButton)
        costButtonHeightAnchor = costButton.bottomAnchor.constraint(equalTo: reserveButton.topAnchor, constant: -40)
            costButtonHeightAnchor.isActive = true
        costButton.widthAnchor.constraint(equalTo: viewContainer.widthAnchor, constant: -200).isActive = true
        costButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        costButton.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        
        self.view.addSubview(hoursButton)
        hoursButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -8).isActive = true
        hoursButton.heightAnchor.constraint(equalTo: reserveButton.heightAnchor).isActive = true
        hoursButton.widthAnchor.constraint(equalTo: hoursButton.heightAnchor).isActive = true
        hoursButton.centerYAnchor.constraint(equalTo: reserveButton.centerYAnchor).isActive = true
        
        self.view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -5).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -25).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line2.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
        line2.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        
        self.view.addSubview(toReserveLabel)
        toReserveLabel.bottomAnchor.constraint(equalTo: reserveButton.topAnchor, constant: -10).isActive = true
        toReserveLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toReserveLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        toReserveLabel.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        
        self.view.addSubview(reserveToLabel)
        reserveToLabel.bottomAnchor.constraint(equalTo: reserveButton.topAnchor, constant: -10).isActive = true
        reserveToLabel.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3 - 20).isActive = true
        reserveToLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reserveToLabel.leftAnchor.constraint(equalTo: toReserveLabel.rightAnchor, constant: 10).isActive = true
        
        self.view.addSubview(reserveFromLabel)
        reserveFromLabel.bottomAnchor.constraint(equalTo: reserveButton.topAnchor, constant: -10).isActive = true
        reserveFromLabel.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3 - 20).isActive = true
        reserveFromLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reserveFromLabel.rightAnchor.constraint(equalTo: toReserveLabel.leftAnchor, constant: -10).isActive = true
        
        self.view.addSubview(reserveCostLabel)
        reserveCostButtonHeightAnchor = reserveCostLabel.bottomAnchor.constraint(equalTo: reserveButton.topAnchor, constant: -60)
            reserveCostButtonHeightAnchor.isActive = true
        reserveCostLabel.widthAnchor.constraint(equalTo: viewContainer.widthAnchor, constant: -200).isActive = true
        reserveCostLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reserveCostLabel.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        
        self.view.addSubview(toLabel)
        toLabel.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: -40).isActive = true
        
        self.view.addSubview(currentTimeLabel)
        currentTimeLabel.rightAnchor.constraint(equalTo: toLabel.leftAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currentTimeLabel.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor).isActive = true
        
        self.view.addSubview(timeToPicker)
        timeToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        timeToPicker.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor).isActive = true
        timeToPicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeToPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(reserveController.view)
        self.addChild(reserveController)
        reserveController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reserveController.view.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
        reserveController.view.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 45).isActive = true
        reserveController.view.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 12).isActive = true
        exitButtonHeightAnchor = exitButton.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor)
            exitButtonHeightAnchor.isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(couponStaus)
        couponStaus.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10).isActive = true
        couponStaus.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 50).isActive = true
        couponStaus.widthAnchor.constraint(equalToConstant: 80).isActive = true
        couponStaus.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func currentPressed(sender: UIButton) {
        currentSender()
    }
    
    @objc func currentSwiped(sender: UISwipeGestureRecognizer) {
        if self.currentSegment.alpha == 1 {
            currentSender()
        }
    }
    
    func currentSender() {
        self.minimizeHours()
        self.reserveSegmentAnchor.isActive = false
        self.currentSegmentAnchor.isActive = true
        self.currentSegment.titleLabel?.font = Fonts.SSPSemiBoldH4
        self.currentSegment.setTitleColor(Theme.BLACK, for: .normal)
        self.reserveSegment.titleLabel?.font = Fonts.SSPLightH4
        self.reserveSegment.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.5), for: .normal)
        UIView.animate(withDuration: animationIn, animations: {
            self.reserveController.view.alpha = 0
            self.toReserveLabel.alpha = 0
            self.reserveToLabel.alpha = 0
            self.reserveFromLabel.alpha = 0
            self.reserveCostLabel.alpha = 0
            self.line2.alpha = 0
            self.reserveButton.alpha = 1
            self.reserveButton.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.viewContainerHeightAnchor.constant = 220
                self.reserveWidthAnchor.constant = -72
                self.paymentButton.alpha = 1
                self.costButton.alpha = 1
                self.hoursButton.alpha = 1
                self.line.alpha = 1
                self.view.layoutIfNeeded()
            })
            self.reserveButton.setTitle("Book Spot", for: .normal)
        }
        if self.isCouponActive == true {
            self.couponStaus.alpha = 0.8
        } else {
            self.couponStaus.alpha = 0
        }
    }

    @objc func reservePressed(sender: UIButton) {
        self.reserveSender()
    }
    
    @objc func reserveSwiped(sender: UISwipeGestureRecognizer) {
        if self.reserveSegment.alpha == 1 {
            self.reserveSender()
        }
    }
    
    func reserveSender() {
        self.expandHours()
        self.currentSegmentAnchor.isActive = false
        self.reserveSegmentAnchor.isActive = true
        self.reserveSegment.titleLabel?.font = Fonts.SSPSemiBoldH4
        self.reserveSegment.setTitleColor(Theme.BLACK, for: .normal)
        self.currentSegment.titleLabel?.font = Fonts.SSPLightH4
        self.currentSegment.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.5), for: .normal)
        self.currentSegment.isUserInteractionEnabled = true
        UIView.animate(withDuration: animationIn, animations: {
            self.paymentButton.alpha = 0
            self.costButton.alpha = 0
            self.hoursButton.alpha = 0
            self.line.alpha = 0
            self.line2.alpha = 0
            self.toReserveLabel.alpha = 0
            self.reserveToLabel.alpha = 0
            self.reserveFromLabel.alpha = 0
            self.reserveCostLabel.alpha = 0
            self.couponStaus.alpha = 0
            self.reserveButton.alpha = 0.6
            //            self.currentSegment.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.reserveCostButtonHeightAnchor.constant = -60
                self.viewContainerHeightAnchor.constant = 340
                self.reserveWidthAnchor.constant = -12
                self.view.layoutIfNeeded()
            }) { (success) in
                self.reserveButton.setTitle("Reserve Spot", for: .normal)
                UIView.animate(withDuration: animationIn, animations: {
                    self.reserveController.view.alpha = 1
                })
            }
        }
    }
    
    func reserveCheckPressed(from: String, to: String, hour: Double, fromTimestamp: Date, toTimestamp: Date) {
        self.fromDateTimestampValue = fromTimestamp
        self.toDateTimestampValue = toTimestamp
        self.minimizeHours()
        self.reserveFromLabel.setTitle(from, for: .normal)
        self.reserveToLabel.setTitle(to, for: .normal)
        
        let costString = self.parkingCost?.replacingOccurrences(of: "$", with: "")
        let cost = Double(costString!.replacingOccurrences(of: "/hour", with: ""))
        
        let payment = cost! * hour
        self.hours = Int(hour)
        self.cost = payment
        let paymentString = String(format: "$%.2f", payment)
        self.reserveCostLabel.setTitle(paymentString, for: .normal)
        
        self.currentSegmentAnchor.isActive = false
        self.reserveSegmentAnchor.isActive = true
        self.currentSegment.isUserInteractionEnabled = true
        UIView.animate(withDuration: animationIn, animations: {
            self.paymentButton.alpha = 0
            self.costButton.alpha = 0
            self.hoursButton.alpha = 0
            self.line.alpha = 0
            self.reserveController.view.alpha = 0
            self.exitButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.viewContainerHeightAnchor.constant = 220
            self.reserveCostButtonHeightAnchor.constant = -60
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationIn, animations: {
                    self.toReserveLabel.alpha = 1
                    self.reserveToLabel.alpha = 1
                    self.reserveFromLabel.alpha = 1
                    self.reserveCostLabel.alpha = 1
                    self.line2.alpha = 1
                    self.reserveButton.alpha = 1
                    self.reserveButton.isUserInteractionEnabled = true
                    self.view.layoutIfNeeded()
                })
            }
        }
        if self.isCouponActive == true {
            self.couponStaus.alpha = 0.8
        } else {
            self.couponStaus.alpha = 0
        }
    }
    
    @objc func hourButtonPressed(sender: UIButton) {
        viewContainerHeightAnchor.constant = 220
        self.currentSegment.isUserInteractionEnabled = false
        self.setTimes()
        UIView.animate(withDuration: animationIn, animations: {
            self.hoursButton.alpha = 0
            self.costButton.alpha = 0
            self.reserveSegment.alpha = 0
            self.couponStaus.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.reserveWidthAnchor.constant = -12
                self.toLabel.alpha = 1
                self.timeToPicker.alpha = 1
                self.currentTimeLabel.alpha = 1
                self.exitButton.alpha = 1
                self.reserveButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.reserveButton.removeTarget(self, action: #selector(self.bringBackReserve(sender:)), for: .touchUpInside)
                self.reserveButton.removeTarget(self, action: #selector(self.handleConfirmRideButtonTapped), for: .touchUpInside)
                self.reserveButton.addTarget(self, action: #selector(self.checkButtonPressed(sender:)), for: .touchUpInside)
                self.reserveButton.setTitle("Select hours", for: .normal)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func exitHoursButton(sender: UIButton) {
        self.viewContainerHeightAnchor.constant = 220
        self.reserveSegmentAnchor.isActive = false
        self.currentSegmentAnchor.isActive = true
        self.currentSegment.titleLabel?.font = Fonts.SSPSemiBoldH4
        self.currentSegment.setTitleColor(Theme.BLACK, for: .normal)
        self.reserveSegment.titleLabel?.font = Fonts.SSPLightH4
        self.reserveSegment.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.5), for: .normal)
        UIView.animate(withDuration: animationIn, animations: {
            self.costButtonHeightAnchor.constant = -40
            self.toLabel.alpha = 0
            self.timeToPicker.alpha = 0
            self.currentTimeLabel.alpha = 0
            self.exitButton.alpha = 0
            self.line2.alpha = 0
            self.reserveCostLabel.alpha = 0
            self.costButton.alpha = 1
            self.reserveSegment.alpha = 1
            self.reserveButton.alpha = 1
            self.line.alpha = 1
            self.paymentButton.alpha = 1
            self.reserveButton.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.reserveWidthAnchor.constant = -72
                self.viewContainerHeightAnchor.constant = 220
                self.exitButtonHeightAnchor.constant = 0
                self.hoursButton.alpha = 1
                self.reserveButton.backgroundColor = Theme.SEA_BLUE
                self.view.layoutIfNeeded()
            })
            self.reserveButton.setTitle("Book Spot", for: .normal)
            self.reserveButton.removeTarget(self, action: #selector(self.checkButtonPressed(sender:)), for: .touchUpInside)
            self.reserveButton.addTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
            if self.isCouponActive == true {
                self.couponStaus.alpha = 0.8
            } else {
                self.couponStaus.alpha = 0
            }
        }
    }
    
    @objc func checkButtonPressed(sender: UIButton) {
        viewContainerHeightAnchor.constant = 220
        UIView.animate(withDuration: animationIn, animations: {
            self.toLabel.alpha = 0
            self.timeToPicker.alpha = 0
            self.currentTimeLabel.alpha = 0
            self.exitButton.alpha = 0
//            self.checkButton.alpha = 0
            self.costButton.alpha = 1
            self.reserveSegment.alpha = 1
            self.reserveButton.alpha = 1
            self.reserveButton.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.reserveWidthAnchor.constant = -72
                self.hoursButton.alpha = 1
                self.reserveButton.backgroundColor = Theme.SEA_BLUE
                self.view.layoutIfNeeded()
            })
            let costString = self.parkingCost?.replacingOccurrences(of: "$", with: "")
            let cost = Double(costString!.replacingOccurrences(of: "/hour", with: ""))
            let hoursString = self.hoursButton.titleLabel?.text?.replacingOccurrences(of: " hours", with: "")
            let hour = Double(hoursString!.replacingOccurrences(of: " hour", with: ""))
            
            let payment = cost! * hour!
            self.hours = Int(hour!)
            self.cost = payment
            let paymentString = String(format: "$%.2f", payment)
            self.costButton.setTitle(paymentString, for: .normal)
            
            self.reserveButton.removeTarget(self, action: #selector(self.checkButtonPressed(sender:)), for: .touchUpInside)
            self.reserveButton.addTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
            if self.hours > 1 {
                self.reserveButton.setTitle("Book Spot for \(self.hours) hours", for: .normal)
            } else {
                self.reserveButton.setTitle("Book Spot for 1 hour", for: .normal)
            }
            self.view.layoutIfNeeded()
        }
        if self.isCouponActive == true {
            self.couponStaus.alpha = 0.8
        } else {
            self.couponStaus.alpha = 0
        }
    }
    
    func resetReservationButton() {
        self.reserveButton.backgroundColor = Theme.SEA_BLUE
        self.reserveButton.setTitle("Book Spot", for: .normal)
        self.costButtonHeightAnchor.constant = -40
        self.exitButton.alpha = 0
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0
        self.currentSegment.alpha = 1
        self.line2.alpha = 0
        self.view.layoutIfNeeded()
        self.currentSender()
        if self.isCouponActive == true {
            self.couponStaus.alpha = 0.8
        } else {
            self.couponStaus.alpha = 0
        }
        self.reserveButton.removeTarget(self, action: #selector(self.handleConfirmRideButtonTapped), for: .touchUpInside)
        self.reserveButton.addTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
    }
    
    func checkButtonSender() {
        UIView.animate(withDuration: animationIn) {
            self.toLabel.alpha = 0
            self.timeToPicker.alpha = 0
            self.currentTimeLabel.alpha = 0
//            self.checkButton.alpha = 0
            self.reserveSegment.alpha = 1
            self.reserveButton.alpha = 1
            self.reserveButton.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }
    }
    
    func hideParkNow() {
        UIView.animate(withDuration: animationIn) {
            self.currentSegment.alpha = 0
        }
    }
    
    func bringParkNow() {
        UIView.animate(withDuration: animationIn) {
            self.currentSegment.alpha = 1
        }
    }
    
    func expandHours() {
        self.delegate?.openHoursButton()
    }
    
    func minimizeHours() {
        self.delegate?.closeHoursButton()
    }
    
    var futureHours: [String] = []
    var lastDate: Date = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
    
    func setTimes() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let dateString = formatter.string(from: Date())
        
        self.currentTimeLabel.text = dateString
        
        for _ in 0..<12 {
            let lateDate = Calendar.current.date(byAdding: .hour, value: 1, to: lastDate)
            let futureDateString = formatter.string(from: lateDate!)
            self.futureHours.append(futureDateString)
            self.lastDate = lateDate!
        }
        self.timeToPicker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.futureHours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.futureHours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = Fonts.SSPSemiBoldH3
        label.text = self.futureHours[row]
        view.addSubview(label)
        
        return view
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            self.hoursButton.setTitle("\(row+1) hours", for: .normal)
        } else {
            self.hoursButton.setTitle("\(row+1) hour", for: .normal)
        }
    }
    
    private let timeValues: NSArray = ["All day","1:00 am","1:30 am","2:00 am","2:30 am","3:00 am","3:30 am","4:00 am","4:30 am","5:00 am","5:30 am","6:00 am","6:30 am","7:00 am","7:30 am","8:00 am","8:30 am","9:00 am","9:30 am","10:00 am","10:30 am","11:00 am","11:30 am","12:00 pm","12:30 pm","1:00 pm","1:30 pm","2:00 pm","2:30 pm","3:00 pm","3:30 pm","4:00 pm","4:30 pm","5:00 pm","5:30 pm","6:00 pm","6:30 pm","7:00 pm","7:30 pm","8:00 pm","8:30 pm","9:00 pm","9:30 pm","10:00 pm","10:30 pm","11:00 pm","11:30 pm","12:00 am","12:30 am"]

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    //
    //
    //
    //
    //  Purchase Extension
    //  DriveWayz
    //
    //  Created by Tyler Jordan Cagle on 8/9/18.
    //  Copyright © 2018 COAD. All rights reserved.
    //
    //
    //
    //
    
    
    
    
    // Controllers
    var removeDelegate: removePurchaseView?
    var hoursDelegate: controlHoursButton?
    
    let stripePublishableKey = "pk_live_xPZ14HLRoxNVnMRaTi8ecUMQ"
    let backendBaseURL: String? = "https://boiling-shore-28466.herokuapp.com"
    
    let paymentCurrency = "usd"
    var count: Int = 0
    var recentCount: Int = 0
    
    var id: String = ""
    var cost: Double = 0.00
    var hours: Int = 1
    var parkingId: String = ""
    
    private var paymentContext: STPPaymentContext
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private enum RideRequestState {
        case none
        case requesting
        case active
    }
    
    private var rideRequestState: RideRequestState = .none {
        didSet {
            reloadRequestRideButton()
        }
    }
    
    private var price: Double = 0 {
        didSet {
            // Forward value to payment context
            paymentContext.paymentAmount = Int(price)
        }
    }
    
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.reserveButton.alpha = 0.6
                    self.reserveButton.backgroundColor = Theme.DARK_GRAY
                    self.reserveButton.setTitle("", for: .normal)
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.reserveButton.alpha = 1
                    self.reserveButton.isUserInteractionEnabled = true
                    self.reserveButton.backgroundColor = Theme.SEA_BLUE
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.reserveButton.setTitle("Book Spot", for: .normal)
                    }
                }
            }, completion: nil)
        }
    }
    
    lazy var unavailable: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Unavailable", for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 1
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    // MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.requiredBillingAddressFields = STPBillingAddressFields.none
        config.additionalPaymentMethods = .all
        
        // Create card sources instead of card tokens
        config.createCardSources = true;
        
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: config,
                                               theme: .default())
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentAmount = Int(price * 100)
        paymentContext.paymentCurrency = self.paymentCurrency
        
        self.paymentContext = paymentContext
        
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        
        
        super.init(nibName: nil, bundle: nil)
        
        self.paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    var confirmCenterAnchor: NSLayoutConstraint!
    
    func setupExtraViews() {
        
        self.view.addSubview(unavailable)
        unavailable.rightAnchor.constraint(equalTo: reserveButton.rightAnchor).isActive = true
        unavailable.bottomAnchor.constraint(equalTo: reserveButton.bottomAnchor).isActive = true
        unavailable.leftAnchor.constraint(equalTo: reserveButton.leftAnchor).isActive = true
        unavailable.heightAnchor.constraint(equalTo: reserveButton.heightAnchor).isActive = true
        
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: reserveButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: reserveButton.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func bringBackReserve(sender: UIButton) {
        UIView.animate(withDuration: animationIn, animations: {
            if sender == self.reserveCostLabel {
                self.reserveFromLabel.alpha = 1
                self.reserveToLabel.alpha = 1
                self.toReserveLabel.alpha = 1
                self.view.layoutIfNeeded()
            } else {
                self.paymentButton.alpha = 1
                self.hoursButton.alpha = 1
                self.line.alpha = 1
                self.view.layoutIfNeeded()
            }
        }) { (success) in
            self.costButton.removeTarget(self, action: #selector(self.bringBackReserve(sender:)), for: .touchUpInside)
            self.reserveCostLabel.removeTarget(self, action: #selector(self.bringBackReserve(sender:)), for: .touchUpInside)
            self.reserveButton.setTitle("Book Spot", for: .normal)
            self.reserveButton.removeTarget(self, action: #selector(self.handleConfirmRideButtonTapped), for: .touchUpInside)
            self.reserveButton.addTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func handlePaymentButtonTapped() {
        self.paymentContext.presentPaymentMethodsViewController()
    }
    
    @objc func handleRequestRideButtonTapped() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("user-vehicles")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if (dictionary[currentUser] as? [String:AnyObject]) != nil {
                    UIView.animate(withDuration: animationIn, animations: {
                        self.reserveWidthAnchor.constant = -12
                        self.viewContainerHeightAnchor.constant = 180
                        self.costButtonHeightAnchor.constant = -20
                        self.exitButtonHeightAnchor.constant = 10
                        self.reserveCostButtonHeightAnchor.constant = -20
                        self.paymentButton.alpha = 0
                        self.reserveFromLabel.alpha = 0
                        self.reserveToLabel.alpha = 0
                        self.toReserveLabel.alpha = 0
                        self.hoursButton.alpha = 0
                        self.line.alpha = 0
                        self.line2.alpha = 0
                        self.exitButton.alpha = 1
                        self.couponStaus.alpha = 0
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        self.costButton.addTarget(self, action: #selector(self.bringBackReserve(sender:)), for: .touchUpInside)
                        self.reserveCostLabel.addTarget(self, action: #selector(self.bringBackReserve(sender:)), for: .touchUpInside)
                        self.reserveButton.setTitle("Confirm Purchase", for: .normal)
                        self.reserveButton.removeTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
                        self.reserveButton.addTarget(self, action: #selector(self.handleConfirmRideButtonTapped), for: .touchUpInside)
                    }
                } else {
                    self.sendHelp(title: "Vehicle Info Needed", message: "You must enter your vehicle information before reserving a spot")
                }
            }
        }
    }
    
    @objc private func handleConfirmRideButtonTapped() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async { // Correct
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        self.addCurrentParking()
        if reserveSegmentAnchor.isActive == true {
            self.reserveParking()
        } else if currentSegmentAnchor.isActive == true {
            self.updateUserProfileCurrent()
            self.sendNotifications()
            UIView.animate(withDuration: animationIn) {
                self.resetReservationButton()
                currentButton.alpha = 1
            }
        }
        self.notify(status: true)
        
        self.paymentInProgress = true
//        self.paymentContext.requestPayment() //////////////////////////PAYMENT NOT SET UP///////////////////////////////////////
    }
    
    var notificationController: SendNotificationsViewController = {
        let controller = SendNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    func sendNotifications() {
        let ref = Database.database().reference().child("parking").child(self.parkingId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let parkingAddress = dictionary["parkingAddress"] as? String {
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(parkingAddress) { (placemarks, error) in
                        guard let placemarks = placemarks, let location = placemarks.first?.location else {
                            return
                        }
                        self.notificationController.sendNotifications(location: location)
                    }
                }
            }
        }
    }
    
    
    private func reloadPaymentButtonContent() {
        
        guard let selectedPaymentMethod = paymentContext.selectedPaymentMethod else {
            // Show default image, text, and color
            //            paymentButton.setImage(#imageLiteral(resourceName: "Payment"), for: .normal)
            paymentButton.setTitle("Payment", for: .normal)
            paymentButton.setTitleColor(Theme.BLACK, for: .normal)
            return
        }
        
        // Show selected payment method image, label, and darker color
        paymentButton.setImage(selectedPaymentMethod.image, for: .normal)
        paymentButton.setTitle(selectedPaymentMethod.label, for: .normal)
        paymentButton.setTitleColor(Theme.BLACK, for: .normal)
    }
    
    func reloadRequestRideButton() {
        // Show disabled state
        reserveButton.backgroundColor = Theme.DARK_GRAY
        reserveButton.setTitle("Book Spot", for: .normal)
        reserveButton.setTitleColor(.white, for: .normal)
        //        requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
        reserveButton.isEnabled = false
        
        switch rideRequestState {
        case .none:
            // Show enabled state
            reserveButton.backgroundColor = Theme.SEA_BLUE
            reserveButton.setTitle("Book Spot", for: .normal)
            reserveButton.setTitleColor(.white, for: .normal)
            //            requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
            reserveButton.isEnabled = true
        case .requesting:
            // Show loading state
            reserveButton.backgroundColor = Theme.DARK_GRAY
            reserveButton.setTitle("···", for: .normal)
            reserveButton.setTitleColor(.white, for: .normal)
            reserveButton.setImage(nil, for: .normal)
            reserveButton.isEnabled = false
        case .active:
            // Show completion state
            reserveButton.backgroundColor = .white
            reserveButton.setTitle("Working", for: .normal)
            reserveButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            reserveButton.setImage(nil, for: .normal)
            reserveButton.isEnabled = true
        }
    }
    
    private func completeActiveRide() {
        guard case .active = rideRequestState else {
            // Missing active ride
            return
        }
        
        // Reset to none state
        rideRequestState = .none
        
    }
    
    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Reload related components
        reloadPaymentButtonContent()
        reloadRequestRideButton()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        let costs = hours * paymentContext.paymentAmount
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("CurrentCoupon")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let value = dictionary["coupon"] as? Double
                let percent: Double = Double(value! / 100)
                let removal = Int(percent * Double(costs))
                let payment = costs - removal
                
                MyAPIClient.sharedClient.completeCharge(paymentResult,
                                                        amount: payment,
                                                        completion: completion)
                
                ref.removeValue()
            } else {
                MyAPIClient.sharedClient.completeCharge(paymentResult,
                                                        amount: costs,
                                                        completion: completion)
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        switch status {
        case .error:
            print(error?.localizedDescription as Any)
            self.notify(status: false)
        case .success:
            self.addCurrentParking()
            if reserveSegmentAnchor.isActive == true {
                self.reserveParking()
            } else if currentSegmentAnchor.isActive == true {
                self.updateUserProfileCurrent()
                UIView.animate(withDuration: animationIn) {
                    currentButton.alpha = 1
                }
            }
            self.notify(status: true)
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        case .userCancellation:
            self.notify(status: false)
            return
        }
    }
    
    func notify(status: Bool) {
        self.removeDelegate?.showPurchaseStatus(status: status)
    }
    
    func changeReserveButton() {
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.reserveButton.setTitle("Book Spot", for: .normal)
                self.reserveButton.removeTarget(self, action: #selector(self.handleConfirmRideButtonTapped), for: .touchUpInside)
                self.reserveButton.addTarget(self, action: #selector(self.handleRequestRideButtonTapped), for: .touchUpInside)
            }
        }
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func sendHelp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (success) in
//            self.removeDelegate?.addAVehicleReminder()
        }))
        self.present(alert, animated: true)
    }
    
    func addCurrentParking() {
        UIView.animate(withDuration: animationIn, animations: {
            self.reserveButton.alpha = 0.6
        }) { (success) in
            self.removeDelegate?.purchaseButtonSwipedDown()
            UIView.animate(withDuration: animationIn, animations: {
                self.view.alpha = 0
            })
        }
    }
    
    private func reserveParking() {
        self.saveDelegate?.saveUserCurrentLocation()
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        let couponRef = Database.database().reference().child("users").child(currentUser).child("CurrentCoupon")
        couponRef.removeValue()
        couponActive = nil
        
        let timestamp = NSDate().timeIntervalSince1970
        let ref = Database.database().reference().child("users").child(currentUser)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if (dictionary["upcomingParking"] as? [String:AnyObject]) != nil {
                    self.sendPreviousUpcomingAlert()
                } else {
                    let from = self.fromDateTimestampValue?.timeIntervalSince1970
                    let to = self.toDateTimestampValue?.timeIntervalSince1970
                    ref.child("upcomingParking").child(self.parkingId).updateChildValues(["timestamp": timestamp, "hours": self.hours, "parkingID": self.parkingId, "cost": self.cost, "startTime": from!, "endTime": to!])
                    let parkingRef = Database.database().reference().child("parking").child(self.parkingId).child("Upcoming")
                    parkingRef.updateChildValues(["\(currentUser)": currentUser])
                    parkingRef.observe(.childAdded) { (snapshot) in
                        self.sendNewCurrent(status: "upcoming")
                    }
                    let beginTimeInterval = (self.fromDateTimestampValue?.timeIntervalSince1970)! - timestamp
                    let content = UNMutableNotificationContent()
                    content.title = "Your parking reservation has begun."
                    content.subtitle = "Please open in app to confirm."
                    content.body = "We have given you a 10 minute buffer time."
                    content.badge = 0
                    content.sound = UNNotificationSound.default
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: beginTimeInterval, repeats: false)
                    let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { (error) in
                        if error != nil {
                            print("Error sending upcoming reservation notification: ", error!)
                        }
                    }
                }
            }
        }
        let paymentRef = Database.database().reference().child("users").child(self.id).child("Payments")
        let currentRef = Database.database().reference().child("users").child(self.id)
        currentRef.observeSingleEvent(of: .value) { (current) in
            let dictionary = current.value as? [String:AnyObject]
            var currentFunds = dictionary!["userFunds"] as? Double
            if currentFunds != nil {} else {currentFunds = 0}
            paymentRef.observeSingleEvent(of: .value) { (snapshot) in
                self.count =  Int(snapshot.childrenCount)
                let payRef = paymentRef.child("\(self.count)")
                let newFunds = Double(currentFunds!) + (Double(self.cost) * 0.75)
                payRef.updateChildValues(["cost": self.cost, "currentFunds": newFunds, "hours": self.hours, "user": currentUser, "timestamp": timestamp, "parkingID": self.parkingId])
            }
        }
        self.paymentInProgress = false
    }
    
    private func updateUserProfileCurrent() {

        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let timestamp = NSDate().timeIntervalSince1970
        
        let couponRef = Database.database().reference().child("users").child(currentUser).child("CurrentCoupon")
        couponRef.removeValue()
        couponActive = nil
        
        let userRef = Database.database().reference().child("users").child(currentUser).child("recentParking")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            self.recentCount =  Int(snapshot.childrenCount)
            let recentRef = userRef.child("\(self.recentCount)")
            recentRef.updateChildValues(["parkingID": self.parkingId, "timestamp": timestamp, "cost": self.cost, "hours": self.hours])
        }
        
        let parkingRef = Database.database().reference().child("parking").child(self.parkingId)
        let currentParkingRef = parkingRef.child("Current")
        parkingRef.updateChildValues(["previousUser": currentUser, "previousCost": self.cost])
        currentParkingRef.updateChildValues(["\(currentUser)": currentUser])
        
        let paymentRef = Database.database().reference().child("users").child(self.id).child("Payments")
        let currentRef = Database.database().reference().child("users").child(self.id)
        currentRef.observeSingleEvent(of: .value) { (current) in
            let dictionary = current.value as? [String:AnyObject]
            var currentFunds = dictionary!["userFunds"] as? Double
            if currentFunds != nil {} else {currentFunds = 0}
            paymentRef.observeSingleEvent(of: .value) { (snapshot) in
                self.count =  Int(snapshot.childrenCount)
                let payRef = paymentRef.child("\(self.count)")
                let newFunds = Double(currentFunds!) + (Double(self.cost) * 0.75)
                payRef.updateChildValues(["cost": self.cost, "currentFunds": newFunds, "hours": self.hours, "user": currentUser, "timestamp": timestamp, "parkingID": self.parkingId])
            }
        }
        
        let helpRef = Database.database().reference().child("users").child(currentUser).child("currentParking").child(self.parkingId)
        helpRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let oldHours = dictionary["hours"] as? Int {
                    let newHours = oldHours + self.hours
                    helpRef.updateChildValues(["timestamp": timestamp, "hours": newHours, "parkingID": self.parkingId, "cost": self.cost])
                    seconds! = seconds! + (3600 * self.hours)
                }
            } else {
                helpRef.updateChildValues(["timestamp": timestamp, "hours": self.hours, "parkingID": self.parkingId, "cost": self.cost])
            }
        }
        ///////
        let observeRef = Database.database().reference().child("parking").child(self.parkingId).child("Current")
        observeRef.observe(.childAdded) { (snapshot) in
            self.sendNewCurrent(status: "start")
        }
        observeRef.observe(.childRemoved) { (snapshot) in
            self.sendNewCurrent(status: "end")
        }
        
        let fundRef = Database.database().reference().child("users").child(self.id)
        fundRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if var dictionary = snapshot.value as? [String:AnyObject] {
                
                if let previousFunds = dictionary["userFunds"] {
                    let funds = Double(truncating: previousFunds as! NSNumber) + (self.cost) * 0.75
                    fundRef.updateChildValues(["userFunds": funds])
                } else {
                    fundRef.updateChildValues(["userFunds": (self.cost * 0.75)])
                }
                if let previousHours = dictionary["hostHours"] as? Int{
                    let hour = previousHours + self.hours
                    fundRef.updateChildValues(["hostHours": hour])
                } else {
                    fundRef.updateChildValues(["hostHours": self.hours])
                }
                
            }
        }, withCancel: nil)
        self.paymentInProgress = false
    }
    
    func sendNewCurrent(status: String) {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userName = dictionary["name"] as? String
                var fullNameArr = userName?.split(separator: " ")
                let firstName: String = String(fullNameArr![0])
                
                let sendRef = Database.database().reference().child("currentParking").child(currentUser)
                if status == "start" {
                    sendRef.updateChildValues(["status": "In use", "deviceID": AppDelegate.DEVICEID, "fromID": currentUser, "toID": self.id])
                } else if status == "end" {
                    sendRef.updateChildValues(["status": "Finished", "deviceID": AppDelegate.DEVICEID, "fromID": currentUser, "toID": self.id])
                } else if status == "upcoming" {
                    let upcomingRef = Database.database().reference().child("upcomingParking").child(currentUser)
                    upcomingRef.updateChildValues(["status": "In use", "deviceID": AppDelegate.DEVICEID, "fromID": currentUser, "toID": self.id])
                }
                self.fetchNewCurrent(key: self.id, name: firstName, status: status)
            }
        }
    }
    
    func fetchNewCurrent(key: String, name: String, status: String) {
        Database.database().reference().child("users").child(key).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let fromDevice = dictionary["DeviceID"] as? String
                self.setupPushNotifications(fromDevice: fromDevice!, name: name, status: status)
            }
        }
    }
    
    func sendPreviousUpcomingAlert() {
        let alert = UIAlertController(title: "You have already reserved a spot.", message: "Currently you can only reserve one spot at a time! You have not been charged.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    fileprivate func setupPushNotifications(fromDevice: String, name: String, status: String) {
        if status == "start" {
            let title = "\(name) is currently parked in your spot!"
            let body = "Open to see more details."
            let toDevice = fromDevice
            var headers: HTTPHeaders = HTTPHeaders()
            
            headers = ["Content-Type": "application/json", "Authorization": "key=\(AppDelegate.SERVERKEY)"]
            let notification = ["to": "\(toDevice)", "notification": ["body": body, "title": title, "badge": 0, "sound": "default"]] as [String:Any]
            
            Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).response { (response) in
                //
            }
        } else if status == "end" {
            let title = "\(name) has ended their parking reservation."
            let body = "Let us know if they've left your parking space."
            let toDevice = fromDevice
            var headers: HTTPHeaders = HTTPHeaders()
            
            headers = ["Content-Type": "application/json", "Authorization": "key=\(AppDelegate.SERVERKEY)"]
            let notification = ["to": "\(toDevice)", "notification": ["body": body, "title": title, "badge": 0, "sound": "default"]] as [String:Any]
            
            Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).response { (response) in
                //
            }
            
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            let deleteRef = Database.database().reference().child("currentParking")
            deleteRef.child(currentUser).removeValue()
        } else if status == "upcoming" {
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("users").child(currentUser).child("upcomingParking").child(self.parkingId)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let fromTimestamp = dictionary["startTime"] as? TimeInterval
                    let toTimestamp = dictionary["endTime"] as? TimeInterval
                    let fromDate = Date(timeIntervalSince1970: fromTimestamp!)
                    let toDate = Date(timeIntervalSince1970: toTimestamp!)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mm a EEEE"
                    let fromString = formatter.string(from: fromDate)
                    let toString = formatter.string(from: toDate)
                    
                    let title = "\(name) has reserved your spot from"
                    let subtitle = "\(fromString) to \(toString)"
                    let body = "Open to see more details."
                    let toDevice = fromDevice
                    var headers: HTTPHeaders = HTTPHeaders()
                    
                    headers = ["Content-Type": "application/json", "Authorization": "key=\(AppDelegate.SERVERKEY)"]
                    let notification = ["to": "\(toDevice)", "notification": ["body": body, "title": title, "subtitle": subtitle, "badge": 0, "sound": "default"]] as [String:Any]
                    
                    Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).response { (response) in
                        //
                    }
                }
            }
        }
    }
    
    var isCouponActive: Bool = false

    func checkForCoupons() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("CurrentCoupon")
        ref.observe(.childAdded) { (snapshot) in
            let percent = snapshot.value as? Int
            self.couponStaus.setTitle("\(percent!)% off!", for: .normal)
            self.couponStaus.alpha = 0.8
            couponActive = percent!
            self.isCouponActive = true
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.couponStaus.setTitle("", for: .normal)
            self.couponStaus.alpha = 0
            self.isCouponActive = false
        }
    }
    
    
    

}
