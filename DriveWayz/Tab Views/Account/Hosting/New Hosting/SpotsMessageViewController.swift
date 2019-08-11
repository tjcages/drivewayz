//
//  SpotsMessageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class SpotsMessageViewController: UIViewController, UITextViewDelegate {
    
    var delegate: handleConfigureProcess?
    var goodToGo: Bool = false
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize = CGSize(width: self.view.frame.width, height: 800)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    let activityIndicatorParkingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH4
        label.numberOfLines = 2
        label.text = "Promote your spot or give any information so motorists can better find it."
        
        return label
    }()
    
    var messageTextView: UITextView = {
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
    
    var messageTextLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PACIFIC_BLUE
        label.font = Fonts.SSPRegularH5
        label.text = "0/160"
        label.textAlignment = .right
        
        return label
    }()
    
    var exampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.5)
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 6
        label.text =
        """
        Example:
        A secure and affordable parking spot in the heart of downtown Boulder. A quick 5 minute walk to Pearl St. makes this a great location whether you are shopping for the day or have a meeting in the busy area.
        """
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        messageTextView.delegate = self
        
        setupMessageViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMessageViews() {
        
        self.view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        informationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 48).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(messageTextView)
        messageTextView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 20).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 136).isActive = true
        
        scrollView.addSubview(messageTextLine)
        messageTextLine.leftAnchor.constraint(equalTo: messageTextView.leftAnchor).isActive = true
        messageTextLine.rightAnchor.constraint(equalTo: messageTextView.rightAnchor).isActive = true
        messageTextLine.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor).isActive = true
        messageTextLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        scrollView.addSubview(characterLabel)
        characterLabel.rightAnchor.constraint(equalTo: messageTextView.rightAnchor, constant: -2).isActive = true
        characterLabel.leftAnchor.constraint(equalTo: messageTextView.leftAnchor).isActive = true
        characterLabel.bottomAnchor.constraint(equalTo: messageTextView.topAnchor, constant: -2).isActive = true
        characterLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(exampleLabel)
        exampleLabel.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 20).isActive = true
        exampleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        exampleLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 60).isActive = true
        exampleLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        createToolbar()
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        self.messageTextLine.backgroundColor = Theme.BLUE
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        self.messageTextLine.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.4)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text?.count)! + text.count - range.length
        delayWithSeconds(0.1) {
            self.checkIfGood()
        }
        if (newLength <= 160) {
            self.characterLabel.textColor = Theme.PACIFIC_BLUE
            self.characterLabel.text = "\(newLength)/160"
            return true
        } else {
            self.characterLabel.textColor = Theme.HARMONY_RED
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addPropertiesToDatabase(parkingID: String) {
        let ref = Database.database().reference().child("parking").child(parkingID)
        let text = messageTextView.text
        if text == "Message" {
            ref.updateChildValues(["message": ""])
        } else {
            ref.updateChildValues(["message": text!])
        }
    }
    
    func checkIfGood() {
        if self.messageTextView.text == "" || self.messageTextView.text == "Enter message" {
            self.goodToGo = false
        } else {
            self.goodToGo = true
        }
    }

}










