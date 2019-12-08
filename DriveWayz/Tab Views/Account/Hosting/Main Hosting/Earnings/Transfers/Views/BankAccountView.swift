//
//  BankAccountView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BankAccountView: UIViewController {

    var delegate: BankNamesDelegate?

    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your \naccount details"
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

    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    var routingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Routing number"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var routingTextField: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .numberPad
        view.lineTextView?.placeholderLabel.text = "110000000"
        view.lineTextView?.autocapitalizationType = .none
        view.lineTextView?.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        
        return view
    }()
    
    var accountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Account number"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var accountTextField: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .numberPad
        view.lineTextView?.placeholderLabel.text = "000123456789"
        view.lineTextView?.autocapitalizationType = .none
        view.lineTextView?.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        
        return view
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
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.cornerRadius = 3
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        
        scrollView.delegate = self
        routingTextField.lineTextView?.delegate = self
        accountTextField.lineTextView?.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        setupViews()
        setupFirst()
        createToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.scrollToTop(animated: true)
        iconController.expandBank()
        routingTextField.lineTextView?.becomeFirstResponder()
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

        view.addSubview(container)
        view.addSubview(line)
        
        container.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        line.anchor(top: nil, left: nil, bottom: container.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 60, height: 6)
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        container.addSubview(scrollView)
        container.addSubview(backView)
        view.addSubview(backButton)
        scrollView.addSubview(iconController.view)
        
        backButton.anchor(top: container.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        backView.anchor(top: container.topAnchor, left: view.leftAnchor, bottom: backButton.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -20, paddingRight: 0, width: 0, height: 0)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1200)
        scrollView.anchor(top: container.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        iconController.expandPhone()
        iconController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        iconController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconController.view.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        iconController.view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        scrollView.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: iconController.view.bottomAnchor, constant: 32).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.sizeToFit()
        
    }
    
    func setupFirst() {
        
        scrollView.addSubview(routingLabel)
        scrollView.addSubview(routingTextField)
        routingLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        routingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        routingLabel.sizeToFit()
        
        routingTextField.anchor(top: routingLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        
        scrollView.addSubview(accountLabel)
        scrollView.addSubview(accountTextField)
        accountLabel.topAnchor.constraint(equalTo: routingTextField.bottomAnchor, constant: 20).isActive = true
        accountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        accountLabel.sizeToFit()
        
        accountTextField.anchor(top: accountLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        
        container.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
    }
    
    @objc func nextButtonPressed() {

    }
    
    @objc func backButtonPressed() {
        dismissController()
    }
    
    @objc func dismissController() {
        dismiss(animated: true) {
            self.delegate?.dismissAccount()
        }
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

}

extension BankAccountView: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismissController()
    }
}

extension BankAccountView: UITextViewDelegate, UITextFieldDelegate {
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.tag = 1
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        routingTextField.lineTextView?.inputAccessoryView = toolBar
        accountTextField.lineTextView?.inputAccessoryView = toolBar
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" {
            textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
            dismissKeyboard()
            return
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        // check the condition not exceed 9 chars
        if textView == routingTextField {
            return !(textView.text!.count > 9 && (text.count ) > range.length)
        } else {
            return !(textView.text!.count > 12 && (text.count ) > range.length)
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

extension BankAccountView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 60 {
            if backView.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.backView.alpha = 1
                }
            }
        } else {
            if backView.alpha == 1 {
                UIView.animate(withDuration: animationIn) {
                    self.backView.alpha = 0
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 60 {
            if backView.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.backView.alpha = 1
                }
            }
        } else {
            if backView.alpha == 1 {
                UIView.animate(withDuration: animationIn) {
                    self.backView.alpha = 0
                }
            }
        }
    }
    
}
