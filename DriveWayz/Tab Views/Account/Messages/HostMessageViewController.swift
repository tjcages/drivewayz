//
//  HostMessageOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/16/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol setTextField {
    func setTextField(message: String)
}

class HostMessageViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate, setTextField {
    
    var delegate: handSendButton?
    var userID: String = ""
    
    var userTextWhiteSpace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var sendArrow: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.backgroundColor = Theme.PRIMARY_DARK_COLOR
        button.layer.cornerRadius = 15
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "camera")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var userTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = Theme.WHITE
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.text = "Enter message"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        view.layer.cornerRadius = 20
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 0.5
        view.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 42)
        
        return view
    }()
    
    var extraOptionsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    lazy var hostMessageOptionsController: HostMessageOptionsViewController = {
        let controller = HostMessageOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var parkingMessageOptionsController: ParkingMessageOptionsViewController = {
        let controller = ParkingMessageOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.alpha = 0
        
        userTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setupUserTextField()
    }
    
    var userTextViewHeight: NSLayoutConstraint!
    var userTextViewBottom: NSLayoutConstraint!
    
    private func setupUserTextField() {
        
        self.view.addSubview(extraOptionsContainer)
        extraOptionsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        extraOptionsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        extraOptionsContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        switch device {
        case .iphone8:
            extraOptionsContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        case .iphoneX:
            extraOptionsContainer.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
        
        extraOptionsContainer.addSubview(hostMessageOptionsController.view)
        hostMessageOptionsController.view.leftAnchor.constraint(equalTo: extraOptionsContainer.leftAnchor).isActive = true
        hostMessageOptionsController.view.rightAnchor.constraint(equalTo: extraOptionsContainer.rightAnchor).isActive = true
        hostMessageOptionsController.view.topAnchor.constraint(equalTo: extraOptionsContainer.topAnchor).isActive = true
        hostMessageOptionsController.view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        extraOptionsContainer.addSubview(parkingMessageOptionsController.view)
        parkingMessageOptionsController.view.leftAnchor.constraint(equalTo: extraOptionsContainer.leftAnchor).isActive = true
        parkingMessageOptionsController.view.rightAnchor.constraint(equalTo: extraOptionsContainer.rightAnchor).isActive = true
        parkingMessageOptionsController.view.topAnchor.constraint(equalTo: extraOptionsContainer.topAnchor).isActive = true
        parkingMessageOptionsController.view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(userTextWhiteSpace)
        userTextWhiteSpace.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        userTextWhiteSpace.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        userTextViewHeight = userTextWhiteSpace.heightAnchor.constraint(equalToConstant: 55)
            userTextViewHeight.isActive = true
        switch device {
        case .iphone8:
            userTextViewBottom = userTextWhiteSpace.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60)
                userTextViewBottom.isActive = true
        case .iphoneX:
            userTextViewBottom = userTextWhiteSpace.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75)
                userTextViewBottom.isActive = true
        }
        
        userTextWhiteSpace.addSubview(userTextView)
        userTextView.topAnchor.constraint(equalTo: userTextWhiteSpace.topAnchor, constant: 5).isActive = true
        userTextView.bottomAnchor.constraint(equalTo: userTextWhiteSpace.bottomAnchor, constant: -10).isActive = true
        userTextView.leftAnchor.constraint(equalTo: userTextWhiteSpace.leftAnchor, constant: 52).isActive = true
        userTextView.rightAnchor.constraint(equalTo: userTextWhiteSpace.rightAnchor, constant: -12).isActive = true
        
        userTextWhiteSpace.addSubview(sendArrow)
        sendArrow.rightAnchor.constraint(equalTo: userTextWhiteSpace.rightAnchor, constant: -20).isActive = true
        sendArrow.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendArrow.centerYAnchor.constraint(equalTo: userTextView.bottomAnchor, constant: -20).isActive = true
        sendArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        userTextWhiteSpace.addSubview(cameraButton)
        cameraButton.leftAnchor.constraint(equalTo: userTextWhiteSpace.leftAnchor, constant: 8).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: userTextView.bottomAnchor, constant: -20).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(threadButtonPressed(sender:)))
        userTextView.addGestureRecognizer(tapGesture)
    }
    
    func setHostOptions() {
        UIView.animate(withDuration: 0.1) {
            self.hostMessageOptionsController.view.alpha = 1
            self.parkingMessageOptionsController.view.alpha = 0
        }
    }
    
    func setParkingOptions() {
        UIView.animate(withDuration: 0.1) {
            self.hostMessageOptionsController.view.alpha = 0
            self.parkingMessageOptionsController.view.alpha = 1
        }
    }
    
    @objc func threadButtonPressed(sender: UIButton) {
        threadButtonPressedSender()
    }
    
    func threadButtonPressedSender() {
        userTextView.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            guard let height = self.keyboardHeight else { return }
            self.userTextViewBottom.constant = -height + self.userTextViewHeight.constant
            self.view.layoutIfNeeded()
        }
    }
    
    var previousPosition: CGRect = .zero
    var newTextViewHeight: CGFloat = 55
    
    func textViewDidChange(_ textView: UITextView) {
        self.sendArrow.isUserInteractionEnabled = true
        let currentPosition = textView.caretRect(for: textView.endOfDocument)
        if currentPosition.origin.y > previousPosition.origin.y && previousPosition != CGRect.zero {
            UIView.animate(withDuration: 0.2) {
                self.userTextView.scrollsToTop = true
                self.userTextViewHeight.constant = self.userTextViewHeight.constant + 19
                self.newTextViewHeight = self.userTextViewHeight.constant
                self.userTextView.setContentOffset(.zero, animated: true)
                self.view.layoutIfNeeded()
            }
        } else if currentPosition.origin.y < previousPosition.origin.y && previousPosition != CGRect.zero {
            UIView.animate(withDuration: 0.2) {
                self.userTextView.scrollsToTop = true
                self.userTextViewHeight.constant = self.userTextViewHeight.constant - 19
                self.newTextViewHeight = self.userTextViewHeight.constant
                self.userTextView.setContentOffset(.zero, animated: true)
                self.view.layoutIfNeeded()
            }
        }
        self.previousPosition = currentPosition
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter message" {
            textView.text = ""
            textView.textColor = Theme.BLACK
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter message"
            textView.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
            self.userTextViewHeight.constant = 55
            self.newTextViewHeight = 55
        }
        textView.resignFirstResponder()
        UIView.animate(withDuration: 0.2) {
            switch device {
            case .iphone8:
                self.userTextViewBottom.constant = -60
            case .iphoneX:
                self.userTextViewBottom.constant = -75
            }
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.userTextView.endEditing(true)
    }
    
    var keyboardHeight: CGFloat?
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height + self.userTextView.frame.height + 10
            self.keyboardHeight = keyboardHeight
//            self.keyboardHeight = keyboardRectangle.height + 55
        }
    }
    
    @objc func sendButtonPressed(sender: UIButton) {
        guard let message = self.userTextView.text else { return }
        if message != "Enter message" && message != "" {
            let properties = ["text": message] as [String : AnyObject]
            sendMessageWithProperties(properties: properties)
        }
    }
    
    private func sendMessageWithProperties(properties: [String: AnyObject]) {
        self.userTextView.text = ""
        self.sendArrow.backgroundColor = Theme.DARK_GRAY
        self.sendArrow.isUserInteractionEnabled = false
        self.userTextView.resignFirstResponder()
        
        let ref = Database.database().reference()
        let toID = self.userID
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let childRef = ref.child("messages").childByAutoId()
        var values = ["toID": toID, "fromID": fromID, "timestamp": timestamp] as [String : Any]
        ref.child("messages").child(fromID).removeValue()
        
        properties.forEach({values[$0] = $1})
        childRef.updateChildValues(values) { (error, ralf) in
            UIView.animate(withDuration: 0.1, animations: {
                self.sendArrow.backgroundColor = Theme.PRIMARY_DARK_COLOR
                self.sendArrow.isUserInteractionEnabled = true
                self.userTextView.text = "Enter message"
                self.userTextView.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
                self.userTextViewHeight.constant = 55
                self.newTextViewHeight = 55
            })
            if error != nil {
                print(error ?? "")
                return
            }
            if let messageId = childRef.key {
                let vals = [messageId: 1] as [String: Int]
                
                let userMessagesRef = ref.child("user-messages").child(fromID).child(toID)
                userMessagesRef.updateChildValues(vals)
                
                let recipientUserMessagesRef = ref.child("user-messages").child(toID).child(fromID)
                recipientUserMessagesRef.updateChildValues(vals)
            }
        }
    }
    
    func setTextField(message: String) {
        self.userTextView.text = message
        self.userTextViewHeight.constant = 55
        let currentPosition = self.userTextView.caretRect(for: self.userTextView.endOfDocument)
        if currentPosition.origin.y > previousPosition.origin.y && previousPosition != CGRect.zero {
            UIView.animate(withDuration: 0.2) {
                self.userTextView.scrollsToTop = true
                self.userTextViewHeight.constant = self.userTextViewHeight.constant + 19
                self.newTextViewHeight = self.userTextViewHeight.constant
                self.userTextView.setContentOffset(.zero, animated: true)
                self.view.layoutIfNeeded()
            }
        }
    }
    

}
