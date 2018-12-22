//
//  LeaveReviewViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Cosmos

class LeaveReviewViewController: UIViewController, UITextViewDelegate {
    
    var delegate: removePurchaseView?
    var parkingID: String?
    var rating: Int = 0
    
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
    
    var terms: UILabel = {
        let label = UILabel()
        label.textColor = Theme.PACIFIC_BLUE
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        label.text = "Leave a review"
        
        return label
    }()
    
    var text: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH6
        label.text = "Please leave a review for the host of the parking space and for future users."
        label.numberOfLines = 2
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 0
        view.settings.updateOnTouch = true
        view.settings.fillMode = .full
        view.settings.starSize = 30
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.settings.emptyBorderColor = Theme.DARK_GRAY
        view.settings.filledBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.backgroundColor = UIColor.clear
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
        input.textColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        input.font = UIFont.boldSystemFont(ofSize: 16)
        input.translatesAutoresizingMaskIntoConstraints = false
        
        return input
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.isScrollEnabled = false
        view.keyboardDismissMode = .interactive
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        scrollView.delegate = self
        
        setupTerms()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(parkingID: String) {
        self.parkingID = parkingID
    }
    
    func setupTerms() {
        
        self.view.addSubview(blurBackgroundStartup)
        blurBackgroundStartup.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurBackgroundStartup.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blurBackgroundStartup.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurBackgroundStartup.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(termsContainer)
        termsContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
        termsContainer.heightAnchor.constraint(equalToConstant: 360).isActive = true
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
        text.heightAnchor.constraint(equalToConstant: 60).isActive = true
        text.leftAnchor.constraint(equalTo: termsContainer.leftAnchor, constant: 10).isActive = true
        text.rightAnchor.constraint(equalTo: termsContainer.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(stars)
        stars.didFinishTouchingCosmos = {rating in self.setRating()}
        stars.widthAnchor.constraint(equalTo: termsContainer.widthAnchor).isActive = true
        stars.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: (self.view.frame.width - 60) / 4).isActive = true
        stars.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: termsContainer.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: termsContainer.rightAnchor, constant: -10).isActive = true
        inputTextField.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 10).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
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
    
    func setRating() {
        self.rating = Int(stars.rating)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.inputTextField.endEditing(true)
    }
    
    @objc func nextPressed(sender: UIButton) {
        if self.rating == 0 {
            let alert = UIAlertController(title: "Please leave a review", message: "You are not required to leave a review but it can be very helpful for future users and for the host.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else if self.rating != 0 && (inputTextField.text == "Enter text here" || inputTextField.text == "Sent!" || inputTextField.text == "") {
            sendMessage(status: false)
        } else {
            sendMessage(status: true)
        }
    }
    
    func sendMessage(status: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.accept.alpha = 0.6
            self.accept.isUserInteractionEnabled = false
        }, completion: nil)
        sendMessageWithProperties(status: status)
    }
    
    var user: Users?
    var count: Int?
    
    private func sendMessageWithProperties(status: Bool) {
        if status == true {
            let parkingRef = Database.database().reference().child("parking").child(parkingID!)
            parkingRef.observeSingleEvent(of: .value) { (current) in
                let dictionary = current.value as? [String:AnyObject]
                var currentRating = dictionary!["rating"] as? Int
                if currentRating != nil {} else {currentRating = 0}
                parkingRef.updateChildValues(["rating": currentRating! + self.rating])
            }
            let ref = Database.database().reference().child("parking").child(parkingID!).child("Reviews")
            let currentUser = Auth.auth().currentUser?.uid
            let timestamp = NSDate().timeIntervalSince1970
            let review = inputTextField.text as String
            ref.observeSingleEvent(of: .value) { (snapshot) in
                self.count =  Int(snapshot.childrenCount)
                let revRef = ref.child("\(String(describing: self.count!))")
                revRef.updateChildValues(["timestamp": timestamp, "fromUser": currentUser!, "review": review, "rating": self.rating])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: animationIn, animations: {
                        self.view.alpha = 0
                    }) { (success) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.accept.alpha = 1
                            self.accept.isUserInteractionEnabled = true
                        }, completion: nil)
//                        self.delegate?.removeLeaveAReview()
                    }
                }
            }
        } else if status == false {
            let parkingRef = Database.database().reference().child("parking").child(parkingID!)
            parkingRef.observeSingleEvent(of: .value) { (current) in
                let dictionary = current.value as? [String:AnyObject]
                var currentRating = dictionary!["rating"] as? Int
                if currentRating != nil {} else {currentRating = 0}
                parkingRef.updateChildValues(["rating": currentRating! + self.rating])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: animationIn, animations: {
                        self.view.alpha = 0
                    }) { (success) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.accept.alpha = 1
                            self.accept.isUserInteractionEnabled = true
                        }, completion: nil)
//                        self.delegate?.removeLeaveAReview()
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
    
    @objc func backPressed(sender: UIButton) {
//        self.delegate?.removeLeaveAReview()
    }

}
