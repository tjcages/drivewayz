//
//  BankSSNViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BankSSNViewController: UIViewController {

    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var ssnLabel: UILabel = {
        let label = UILabel()
        label.text = "SSN last four"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var ssnTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.PACIFIC_BLUE
        label.placeholder = "_ _ _ _"
        label.tintColor = Theme.PACIFIC_BLUE
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(112, 0, 0)
        label.keyboardAppearance = .dark
        label.keyboardType = .numberPad
        
        return label
    }()
    
    var xxx: UILabel = {
        let label = UILabel()
        label.text = "X X X - X X  - "
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        ssnTextField.delegate = self
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 100)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        scrollView.addGestureRecognizer(tap)
        
        scrollView.addSubview(ssnLabel)
        scrollView.addSubview(xxx)
        scrollView.addSubview(ssnTextField)
        
        ssnLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        ssnLabel.leftAnchor.constraint(equalTo: ssnTextField.leftAnchor).isActive = true
        ssnLabel.sizeToFit()
        
        xxx.centerYAnchor.constraint(equalTo: ssnTextField.centerYAnchor).isActive = true
        xxx.leftAnchor.constraint(equalTo: ssnTextField.leftAnchor, constant: 16).isActive = true
        xxx.widthAnchor.constraint(equalToConstant: (xxx.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH3))!).isActive = true
        xxx.sizeToFit()
        
        ssnTextField.topAnchor.constraint(equalTo: ssnLabel.bottomAnchor, constant: 8).isActive = true
        ssnTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ssnTextField.widthAnchor.constraint(equalToConstant: 182).isActive = true
        ssnTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
}


extension BankSSNViewController: UIScrollViewDelegate {
    
}


extension BankSSNViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if string != "" {
            if text.count <= 7 {
                textField.text = text + " "
                return true
            } else {
                return false
            }
        } else {
            textField.text = String(text.dropLast())
            return true
        }
    }
    
}
