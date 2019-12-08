//
//  AvailabilitySettingsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol AvailabiltySettingsDelegate {
    func removeDim()
}

class AvailabilitySettingsView: UIViewController {
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.setBackButton()
        controller.scrollView.alpha = 0
        
        return controller
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Reservations"
        
        return label
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var reservationsMainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Allows reservations"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var reservationsSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select this if you allow drivers to book your spot in advance."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var reservationsSwitchButton: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = Theme.BLUE
        view.tintColor = lineColor
        view.addTarget(self, action: #selector(switchPressed(sender:)), for: .valueChanged)
        
        return view
    }()
    
    var reservationsInformationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.addTarget(self, action: #selector(informationPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var noticeMainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Advance notice"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var noticeSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select this if you require more than 24 hours notice for reservations."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var noticeSwitchButton: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = Theme.BLUE
        view.tintColor = lineColor
        view.addTarget(self, action: #selector(switchPressed(sender:)), for: .valueChanged)
        
        return view
    }()
    
    var noticeInformationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.addTarget(self, action: #selector(informationPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE

        setupViews()
        setupReservations()
        setupNotice() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text != "Settings" {
            gradientController.animateText(text: "Settings")
        }
        UIView.animate(withDuration: animationIn) {
            self.gradientController.scrollView.alpha = 1
        }
    }
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        gradientController.scrollView.addSubview(container)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        gradientController.scrollView.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: gradientController.scrollView.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        container.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func setupReservations() {
        
        gradientController.scrollView.addSubview(reservationsSwitchButton)
        gradientController.scrollView.addSubview(reservationsMainLabel)
        gradientController.scrollView.addSubview(reservationsSubLabel)
        gradientController.scrollView.addSubview(reservationsInformationIcon)
        gradientController.scrollView.addSubview(line)
        
        reservationsSwitchButton.topAnchor.constraint(equalTo: reservationsMainLabel.topAnchor).isActive = true
        reservationsSwitchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        reservationsSwitchButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
        reservationsSwitchButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        reservationsMainLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        reservationsMainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        reservationsMainLabel.sizeToFit()

        reservationsSubLabel.topAnchor.constraint(equalTo: reservationsMainLabel.bottomAnchor, constant: 4).isActive = true
        reservationsSubLabel.leftAnchor.constraint(equalTo: reservationsMainLabel.leftAnchor).isActive = true
        reservationsSubLabel.rightAnchor.constraint(equalTo: reservationsSwitchButton.leftAnchor, constant: -20).isActive = true
        reservationsSubLabel.sizeToFit()
        
        reservationsInformationIcon.centerYAnchor.constraint(equalTo: reservationsMainLabel.centerYAnchor).isActive = true
        reservationsInformationIcon.leftAnchor.constraint(equalTo: reservationsMainLabel.rightAnchor, constant: 4).isActive = true
        reservationsInformationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reservationsInformationIcon.widthAnchor.constraint(equalTo: reservationsInformationIcon.heightAnchor).isActive = true
        
        line.anchor(top: reservationsSubLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    func setupNotice() {
        
        gradientController.scrollView.addSubview(noticeSwitchButton)
        gradientController.scrollView.addSubview(noticeMainLabel)
        gradientController.scrollView.addSubview(noticeSubLabel)
        gradientController.scrollView.addSubview(noticeInformationIcon)
        
        noticeSwitchButton.topAnchor.constraint(equalTo: noticeMainLabel.topAnchor).isActive = true
        noticeSwitchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        noticeSwitchButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
        noticeSwitchButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        noticeMainLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        noticeMainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        noticeMainLabel.sizeToFit()

        noticeSubLabel.topAnchor.constraint(equalTo: noticeMainLabel.bottomAnchor, constant: 4).isActive = true
        noticeSubLabel.leftAnchor.constraint(equalTo: noticeMainLabel.leftAnchor).isActive = true
        noticeSubLabel.rightAnchor.constraint(equalTo: noticeSwitchButton.leftAnchor, constant: -20).isActive = true
        noticeSubLabel.sizeToFit()
        
        noticeInformationIcon.centerYAnchor.constraint(equalTo: noticeMainLabel.centerYAnchor).isActive = true
        noticeInformationIcon.leftAnchor.constraint(equalTo: noticeMainLabel.rightAnchor, constant: 4).isActive = true
        noticeInformationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        noticeInformationIcon.widthAnchor.constraint(equalTo: noticeInformationIcon.heightAnchor).isActive = true
        
        view.addSubview(dimView)
        
    }
    
    @objc func informationPressed(sender: UIButton) {
        dimBackground()
        delayWithSeconds(animationIn) {
            let controller = AvailabilityInformationView()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            if sender == self.reservationsInformationIcon {
                controller.informationIndex = 0
            } else if sender == self.noticeInformationIcon {
                controller.informationIndex = 1
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func switchPressed(sender: UISwitch) {
        sender.setOn(sender.isOn, animated: true)
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension AvailabilitySettingsView: AvailabiltySettingsDelegate {
    
    func dimBackground() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0.7
        }
    }
    
    func removeDim() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0
        }
    }
    
}
