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
        label.textColor = Theme.BLACK
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
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.font = Fonts.SSPLightH5
        label.text = "You will also recieve notifications when users park in your spot."
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var acceptNotifications: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Allow", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(registerForPushNotifications), for: .touchUpInside)
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var denyNotifications: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK.withAlphaComponent(0.3)
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
        button.setTitle("Open settings to allow notifications", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPLightH4
        button.addTarget(self, action: #selector(sendToSettings), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var informationAcceptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 6
        label.text = "By registering your host parking space you confirm that you own all rights and privileges to the property or have written consent from the landlord and you agree to the policies below."
        
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(finalizeParking), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    var mainPoliciesCheck: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.borderStyle = .roundedSquare(radius: 2)
        check.checkedBorderColor = Theme.BLUE
        check.uncheckedBorderColor = Theme.LINE_GRAY
        check.checkmarkColor = Theme.BLUE
        check.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        
        return check
    }()
    
    var mainPoliciesLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        label.isSelectable = false
        let string = "I agree to the Privacy Policy and \nTerms & Conditions"
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        let privacyRange = (string as NSString).range(of: "Privacy Policy")
        let termsRange = (string as NSString).range(of: "Terms & Conditions")
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH5, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: termsRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: termsRange)
        
        let privacyAttribute = [NSAttributedString.Key.myAttributeName: "Privacy Policy"]
        attributedString.addAttributes(privacyAttribute, range: privacyRange)
        let termsAttribute = [NSAttributedString.Key.myAttributeName: "Terms & Conditions"]
        attributedString.addAttributes(termsAttribute, range: termsRange)
        
        label.attributedText = attributedString
        label.isScrollEnabled = false
        label.isEditable = false
        
        return label
    }()
    
    var hostPoliciesCheck: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.borderStyle = .roundedSquare(radius: 2)
        check.checkedBorderColor = Theme.BLUE
        check.uncheckedBorderColor = Theme.LINE_GRAY
        check.checkmarkColor = Theme.BLUE
        check.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        
        return check
    }()
    
    lazy var hostPoliciesLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        label.isSelectable = false
        let string = "I have read and agree to the Host Policy and Host Regulations"
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        let privacyRange = (string as NSString).range(of: "Host Policy")
        let regulationRange = (string as NSString).range(of: "Host Regulations")
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH5, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: privacyRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLUE, range: regulationRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.BLUE, range: regulationRange)
        
        let privacyAttribute = [NSAttributedString.Key.myAttributeName: "Host Policy"]
        attributedString.addAttributes(privacyAttribute, range: privacyRange)
        let regulationAttribute = [NSAttributedString.Key.myAttributeName: "Host Regulations"]
        attributedString.addAttributes(regulationAttribute, range: regulationRange)
        
        label.attributedText = attributedString
        label.isScrollEnabled = false
        label.isEditable = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        tap.delegate = self
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    //verifying email address so others can;t sign someone else up
    //checking in monthly to see if they want to continue or suspend the spot
    //signing up for phone/email notifications
    //accepting terms of service
    //notifying after a month of being inactive
    //just tow after two chances
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        mainTap.delegate = self
        mainPoliciesLabel.addGestureRecognizer(mainTap)
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        hostTap.delegate = self
        hostPoliciesLabel.addGestureRecognizer(hostTap)
        
        setupViews()
        setupNotifications()
        setupConfirmation()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: self.view.frame.height * 2)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupNotifications() {
        
        scrollView.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationLabel.sizeToFit()
        
        scrollView.addSubview(acceptNotifications)
        acceptNotifications.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 60).isActive = true
        acceptNotifications.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        acceptNotifications.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        acceptNotifications.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        scrollView.addSubview(denyNotifications)
        denyNotifications.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 60).isActive = true
        denyNotifications.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        denyNotifications.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        denyNotifications.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
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
        
    }
    
    func setupConfirmation() {
        
        scrollView.addSubview(informationAcceptLabel)
        informationAcceptLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: phoneHeight + 16).isActive = true
        informationAcceptLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        informationAcceptLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        informationAcceptLabel.sizeToFit()
        
        scrollView.addSubview(mainPoliciesCheck)
        mainPoliciesCheck.leftAnchor.constraint(equalTo: informationAcceptLabel.leftAnchor).isActive = true
        mainPoliciesCheck.topAnchor.constraint(equalTo: informationAcceptLabel.bottomAnchor, constant: 64).isActive = true
        mainPoliciesCheck.heightAnchor.constraint(equalToConstant: 25).isActive = true
        mainPoliciesCheck.widthAnchor.constraint(equalTo: mainPoliciesCheck.heightAnchor).isActive = true
        
        scrollView.addSubview(mainPoliciesLabel)
        mainPoliciesLabel.leftAnchor.constraint(equalTo: mainPoliciesCheck.rightAnchor, constant: 16).isActive = true
        mainPoliciesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainPoliciesLabel.centerYAnchor.constraint(equalTo: mainPoliciesCheck.centerYAnchor).isActive = true
        mainPoliciesLabel.sizeToFit()
        
        scrollView.addSubview(hostPoliciesCheck)
        hostPoliciesCheck.leftAnchor.constraint(equalTo: informationAcceptLabel.leftAnchor).isActive = true
        hostPoliciesCheck.topAnchor.constraint(equalTo: mainPoliciesCheck.bottomAnchor, constant: 32).isActive = true
        hostPoliciesCheck.heightAnchor.constraint(equalToConstant: 25).isActive = true
        hostPoliciesCheck.widthAnchor.constraint(equalTo: mainPoliciesCheck.heightAnchor).isActive = true
        
        scrollView.addSubview(hostPoliciesLabel)
        hostPoliciesLabel.leftAnchor.constraint(equalTo: hostPoliciesCheck.rightAnchor, constant: 16).isActive = true
        hostPoliciesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        hostPoliciesLabel.centerYAnchor.constraint(equalTo: hostPoliciesCheck.centerYAnchor).isActive = true
        hostPoliciesLabel.sizeToFit()
        
        scrollView.addSubview(confirmButton)
        confirmButton.topAnchor.constraint(equalTo: hostPoliciesLabel.bottomAnchor, constant: 64).isActive = true
        confirmButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        confirmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: confirmButton.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: confirmButton.centerYAnchor).isActive = true
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerForNotifications"), object: nil)
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerForNotifications"), object: nil)
            }
        }
    }
    
    func checkForPushNotifications() {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            self.scrollView.isScrollEnabled = true
            self.scrollView.scrollToView(view: self.informationAcceptLabel, animated: true, offset: 16)
            delayWithSeconds(animationOut) {
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
        self.scrollView.scrollToView(view: self.informationAcceptLabel, animated: true, offset: 16)
        delayWithSeconds(animationOut) {
            self.scrollView.isScrollEnabled = false
        }
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        if self.mainPoliciesCheck.isChecked == true && self.hostPoliciesCheck.isChecked == true {
            self.confirmButton.backgroundColor = Theme.BLUE
            self.confirmButton.setTitleColor(Theme.WHITE, for: .normal)
            self.confirmButton.isUserInteractionEnabled = true
        } else {
            self.confirmButton.backgroundColor = Theme.LINE_GRAY
            self.confirmButton.setTitleColor(Theme.BLACK, for: .normal)
            self.confirmButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func sendToSettings() {
        if let url = NSURL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func finalizeParking() {
        self.delegate?.finalizeDatabase()
        self.confirmButton.isUserInteractionEnabled = false
        self.confirmButton.setTitle("", for: .normal)
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
    }
    
    func endLoading() {
        self.confirmButton.isUserInteractionEnabled = true
        self.confirmButton.setTitle("Confirm", for: .normal)
        self.loadingActivity.alpha = 0
        self.loadingActivity.stopAnimating()
    }
    
}

extension ConfirmParkingViewController: UIGestureRecognizerDelegate {
    
    @objc func textViewMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            // check if the tap location has a certain attribute
            let attributeName = NSAttributedString.Key.myAttributeName
            let attributeValue = myTextView.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: nil)
            if let value = attributeValue as? String {
                if value == "Host Policy" {
                    self.delegate?.moveToHostPolicies()
                } else if value == "Host Regulations" {
                    self.delegate?.moveToHostRegulations()
                } else if value == "Privacy Policy" {
                    self.delegate?.moveToPrivacy()
                } else if value == "Terms & Conditions" {
                    self.delegate?.moveToTerms()
                }
            }
        }
    }
    
}

extension NSAttributedString.Key {
    static let myAttributeName = NSAttributedString.Key(rawValue: "MyCustomAttribute")
}
