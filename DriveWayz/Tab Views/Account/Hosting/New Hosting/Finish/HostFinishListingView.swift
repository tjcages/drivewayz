//
//  HostFinishListingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import AudioToolbox

class HostFinishListingView: UIViewController {
    
    var delegate: HandlePresentingNotifications?
    
    private let fireworkController = ClassicFireworkController()
    var successfulListingController: SuccessfulListingView?
    
    let center = UNUserNotificationCenter.current()
    var finishAllowed: Bool = false {
        didSet {
            if finishAllowed {
                mainButtonAvailable()
            } else {
                mainButtonUnvailable()
            }
        }
    }
    
    lazy var width: CGFloat = phoneWidth
    
    let gradientContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.HOST_BLUE
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 20
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Congrats, your spot is \nready to be listed!"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH1
        label.numberOfLines = 2
        label.alpha = 0
        
        return label
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz will verify the spot and \nsend a code to the email provided \nto confirm the listing."
        label.textColor = Theme.DARK_GRAY
        label.numberOfLines = 3
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        
        return label
    }()

    lazy var bottomController: HostOnboardingBottomView = {
        let controller = HostOnboardingBottomView()
        self.addChild(controller)
        controller.mainButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        controller.mainIcon.alpha = 0
        controller.mainButton.setTitle("List Your Spot", for: .normal)
        controller.hostPoliciesLabel.text = ""
        controller.view.backgroundColor = .clear
        
        return controller
    }()
    
    var hostGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "listingGraphic")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    lazy var mainPoliciesCheck: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.borderWidth = 0
        check.borderStyle = .roundedSquare(radius: 2)
        check.checkedBorderColor = Theme.BLUE
        check.uncheckedBorderColor = lineColor
        check.backgroundColor = lineColor
        check.layer.cornerRadius = 2
        check.clipsToBounds = true
        check.checkmarkColor = Theme.WHITE
        check.isChecked = false
        check.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        
        return check
    }()
    
    var mainPoliciesLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.isSelectable = false
        let string = "I agree to the Privacy Policy and \nTerms & Conditions."
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
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var hostPoliciesCheck: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.borderWidth = 0
        check.borderStyle = .roundedSquare(radius: 2)
        check.checkedBorderColor = Theme.BLUE
        check.uncheckedBorderColor = lineColor
        check.backgroundColor = lineColor
        check.layer.cornerRadius = 2
        check.clipsToBounds = true
        check.checkmarkColor = Theme.WHITE
        check.isChecked = false
        check.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        
        return check
    }()
    
    var hostPoliciesLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.isSelectable = false
        let string = "I have read and agree to the \nHost Policy and Host Regulations."
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
        label.backgroundColor = .clear
        
        return label
    }()
    
    var fireworksView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = false
        }
        
        view.clipsToBounds = false
        view.backgroundColor = Theme.WHITE
        
        finishAllowed = false
        
        let mainTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        mainTap.delegate = self
        mainPoliciesLabel.addGestureRecognizer(mainTap)
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        hostTap.delegate = self
        hostPoliciesLabel.addGestureRecognizer(hostTap)

        setupViews()
        setupControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainLabelLeftAnchor.constant = 20
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.alpha = 1
            self.subLabel.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.shootFireworks()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mainLabelLeftAnchor.constant = -40
        self.mainLabel.alpha = 0
        self.subLabel.alpha = 0
    }
    
    var mainLabelLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(gradientContainer)
        view.addSubview(hostGraphic)
        view.addSubview(bottomController.view)
        view.addSubview(container)
        
        gradientContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        gradientContainer.bottomAnchor.constraint(equalTo: hostGraphic.bottomAnchor).isActive = true
        
        view.addSubview(backButton)
        switch device {
        case .iphone8:
            backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        case .iphoneX:
            backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        }
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        mainLabelLeftAnchor = mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -40)
            mainLabelLeftAnchor.isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        mainLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.sizeToFit()
        
        hostGraphic.bottomAnchor.constraint(equalTo: container.topAnchor).isActive = true
        hostGraphic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hostGraphic.widthAnchor.constraint(equalToConstant: width).isActive = true
        if let image = hostGraphic.image {
            let scale = image.size.height/image.size.width
            hostGraphic.heightAnchor.constraint(equalToConstant: width * scale).isActive = true
        }
        
        view.addSubview(fireworksView)
        fireworksView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fireworksView.centerYAnchor.constraint(equalTo: hostGraphic.centerYAnchor, constant: -40).isActive = true
        fireworksView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        fireworksView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupControllers() {
        
        bottomController.view.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bottomController.view.heightAnchor.constraint(equalToConstant: bottomController.bottomHeight - 92).isActive = true
        
        container.anchor(top: nil, left: view.leftAnchor, bottom: bottomController.view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 152)
        
        view.addSubview(mainPoliciesCheck)
        mainPoliciesCheck.anchor(top: nil, left: view.leftAnchor, bottom: container.centerYAnchor, right: nil, paddingTop: 48, paddingLeft: 32, paddingBottom: 16, paddingRight: 0, width: 25, height: 25)
        
        view.addSubview(mainPoliciesLabel)
        mainPoliciesLabel.leftAnchor.constraint(equalTo: mainPoliciesCheck.rightAnchor, constant: 16).isActive = true
        mainPoliciesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainPoliciesLabel.centerYAnchor.constraint(equalTo: mainPoliciesCheck.centerYAnchor).isActive = true
        mainPoliciesLabel.sizeToFit()
        
        view.addSubview(hostPoliciesCheck)
        hostPoliciesCheck.anchor(top: mainPoliciesCheck.bottomAnchor, left: mainPoliciesCheck.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        hostPoliciesCheck.leftAnchor.constraint(equalTo: mainPoliciesCheck.leftAnchor).isActive = true
        hostPoliciesCheck.topAnchor.constraint(equalTo: mainPoliciesCheck.bottomAnchor, constant: 32).isActive = true
        hostPoliciesCheck.heightAnchor.constraint(equalToConstant: 25).isActive = true
        hostPoliciesCheck.widthAnchor.constraint(equalTo: mainPoliciesCheck.heightAnchor).isActive = true
        
        view.addSubview(hostPoliciesLabel)
        hostPoliciesLabel.leftAnchor.constraint(equalTo: hostPoliciesCheck.rightAnchor, constant: 16).isActive = true
        hostPoliciesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        hostPoliciesLabel.centerYAnchor.constraint(equalTo: hostPoliciesCheck.centerYAnchor).isActive = true
        hostPoliciesLabel.sizeToFit()
        
    }
    
    @objc func nextButtonPressed() {
        configureNewParking()
        
        let controller = SuccessfulListingView()
        successfulListingController = controller
        controller.loadingActivity.startAnimating()
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true) {
            
        }
    }
    
    @objc func dismissController() {
        mainTypeState = .email
        delegate?.presentingNotificationsDismissed()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        if sender.isChecked {
            sender.backgroundColor = Theme.BLUE
        } else {
            sender.backgroundColor = lineColor
        }
        if mainPoliciesCheck.isChecked == true && hostPoliciesCheck.isChecked == true {
            finishAllowed = true
            if gradientContainer.backgroundColor == Theme.HOST_BLUE {
                UIView.animate(withDuration: animationOut) {
                    self.gradientContainer.backgroundColor = Theme.HOST_RED
                }
            }
        } else {
            finishAllowed = false
            if gradientContainer.backgroundColor == Theme.HOST_RED {
                UIView.animate(withDuration: animationOut) {
                    self.gradientContainer.backgroundColor = Theme.HOST_BLUE
                }
            }
        }
    }
    
    func mainButtonAvailable() {
        bottomController.mainButton.backgroundColor = Theme.DARK_GRAY
        bottomController.mainButton.setTitleColor(Theme.WHITE, for: .normal)
        bottomController.mainButton.isUserInteractionEnabled = true
    }
    
    func mainButtonUnvailable() {
        bottomController.mainButton.backgroundColor = lineColor
        bottomController.mainButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
        bottomController.mainButton.isUserInteractionEnabled = false
    }

    func shootFireworks() {
        fireworkController.addFireworks(count: 4, sparks: 8, around: fireworksView)
        AudioServicesPlaySystemSound(1520) // Vibration feedback (strong boom)
        delayWithSeconds(animationIn) {
            self.fireworkController.addFireworks(count: 4, sparks: 8, around: self.fireworksView)
            AudioServicesPlaySystemSound(1519) // Vibration feedback (weak boom)
            delayWithSeconds(animationIn * 2) {
                self.fireworkController.addFireworks(count: 3, sparks: 8, around: self.fireworksView)
                AudioServicesPlaySystemSound(1519) // Vibration feedback (weak boom)
                delayWithSeconds(animationIn) {
                    self.fireworkController.addFireworks(count: 3, sparks: 8, around: self.fireworksView)
                    AudioServicesPlaySystemSound(1519) // Vibration feedback (weak boom)
                    delayWithSeconds(animationIn + 1) {
                        self.fireworkController.addFireworks(count: 3, sparks: 6, around: self.fireworksView)
                        AudioServicesPlaySystemSound(1519) // Vibration feedback (weak boom)
                        delayWithSeconds(animationIn * 2) {
                            self.fireworkController.addFireworks(count: 3, sparks: 6, around: self.fireworksView)
                            AudioServicesPlaySystemSound(1519) // Vibration feedback (weak boom)
                            delayWithSeconds(animationIn) {
                                self.fireworkController.addFireworks(count: 3, sparks: 6, around: self.fireworksView)
                                AudioServicesPlaySystemSound(1519) // Vibration feedback (weak boom)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension HostFinishListingView: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        mainTypeState = .email
        delegate?.presentingNotificationsDismissed()
        mainLabelLeftAnchor.constant = -40
        mainLabel.alpha = 0
        subLabel.alpha = 0
    }
}

extension HostFinishListingView: UIGestureRecognizerDelegate {
    
    func moveToSettings(message: String) {
        let alertController = UIAlertController (title: "Enable notifications", message: message, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
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
                    moveToHostPolicies()
                } else if value == "Host Regulations" {
                    moveToHostRegulations()
                } else if value == "Privacy Policy" {
                    moveToPrivacy()
                } else if value == "Terms & Conditions" {
                    moveToTerms()
                }
            }
        }
    }
    
    func moveToTerms() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/terms.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToPrivacy() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/privacy.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostPolicies() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/host-policies.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostRegulations() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/rules--regulations.html")
        controller.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
