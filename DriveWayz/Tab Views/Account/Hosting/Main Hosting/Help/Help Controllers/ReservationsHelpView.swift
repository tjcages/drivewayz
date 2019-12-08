//
//  ReservationsHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ReservationsHelpView: UIViewController {

    var delegate: HelpMenuDelegate?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    var previousBooking: Bool = true {
        didSet {
            if previousBooking {
                setPrevious()
            } else {
                setCurrent()
            }
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 2.5
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Reservations"
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var reservationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.tintColor = Theme.DARK_GRAY
        let image = UIImage(named: "helpCalendar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wed 18, Nov 2019"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Previous reservation"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()

    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11:00am • 3:30pm"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You do not currently have an upcoming reservation."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 4
        
        return label
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change reservation settings", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()
        
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
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
        setupListing()
        setupContainer()
    }
    
    var panBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        view.addSubview(mainButton)
        panBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight)
            panBottomAnchor.isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    var subLabelTop: CGFloat = 0.0
    
    func setupListing() {
        
        view.addSubview(settingsButton)
        view.addSubview(informationLabel)
        
        settingsButton.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 0, width: 0, height: 0)
        settingsButton.sizeToFit()
        
        informationLabel.bottomAnchor.constraint(equalTo: settingsButton.topAnchor, constant: -20).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: settingsButton.leftAnchor).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(reservationIcon)
        view.addSubview(titleLabel)
        view.addSubview(subLabel)
        view.addSubview(timeLabel)
        
        if previousBooking {
            reservationIcon.anchor(top: nil, left: view.leftAnchor, bottom: informationLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 45, height: 45)
        } else {
            reservationIcon.anchor(top: nil, left: view.leftAnchor, bottom: informationLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 0, width: 45, height: 45)
        }
        
        subLabel.topAnchor.constraint(equalTo: reservationIcon.topAnchor, constant: subLabelTop).isActive = true
        subLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        titleLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        titleLabel.sizeToFit()
        
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        timeLabel.sizeToFit()
        
    }
    
    func setupContainer() {
        
        container.addSubview(line)
        container.addSubview(mainLabel)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: subLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        
    }
    
    @objc func mainButtonPressed() {
        dismissView()
    }
    
    func setPrevious() {
        subLabelTop = -2
        timeLabel.alpha = 0
        reservationIcon.tintColor = Theme.DARK_GRAY
        reservationIcon.backgroundColor = lineColor
        subLabel.text = "Previous reservation"
        informationLabel.text = "You do not currently have an upcoming reservation."
        mainButton.setTitle("Dismiss", for: .normal)
        mainButton.backgroundColor = Theme.DARK_GRAY
    }
    
    func setCurrent() {
        subLabelTop = -12
        timeLabel.alpha = 1
        reservationIcon.tintColor = Theme.BLUE
        reservationIcon.backgroundColor = Theme.HOST_BLUE
        subLabel.text = "Upcoming reservation"
        informationLabel.text = "Reservations can only be canceled up to 24 hours in advance."
        mainButton.setTitle("Cancel Reservation", for: .normal)
        mainButton.backgroundColor = Theme.HARMONY_RED
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.panBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.panBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.panBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        delegate?.removeDim()
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
