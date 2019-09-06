//
//  RecognizerViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import PayCardsRecognizer

class RecognizerViewController: UIViewController, PayCardsRecognizerPlatformDelegate {
    
    var delegate: handleCardRecognition?
    var recognizer: PayCardsRecognizer!
    
    var container = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight - 140))
    
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
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan your card"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.text = "Make sure the edges line up and the card number is visible."
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 2
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizer = PayCardsRecognizer(delegate: self, resultMode: .async, container: container, frameColor: Theme.WHITE)
        recognizer.delegate = self
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recognizer.startCamera()
        recognizer.resumeRecognizer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        recognizer.stopCamera()
    }
    
    func setupViews() {
        
        view.addSubview(container)
        view.addSubview(gradientContainer)
        gradientContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.bottomAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: -16).isActive = true
        
        view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 16).isActive = true
        mainLabel.sizeToFit()
        
        view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        self.delegate?.cardRecognized(result: result)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
