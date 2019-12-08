//
//  BankNamesView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol BankNamesDelegate {
    func adjustForKeyboard(notification: Notification)
    func removeDim()
    
    func moveToAccount()
    func dismissAccount()
}

class BankNamesView: UIViewController {
    
    var delegate: NewBankDelegate?
    
    var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Please confirm \nyour information"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var iconController = BankIconsView()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "First name"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var firstTextView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .emailAddress
        view.lineTextView?.placeholderLabel.alpha = 0
        view.lineTextView?.autocapitalizationType = .none
        view.lineTextView?.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        view.deleteButton.alpha = 0
        
        return view
    }()
    
    var lastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Last name"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var lastTextView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .emailAddress
        view.lineTextView?.placeholderLabel.alpha = 0
        view.lineTextView?.autocapitalizationType = .none
        view.lineTextView?.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        view.deleteButton.alpha = 0
        
        return view
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email address"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var emailTextView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .emailAddress
        view.lineTextView?.placeholderLabel.alpha = 0
        view.lineTextView?.autocapitalizationType = .none
        view.lineTextView?.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        view.deleteButton.alpha = 0
        
        return view
    }()
    
    lazy var locationView: BankLocationView = {
        let controller = BankLocationView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.view.alpha = 0
        
        return controller
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var dobController = BankDOBView()
    var accountController = BankAccountView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        
        firstTextView.lineTextView?.delegate = self
        lastTextView.lineTextView?.delegate = self
        emailTextView.lineTextView?.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        setupViews()
        setupFirst()
        createToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if nextButton.tintColor != Theme.WHITE {
            showNextButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideNextButton()
    }
    
    var nextButtonBottomAnchor: NSLayoutConstraint!
    var nextButtonKeyboardAnchor: NSLayoutConstraint!
    var nextButtonRightAnchor: NSLayoutConstraint!
    
    func setupViews() {

        view.addSubview(scrollView)
        view.addSubview(backView)
        view.addSubview(exitButton)
        view.addSubview(backButton)
        scrollView.addSubview(iconController.view)
        
        exitButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: exitButton.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -20, paddingRight: 0, width: 0, height: 0)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1200)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        iconController.expandPhone()
        iconController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 72).isActive = true
        iconController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        iconController.view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        scrollView.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 32).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.sizeToFit()
        
    }
    
    var containerLeftAnchor: NSLayoutConstraint!
    
    func setupFirst() {
        
        scrollView.addSubview(container)
        container.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        containerLeftAnchor = container.leftAnchor.constraint(equalTo: view.leftAnchor)
            containerLeftAnchor.isActive = true
        container.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        container.addSubview(firstLabel)
        firstLabel.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        firstLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        firstLabel.sizeToFit()
        
        container.addSubview(firstTextView)
        firstTextView.anchor(top: firstLabel.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.centerXAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        firstTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(lastLabel)
        lastLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        lastLabel.leftAnchor.constraint(equalTo: container.centerXAnchor, constant: 8).isActive = true
        lastLabel.sizeToFit()
        
        container.addSubview(lastTextView)
        lastTextView.anchor(top: lastLabel.bottomAnchor, left: lastLabel.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        lastTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: firstTextView.bottomAnchor, constant: 20).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        emailLabel.sizeToFit()
        
        container.addSubview(emailTextView)
        emailTextView.anchor(top: emailLabel.bottomAnchor, left: emailLabel.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        emailTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(locationView.view)
        locationView.view.anchor(top: container.topAnchor, left: container.rightAnchor, bottom: container.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth, height: 0)
        
        view.addSubview(bankSearchResults.view)
        bankSearchResults.view.leftAnchor.constraint(equalTo: locationView.streetLine.leftAnchor).isActive = true
        bankSearchResults.view.rightAnchor.constraint(equalTo: locationView.streetLine.rightAnchor).isActive = true
        bankSearchResults.view.topAnchor.constraint(equalTo: locationView.streetLine.bottomAnchor).isActive = true
        bankSearchResults.view.heightAnchor.constraint(equalToConstant: 199).isActive = true
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
        view.addSubview(dimView)
        dimView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func nextButtonPressed() {
        if container.alpha == 1 {
            containerLeftAnchor.constant = -phoneWidth
            UIView.animate(withDuration: animationOut, animations: {
                self.exitButton.alpha = 0
                self.container.alpha = 0
                self.locationView.view.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.animate(withDuration: animationOut) {
                    self.backButton.alpha = 1
                }
            }
        } else {
//            dobController.modalPresentationStyle = .overFullScreen
            UIView.animate(withDuration: animationIn, animations: {
                self.dimView.alpha = 0.7
            }) { (success) in
                self.dobController.delegate = self
                self.dobController.presentationController?.delegate = self.dobController
                self.present(self.dobController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func backButtonPressed() {
        containerLeftAnchor.constant = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.backButton.alpha = 0
            self.container.alpha = 1
            self.locationView.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut) {
                self.exitButton.alpha = 1
            }
        }
    }
    
    @objc func dismissController() {
        delegate?.removeDim()
        dismiss(animated: true, completion: nil)
    }
    
    func showNextButton() {
        nextButton.alpha = 1
        nextButtonRightAnchor.constant = phoneWidth/2
        view.layoutIfNeeded()
        
        nextButtonRightAnchor.constant = -20
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                self.nextButton.tintColor = Theme.WHITE
            }) { (success) in
                self.nextButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func hideNextButton() {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.DARK_GRAY
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in

            }
        }
    }

    func removeDim() {
        UIView.animate(withDuration: animationOut) {
            self.dimView.alpha = 0
        }
    }
    
}

extension BankNamesView: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismissController()
    }
}

extension BankNamesView: UITextViewDelegate, BankNamesDelegate {
    
    func moveToAccount() {
        dismiss(animated: true, completion: nil)
        accountController.delegate = self
        accountController.presentationController?.delegate = accountController
        present(accountController, animated: true, completion: nil)
    }
    
    func dismissAccount() {
        self.dobController.delegate = self
        self.dobController.presentationController?.delegate = self.dobController
        self.present(self.dobController, animated: true, completion: nil)
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextPressed))
        doneButton.tag = 0
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let toolBar2 = UIToolbar()
        toolBar2.sizeToFit()
        toolBar2.barTintColor = Theme.DARK_GRAY
        toolBar2.tintColor = Theme.WHITE
        
        let doneButton2 = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton2.tag = 1
        doneButton2.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        
        toolBar2.setItems([flexibleSpace, doneButton2], animated: false)
        toolBar2.isUserInteractionEnabled = true
        
        firstTextView.lineTextView?.inputAccessoryView = toolBar
        lastTextView.lineTextView?.inputAccessoryView = toolBar
        emailTextView.lineTextView?.inputAccessoryView = toolBar2
    }
    
    @objc func nextPressed() {
        if firstTextView.lineTextView!.isFirstResponder {
            lastTextView.lineTextView?.becomeFirstResponder()
        } else if lastTextView.lineTextView!.isFirstResponder {
            emailTextView.lineTextView?.becomeFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" {
            textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
            dismissKeyboard()
            return
        }
    }
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let height = keyboardViewEndFrame.height
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            nextButtonBottomAnchor.isActive = true
            nextButtonKeyboardAnchor.isActive = false
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 60, right: 0)
            nextButtonBottomAnchor.isActive = false
            nextButtonKeyboardAnchor.isActive = true
            nextButtonKeyboardAnchor.constant = -height - 16
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
