//
//  VerifyMessageView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class VerifyMessageView: UIViewController {

    var delegate: HostVerifyDelegate?
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Promotional message"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        
        return button
    }()
    
    var mainTextView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.lineTextView?.placeHolderCenter = false
        view.textViewFont = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .default
        view.lineTextView?.placeholderLabel.text = "Write your message here"
        view.lineTextView?.placeholderLabel.font = Fonts.SSPRegularH4
        view.lineTextView?.showPlaceholderLabel()
        view.deleteButton.alpha = 0
//        view.lineTextView?.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        
        return view
    }()
    
    var characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH5
        label.text = "0/160"
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.message = "Please provide a description for your parking space."
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
        
        view.addSubview(mainLabel)
        view.addSubview(informationIcon)
    
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        informationIcon.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        informationIcon.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 4).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true
        
        view.addSubview(mainTextView)
        mainTextView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        mainTextHeight = mainTextView.heightAnchor.constraint(equalToConstant: 110)
            mainTextHeight.isActive = true
        
        view.addSubview(characterLabel)
        characterLabel.rightAnchor.constraint(equalTo: mainTextView.rightAnchor).isActive = true
        characterLabel.bottomAnchor.constraint(equalTo: mainTextView.topAnchor, constant: -4).isActive = true
        characterLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(bubbleArrow)
        bubbleArrow.topAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: 8).isActive = true
        bubbleArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bubbleArrow.widthAnchor.constraint(equalToConstant: 280).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
    }
    
}

extension VerifyMessageView: UITextViewDelegate {
    
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text?.count)! + text.count - range.length
        if (newLength <= 160) {
            self.characterLabel.textColor = Theme.BLUE
            self.characterLabel.text = "\(newLength)/160"
            return true
        } else {
            self.characterLabel.textColor = Theme.HARMONY_RED
            return false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: phoneWidth - 40, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let estimatedHeight = estimatedSize.height
        
        if estimatedHeight >= 110 {
            mainTextHeight.constant = estimatedSize.height
            view.layoutIfNeeded()
        }
    }
    
    func checkMessage() -> Bool {
        var check = true
        if self.mainTextView.lineTextView?.text == "" || self.mainTextView.lineTextView?.text == "Write your message here" || (self.mainTextView.lineTextView?.text.count)! < 8 {
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
