//
//  NewCardView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFirestore
import PayCardsRecognizer

protocol handleCardRecognition {
    func cardRecognized(result: PayCardsRecognizerResult)
}

class NewCardView: UIViewController {
    
    var delegate: updatePaymentMethod?
    var paymentMethods: [PaymentMethod] = []
    var cardName: String?
    
    var paymentCardTextField: STPPaymentCardTextField = {
        let field = STPPaymentCardTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardAppearance = .dark
        field.borderColor = Theme.BLUE
        field.borderWidth = 2
        
        return field
    }()

    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        //        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "New card"
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
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var cardNumberLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        view.text = "Card number"

        return view
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.setTitle("Save Card", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var imageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.addTarget(self, action: #selector(openCardRecognizer), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.backgroundColor = Theme.DARK_GRAY
        
        return button
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        scrollView.delegate = self
        
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        paymentCardTextField.delegate = self
        
        setupViews()
        createToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        paymentCardTextField.becomeFirstResponder()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var saveButtonWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        }
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
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
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        scrollView.addSubview(cardNumberLabel)
        cardNumberLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        cardNumberLabel.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 32).isActive = true
        cardNumberLabel.sizeToFit()
        
        scrollView.addSubview(paymentCardTextField)
        paymentCardTextField.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 8).isActive = true
        paymentCardTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        paymentCardTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        paymentCardTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        scrollView.addSubview(saveButton)
        scrollView.addSubview(imageButton)
        
        saveButton.topAnchor.constraint(equalTo: paymentCardTextField.bottomAnchor, constant: 32).isActive = true
        saveButtonWidthAnchor = saveButton.leftAnchor.constraint(equalTo: imageButton.leftAnchor, constant: 68)
            saveButtonWidthAnchor.isActive = true
        saveButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        imageButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor).isActive = true
        imageButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageButton.heightAnchor.constraint(equalTo: imageButton.widthAnchor).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    @objc func saveButtonPressed() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        saveButtonUnavailable()
        loadingLine.alpha = 1
        loadingLine.startAnimating()
        
        let cardParams = paymentCardTextField.cardParams
        let params = STPCardParams()
        params.number = cardParams.number
        if let monthNumber = cardParams.expMonth, let month = UInt(exactly: monthNumber), let yearNumber = cardParams.expYear, let year = UInt(exactly: yearNumber) {
            if let name = cardName {
                params.name = name
            }
            params.expMonth = month
            params.expYear = year
            params.cvc = cardParams.cvc
            STPAPIClient.shared().createToken(withCard: params) { token, error in
                guard let token = token else {
                    // Handle the error
                    return
                }
                // Set all other cards to false for default
                for method in self.paymentMethods {
                    if let fingerprint = method.fingerprint, var dictionary = method.dictionary {
                        dictionary["default"] = false
                        let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("sources").document(fingerprint)
                        db.setData(dictionary)
                    }
                }
                
                // Use the token in the next step
                let db = Firestore.firestore()
                let data = ["tokens": token.tokenId]
                db.collection("stripe_customers").document(userId).collection("tokens").addDocument(data: data, completion: { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                        return
                    }
                    
                    self.delegate?.loadPayments()
                    self.loadingLine.alpha = 0
                    self.loadingLine.endAnimating()
                    self.backButtonPressed()
                })
            }
        }
    }
    
}

extension NewCardView: STPPaymentCardTextFieldDelegate, handleCardRecognition {
    
    func cardRecognized(result: PayCardsRecognizerResult) {
        let params = STPCardParams()
        params.number = result.recognizedNumber
        if let month = result.recognizedExpireDateMonth, let monthInt = UInt(month) {
            params.expMonth = monthInt
        }
        if let year = result.recognizedExpireDateYear, let yearInt = UInt(year) {
            params.expYear = yearInt
        }
        if let name = result.recognizedHolderName {
            params.name = name
            cardName = name
        }
        paymentCardTextField.cardParams = STPPaymentMethodCardParams(cardSourceParams: params)
        paymentCardTextField.becomeFirstResponder()
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        if textField.isValid {
            saveButtonAvailable()
        } else {
            saveButtonUnavailable()
        }
        if textField.cardNumber != "" {
            if imageButton.alpha == 1 {
                UIView.animate(withDuration: animationIn, animations: {
                    self.imageButton.alpha = 0
                }) { (success) in
                    self.saveButtonWidthAnchor.constant = 0
                    UIView.animate(withDuration: animationIn) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        } else if textField.cardNumber == "" {
            if imageButton.alpha == 0 {
                self.saveButtonWidthAnchor.constant = 68
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.layoutIfNeeded()
                }) { (success) in
                    UIView.animate(withDuration: animationIn) {
                        self.imageButton.alpha = 1
                    }
                }
            }
        }
    }
    
    func saveButtonAvailable() {
        UIView.animate(withDuration: animationIn) {
            self.saveButton.setTitleColor(Theme.WHITE, for: .normal)
            self.saveButton.backgroundColor = Theme.DARK_GRAY
            self.saveButton.isEnabled = true
        }
    }
    
    func saveButtonUnavailable() {
        UIView.animate(withDuration: animationIn) {
            self.saveButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.saveButton.backgroundColor = lineColor
            self.saveButton.isEnabled = false
        }
    }
    
    @objc func openCardRecognizer() {
        let controller = RecognizerViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true, completion: nil)
    }

    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


extension NewCardView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
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
        
        paymentCardTextField.inputAccessoryView = toolBar
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
