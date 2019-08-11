//
//  TransferOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class TransfersOptionsViewController: UIViewController {
    
    var delegate: changeTransferOptions?
    var keyboardHeight: CGFloat = 0.0
    var previousMessageHeight: CGFloat = 0.0
    
    // Potential options for payout issues the user may be experiencing
    let mainArray: [String] = ["Payments in transit",
                               "My payout information is incorrect",
                               "My bank does not show the payment was received",
                               "Contact support",
                               "How do I transfer my money?",
                               "My account information is incorrect",
                               "My wallet balance is incorrect"
    ]
    let subArray: [String] = ["In general, payments take 2-3 business days to transfer from Drivewayz' account to your account. Payments that have not yet shown up in your bank account may be in transit or delayed so we suggest waiting up to 5 business days from when the payment was initiated. Please contact Drivewayz if the payment has not shown up after the suggested arrival time.",
                              "If the payout information is incorrect it likely means that the payout failed or has been transferred to an incorrect account. We will review your payout information and attempt to fix the incorrect account if it has not already arrived in the incorrect account.",
                              "Payment transfers generally take between 2-3 business days to show up in your bank account. If it has been longer than 2-3 business days then Drivewayz will review the payout information and reach out to you with further details.",
                              "Please contact Drivewayz with any relevent payout information in regards to the issue that you are currently experiencing.",
                              "To transfer your money you can either tap the card itself or press 'Manage balance' just below the card. From there you can link a new payout method or you can easily send money to your current account.",
                              "We do not store your payout information so we are unable to edit any account information. You may delete the current account and link a new account without losing current earnings. If the issue persists please contact support below.",
                              "Your wallet balance should reflect all payments since your last payout. If you believe the balance is incorrect please contact support and we will do our best to fix the issue."]

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = ""
        label.font = Fonts.SSPRegularH2
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = ""
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 50
        
        return label
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Contact support", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(sendMessage(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var messageTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = Theme.WHITE
        view.font = Fonts.SSPRegularH5
        view.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
        view.text = "Write a message"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autocorrectionType = .default
        view.autocapitalizationType = UITextAutocapitalizationType.sentences
        view.alpha = 0
        
        return view
    }()
    
    var messageLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        view.alpha = 0
        
        return view
    }()
    
    var messageIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "sendMessageIcon")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    lazy var messageBottomBar: MessageBottomBarViewController = {
        let controller = MessageBottomBarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        self.addChild(controller)
        controller.sendButton.addTarget(self, action: #selector(sendMessage(sender:)), for: .touchUpInside)
        controller.imageIcon.alpha = 0
        controller.microphoneIcon.alpha = 0
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissEditing))
        view.addGestureRecognizer(tap)

        setupViews()
    }
    
    var messageLineTopAnchor: NSLayoutConstraint!
    var messageBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        subLabel.sizeToFit()
        
        self.view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 24).isActive = true
        mainButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 72).isActive = true
        mainButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -72).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(messageLine)
        messageLineTopAnchor = messageLine.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 156)
            messageLineTopAnchor.isActive = true
        messageLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messageLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        self.view.addSubview(messageIcon)
        messageIcon.topAnchor.constraint(equalTo: messageLine.bottomAnchor, constant: 20).isActive = true
        messageIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        messageIcon.heightAnchor.constraint(equalToConstant: 14).isActive = true
        messageIcon.widthAnchor.constraint(equalTo: messageIcon.heightAnchor).isActive = true
        
        self.view.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: messageIcon.topAnchor, constant: -12).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: messageIcon.rightAnchor, constant: 16).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        messageBottomAnchor = messageTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
            messageBottomAnchor.isActive = true
        
        self.view.addSubview(messageBottomBar.view)
        messageBottomBar.view.topAnchor.constraint(equalTo: messageTextView.bottomAnchor).isActive = true
        messageBottomBar.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageBottomBar.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messageBottomBar.view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.previousMessageHeight = messageTextView.text.height(withConstrainedWidth: phoneWidth - 46, font: Fonts.SSPSemiBoldH4)
    }
    
    func typingMessage() {
        self.messageTextView.alpha = 1
        self.messageLine.alpha = 1
        self.messageIcon.alpha = 1
        self.messageBottomBar.view.alpha = 1
    }
    
    func noMessage() {
        self.messageTextView.alpha = 0
        self.messageLine.alpha = 0
        self.messageIcon.alpha = 0
        self.messageBottomBar.view.alpha = 0
    }
    
    @objc func dismissEditing() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}


extension TransfersOptionsViewController {
    
    // Delegate which view the message is being sent from and which message to include
    @objc func sendMessage(sender: UIButton) {
        if sender == self.mainButton {
            guard let text = self.mainLabel.text else { return }
            self.contactDrivewayz(message: text, sender: sender)
        } else {
            guard let text = self.messageTextView.text else { return }
            self.contactDrivewayz(message: text, sender: sender)
        }
    }
    
    // Send the contact message
    func contactDrivewayz(message: String, sender: UIButton) {
        sender.alpha = 0.5
        sender.isUserInteractionEnabled = false
        
        if message != "" && message != "Write a message" {
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
                    let values = ["name": name,
                                  "email": email,
                                  "timestamp": timestamp,
                                  "message": message,
                                  "context": "Payout Issue",
                                  "deviceID": deviceID,
                                  "fromID": userID,
                                  "picture": picture,
                                  "communicationsStatus": "Recent"
                        ] as [String : Any]
                    
                    let messageRef = Database.database().reference().child("DrivewayzMessages").child(userID).childByAutoId()
                    messageRef.updateChildValues(values)
                    
                    messageRef.updateChildValues(values, withCompletionBlock: { (error, snap) in
                        if let key = snap.key {
                            let childRef = Database.database().reference().child("Messages").child(key)
                            childRef.updateChildValues(values, withCompletionBlock: { (error, success) in
                                sender.alpha = 1
                                sender.isUserInteractionEnabled = true
                                self.view.endEditing(true)
                                self.createSimpleAlert(title: "Sent!", message: "")
                            })
                        }
                    })
                }
            }
        } else {
            delayWithSeconds(1) {
                sender.alpha = 1
                sender.isUserInteractionEnabled = true
            }
        }
    }
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if message != "" {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            self.present(alert, animated: true)
            delayWithSeconds(1) {
                self.delegate?.dismissView()
                self.delegate?.dismissView()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}


extension TransfersOptionsViewController: UITextViewDelegate {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height - 180
            self.keyboardHeight = keyboardHeight
            self.delegate?.changeOptionsHeight(amount: keyboardHeight)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = textView.beginningOfDocument
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        if textView.text == "Write a message" {
            textView.textColor = Theme.BLACK
            textView.text = ""
        }
        self.messageLineTopAnchor.constant = 74
        self.messageBottomAnchor.constant = -290
        UIView.animate(withDuration: animationOut) {
            self.subLabel.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.changeOptionsHeight(amount: -self.keyboardHeight)
        self.messageLineTopAnchor.constant = 156
        self.messageBottomAnchor.constant = -50
        UIView.animate(withDuration: animationOut) {
            self.subLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
        if textView.text == "" {
            textView.text = "Write a message"
            textView.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.textColor = Theme.BLACK
        if textView.text == "Write a message" {
            textView.text = ""
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write a message"
            textView.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.6)
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
        let newHeight = messageTextView.text.height(withConstrainedWidth: phoneWidth - 46, font: Fonts.SSPSemiBoldH4)
        let difference = newHeight - self.previousMessageHeight
        if difference != 0 {
            self.previousMessageHeight = newHeight
            if difference >= 0 {
                self.delegate?.changeOptionsHeight(amount: difference - 2)
            } else {
                self.delegate?.changeOptionsHeight(amount: difference + 2)
            }
        }
    }
    
}
