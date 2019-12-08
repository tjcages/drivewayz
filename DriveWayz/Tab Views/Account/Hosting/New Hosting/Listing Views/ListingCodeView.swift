//
//  ListingCodeView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingCodeView: UIViewController {
    
    var delegate: HandleListingDetails?

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Gate code"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select this if a gate code is required park in the space."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        
        return label
    }()
    
    var switchButton: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = Theme.BLUE
        view.tintColor = lineColor
        view.addTarget(self, action: #selector(switchPressed(sender:)), for: .valueChanged)
        
        return view
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        
        return button
    }()
    
    var mainTextView: UITextView = {
        let view = UITextView()
        view.textColor = Theme.DARK_GRAY
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.keyboardType = .numberPad
        view.tintColor = Theme.BLUE
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        view.alpha = 0
        
        return view
    }()
    
    var textViewLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.alpha = 0
        
        return view
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.message = "Please enter a valid gate code."
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.rightTriangle()
        view.horizontalTriangle()
        view.label.font = Fonts.SSPRegularH5
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTextView.delegate = self
        
        view.clipsToBounds = true

        setupViews()
        setupTextViews()
        createToolbar()
    }
        
    func setupViews() {
        
        view.addSubview(switchButton)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(informationIcon)
        
        switchButton.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        switchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()

        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: switchButton.leftAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        informationIcon.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        informationIcon.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 4).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true
        
    }
    
    var textViewWidthAnchor: NSLayoutConstraint!
    
    func setupTextViews() {
        
        view.addSubview(mainTextView)
        view.addSubview(textViewLine)
        
        mainTextView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 8).isActive = true
        mainTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainTextView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        textViewWidthAnchor = mainTextView.widthAnchor.constraint(equalToConstant: 32)
            textViewWidthAnchor.isActive = true
        
        textViewLine.anchor(top: nil, left: mainTextView.leftAnchor, bottom: mainTextView.bottomAnchor, right: mainTextView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(bubbleArrow)
        bubbleArrow.leftAnchor.constraint(equalTo: mainTextView.rightAnchor, constant: 32).isActive = true
        bubbleArrow.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bubbleArrow.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    @objc func switchPressed(sender: UISwitch) {
        delegate?.dismissKeyboard()
        if sender.isOn {
            gateViewExpanded()
        } else {
            gateViewDismissed()
        }
    }
    
    func gateViewExpanded() {
        delegate?.expandGateView()
        UIView.animate(withDuration: animationIn) {
            self.mainTextView.alpha = 1
            self.textViewLine.alpha = 1
        }
    }
    
    func gateViewDismissed() {
        delegate?.dismissKeyboard()
        delegate?.minimizeGateView()
        UIView.animate(withDuration: animationIn) {
            self.bubbleArrow.alpha = 0
            self.mainTextView.alpha = 0
            self.textViewLine.alpha = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if switchButton.isOn {
            mainTextView.becomeFirstResponder()
        } else {
            if let check = delegate?.checkNumber() {
                if check {
                    delegate?.unselectViews()
                    switchButton.setOn(true, animated: true)
                    gateViewExpanded()
                } else {
                    switchButton.setOn(false, animated: true)
                }
            }
        }
    }
}


extension ListingCodeView: UITextViewDelegate {
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.sizeToFit()
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        mainTextView.inputAccessoryView = toolBar
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.unselectViews()
        delegate?.selectView(view: view)
        textViewLine.backgroundColor = Theme.BLUE
        if bubbleArrow.alpha == 1 {
            UIView.animate(withDuration: animationIn) {
                self.bubbleArrow.alpha = 0
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.unselectViews()
        textViewLine.backgroundColor = lineColor
        if let text = mainTextView.text {
            if text == "" {
                switchButton.setOn(false, animated: true)
                gateViewDismissed()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let width = text.width(withConstrainedHeight: 46, font: Fonts.SSPRegularH2)
            textViewWidthAnchor.constant = width + 24
            view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
