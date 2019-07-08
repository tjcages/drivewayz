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
    var confirmedIDs: [String] = []
    
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
        observeCorrectID()
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
        
        let addButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendEmail))
        addButton.tintColor = Theme.WHITE
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: #selector(sendEmail))
        let flexibleSpace2 = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: #selector(sendEmail))
        
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
                    
                    let messageRef = Database.database().reference().child("DrivewayzMessages").childByAutoId()
                    messageRef.updateChildValues(values)
                    self.sendMessageWithProperties(toID: userID, properties: values)
                    
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
    }
    
    private func sendMessageWithProperties(toID: String, properties: [String: AnyObject]) {
        let ref = Database.database().reference()
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let childRef = ref.child("messages").childByAutoId()
        var values = ["status": "Sent", "deviceID": AppDelegate.DEVICEID, "toID": toID, "fromID": fromID, "timestamp": timestamp, "communicationID": childRef.key as Any] as [String : Any]
        
        let userRef = ref.child("users").child(fromID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let userName = dictionary["name"] as? String
                var fullNameArr = userName?.split(separator: " ")
                let firstName: String = String(fullNameArr![0])
                
                values["name"] = userName
                self.fetchNewCurrent(name: firstName)
                
                values["fromID"] = fromID
                
                ref.child("messages").child(fromID).removeValue()
                
                properties.forEach({values[$0] = $1})
                for keys in self.confirmedIDs {
                    values["toID"] = keys
                    childRef.updateChildValues(values) { (error, ralf) in
                        if error != nil {
                            print(error ?? "")
                            return
                        }
                        if let messageId = childRef.key {
                            let vals = [messageId: 1] as [String: Int]
                            
                            let userMessagesRef = ref.child("user-messages").child(fromID).child(keys)
                            userMessagesRef.updateChildValues(vals)
                            
                            let recipientUserMessagesRef = ref.child("user-messages").child(keys).child(fromID)
                            recipientUserMessagesRef.updateChildValues(vals)
                            
                            self.sendButton.alpha = 1
                            self.sendButton.isUserInteractionEnabled = true
                        }
                    }
                }
            }
        }
    }
    
    func fetchNewCurrent(name: String) {
        let sender = PushNotificationSender()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a MM/dd/yyyy"
        let time = dateFormatter.string(from: date)
        for keys in self.confirmedIDs {
            sender.sendPushNotification(toUser: keys, title: "\(name) sent Drivewayz a message", subtitle: "\(time)")
        }
    }
    
    func observeCorrectID() {
        self.confirmedIDs = []
        let ref = Database.database().reference().child("ConfirmedID")
        ref.observe(.childAdded) { (snapshot) in
            if let key = snapshot.value as? String {
                self.confirmedIDs.append(key)
            }
        }
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
