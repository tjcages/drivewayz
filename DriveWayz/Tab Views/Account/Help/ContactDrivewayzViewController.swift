//
//  ContactDrivewayzViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MessageUI

class ContactDrivewayzViewController: UIViewController {
    
    var context: String = "Help"
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPSemiBoldH4
        label.numberOfLines = 2
        label.text = "Please reach out to us with any questions or concerns"
        
        return label
    }()
    
    var message: UITextView = {
        let field = UITextView()
        field.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        field.text = "Contact us"
        field.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        field.font = Fonts.SSPRegularH5
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 4
        field.tintColor = Theme.PACIFIC_BLUE
        field.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
        
        return field
    }()
    
    var exampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 8
        label.text = """
        We're not perfect and we know sometimes we make mistakes. Please reach out to us and provide any necessary information in regards to the issues you are experiencing.

        Drivewayz will attempt to reach out to you in the next 1 to 2 business days.
        """
        
        return label
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
//        button.clipsToBounds = true
        button.alpha = 0.5
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        
        message.delegate = self

        setupViews()
        createKeyboardButton()
    }
    
    func setupViews() {
        
        self.view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        informationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 48).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(message)
        message.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 20).isActive = true
        message.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        message.widthAnchor.constraint(equalToConstant: 328).isActive = true
        message.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        self.view.addSubview(exampleLabel)
        exampleLabel.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 8).isActive = true
        exampleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        exampleLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 60).isActive = true
        exampleLabel.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        self.view.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        sendButton.topAnchor.constraint(equalTo: exampleLabel.bottomAnchor, constant: 12).isActive = true
        
    }
    
    func createKeyboardButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = false
        keyboardToolbar.barTintColor = Theme.BLUE
        keyboardToolbar.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 45)
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(sendEmail)
        )
        addButton.tintColor = Theme.WHITE
        addButton.title = "Send"
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let flexibleSpace2 = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        keyboardToolbar.items = [flexibleSpace, addButton, flexibleSpace2]
        message.inputAccessoryView = keyboardToolbar
    }
    
}

extension ContactDrivewayzViewController: MFMailComposeViewControllerDelegate {
    
    @objc func sendEmail() {
        self.sendButton.alpha = 0.5
        self.sendButton.isUserInteractionEnabled = false
        
        guard let message = self.message.text else { return }
        if message != "" && message != "Contact us" {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    guard let name = dictionary["name"] as? String else { return }
                    var email = ""
                    if let mail = dictionary["email"] as? String {
                        email = mail
                    }
                    let timestamp = Date().timeIntervalSince1970
                    let messageRef = Database.database().reference().child("DrivewayzMessages").childByAutoId()
                    messageRef.updateChildValues(["name": name, "email": email, "timestamp": timestamp, "message": message, "context": self.context])
                    self.view.endEditing(true)
                    self.createSimpleAlert(title: "Sent!", message: "")
                    self.message.text = ""
                    self.sendButton.alpha = 1.0
                    self.sendButton.isUserInteractionEnabled = true
                }
            }
        } else {
            self.createSimpleAlert(title: "No message", message: "")
            self.sendButton.alpha = 1.0
            self.sendButton.isUserInteractionEnabled = true
        }
        
//        if MFMailComposeViewController.canSendMail() {
//            if let message = self.message.text {
//                let mail = MFMailComposeViewController()
//                mail.mailComposeDelegate = self
//                mail.setToRecipients(["reese@drivewayz.io"])
//                mail.setMessageBody("<p>\(message)</p>", isHTML: true)
//                mail.setSubject("Drivewayz Help")
//
//                present(mail, animated: true)
//            } else {
//                self.createSimpleAlert(title: "Please include a custom message", message: "Describe any problems or discrepancies you may have with us.")
//            }
//        } else {
//            self.createSimpleAlert(title: "Issue sending email", message: "Please check your email account associated with this phone. It does not appear to be linked.")
//        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}


extension ContactDrivewayzViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.message.text == "Contact us" {
            self.message.text = ""
            self.message.textColor = Theme.BLACK
            self.sendButton.alpha = 1.0
            self.sendButton.isUserInteractionEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.message.text == "" {
            self.message.text = "Contact us"
            self.message.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            self.sendButton.alpha = 0.5
            self.sendButton.isUserInteractionEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if message != "" {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            self.present(alert, animated: true)
            delayWithSeconds(1) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
