//
//  ConfirmParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import UserNotifications
import NVActivityIndicatorView

class ConfirmParkingViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var delegate: handlePopupTerms?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.text = """
        Drivewayz would like to send you monthly notifications to verify your status as an active host.

        You must accept to save this parking space.
        """
        label.numberOfLines = 6
        
        return label
    }()
    
    var extraLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.7)
        label.font = Fonts.SSPLightH5
        label.text = "You will also recieve notifications when users park in your spot."
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var acceptNotifications: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.setTitle("Allow", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(registerForPushNotifications), for: .touchUpInside)
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 120, height: 60)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var denyNotifications: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        button.setTitle("Allow", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.alpha = 0
        
        return button
    }()
    
    var sendToNotifications: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open up settings to save parking", for: .normal)
        button.setTitleColor(Theme.SEA_BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH4
        button.addTarget(self, action: #selector(sendToSettings), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var informationAcceptLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH3
        button.titleLabel?.numberOfLines = 4
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(showTerms), for: .touchUpInside)
        
        let main_string = "By registering your host parking space, you confirm that you own all rights and privileges to the property and you agree to our Services Agreement."
        let string_to_color = "Services Agreement."
        let string_to_notColor = "By registering your host parking space, you confirm that you own all rights and privileges to the property and you agree to our "
        let range = (main_string as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: main_string)
        let notRange = (main_string as NSString).range(of: string_to_notColor)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.PACIFIC_BLUE , range: range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.WHITE , range: notRange)
        attribute.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPSemiBoldH3 , range: range)
        button.setAttributedTitle(attribute, for: .normal)
        
        return button
    }()
    
    lazy var confirmNotifications: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 120, height: 60)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(finalizeParking), for: .touchUpInside)
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    //verifying email address so others can;t sign someone else up
    //checking in monthly to see if they want to continue or suspend the spot
    //signing up for phone/email notifications
    //accepting terms of service
    //notifying after a month of being inactive
    //just tow after two chances
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.8)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        scrollView.addSubview(acceptNotifications)
        acceptNotifications.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 60).isActive = true
        acceptNotifications.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        acceptNotifications.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        acceptNotifications.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(denyNotifications)
        denyNotifications.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 60).isActive = true
        denyNotifications.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        denyNotifications.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        denyNotifications.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(extraLabel)
        extraLabel.topAnchor.constraint(equalTo: denyNotifications.bottomAnchor, constant: 20).isActive = true
        extraLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        extraLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        extraLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(sendToNotifications)
        sendToNotifications.topAnchor.constraint(equalTo: denyNotifications.bottomAnchor, constant: 20).isActive = true
        sendToNotifications.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        sendToNotifications.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        sendToNotifications.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(informationAcceptLabel)
        informationAcceptLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: self.view.frame.height + 20).isActive = true
        informationAcceptLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationAcceptLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationAcceptLabel.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        scrollView.addSubview(confirmNotifications)
        confirmNotifications.topAnchor.constraint(equalTo: informationAcceptLabel.bottomAnchor, constant: 60).isActive = true
        confirmNotifications.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        confirmNotifications.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        confirmNotifications.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: confirmNotifications.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: confirmNotifications.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
    }
    
    @objc func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // Check if permission granted
            DispatchQueue.main.async {
                guard granted else {
                    UIView.animate(withDuration: animationOut, animations: {
                        self.denyNotifications.alpha = 1
                        self.sendToNotifications.alpha = 1
                        self.acceptNotifications.alpha = 0
                        self.extraLabel.alpha = 0
                    }, completion: { (success) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            UIView.animate(withDuration: animationOut, animations: {
                                self.denyNotifications.alpha = 0
                                self.sendToNotifications.alpha = 0
                                self.acceptNotifications.alpha = 1
                                self.extraLabel.alpha = 1
                            })
                        }
                    })
                    return
                }
                self.moveToFinalizeParking()
                UIView.animate(withDuration: animationOut, animations: {
                    self.denyNotifications.alpha = 0
                    self.sendToNotifications.alpha = 0
                    self.acceptNotifications.alpha = 1
                })
            }
            // Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func checkForPushNotifications() {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            self.scrollView.isScrollEnabled = true
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom);
            self.scrollView.setContentOffset(bottomOffset, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.scrollView.isScrollEnabled = false
            }
        } else {
            self.denyNotifications.alpha = 0
            self.sendToNotifications.alpha = 0
            self.acceptNotifications.alpha = 1
            self.extraLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func moveToFinalizeParking() {
        self.scrollView.isScrollEnabled = true
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom);
        self.scrollView.setContentOffset(bottomOffset, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.scrollView.isScrollEnabled = false
        }
    }
    
    @objc func sendToSettings() {
        if let url = NSURL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func showTerms() {
        self.delegate?.showTerms()
    }
    
    @objc func finalizeParking() {
        self.delegate?.finalizeDatabase()
        self.confirmNotifications.setTitle("", for: .normal)
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
    }
    
    func endLoading() {
        self.confirmNotifications.setTitle("CONFIRM", for: .normal)
        self.loadingActivity.alpha = 0
        self.loadingActivity.stopAnimating()
    }

}
