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
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var subDetailLabel: UITextField = {
        let label = UITextField()
        label.text = ""
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        label.placeholder = ""
        label.textAlignment = .center
        
        return label
    }()
    
    var subLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
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
        subDetailLabel.placeholder = title
        subDetailLabel.text = subtitle
        if title == "Phone" {
            self.subDetailLabel.keyboardType = .numberPad
        } else {
            self.subDetailLabel.keyboardType = .default
        }
        subDetailLabel.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        
        subDetailLabel.delegate = self
        
        setupViews()
    }
    
    func setupViews() {
     
        self.view.addSubview(detailLabel)
        detailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        detailLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(subDetailLabel)
        subDetailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        subDetailLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        subDetailLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 24).isActive = true
        subDetailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(subLine)
        subLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        subLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        subLine.topAnchor.constraint(equalTo: subDetailLabel.bottomAnchor, constant: 12).isActive = true
        subLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(updateButton)
        updateButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        updateButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        updateButton.topAnchor.constraint(equalTo: subLine.bottomAnchor, constant: 60).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func updateButtonPressed() {
        self.view.endEditing(true)
        self.delegate?.bringBackMain()
        if let title = detailLabel.text, let message = subDetailLabel.text, let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID)
            if title == "Email" {
                ref.updateChildValues(["email": message])
                self.delegate?.changeEmail(text: message)
            } else if title == "Phone" {
                ref.updateChildValues(["phone": message])
                self.delegate?.changePhone(text: message)
            }
        }
    }

}


extension EditSettingsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.subDetailLabel && self.detailLabel.text == "Phone" {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = format(phoneNumber: fullString)
            }
            return false
        } else {
            return true
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
    
}
