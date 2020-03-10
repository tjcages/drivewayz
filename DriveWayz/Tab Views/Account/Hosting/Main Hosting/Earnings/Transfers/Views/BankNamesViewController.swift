//
//  BankNamesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

var bankSearchResults: LocationSearchResults = {
    let controller = LocationSearchResults()
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    controller.view.alpha = 0
    
    return controller
}()

class BankNamesViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "First name"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var nameTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "First"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var lastLabel: UILabel = {
        let label = UILabel()
        label.text = "Last name"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var lastTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "Last"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        
        return label
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email address"
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH5
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        
        return label
    }()
    
    var emailTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.BLUE
        label.placeholder = "Email"
        label.tintColor = Theme.BLUE
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        label.keyboardAppearance = .dark
        
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false

        setupViews()
        createToolbar()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 500)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        scrollView.addGestureRecognizer(tap)
        
        scrollView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        nameLabel.sizeToFit()
        
        scrollView.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        scrollView.addSubview(lastLabel)
        lastLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        lastLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        lastLabel.sizeToFit()
        
        scrollView.addSubview(lastTextField)
        lastTextField.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: 8).isActive = true
        lastTextField.leftAnchor.constraint(equalTo: lastLabel.leftAnchor).isActive = true
        lastTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        lastTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        scrollView.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: lastTextField.bottomAnchor, constant: 20).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        emailLabel.sizeToFit()
        
        scrollView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: emailLabel.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.BLUE
        toolBar.layer.borderColor = Theme.BLACK.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        nameTextField.inputAccessoryView = toolBar
        lastTextField.inputAccessoryView = toolBar
        emailTextField.inputAccessoryView = toolBar
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }

}


extension BankNamesViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
