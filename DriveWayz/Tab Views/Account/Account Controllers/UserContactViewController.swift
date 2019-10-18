//
//  ContactDrivewayzViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MessageUI

class UserContactViewController: UIViewController {
    
    var delegate: moveControllers?
    var context: String = "Help"
    var confirmedIDs: [String] = []
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        //        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Drivewayz"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()

    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 3
        label.text = "Please reach out to us with any questions or concerns."
        
        return label
    }()
    
    var supportTextLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.PRUSSIAN_BLUE
        view.text = "Share your thoughts"
        
        return view
    }()
    
    var supportTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.tintColor = Theme.BLUE
        view.font = Fonts.SSPRegularH4
        view.textColor = Theme.BLACK
        view.isScrollEnabled = false
        view.keyboardAppearance = .dark
        
        return view
    }()
    
    var supportTextLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var exampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 10
        label.textAlignment = .center
        label.text = """
        We're not perfect and we know sometimes we make mistakes. Please reach out to us and provide any necessary information in regards to the issues you are experiencing.

        Drivewayz will attempt to reach out to you in the next 1 to 2 business days.
        """
        
        return label
    }()
    
    var supportButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.isUserInteractionEnabled = false
        button.setTitle("Contact support", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        
        return button
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        supportTextView.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        setupViews()
        createToolbar()
        observeCorrectID()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(scrollView)
        view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
        }
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        }
        
        view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        scrollView.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: phoneWidth - 48).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(supportTextLabel)
        supportTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        supportTextLabel.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 16).isActive = true
        supportTextLabel.sizeToFit()
        
        scrollView.addSubview(supportTextView)
        supportTextView.topAnchor.constraint(equalTo: supportTextLabel.bottomAnchor, constant: 8).isActive = true
        supportTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        supportTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        supportTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        supportTextView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        scrollView.addSubview(supportTextLine)
        supportTextLine.leftAnchor.constraint(equalTo: supportTextView.leftAnchor).isActive = true
        supportTextLine.rightAnchor.constraint(equalTo: supportTextView.rightAnchor).isActive = true
        supportTextLine.bottomAnchor.constraint(equalTo: supportTextView.bottomAnchor).isActive = true
        supportTextLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        scrollView.addSubview(supportButton)
        supportButton.topAnchor.constraint(equalTo: supportTextView.bottomAnchor, constant: 32).isActive = true
        supportButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        supportButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        supportButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        scrollView.addSubview(exampleLabel)
        exampleLabel.topAnchor.constraint(equalTo: supportButton.bottomAnchor, constant: 32).isActive = true
        exampleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exampleLabel.widthAnchor.constraint(equalToConstant: phoneWidth - 48).isActive = true
        exampleLabel.sizeToFit()
        
    }

}

extension UserContactViewController: MFMailComposeViewControllerDelegate {
    
    @objc func sendEmail() {
        supportButton.backgroundColor = lineColor
        supportButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
        supportButton.isUserInteractionEnabled = false
        loadingLine.startAnimating()
        
        guard let message = self.supportTextView.text else { return }
        if message != "" && message != "Contact us" {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    guard let name = dictionary["name"] as? String else { return }
                    guard let deviceID = dictionary["DeviceID"] as? String else { return }
                    var email = ""
                    if let mail = dictionary["email"] as? String {
                        email = mail
                    }
                    var picture = ""
                    if let photo = dictionary["picture"] as? String {
                        picture = photo
                    }
                    let timestamp = Date().timeIntervalSince1970
                    let values = ["name": name, "email": email, "timestamp": timestamp, "message": message, "context": self.context, "deviceID": deviceID, "fromID": userID, "picture": picture, "communicationsStatus": "Recent"] as [String : AnyObject]
                    
                    let messageRef = Database.database().reference().child("DrivewayzMessages").child(userID).childByAutoId()
                    messageRef.updateChildValues(values)
                    
                    messageRef.updateChildValues(values, withCompletionBlock: { (error, snap) in
                        if let key = snap.key {
                            let childRef = Database.database().reference().child("Messages").child(key)
                            childRef.updateChildValues(values, withCompletionBlock: { (error, success) in
                                self.supportButton.backgroundColor = lineColor
                                self.supportButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                                self.supportButton.isUserInteractionEnabled = true
                                self.loadingLine.endAnimating()
                                self.view.endEditing(true)
                                self.createSimpleAlert(title: "Sent!", message: "")
                                self.backButtonPressed()
                                self.supportTextView.text = ""
                            })
                        }
                    })
                }
            }
        } else {
            createSimpleAlert(title: "No message", message: "")
            supportButton.backgroundColor = lineColor
            supportButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            supportButton.isUserInteractionEnabled = true
            loadingLine.endAnimating()
        }
    }
    
    func observeCorrectID() {
        confirmedIDs = []
        let ref = Database.database().reference().child("ConfirmedID")
        ref.observe(.childAdded) { (snapshot) in
            if let key = snapshot.value as? String {
                self.confirmedIDs.append(key)
            }
        }
    }
    
}


extension UserContactViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        supportTextLine.backgroundColor = Theme.BLUE
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        supportTextLine.backgroundColor = lineColor
    }
    
    // Determine the size of the textview so that it adjusts as the user types
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: phoneWidth - 40, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let estimatedHeight = estimatedSize.height
        if textView.text != "" {
            supportButton.backgroundColor = Theme.BLUE
            supportButton.setTitleColor(Theme.WHITE, for: .normal)
            supportButton.isUserInteractionEnabled = true
        } else {
            supportButton.backgroundColor = lineColor
            supportButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            supportButton.isUserInteractionEnabled = false
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
            self.scrollView.contentInset = .zero
        } else {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        
        //        let selectedRange = self.supportTextView.selectedRange
        //        self.supportTextView.scrollRangeToVisible(selectedRange)
    }
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        supportTextView.inputAccessoryView = toolBar
    }
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if message != "" {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            self.present(alert, animated: true)
            delayWithSeconds(1) {
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerForNotifications"), object: nil)
                })
            }
        }
    }
    
    @objc func backButtonPressed() {
        if delegate != nil {
            self.delegate?.dismissActiveController()
            self.dismiss(animated: true) {
//                self.backButton.alpha = 0
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension UserContactViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
