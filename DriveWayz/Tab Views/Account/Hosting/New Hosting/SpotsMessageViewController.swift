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
    
    let activityIndicatorParkingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH4
        label.numberOfLines = 2
        label.text = "Promote your spot or give any information so the user can better find it."
        
        return label
    }()
    
    var message: UITextView = {
        let field = UITextView()
        field.backgroundColor = Theme.OFF_WHITE
        field.text = "Message"
        field.textColor = Theme.BLACK
        field.font = Fonts.SSPRegularH4
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 4
        field.tintColor = Theme.SEA_BLUE
        field.isScrollEnabled = false
        field.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
        
        return field
    }()
    
    var characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.SEA_BLUE
        label.font = Fonts.SSPRegularH5
        label.text = "0/160"
        label.textAlignment = .right
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        message.delegate = self
        
        setupMessageViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMessageViews() {
        
        self.view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -30).isActive = true
        informationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 48).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(message)
        message.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 20).isActive = true
        message.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        message.widthAnchor.constraint(equalToConstant: 328).isActive = true
        message.heightAnchor.constraint(equalToConstant: 108).isActive = true
        
        self.view.addSubview(characterLabel)
        characterLabel.rightAnchor.constraint(equalTo: message.rightAnchor, constant: -2).isActive = true
        characterLabel.leftAnchor.constraint(equalTo: message.leftAnchor).isActive = true
        characterLabel.bottomAnchor.constraint(equalTo: message.topAnchor, constant: -2).isActive = true
        characterLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        createToolbar()
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.WHITE
        toolBar.tintColor = Theme.BLUE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.message.inputAccessoryView = toolBar
    }

    func startMessage() {
        self.message.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.delegate?.moveToNextController()
    }
    
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text?.count)! + text.count - range.length
        if (newLength <= 160) {
            self.characterLabel.textColor = Theme.SEA_BLUE
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
        let text = message.text
        if text == "Message" {
            ref.updateChildValues(["message": ""])
        } else {
            ref.updateChildValues(["message": text!])
        }
    }

}










