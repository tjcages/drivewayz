//
//  ViewNotificationsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostResponsibilities {
    func dismissView()
}

class GeneralNotificationViewController: UIViewController, handleHostResponsibilities {

    var delegate: handleHostNotifications?
    var bottomAnchor: CGFloat = 0.0
    var counterClockwise: Bool = true
    var verification: Bool = false
    var shouldDismiss: Bool = true
    var mainColor: UIColor = Theme.BLUE
    
    var notificationType: String = "general" {
        didSet {
            if self.notificationType == "newHost" {
                self.hostResponsibilities.view.alpha = 1
            } else if self.notificationType == "leftReviewGood" || self.notificationType == "leftReviewPoor" {
                self.generalButton.setTitle("See more information", for: .normal)
            } else if self.notificationType == "userParked" {
                self.generalButton.setTitle("See more information", for: .normal)
            } else if self.notificationType == "notification" {
                self.generalButton.setTitle("Open direct messages", for: .normal)
            } else if self.notificationType == "mailbox" {
                self.openVerification()
            } else if self.notificationType == "plane" {
                self.generalButton.setTitle("FAQs", for: .normal)
            }
        }
    }
    
    var notification: HostNotifications? {
        didSet {
            if let notification = self.notification, let title = notification.title, let subTitle = notification.subtitle, let image = notification.notificationImage, let colors = notification.containerGradient, let notificationType = notification.notificationType, let type = notification.type {
                self.notificationLabel.text = title
                self.notificationSubLabel.text = subTitle
                if let mainColors = colors.first {
                    let topColor = mainColors.key
                    let bottomColor = mainColors.value
                    self.mainColor = bottomColor
                    let background = CAGradientLayer().customColor(topColor: topColor, bottomColor: bottomColor)
                    background.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
                    background.zPosition = -10
                    self.gradientView.layer.addSublayer(background)
                    let background2 = CAGradientLayer().customColor(topColor: topColor, bottomColor: bottomColor)
                    background2.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
                    background2.zPosition = -10
                    self.fadedGradientView.layer.addSublayer(background2)
                    self.iconImageView.image = image
                    self.generalButton.backgroundColor = bottomColor
                    switch type {
                    case .urgent:
                        self.generalButton.alpha = 1
                    case .important:
                        self.generalButton.alpha = 1
                    case .moderate:
                        self.generalButton.alpha = 1
                    case .mild:
                        self.generalButton.alpha = 1
                    default:
                        self.generalButton.alpha = 0
                    }
                    self.notificationType = notificationType
                }
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
    
    var gradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 38
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var fadedGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.5
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-plant")
        view.image = image
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = ""
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var notificationSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = ""
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    var generalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fix general issue", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 55/2
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.addTarget(self, action: #selector(generalButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var hostResponsibilities: HostResponsibilitiesViewController = {
        let controller = HostResponsibilitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    var verificationTextLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK.withAlphaComponent(0.6)
        view.text = "Enter verification code from email"
        view.alpha = 0
        
        return view
    }()
    
    var verificationTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4.withAlphaComponent(0.2)
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.tintColor = Theme.BLUE
        view.font = Fonts.SSPRegularH4
        view.textColor = Theme.BLACK
        view.isScrollEnabled = false
        view.keyboardAppearance = .dark
        view.autocorrectionType = .no
        view.autocapitalizationType = .allCharacters
        view.alpha = 0
        
        return view
    }()
    
    var verificationTextLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verificationTextView.delegate = self
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
        setupVerification()
        setupGeneral()
        setupControllers()
        animateCirclesClockwise(counterClockwise: self.counterClockwise)
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(dimView)
        self.view.addSubview(container)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        container.addGestureRecognizer(tap)
        
        container.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        switch device {
        case .iphone8:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -32
        case .iphoneX:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -52)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -52
        }
        
        container.addSubview(generalButton)
        generalButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -4).isActive = true
        generalButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 48).isActive = true
        generalButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -48).isActive = true
        generalButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
    }
    
    func setupVerification() {
        
        container.addSubview(verificationTextView)
        verificationTextView.bottomAnchor.constraint(equalTo: generalButton.topAnchor, constant: -32).isActive = true
        verificationTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        verificationTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        verificationTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        verificationTextView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        container.addSubview(verificationTextLine)
        verificationTextLine.leftAnchor.constraint(equalTo: verificationTextView.leftAnchor).isActive = true
        verificationTextLine.rightAnchor.constraint(equalTo: verificationTextView.rightAnchor).isActive = true
        verificationTextLine.bottomAnchor.constraint(equalTo: verificationTextView.bottomAnchor).isActive = true
        verificationTextLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        container.addSubview(verificationTextLabel)
        verificationTextLabel.leftAnchor.constraint(equalTo: verificationTextView.leftAnchor).isActive = true
        verificationTextLabel.bottomAnchor.constraint(equalTo: verificationTextView.topAnchor, constant: -8).isActive = true
        verificationTextLabel.sizeToFit()
        
        container.addSubview(loadingLine)
        loadingLine.bottomAnchor.constraint(equalTo: verificationTextLine.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: verificationTextLine.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: verificationTextLine.rightAnchor).isActive = true
        loadingLine.topAnchor.constraint(equalTo: verificationTextLine.topAnchor).isActive = true
        
    }
    
    var verificationAnchor: NSLayoutConstraint!
    var noVerificationAnchor: NSLayoutConstraint!
    
    func setupGeneral() {
        
        container.addSubview(notificationSubLabel)
        notificationSubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        notificationSubLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        notificationSubLabel.sizeToFit()
        if self.verification == true {
            notificationSubLabel.bottomAnchor.constraint(equalTo: verificationTextLabel.topAnchor, constant: -48).isActive = true
        } else {
            notificationSubLabel.bottomAnchor.constraint(equalTo: generalButton.topAnchor, constant: -32).isActive = true
        }

        container.addSubview(notificationLabel)
        notificationLabel.bottomAnchor.constraint(equalTo: notificationSubLabel.topAnchor).isActive = true
        notificationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        notificationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        notificationLabel.sizeToFit()
        
        container.addSubview(gradientView)
        gradientView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: notificationLabel.topAnchor, constant: -12).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        gradientView.widthAnchor.constraint(equalTo: gradientView.heightAnchor).isActive = true
        
        container.addSubview(fadedGradientView)
        container.sendSubviewToBack(fadedGradientView)
        fadedGradientView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 0).isActive = true
        fadedGradientView.leftAnchor.constraint(equalTo: gradientView.leftAnchor, constant: 0).isActive = true
        fadedGradientView.rightAnchor.constraint(equalTo: gradientView.rightAnchor, constant: 0).isActive = true
        fadedGradientView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 0).isActive = true

        container.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 12).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: gradientView.leftAnchor, constant: 12).isActive = true
        iconImageView.rightAnchor.constraint(equalTo: gradientView.rightAnchor, constant: -12).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -12).isActive = true

        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: -24).isActive = true
        
    }
    
    func setupControllers() {
        
        self.view.addSubview(hostResponsibilities.view)
        hostResponsibilities.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight).isActive = true
        hostResponsibilities.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostResponsibilities.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostResponsibilities.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hostResponsibilities.exitButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        hostResponsibilities.cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
    }
    
    func checkVerification() {
        self.loadingLine.startAnimating()
        self.generalButton.isUserInteractionEnabled = false
        self.generalButton.alpha = 0.5
        
        let code = self.verificationTextView.text
        guard let userId = Auth.auth().currentUser?.uid else { return }
        if let notification = self.notification, let notificationId = notification.key {
            let ref = Database.database().reference().child("users").child(userId).child("Hosting Spots")
            ref.observe(.childAdded) { (snapshot) in
                let key = snapshot.key
                let hostRef = Database.database().reference().child("ParkingSpots").child(key)
                hostRef.child("emailVerification").observe(.value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        if let verification = dictionary["code"] as? String {
                            if verification == code {
                                hostRef.child("Notifications").child(notificationId).updateChildValues(["urgency": "unimportant"])
                                hostRef.child("Notifications").child(notificationId).updateChildValues(["title": "Congrats!",
                                                                                                        "subtitle": "Your new space is listed",
                                                                                                        "notificationType": "search"
                                    ])
                                hostRef.child("emailVerification").removeValue()
                                
                                delayWithSeconds(1, completion: {
                                    self.delegate?.observeData()
                                    self.createSimpleAlert(title: "Email address was successfully verified!", message: "Your spot is now successfully listed")
                                    delayWithSeconds(2.2, completion: {
                                        self.dismissView()
                                    })
                                })
                            } else {
                                self.createSimpleAlert(title: "The verification code was incorrect", message: "")
                            }
                        } else {
                            self.createSimpleAlert(title: "The verification code has been deactivated", message: "")
                            return
                        }
                    }
                })
            }
        }
    }
    
    func openVerification() {
        self.verification = true
        self.verificationTextLabel.alpha = 1
        self.verificationTextView.alpha = 1
        self.verificationTextLine.alpha = 1
        self.loadingLine.alpha = 1
        self.generalButton.setTitle("Check verification code", for: .normal)
        self.generalButton.backgroundColor = Theme.LINE_GRAY
        self.generalButton.setTitleColor(Theme.BLACK, for: .normal)
        self.generalButton.isUserInteractionEnabled = false
        self.verificationTextView.tintColor = self.mainColor
        self.createToolbar()
    }
    
    func closeVerification() {
        self.verification = false
        self.verificationTextLabel.alpha = 0
        self.verificationTextView.alpha = 0
        self.verificationTextLine.alpha = 0
    }
    
    func animateCirclesClockwise(counterClockwise: Bool) {
        var multiplier: CGFloat = 1
        if counterClockwise == true {
            self.counterClockwise = false
            multiplier = -1
        } else { self.counterClockwise = true }
        UIView.animate(withDuration: 2, animations: {
            self.gradientView.transform = CGAffineTransform(rotationAngle: multiplier * CGFloat.pi/2)
            self.fadedGradientView.transform = CGAffineTransform(rotationAngle: -multiplier * CGFloat.pi/4)
        }) { (success) in
            self.animateCirclesClockwise(counterClockwise: self.counterClockwise)
        }
    }
    
    @objc func generalButtonPressed(sender: UIButton) {
        if let title = sender.titleLabel?.text {
            if title == "FAQs" {
                self.pushFAQ()
            } else if title == "Open direct messages" {
                self.pushDirectMessage()
            } else if title == "Check verification code" {
                self.checkVerification()
            }
        }
    }
    
    func pushDirectMessage() {
        self.dismissView()
        delayWithSeconds(animationOut) {
            self.delegate?.moveToInbox()
        }
    }
    
    func pushFAQ() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/faqs.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
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
                }
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        delayWithSeconds(2) {
            self.loadingLine.endAnimating()
            self.generalButton.isUserInteractionEnabled = true
            self.generalButton.alpha = 1
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dismissView() {
        self.delegate?.closeBackground()
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension GeneralNotificationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.shouldDismiss = false
        textView.backgroundColor = self.mainColor.withAlphaComponent(0.1)
        self.verificationTextLine.backgroundColor = self.mainColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.shouldDismiss = true
        textView.backgroundColor = Theme.GRAY_WHITE_4.withAlphaComponent(0.2)
        self.verificationTextLine.backgroundColor = Theme.LINE_GRAY
    }
    
    // Determine the size of the textview so that it adjusts as the user types
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: phoneWidth - 64, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let estimatedHeight = estimatedSize.height
        if textView == self.verificationTextView {
            if textView.text != "" {
                self.generalButton.backgroundColor = self.mainColor
                self.generalButton.setTitleColor(Theme.WHITE, for: .normal)
                self.generalButton.isUserInteractionEnabled = true
            } else {
                self.generalButton.backgroundColor = Theme.LINE_GRAY
                self.generalButton.setTitleColor(Theme.BLACK, for: .normal)
                self.generalButton.isUserInteractionEnabled = false
            }
        }
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedHeight >= 110 {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.profitsBottomAnchor.constant = self.bottomAnchor
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.profitsBottomAnchor.constant = -(keyboardViewEndFrame.height - view.safeAreaInsets.bottom - 88)
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.BLACK.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        verificationTextView.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
