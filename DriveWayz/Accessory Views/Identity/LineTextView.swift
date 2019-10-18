//
//  LineTextView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class LineTextView: UITextView {
    
    var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Message"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
//        deleteButton.isHidden = true
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupView()
        createToolbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        placeholderLabel.sizeToFit()

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
        textColor = Theme.DARK_GRAY
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
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
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

