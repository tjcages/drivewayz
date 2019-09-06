//
//  RegisterEmailViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class RegisterEmailViewController: UIViewController {
    
    var delegate: handleConfigureProcess?
    var goodToGo: Bool = false
    
    var messageTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.tintColor = Theme.BLUE
        view.font = Fonts.SSPRegularH3
        view.textColor = Theme.BLACK
        view.isScrollEnabled = false
        view.keyboardAppearance = .dark
        view.autocapitalizationType = .none
        view.enablesReturnKeyAutomatically = false
        view.keyboardType = .emailAddress
        
        return view
    }()
    
    var messageTextLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPLightH4
        label.numberOfLines = 8
        label.text = "Drivewayz will send you an email verification to confirm your status as a host. \n\n You must have a valid email address for your spot to be listed."
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.delegate = self

        setupViews()
        createToolbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        self.view.addSubview(messageTextLine)
        messageTextLine.leftAnchor.constraint(equalTo: messageTextView.leftAnchor).isActive = true
        messageTextLine.rightAnchor.constraint(equalTo: messageTextView.rightAnchor).isActive = true
        messageTextLine.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor).isActive = true
        messageTextLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: messageTextLine.bottomAnchor, constant: 20).isActive = true
        informationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 48).isActive = true
        informationLabel.sizeToFit()
        
    }
    
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
        
        self.messageTextView.inputAccessoryView = toolBar
    }
    
    func startMessage() {
        self.messageTextView.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func checkIfGood() {
        guard let title = self.messageTextView.text else { return }
        if title == "" || title == "Enter message" {
            self.goodToGo = false
        } else {
            if title.contains("@") && title.contains(".") {
                self.goodToGo = true
            } else {
                self.goodToGo = false
            }
        }
    }
    
}


extension RegisterEmailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        self.messageTextLine.backgroundColor = Theme.BLUE
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        messageTextLine.backgroundColor = lineColor
        if let text = messageTextView.text {
            let newText = text.replacingOccurrences(of: "\n", with: "")
            messageTextView.text = newText
        }
        self.checkIfGood()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.checkIfGood()
        return true
    }
    
}
