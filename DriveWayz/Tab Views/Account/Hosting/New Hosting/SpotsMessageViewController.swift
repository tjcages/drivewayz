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
    
    let activityIndicatorParkingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var agreement: UITextView = {
        let agreement = UITextView()
        agreement.isUserInteractionEnabled = false
        agreement.isEditable = false
        agreement.text = "By registering your host parking space, you confirm that you own all rights and privileges to the property and you agree to our Services Agreement."
        agreement.textColor = Theme.BLACK.withAlphaComponent(0.5)
        agreement.textAlignment = .center
        agreement.translatesAutoresizingMaskIntoConstraints = false
        agreement.font = Fonts.SSPRegularH6
        agreement.alpha = 1
        agreement.backgroundColor = UIColor.clear
        agreement.translatesAutoresizingMaskIntoConstraints = false
        
        return agreement
    }()
    
    var message: UITextView = {
        let field = UITextView()
        field.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        field.text = "Add any useful information so the user can better find your spot"
        field.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        field.font = Fonts.SSPLightH4
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 10
        field.tintColor = Theme.HARMONY_RED
        
        return field
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
        
        self.view.addSubview(message)
        message.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        message.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        message.widthAnchor.constraint(equalToConstant: self.view.frame.width - 60).isActive = true
        message.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(agreement)
        agreement.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 10).isActive = true
        agreement.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        agreement.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        agreement.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.message.text == "Add any useful information so the user can better find your spot" {
            self.message.text = ""
            self.message.textColor = Theme.BLACK
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.message.text == "" {
            self.message.text = "Add any useful information so the user can better find your spot"
            self.message.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addPropertiesToDatabase(parkingID: String) {
        let ref = Database.database().reference().child("parking").child(parkingID)
        let text = message.text
        if text == "Add any useful information so the user can better find your spot" {
            ref.updateChildValues(["message": ""])
        } else {
            ref.updateChildValues(["message": text!])
        }
    }


}










