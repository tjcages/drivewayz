//
//  ContactUsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class ContactUsViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {

    var delegate: controlsAccountOptions?
    
    var termsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.alpha = 0.8
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var blurBackgroundStartup: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.8
        
        return blurView
    }()
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var terms: UILabel = {
        let label = UILabel()
        label.textColor = Theme.PACIFIC_BLUE
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.text = "Contact Drivewayz!"
        
        return label
    }()
    
    var text: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "We at Drivewayz strive to give users the best experience that we can. That being said, we aren't perfect and we look for your constant support and ideas to constantly improve."
        label.numberOfLines = 4
        
        return label
    }()
    
    var accept: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.setTitleColor(Theme.SEA_BLUE, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.SEA_BLUE.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(nextPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var back: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.3).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var inputTextField: UITextView = {
        let input = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
        input.isEditable = true
        input.tintColor = Theme.PACIFIC_BLUE
        input.text = "Enter text here"
        input.backgroundColor = Theme.OFF_WHITE
        input.layer.cornerRadius = 10
        input.textColor = Theme.BLACK
        input.font = UIFont.systemFont(ofSize: 18, weight: .light)
        input.translatesAutoresizingMaskIntoConstraints = false
        
        return input
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.isScrollEnabled = true
        view.keyboardDismissMode = .interactive
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        scrollView.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        viewContainer.addGestureRecognizer(gesture)
        
        setupTerms()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTerms() {
        
        self.view.addSubview(blurBackgroundStartup)
        blurBackgroundStartup.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurBackgroundStartup.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blurBackgroundStartup.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurBackgroundStartup.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        viewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(termsContainer)
        termsContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        termsContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
        termsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        termsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        termsContainer.addSubview(scrollView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scrollView.addGestureRecognizer(tap)
        scrollView.contentSize = CGSize(width: self.view.frame.width - 60, height: 300)
        scrollView.topAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 60).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -60).isActive = true
        scrollView.leftAnchor.constraint(equalTo: termsContainer.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: termsContainer.rightAnchor).isActive = true
        
        scrollView.addSubview(text)
        text.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        text.heightAnchor.constraint(equalToConstant: 100).isActive = true
        text.leftAnchor.constraint(equalTo: termsContainer.leftAnchor, constant: 10).isActive = true
        text.rightAnchor.constraint(equalTo: termsContainer.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: termsContainer.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: termsContainer.rightAnchor, constant: -10).isActive = true
        inputTextField.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        termsContainer.addSubview(terms)
        terms.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        terms.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -20).isActive = true
        terms.centerYAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 30).isActive = true
        terms.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        termsContainer.addSubview(accept)
        accept.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: 60).isActive = true
        accept.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -200).isActive = true
        accept.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -30).isActive = true
        accept.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        termsContainer.addSubview(back)
        back.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: -60).isActive = true
        back.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -200).isActive = true
        back.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -30).isActive = true
        back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.inputTextField.endEditing(true)
    }
    
    @objc func nextPressed(sender: UIButton) {
        sendMessage()
    }
    
    func sendMessage() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.accept.alpha = 0.6
            self.accept.isUserInteractionEnabled = false
        }, completion: nil)
        
        let users = Users()
        
        users.name = "Drivewayz"
        users.picture = ""
        users.email = "drivewayz@parking.com"
        users.bio = ""
        users.id = "5oiDGgeolqb6aM8hv43JQTzyLLH3"
        self.user = users
        sendMessageWithProperties()

        self.accept.alpha = 1
        self.accept.isUserInteractionEnabled = true
    }
    
    var user: Users?
    
    private func sendMessageWithProperties() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()

        let toID = user!.id!
        let fromID = Auth.auth().currentUser!.uid
        
        let currentUser = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("users").child(currentUser!)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let name = dictionary["name"] as? String
                let timestamp = Int(Date().timeIntervalSince1970)
                let values = ["name": name!, "text": self.inputTextField.text, "fromID": fromID, "timestamp": timestamp, "toID": toID] as [String : Any]
                
                childRef.updateChildValues(values) { (error, ralf) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    self.inputTextField.text = "Sent!"
                    
                    let userMessagesRef = Database.database().reference().child("user-messages").child(fromID).child(toID)
                    let messageId = childRef.key
                    userMessagesRef.updateChildValues([messageId!: 1])
                    
                    let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID).child(fromID)
                    recipientUserMessagesRef.updateChildValues([messageId!: 1])
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.view.alpha = 0
                        }) { (success) in
                            UIView.animate(withDuration: 0.1, animations: {
                                self.accept.alpha = 1
                                self.accept.isUserInteractionEnabled = true
                            }, completion: nil)
                            self.delegate?.hideContactUsController()
                        }
                    }
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Theme.DARK_GRAY.withAlphaComponent(0.3) {
            textView.text = nil
            textView.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter text here"
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }

    @objc func backPressed(sender: UIButton) {
        self.delegate?.hideContactUsController()
    }

    
}
