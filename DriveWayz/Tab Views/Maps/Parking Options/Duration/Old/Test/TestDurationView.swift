//
//  TestDurationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol handleDurationChanges {
    func changeTimeHeight(amount: CGFloat)
    func changeDateRange(days: [Date], today: Bool)
    func changeMonth(month: String)
    func changeStartAndEnd(start: String, end: String)
    func changeMainButton(enabled: Bool)
    func selectNextDay()
}

class TestDurationView: UIViewController {
    
    var bottomAnchor: CGFloat = 0.0
    var shouldDismiss: Bool = true
    
    var delegate: handleCheckoutParking?
    var fromDate = Date()
    var toDate = Date()
    
    var savingInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
                if self.savingInProgress {
                    self.loadingActivity.startAnimating()
                    self.loadingActivity.alpha = 1
                    self.mainButtonUnavailable()
                    self.mainButton.setTitle("", for: .normal)
                }
                else {
                    self.loadingActivity.stopAnimating()
                    self.loadingActivity.alpha = 0
                    self.mainButtonAvailable()
                    self.mainButton.setTitle("Save Duration", for: .normal)
                }
            }, completion: nil)
        }
    }
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Save Duration", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(saveDates), for: .touchUpInside)
        
        return button
    }()
    
    lazy var hoursController: DurationHoursView = {
        let controller = DurationHoursView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var timesController: NewTimeView = {
        let controller = NewTimeView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var daysController: DurationDaysView = {
        let controller = DurationDaysView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var secondLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
        setupTimes()
        delayWithSeconds(1) {
            self.saveDates()
        }
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        container.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -32
        case .iphoneX:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -52)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -52
        }
        
        container.addSubview(mainButton)
        mainButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -12).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true

        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    var timesControllerHeightAnchor: NSLayoutConstraint!
    
    func setupTimes() {
        
        container.addSubview(hoursController.view)
        hoursController.view.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 35)
        
        container.addSubview(firstLine)
        firstLine.anchor(top: nil, left: view.leftAnchor, bottom: hoursController.view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 12, paddingRight: 20, width: 0, height: 1)
        
        container.addSubview(timesController.view)
        timesController.view.anchor(top: nil, left: view.leftAnchor, bottom: hoursController.view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 32, paddingRight: 0, width: 0, height: 0)
        timesControllerHeightAnchor = timesController.view.heightAnchor.constraint(equalToConstant: 100)
            timesControllerHeightAnchor.isActive = true
        
        container.addSubview(secondLine)
        secondLine.anchor(top: nil, left: view.leftAnchor, bottom: timesController.view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 1)

        container.addSubview(daysController.view)
        daysController.view.anchor(top: nil, left: view.leftAnchor, bottom: timesController.view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 40, paddingRight: 0, width: 0, height: 76)
        daysController.setData()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: daysController.view.topAnchor, constant: -32).isActive = true
        
        view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
    }
    
    @objc func saveDates() {
        savingInProgress = true
        if var text = hoursController.hourLabel.text {
            text = text.replacingOccurrences(of: "hour", with: "hr")
            text = text.replacingOccurrences(of: "minute", with: "min")
            delegate?.setDurationPressed(fromDate: bookingFromDate, totalTime: text)
        }
        delegate?.observeAllHosting()
        delayWithSeconds(animationOut) {
            UIView.animate(withDuration: animationOut, animations: {
                tabDimmingView.alpha = 0
            })
            self.savingInProgress = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func selectNextDay() {
        daysController.selectNextDay()
    }
    
}

extension TestDurationView: handleDurationChanges {
    
    func changeTimeHeight(amount: CGFloat) {
        if amount == 0 {
            profitsBottomAnchor.constant = self.bottomAnchor
        } else {
            profitsBottomAnchor.constant = amount
        }
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func changeDateRange(days: [Date], today: Bool) {
        hoursController.dates = days
        if today {
            if days.count > 1 {
                timesController.reservationDateState = .single
            } else {
                timesController.reservationDateState = .today
            }
        } else {
            timesController.reservationDateState = .multiple
        }
        if days.count != 0 {
            mainButtonAvailable()
        } else {
            mainButtonUnavailable()
        }
    }
    
    func changeMonth(month: String) {
        hoursController.month = month
    }
    
    func changeStartAndEnd(start: String, end: String) {
        hoursController.changeStartAndEnd(start: start, end: end)
    }
    
    func changeMainButton(enabled: Bool) {
        if enabled {
            mainButtonAvailable()
        } else {
            mainButtonUnavailable()
        }
    }
    
    func mainButtonAvailable() {
        mainButton.isUserInteractionEnabled = true
        mainButton.backgroundColor = Theme.BLUE
        mainButton.setTitleColor(Theme.WHITE, for: .normal)
    }
    
    func mainButtonUnavailable() {
        mainButton.isUserInteractionEnabled = false
        mainButton.backgroundColor = lineColor
        mainButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
    }
    
}


extension TestDurationView {
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.profitsBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        UIView.animate(withDuration: animationOut, animations: {
            tabDimmingView.alpha = 0
        })
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
