//
//  VerifyEmailView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class VerifyEmailView: UIViewController {

    var delegate: HostVerifyDelegate?
    var goodToGo: Bool = false
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var mainTextView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .emailAddress
        view.lineTextView?.placeholderLabel.alpha = 0
        view.lineTextView?.autocapitalizationType = .none
        view.lineTextView?.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 48)
        
        return view
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.message = "Please provide a valid email address."
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.centerTriangle()
        view.verticalTriangle()
        view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        view.label.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        view.label.font = Fonts.SSPRegularH4
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTextView.lineTextView?.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        setupViews()
        createToolbar()
    }
    
    var mainTextHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(mainTextView)
        mainTextView.anchor(top: informationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        mainTextHeight = mainTextView.heightAnchor.constraint(equalToConstant: 50)
            mainTextHeight.isActive = true
        
        view.addSubview(bubbleArrow)
        bubbleArrow.topAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: 8).isActive = true
        bubbleArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bubbleArrow.widthAnchor.constraint(equalToConstant: 280).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
    }
    
    func checkEmail() -> Bool {
        var check = true
        if mainTextView.lineTextView?.text == "" || !(mainTextView.lineTextView?.text.contains("@"))! || !(mainTextView.lineTextView?.text.contains("."))! {
            check = false
        }
        if !check {
            if bubbleArrow.alpha == 0 {
                UIView.animate(withDuration: animationIn, animations: {
                    self.bubbleArrow.alpha = 1
                }) { (success) in
                    delayWithSeconds(3) {
                        if self.bubbleArrow.alpha == 1 {
                            UIView.animate(withDuration: animationIn) {
                                self.bubbleArrow.alpha = 0
                            }
                        }
                    }
                }
            }
        }
        return check
    }
    
}

extension VerifyEmailView: UITextViewDelegate {
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        mainTextView.lineTextView?.inputAccessoryView = toolBar
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: phoneWidth - 76, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let estimatedHeight = estimatedSize.height
        
        if textView.text.last == "\n" {
            textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
            dismissKeyboard()
            return
        }
        
        if estimatedHeight >= 50 {
            mainTextHeight.constant = estimatedSize.height
            view.layoutIfNeeded()
        }
    }
    
    func checkIfGood() {
        if self.mainTextView.lineTextView?.text == "" || self.mainTextView.lineTextView?.text == "Enter email here" {
            self.goodToGo = false
        } else {
            self.goodToGo = true
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        delegate?.adjustForKeyboard(notification: notification)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
