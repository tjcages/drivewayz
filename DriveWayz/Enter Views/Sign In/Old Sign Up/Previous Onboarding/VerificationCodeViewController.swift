//
//  VerificationCodeViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/20/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import MapKit
import NVActivityIndicatorView

class VerificationCodeViewController: UIViewController {

    var delegate: handleVerificationCode?
    var phoneNumber: String?
    var uid: String?
    var verificationCode: String? {
        didSet {
            guard let number = self.phoneNumber else { return }
            let fullText = "Enter the 6-digit code sent to you at \(number)"
            let range = (NSString(string: fullText)).range(of: "\(number)")
            let attributedString = NSMutableAttributedString(string: fullText)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.BLACK , range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPSemiBoldH1 , range: range)
            self.mainLabel.attributedText = attributedString
        }
    }
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPLightH1
        label.numberOfLines = 2
        
        return label
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(checkVerificationCode), for: .touchUpInside)
        button.backgroundColor = Theme.BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    var firstVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPRegularH0
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = " "
        
        return field
    }()
    
    var firstVerificationLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var secondVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPRegularH0
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = " "
        
        return field
    }()
    
    var secondVerificationLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var thirdVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPRegularH0
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = " "
        
        return field
    }()
    
    var thirdVerificationLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var fourthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPRegularH0
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = " "
        
        return field
    }()
    
    var fourthVerificationLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var fifthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPRegularH0
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = " "
        
        return field
    }()
    
    var fifthVerificationLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var sixthVerificationField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.clear
        field.font = Fonts.SSPRegularH0
        field.textColor = Theme.BLACK
        field.tintColor = UIColor.clear
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.text = " "
        
        return field
    }()
    
    var sixthVerificationLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var didntRecieve: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("I did not recieve code", for: .normal)
        button.setTitleColor(Theme.LIGHT_BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        
        return button
    }()
    
    var passwordSignin: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in with email and password", for: .normal)
        button.setTitleColor(Theme.LIGHT_BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstVerificationField.delegate = self
        secondVerificationField.delegate = self
        thirdVerificationField.delegate = self
        fourthVerificationField.delegate = self
        fifthVerificationField.delegate = self
        sixthVerificationField.delegate = self
        
        setupViews()
    }
    
    var viewContainerHeightAnchor: NSLayoutConstraint!
    var mainLabelTopAnchor: NSLayoutConstraint!
    var phoneNumberWidthAnchor: NSLayoutConstraint!
    var keyboardHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(viewContainer)
        viewContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        viewContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        viewContainer.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 120).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        viewContainer.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 12).isActive = true
        backButton.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 24).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        setupVerificationField()
        createToolbar()
    }
    
    func setupVerificationField() {
        
        self.view.addSubview(firstVerificationField)
        firstVerificationField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        firstVerificationField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10).isActive = true
        firstVerificationField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        firstVerificationField.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(firstVerificationLine)
        firstVerificationLine.leftAnchor.constraint(equalTo: firstVerificationField.leftAnchor).isActive = true
        firstVerificationLine.rightAnchor.constraint(equalTo: firstVerificationField.rightAnchor).isActive = true
        firstVerificationLine.topAnchor.constraint(equalTo: firstVerificationField.bottomAnchor).isActive = true
        firstVerificationLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(secondVerificationField)
        secondVerificationField.leftAnchor.constraint(equalTo: firstVerificationField.rightAnchor, constant: 8).isActive = true
        secondVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        secondVerificationField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        secondVerificationField.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(secondVerificationLine)
        secondVerificationLine.leftAnchor.constraint(equalTo: secondVerificationField.leftAnchor).isActive = true
        secondVerificationLine.rightAnchor.constraint(equalTo: secondVerificationField.rightAnchor).isActive = true
        secondVerificationLine.topAnchor.constraint(equalTo: secondVerificationField.bottomAnchor).isActive = true
        secondVerificationLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(thirdVerificationField)
        thirdVerificationField.leftAnchor.constraint(equalTo: secondVerificationField.rightAnchor, constant: 8).isActive = true
        thirdVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        thirdVerificationField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        thirdVerificationField.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(thirdVerificationLine)
        thirdVerificationLine.leftAnchor.constraint(equalTo: thirdVerificationField.leftAnchor).isActive = true
        thirdVerificationLine.rightAnchor.constraint(equalTo: thirdVerificationField.rightAnchor).isActive = true
        thirdVerificationLine.topAnchor.constraint(equalTo: thirdVerificationField.bottomAnchor).isActive = true
        thirdVerificationLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(fourthVerificationField)
        fourthVerificationField.leftAnchor.constraint(equalTo: thirdVerificationField.rightAnchor, constant: 8).isActive = true
        fourthVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        fourthVerificationField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fourthVerificationField.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(fourthVerificationLine)
        fourthVerificationLine.leftAnchor.constraint(equalTo: fourthVerificationField.leftAnchor).isActive = true
        fourthVerificationLine.rightAnchor.constraint(equalTo: fourthVerificationField.rightAnchor).isActive = true
        fourthVerificationLine.topAnchor.constraint(equalTo: fourthVerificationField.bottomAnchor).isActive = true
        fourthVerificationLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(fifthVerificationField)
        fifthVerificationField.leftAnchor.constraint(equalTo: fourthVerificationField.rightAnchor, constant: 8).isActive = true
        fifthVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        fifthVerificationField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fifthVerificationField.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(fifthVerificationLine)
        fifthVerificationLine.leftAnchor.constraint(equalTo: fifthVerificationField.leftAnchor).isActive = true
        fifthVerificationLine.rightAnchor.constraint(equalTo: fifthVerificationField.rightAnchor).isActive = true
        fifthVerificationLine.topAnchor.constraint(equalTo: fifthVerificationField.bottomAnchor).isActive = true
        fifthVerificationLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(sixthVerificationField)
        sixthVerificationField.leftAnchor.constraint(equalTo: fifthVerificationField.rightAnchor, constant: 8).isActive = true
        sixthVerificationField.topAnchor.constraint(equalTo: firstVerificationField.topAnchor).isActive = true
        sixthVerificationField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sixthVerificationField.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(sixthVerificationLine)
        sixthVerificationLine.leftAnchor.constraint(equalTo: sixthVerificationField.leftAnchor).isActive = true
        sixthVerificationLine.rightAnchor.constraint(equalTo: sixthVerificationField.rightAnchor).isActive = true
        sixthVerificationLine.topAnchor.constraint(equalTo: sixthVerificationField.bottomAnchor).isActive = true
        sixthVerificationLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.view.addSubview(didntRecieve)
        didntRecieve.leftAnchor.constraint(equalTo: firstVerificationLine.leftAnchor).isActive = true
        didntRecieve.rightAnchor.constraint(equalTo: sixthVerificationLine.rightAnchor).isActive = true
        didntRecieve.topAnchor.constraint(equalTo: firstVerificationLine.bottomAnchor, constant: 10).isActive = true
        didntRecieve.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(passwordSignin)
        passwordSignin.leftAnchor.constraint(equalTo: firstVerificationLine.leftAnchor).isActive = true
        passwordSignin.rightAnchor.constraint(equalTo: sixthVerificationLine.rightAnchor).isActive = true
        passwordSignin.topAnchor.constraint(equalTo: didntRecieve.bottomAnchor, constant: 4).isActive = true
        passwordSignin.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func backToMain() {
        self.view.endEditing(true)
        self.delegate?.bringBackPhoneNumber()
    }
    
    func createToolbar() {
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        toolBar.isUserInteractionEnabled = true
//        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
//        
//        nextButton.frame = toolBar.frame
//        firstVerificationField.inputAccessoryView = nextButton
//        secondVerificationField.inputAccessoryView = nextButton
//        thirdVerificationField.inputAccessoryView = nextButton
//        fourthVerificationField.inputAccessoryView = nextButton
//        fifthVerificationField.inputAccessoryView = nextButton
//        sixthVerificationField.inputAccessoryView = nextButton
        
        self.view.addSubview(nextButton)
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.topAnchor.constraint(equalTo: passwordSignin.bottomAnchor, constant: 72).isActive = true
        nextButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        nextButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        loadingActivity.topAnchor.constraint(equalTo: passwordSignin.bottomAnchor, constant: 20).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
    }
    
    func becomeFirst() {
        UIView.animate(withDuration: animationIn) {
            self.firstVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
            self.firstVerificationLine.backgroundColor = Theme.SEA_BLUE
        }
        self.firstVerificationField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.viewContainer.endEditing(true)
    }

}


extension VerificationCodeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.firstVerificationField {
            self.firstVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
            self.firstVerificationLine.backgroundColor = Theme.SEA_BLUE
        } else if textField == self.secondVerificationField {
            self.secondVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
            self.secondVerificationLine.backgroundColor = Theme.SEA_BLUE
        } else if textField == self.thirdVerificationField {
            self.thirdVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
            self.thirdVerificationLine.backgroundColor = Theme.SEA_BLUE
        } else if textField == self.fourthVerificationField {
            self.fourthVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
            self.fourthVerificationLine.backgroundColor = Theme.SEA_BLUE
        } else if textField == self.fifthVerificationField {
            self.fifthVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
            self.fifthVerificationLine.backgroundColor = Theme.SEA_BLUE
        } else if textField == self.sixthVerificationField {
            self.sixthVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
            self.sixthVerificationLine.backgroundColor = Theme.SEA_BLUE
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        UIView.animate(withDuration: animationIn) {
            if range.length == 1 {
                textField.text = " "
                if textField == self.secondVerificationField {
                    self.firstVerificationField.text = " "
                    self.firstVerificationField.becomeFirstResponder()
                    self.firstVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.firstVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.secondVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.secondVerificationLine.backgroundColor = Theme.DARK_GRAY
                } else if textField == self.thirdVerificationField {
                    self.secondVerificationField.text = " "
                    self.secondVerificationField.becomeFirstResponder()
                    self.secondVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.secondVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.thirdVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.thirdVerificationLine.backgroundColor = Theme.DARK_GRAY
                } else if textField == self.fourthVerificationField {
                    self.thirdVerificationField.text = " "
                    self.thirdVerificationField.becomeFirstResponder()
                    self.thirdVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.thirdVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.fourthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.fourthVerificationLine.backgroundColor = Theme.DARK_GRAY
                } else if textField == self.fifthVerificationField {
                    self.fourthVerificationField.text = " "
                    self.fourthVerificationField.becomeFirstResponder()
                    self.fourthVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.fourthVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.fifthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.fifthVerificationLine.backgroundColor = Theme.DARK_GRAY
                } else if textField == self.sixthVerificationField {
                    self.fifthVerificationField.text = " "
                    self.fifthVerificationField.becomeFirstResponder()
                    self.fifthVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.fifthVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.sixthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.sixthVerificationLine.backgroundColor = Theme.DARK_GRAY
                    self.checkVerificationCode()
                }
            } else {
                textField.text = string
                if textField == self.firstVerificationField {
                    self.firstVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.firstVerificationLine.backgroundColor = Theme.DARK_GRAY
                    self.secondVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.secondVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.secondVerificationField.becomeFirstResponder()
                } else if textField == self.secondVerificationField {
                    self.secondVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.secondVerificationLine.backgroundColor = Theme.DARK_GRAY
                    self.thirdVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.thirdVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.thirdVerificationField.becomeFirstResponder()
                } else if textField == self.thirdVerificationField {
                    self.thirdVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.thirdVerificationLine.backgroundColor = Theme.DARK_GRAY
                    self.fourthVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.fourthVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.fourthVerificationField.becomeFirstResponder()
                } else if textField == self.fourthVerificationField {
                    self.fourthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.fourthVerificationLine.backgroundColor = Theme.DARK_GRAY
                    self.fifthVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.fifthVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.fifthVerificationField.becomeFirstResponder()
                } else if textField == self.fifthVerificationField {
                    self.fifthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.fifthVerificationLine.backgroundColor = Theme.DARK_GRAY
                    self.sixthVerificationLine.transform = CGAffineTransform(scaleX: 1.2, y: 3)
                    self.sixthVerificationLine.backgroundColor = Theme.SEA_BLUE
                    self.sixthVerificationField.becomeFirstResponder()
                } else if textField == self.sixthVerificationField {
                    self.sixthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.sixthVerificationLine.backgroundColor = Theme.DARK_GRAY
                    self.sixthVerificationField.endEditing(true)
                    self.checkVerificationCode()
                }
            }
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: animationIn) {
            self.firstVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.firstVerificationLine.backgroundColor = Theme.DARK_GRAY
            self.secondVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.secondVerificationLine.backgroundColor = Theme.DARK_GRAY
            self.thirdVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.thirdVerificationLine.backgroundColor = Theme.DARK_GRAY
            self.fourthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.fourthVerificationLine.backgroundColor = Theme.DARK_GRAY
            self.fifthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.fifthVerificationLine.backgroundColor = Theme.DARK_GRAY
            self.sixthVerificationLine.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.sixthVerificationLine.backgroundColor = Theme.DARK_GRAY
        }
    }
    
    @objc func checkVerificationCode() {
        if let first = self.firstVerificationField.text, let second = self.secondVerificationField.text, let third = self.thirdVerificationField.text, let fourth = self.fourthVerificationField.text, let fifth = self.fifthVerificationField.text, let sixth = self.sixthVerificationField.text {
            if first != " " && second != " " && third != " " && fourth != " " && fifth != " " && sixth != " " {
                let verification = first + second + third + fourth + fifth + sixth
                self.registerWithPhoneNumber(verification: verification)
                self.view.endEditing(true)
            }
        }
    }
    
}


extension VerificationCodeViewController {
    
    func registerWithPhoneNumber(verification: String) {
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
        if let verificationID = self.verificationCode {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verification)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let userID = authResult?.user.uid else { return }
                self.uid = userID
                let ref = Database.database().reference().child("users").child(userID)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userName = UserDefaults.standard.value(forKey: "userName") {
                        print(userName)
                    }
                    if (snapshot.value as? [String:AnyObject]) != nil {
                        self.login(uid: userID)
                    } else {
                        self.delegate?.moveToOnboarding()
                        self.loadingActivity.alpha = 0
                        self.loadingActivity.stopAnimating()
                    }
                })
            }
        }
    }
    
    func login(uid: String) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.delegate?.moveToOnboarding()
                self.loadingActivity.alpha = 0
                self.loadingActivity.stopAnimating()
            case .authorizedAlways, .authorizedWhenInUse:
                let ref = Database.database().reference().child("users").child(uid)
                ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
                
                self.delegate?.moveToMainController()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    self.mainLabel.alpha = 0
                    self.nextButton.alpha = 0
                    self.loadingActivity.alpha = 0
                    self.loadingActivity.stopAnimating()
                }
            }
        } else {
            self.delegate?.moveToOnboarding()
            self.loadingActivity.alpha = 0
            self.loadingActivity.stopAnimating()
        }
    }
    
    func createNewUser(name: String) {
        self.delegate?.moveToLocationServices()
        guard let userID = self.uid, let number = self.phoneNumber else { return }
        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
        let usersReference = ref.child("users").child(userID)
        let values = ["name": name,
                      "phone": "+1 " + number,
                      "DeviceID": AppDelegate.DEVICEID]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err?.localizedDescription as Any)
                return
            }
            print("Successfully logged in!")
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set("\(name)", forKey: "userName")
            UserDefaults.standard.synchronize()
        })
    }
    
}
