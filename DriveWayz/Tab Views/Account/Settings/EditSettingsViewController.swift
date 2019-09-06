//
//  UserEmailViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/26/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class EditSettingsViewController: UIViewController {
    
    var delegate: changeSettingsHandler?
    
    var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Account"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return label
    }()
    
    var detailView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.tintColor = Theme.BLUE
        view.font = Fonts.SSPRegularH3
        view.textColor = Theme.BLACK
        view.isScrollEnabled = false
        view.keyboardAppearance = .dark
        view.autocapitalizationType = .none
        view.enablesReturnKeyAutomatically = false
        
        return view
    }()
    
    var detailLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var updateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(updateButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    func setData(title: String, subtitle: String) {
        detailLabel.text = title
        detailView.text = subtitle
        if title == "Phone" {
            self.detailView.keyboardType = .numberPad
        } else {
            self.detailView.keyboardType = .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        detailView.delegate = self
        
        setupViews()
        createToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        detailView.becomeFirstResponder()
    }
    
    var gradientHeightAnchor: CGFloat = 160
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: gradientHeightAnchor).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: gradientHeightAnchor).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
     
        view.addSubview(detailLabel)
        detailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        detailLabel.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 24).isActive = true
        detailLabel.sizeToFit()

        view.addSubview(detailView)
        detailView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8).isActive = true
        detailView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        detailView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        detailView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        view.addSubview(detailLine)
        detailLine.leftAnchor.constraint(equalTo: detailView.leftAnchor).isActive = true
        detailLine.rightAnchor.constraint(equalTo: detailView.rightAnchor).isActive = true
        detailLine.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        detailLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        view.addSubview(updateButton)
        updateButton.topAnchor.constraint(equalTo: detailLine.bottomAnchor, constant: 48).isActive = true
        updateButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        updateButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func updateButtonPressed() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        if let title = detailLabel.text, let message = detailView.text, let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID)
            if title == "Email" {
                ref.updateChildValues(["email": message])
                self.delegate?.changeEmail(text: message)
            } else if title == "Phone" {
                ref.updateChildValues(["phone": message])
                self.delegate?.changePhone(text: message)
            } else if title == "Name" {
                ref.updateChildValues(["name": message])
                self.delegate?.changeName(text: message)
            }
        }
    }

}


extension EditSettingsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        detailLine.backgroundColor = Theme.BLUE
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        detailLine.backgroundColor = lineColor
        if let text = detailView.text {
            let newText = text.replacingOccurrences(of: "\n", with: "")
            detailView.text = newText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.detailView && self.detailLabel.text == "Phone" {
            guard let fullString = textView.text else { return }
            let range = fullString.count
            if range == 1 {
                textView.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textView.text = format(phoneNumber: fullString)
            }
        }
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        return number
    }
    
    // Build the 'Done' button to dismiss keyboard
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
        
        detailView.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
