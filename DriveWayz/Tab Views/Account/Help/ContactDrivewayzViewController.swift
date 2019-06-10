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
        field.backgroundColor = Theme.OFF_WHITE
        field.text = "Message"
        field.textColor = Theme.BLACK
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
        button.backgroundColor = Theme.WHITE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 55/2
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: 140, height: 55)
        background.zPosition = -10
        background.cornerRadius = button.layer.cornerRadius
        button.layer.addSublayer(background)
//        button.clipsToBounds = true
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.4
        button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        message.delegate = self

        setupViews()
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
    
}

extension ContactDrivewayzViewController: MFMailComposeViewControllerDelegate {
    
    @objc func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            if let message = self.message.text {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["reese@drivewayz.io"])
                mail.setMessageBody("<p>\(message)</p>", isHTML: true)
                mail.setSubject("Drivewayz Help")
                
                present(mail, animated: true)
            } else {
                self.createSimpleAlert(title: "Please include a custom message", message: "Describe any problems or discrepancies you may have with us.")
            }
        } else {
            self.createSimpleAlert(title: "Issue sending email", message: "Please check your email account associated with this phone. It does not appear to be linked.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}


extension ContactDrivewayzViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.message.text == "Message" {
            self.message.text = ""
            self.message.textColor = Theme.BLACK
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.message.text == "" {
            self.message.text = "Message"
            self.message.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
