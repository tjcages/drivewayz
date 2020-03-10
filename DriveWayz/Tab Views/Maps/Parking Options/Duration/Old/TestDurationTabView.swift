//
//  TestDurationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleDuration {
    func parkNowPressed()
    func reservePressed()
    
    func availableMainButton()
    func unavailableMainButton()
    func changeReservation(percent: CGFloat)
    func changeScrollHeight(height: CGFloat)
    
    func dismissView()
}

var parkNow: Bool = true
var bookingDuration: Double = 2.25
var bookingFromDate = Date()
var bookingToDate = Date().addingTimeInterval(TimeInterval(8100))

class TestDurationTabView: UIViewController {
    
//    var delegate: handleRouteNavigation?
    var timeDelegate: handleCheckoutParking?
    var dateFormatter = DateFormatter()
    
    lazy var bottomHeight: CGFloat = -cancelBottomHeight + durationBottomController.buttonHeight + 16
    lazy var parkNowHeight: CGFloat = parkNowController.currentBookingHeight + bottomHeight + 88
    lazy var containerHeight: CGFloat = reservationController.normalScrollHeight
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var reservationController: TestReservationView = {
        let controller = TestReservationView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.mainDelegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var parkNowController: ParkNowView = {
        let controller = ParkNowView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 24
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.alpha = 0
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Save Duration", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0
        
        return view
    }()

    lazy var durationBottomController: DurationBottomView = {
        let controller = DurationBottomView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        
        setupViews()
        setupButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: animationOut) {
            self.backButton.alpha = 1
        }
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var parkNowLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(container)
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: parkNowHeight)
            containerHeightAnchor.isActive = true
        
        view.addSubview(backButton)
        view.addSubview(reservationController.view)
        view.addSubview(parkNowController.view)
        
        view.addSubview(buttonView)
        view.addSubview(mainButton)
        view.addSubview(durationBottomController.view)
        
        parkNowLeftAnchor = parkNowController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
            parkNowLeftAnchor.isActive = true
        parkNowController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        parkNowController.view.bottomAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        parkNowController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        reservationController.view.anchor(top: view.topAnchor, left: parkNowController.view.rightAnchor, bottom: buttonView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth, height: 0)
        
    }
    
    var bottomBottomAnchor: NSLayoutConstraint!
    
    func setupButtons() {
        
        durationBottomController.view.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: bottomHeight)
        bottomBottomAnchor = durationBottomController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            bottomBottomAnchor.isActive = true
        
        mainButton.bottomAnchor.constraint(equalTo: durationBottomController.view.topAnchor, constant: -16).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        buttonView.anchor(top: mainButton.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        backButton.anchor(top: nil, left: view.leftAnchor, bottom: container.topAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 0, width: 48, height: 48)
        
    }
    
    @objc func mainButtonPressed() {
        if reservationController.gradientContainer.alpha == 1 {
            // Save dates
            if let start = reservationController.startButton.titleLabel?.text, let end = reservationController.endButton.titleLabel?.text {
                reservationController.scrollView.scrollToTop(animated: true)
                if start != end {
                    
                    reservationController.minimize = true
                    reservationController.minimizeController()
                } else {
                    reservationController.minimize = false
                    reservationController.maximizeController()
                }
                reservationController.closeFullReservation()
            }
        } else {
            // Save overall duration
            if parkNow {
                // Save as Park Now
//                bookingDuration = parkNowController.sliderView.totalSelectedTime
                timeDelegate?.observeAllHosting()
                dismissView()
            } else {
                // Save as a Reservation
                if let endDate = reservationController.endButton.titleLabel?.text, let endTime = reservationController.endTimeButton.text {
                    let end = endDate + " " + endTime
                    if let date = dateFormatter.date(from: end) {
                        bookingToDate = date
                    }
                }
                if let startDate = reservationController.startButton.titleLabel?.text, let startTime = reservationController.startTimeButton.text {
                    let start = startDate + " " + startTime
                    if let date = dateFormatter.date(from: start) {
                        bookingFromDate = date
                        timeDelegate?.observeAllHosting()
                        dismissView()
                    }
                }
            }
        }
    }

    @objc func dismissView() {
        UIView.animate(withDuration: animationOut, animations: {
            tabDimmingView.alpha = 0
            self.backButton.alpha = 0
        })
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension TestDurationTabView: handleDuration {
    
    func parkNowPressed() {
        container.alpha = 1
        reservationController.scrollTopAnchor.constant = phoneHeight - parkNowController.currentBookingHeight
        if (parkNowController.currentBookingHeight + bottomHeight + 88) > (phoneHeight - parkNowController.currentBookingHeight) {
            containerHeightAnchor.constant = phoneHeight - parkNowController.currentBookingHeight
        } else {
            containerHeightAnchor.constant = parkNowController.currentBookingHeight + bottomHeight + 88
        }
        parkNowLeftAnchor.constant = 0
        UIView.animate(withDuration: animationIn, animations: {
            self.reservationController.view.alpha = 0
            self.parkNowController.view.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.container.alpha = 0
        }
    }
    
    func reservePressed() {
        container.alpha = 1
        reservationController.scrollTopAnchor.constant = reservationController.currentBookingHeight
        containerHeightAnchor.constant = containerHeight
        parkNowLeftAnchor.constant = -phoneWidth
        UIView.animate(withDuration: animationIn, animations: {
            self.reservationController.view.alpha = 1
            self.parkNowController.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.container.alpha = 0
        }
    }
    
    func changeScrollHeight(height: CGFloat) {
        containerHeight = height
        containerHeightAnchor.constant = height
    }
    
    func availableMainButton() {
        mainButton.backgroundColor = Theme.BLACK
        mainButton.setTitleColor(Theme.WHITE, for: .normal)
        mainButton.isUserInteractionEnabled = true
    }
    
    func unavailableMainButton() {
        mainButton.backgroundColor = Theme.LINE_GRAY
        mainButton.setTitleColor(Theme.BLACK, for: .normal)
        mainButton.isUserInteractionEnabled = false
    }
    
    func changeReservation(percent: CGFloat) {
        if percent == 1.0 {
            bottomBottomAnchor.constant = bottomHeight + cancelBottomHeight + 36
            UIView.animate(withDuration: animationOut, animations: {
                self.backButton.alpha = 0
                self.buttonView.layer.shadowOpacity = 0.2
                self.view.layoutIfNeeded()
            }) { (success) in
                lightContentStatusBar()
            }
        } else if percent == 0 {
            bottomBottomAnchor.constant = 0
            UIView.animate(withDuration: animationOut, animations: {
                self.buttonView.layer.shadowOpacity = 0
                self.backButton.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                defaultContentStatusBar()
            }
        } else {
            backButton.alpha = 1 - percent
        }
    }
    
}

func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
    return (minutes / 60, (minutes % 60))
}
