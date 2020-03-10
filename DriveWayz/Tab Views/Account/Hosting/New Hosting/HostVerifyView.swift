//
//  HostVerifyView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol HostVerifyDelegate {
    func removeDim()
    func changeMessage(promotional: Bool)
    func adjustForKeyboard(notification: Notification)
    func moveToFinish()
}

var hostMessage: String?
var promotionalMessage: Bool = false
var hostEmail: String?

class HostVerifyView: UIViewController {
     
    let center = UNUserNotificationCenter.current()

    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = ""
        controller.setBackButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 900
        
        return controller
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var instructionsController: VerifyInstructionsView = {
        let controller = VerifyInstructionsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        controller.informationIcon.addTarget(self, action: #selector(instructionsInformationPressed), for: .touchUpInside)
        
        return controller
    }()
    
    lazy var messageController: VerifyMessageView = {
        let controller = VerifyMessageView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        controller.informationIcon.addTarget(self, action: #selector(messageInformationPressed), for: .touchUpInside)
        
        return controller
    }()
    
    lazy var emailController: VerifyEmailView = {
        let controller = VerifyEmailView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BACKGROUND_GRAY.withAlphaComponent(0), bottomColor: Theme.BACKGROUND_GRAY)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: abs(cancelBottomHeight * 2) + 16)
        background.zPosition = 10
        view.layer.addSublayer(background)
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    let paging: ProgressPagingDisplay = {
        let view = ProgressPagingDisplay()
        view.changeProgress(index: 4)
        view.alpha = 0
        
        return view
    }()
    
    // Rest of the Host Signup process
    var hostNotificationsController = HostNotificationsView()
    var hostFinishController = HostFinishListingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        gradientController.scrollView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(progressTapped))
        paging.addGestureRecognizer(tap)

        setupViews()
        setupControllers()
    }
    
    @objc func progressTapped() {
        let controller = HostProgressView()
        controller.shouldDismiss = true
        controller.progressController.fifthStep()
        present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gradientController.scrollView.scrollToTop(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text == "" {
             gradientController.animateText(text: "Verify listing")
             delayWithSeconds(animationOut) {
                if self.instructionsController.switchButton.isOn {
                    self.gradientController.setSublabel(text: "Parking instructions")
                } else {
                    self.gradientController.setSublabel(text: "Parking description")
                }
                UIView.animate(withDuration: animationIn) {
                    self.paging.alpha = 1
                    self.view.layoutIfNeeded()
                }
                if self.nextButton.tintColor != Theme.WHITE {
                    self.showNextButton()
                }
                self.animate()
             }
         } else {
            removeDim()
            showNextButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gradientController.scrollView.scrollToTop(animated: true)
    }
    
    var nextButtonBottomAnchor: NSLayoutConstraint!
    var nextButtonKeyboardAnchor: NSLayoutConstraint!
    var nextButtonRightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        view.addSubview(gradientController.view)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        gradientController.view.addSubview(paging)
        paging.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paging.centerYAnchor.constraint(equalTo: gradientController.backButton.centerYAnchor).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 86).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(blurView)
        blurView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: abs(cancelBottomHeight * 2) + 16)
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
    }
    
    var instructionsLeftAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        gradientController.scrollView.addSubview(instructionsController.view)
        instructionsController.view.topAnchor.constraint(equalTo: gradientController.scrollView.topAnchor).isActive = true
        instructionsLeftAnchor = instructionsController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
            instructionsLeftAnchor.isActive = true
        instructionsController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        instructionsController.view.heightAnchor.constraint(equalToConstant: 116).isActive = true
        
        gradientController.scrollView.addSubview(messageController.view)
        messageController.view.anchor(top: instructionsController.view.bottomAnchor, left: instructionsController.view.leftAnchor, bottom: view.bottomAnchor, right: instructionsController.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        gradientController.scrollView.addSubview(emailController.view)
        emailController.view.topAnchor.constraint(equalTo: gradientController.scrollView.topAnchor).isActive = true
        emailController.view.leftAnchor.constraint(equalTo: instructionsController.view.rightAnchor).isActive = true
        emailController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        emailController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        view.addSubview(dimView)
    }
    
    @objc func nextButtonPressed() {
        gradientController.scrollView.scrollToTop(animated: true)
        nextButton.isUserInteractionEnabled = false
        switch mainTypeState {
        case .message:
            moveToEmail()
        case .email:
            confirmEmail()
        default:
            nextButton.isUserInteractionEnabled = true
            return
        }
    }
    
    func moveToFinish() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                DispatchQueue.main.async {
                    mainTypeState = .notifications
                    self.hideNextButton(completion: {})
                    delayWithSeconds(animationOut + animationIn/2) {
                        self.dimBackground()
                        self.hostNotificationsController.delegate = self
                        let navigation = UINavigationController(rootViewController: self.hostNotificationsController)
                        navigation.navigationBar.isHidden = true
                        navigation.presentationController?.delegate = self.hostNotificationsController
                        self.present(navigation, animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    mainTypeState = .finish
                    self.hideNextButton(completion: {})
                    delayWithSeconds(animationOut + animationIn/2) {
                        self.dimBackground()
                        self.hostFinishController.delegate = self
                        let navigation = UINavigationController(rootViewController: self.hostFinishController)
                        navigation.navigationBar.isHidden = true
                        navigation.presentationController?.delegate = self.hostFinishController
                        self.present(navigation, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func confirmEmail() {
        let check = emailController.checkEmail()
        if check {
            dimBackground()
            let controller = ConfirmEmailView()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            present(controller, animated: true) {
                self.nextButton.isUserInteractionEnabled = true
                if let text = self.emailController.mainTextView.lineTextView?.text {
                    hostEmail = text
                }
            }
        } else {
            nextButton.isUserInteractionEnabled = true
        }
    }
    
    func moveToEmail() {
        let check = messageController.checkMessage()
        if check {
            mainTypeState = .email
            instructionsLeftAnchor.constant = -phoneWidth
            gradientController.setSublabel(text: "Enter your email address")
            UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.instructionsController.view.alpha = 0
                self.messageController.view.alpha = 0
                self.emailController.view.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                self.nextButton.isUserInteractionEnabled = true
                self.emailController.mainTextView.lineTextView?.becomeFirstResponder()
                
                if let text = self.messageController.mainTextView.lineTextView?.text {
                    hostMessage = text
                    promotionalMessage = !self.instructionsController.switchButton.isOn
                }
            }
        } else {
            nextButton.isUserInteractionEnabled = true
        }
    }
    
    func moveToMessage() {
        mainTypeState = .message
        instructionsLeftAnchor.constant = 0
        if instructionsController.switchButton.isOn {
            gradientController.setSublabel(text: "Parking instructions")
        } else {
            gradientController.setSublabel(text: "Parking description")
        }
        UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.instructionsController.view.alpha = 1
            self.messageController.view.alpha = 1
            self.emailController.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.gradientController.backButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func backButtonPressed() {
        view.endEditing(true)
        gradientController.backButton.isUserInteractionEnabled = false
        switch mainTypeState {
        case .message:
            mainTypeState = .availability
            gradientController.backButton.isUserInteractionEnabled = true
            navigationController?.popViewController(animated: true)
        case .email:
            moveToMessage()
        default:
            gradientController.backButton.isUserInteractionEnabled = true
            return
        }
    }
    
    @objc func instructionsInformationPressed() {
        dimBackground()
        delayWithSeconds(animationIn) {
            let controller = VerifyInformationView()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            controller.informationIndex = 0
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func messageInformationPressed() {
        let controller = VerifyInformationView()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        
        if instructionsController.switchButton.isOn {
             controller.informationIndex = 1
        } else {
            controller.informationIndex = 2
        }
        dimBackground()
        delayWithSeconds(animationIn) {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func showNextButton() {
        nextButton.alpha = 1
        nextButtonRightAnchor.constant = phoneWidth/2
        view.layoutIfNeeded()
        
        nextButtonRightAnchor.constant = -20
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                if mainTypeState == .pictures {
                    self.nextButton.tintColor = Theme.BLACK
                } else {
                    self.nextButton.tintColor = Theme.WHITE
                }
            }) { (success) in
                self.nextButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func hideNextButton(completion: @escaping() -> Void) {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.BLACK
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                completion()
            }
        }
    }
    
    func animate() {
        UIView.animate(withDuration: animationOut, animations: {
            self.instructionsController.view.alpha = 1
            self.messageController.view.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func dimBackground() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0.7
        }
    }
    
}

extension HostVerifyView: HostVerifyDelegate, HandlePresentingNotifications {
    
    func removeDim() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0
        }
    }

    func changeMessage(promotional: Bool) {
        if promotional {
            messageController.mainLabel.text = "Promotional message"
            gradientController.subLabel.text = "Parking description"
        } else {
            messageController.mainLabel.text = "Instructional message"
            gradientController.subLabel.text = "Parking instructions"
        }
    }
    
    func presentingNotificationsDismissed() {
        removeDim()
        showNextButton()
    }
    
}

extension HostVerifyView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight - (gradientController.gradientNewHeight - gradientHeight + 60) * percent
                gradientController.subLabelBottom.constant = gradientController.subHeight * percent
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                if percent >= 0 && percent <= 0.3 {
                    let percentage = percent/0.3
                    gradientController.subLabel.alpha = 1 - 1 * percentage
                    paging.alpha = 1 - 1 * percentage
                } else if percent >= 0 {
                    gradientController.subLabel.alpha = 0
                    paging.alpha = 0
                }
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientController.gradientNewHeight {
                scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        gradientController.subLabelBottom.constant = 0
        gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gradientController.subLabel.alpha = 1
            self.paging.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.subLabelBottom.constant = gradientController.subHeight
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.gradientController.subLabel.alpha = 0
            self.paging.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    // Handle when the keyboard is activated so that the textview is always visible
    func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if emailController.view.alpha == 1 {
            let height = keyboardViewEndFrame.height
            
            if notification.name == UIResponder.keyboardWillHideNotification {
                nextButtonBottomAnchor.isActive = true
                nextButtonKeyboardAnchor.isActive = false
    //            detailsController.spotView.switchButton.isUserInteractionEnabled = true
            } else {
                nextButtonBottomAnchor.isActive = false
                nextButtonKeyboardAnchor.isActive = true
                nextButtonKeyboardAnchor.constant = -height - 16
    //            detailsController.spotView.switchButton.isUserInteractionEnabled = false
            }
            UIView.animate(withDuration: animationOut) {
                self.view.layoutIfNeeded()
            }
        } else {
            if notification.name == UIResponder.keyboardWillHideNotification {
                gradientController.scrollView.contentInset = .zero
            } else {
                gradientController.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 60, right: 0)
            }
            
            gradientController.scrollView.scrollIndicatorInsets = gradientController.scrollView.contentInset
        }
    }
    
}
