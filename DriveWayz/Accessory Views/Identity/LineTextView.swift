//
//  LineTextView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class LineTextView: UITextView {
    
    var placeCenter: Bool = false {
        didSet {
            if placeCenter {
                placeLeftAnchor.isActive = false
                placeCenterAnchor.isActive = true
            } else {
                placeLeftAnchor.isActive = true
                placeCenterAnchor.isActive = false
            }
        }
    }
    var placeHolderCenter: Bool = true {
        didSet {
            if placeHolderCenter {
                placeHolderCenterAnchor.isActive = true
                placeHolderTopAnchor.isActive = false
            } else {
                placeHolderCenterAnchor.isActive = false
                placeHolderTopAnchor.isActive = true
            }
        }
    }
    
    var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Message"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
//        deleteButton.isHidden = true
    }
    
    var placeHolderCenterAnchor: NSLayoutConstraint!
    var placeHolderTopAnchor: NSLayoutConstraint!
    
    var placeLeftAnchor: NSLayoutConstraint!
    var placeCenterAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupView()
        createToolbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeLeftAnchor = placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12)
            placeLeftAnchor.isActive = true
        placeCenterAnchor = placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            placeCenterAnchor.isActive = false
        placeholderLabel.sizeToFit()
        
        placeHolderCenterAnchor = placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            placeHolderCenterAnchor.isActive = true
        placeHolderTopAnchor = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            placeHolderTopAnchor.isActive = false

    }
    
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
    
    func setupView() {
        backgroundColor = .clear
        textColor = Theme.BLACK
        font = Fonts.SSPRegularH3
        tintColor = Theme.BLUE
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        translatesAutoresizingMaskIntoConstraints = false
        keyboardAppearance = .dark
        returnKeyType = .done
        isScrollEnabled = false
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
//        deleteButton.isHidden = self.text.isEmpty
        
        if text.last == "\n" {
            text = text.replacingOccurrences(of: "\n", with: "")
            if text.isEmpty {
                showPlaceholderLabel()
            }
            dismissKeyboard()
        }
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.BLACK.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

