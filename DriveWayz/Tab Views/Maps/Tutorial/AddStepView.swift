//
//  AddStepView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AddStepView: UIViewController {
    
    var delegate: handleAdditionalSteps?
    
    let paymentController = ChoosePaymentView()
    let vehicleController = ChooseVehicleView()
    
    var currentPaymentMethod: PaymentMethod? {
        didSet {
            paymentView.currentPaymentMethod = self.currentPaymentMethod
            if self.currentPaymentMethod != nil {
                paymentView.completed()
                mainLabel.text = "One more step to book your first space"
                mainLabel.font = Fonts.SSPSemiBoldH3
                subLabel.text = "Next let's add your default vehicle"
                mainButton.setTitle("Enter Vehicle Information", for: .normal)
            } else {
                paymentView.incomplete()
                mainLabel.text = "You're almost ready to park"
                mainLabel.font = Fonts.SSPSemiBoldH3
                subLabel.text = "First let's add your payment method."
                successIcon.alpha = 0
                mainButton.setTitle("Enter Payment Information", for: .normal)
                mainButton.backgroundColor = Theme.BLUE
            }
        }
    }
    
    var currentVehicleMethod: Vehicles? {
        didSet {
            vehicleView.currentVehicleMethod = self.currentVehicleMethod
            if self.currentVehicleMethod != nil {
                vehicleView.completed()
                mainLabel.text = "You're all set!"
                mainLabel.font = Fonts.SSPSemiBoldH2
                subLabel.text = "Tap confirm to book parking."
                successIcon.alpha = 1
                mainButton.setTitle("Confirm Booking", for: .normal)
                mainButton.backgroundColor = Theme.DARK_GRAY
            } else {
                vehicleView.incomplete()
                successIcon.alpha = 0
                mainButton.backgroundColor = Theme.BLUE
            }
        }
    }
    
    lazy var dimmingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var helpButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "helpIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openHelp), for: .touchUpInside)
        button.alpha = 0
        
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
    
    var userGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        let image = UIImage(named: "additionalInformationGraphic")
        view.image = image
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You're almost ready to park"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "First let's add your payment method."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var paymentView: AddPaymentView = {
        let controller = AddPaymentView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        let tap = UITapGestureRecognizer(target: self, action: #selector(paymentButtonPressed))
        controller.view.addGestureRecognizer(tap)
        
        return controller
    }()
    
    lazy var vehicleView: AddVehicleView = {
        let controller = AddVehicleView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        let tap = UITapGestureRecognizer(target: self, action: #selector(vehicleButtonPressed))
        controller.view.addGestureRecognizer(tap)
        
        return controller
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Enter Payment Information", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var successIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.backgroundColor = Theme.GREEN_PIGMENT
        button.layer.cornerRadius = 24
        let image = UIImage(named: "likeIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.alpha = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.OFF_WHITE
        
        setupViews()
    }
    
    func setupViews() {

        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(helpButton)
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        }
        
        helpButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        helpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        helpButton.heightAnchor.constraint(equalTo: helpButton.widthAnchor).isActive = true
        helpButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(userGraphic)
        scrollView.addSubview(mainLabel)
        scrollView.addSubview(subLabel)
        
        userGraphic.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 72).isActive = true
        userGraphic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userGraphic.widthAnchor.constraint(equalTo: userGraphic.heightAnchor).isActive = true
        userGraphic.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: userGraphic.bottomAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        subLabel.sizeToFit()
        
        scrollView.addSubview(paymentView.view)
        paymentView.view.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 32).isActive = true
        paymentView.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        paymentView.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        paymentView.view.heightAnchor.constraint(equalToConstant: 116).isActive = true
        
        scrollView.addSubview(vehicleView.view)
        vehicleView.view.topAnchor.constraint(equalTo: paymentView.view.bottomAnchor, constant: 20).isActive = true
        vehicleView.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        vehicleView.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        vehicleView.view.heightAnchor.constraint(equalToConstant: 116).isActive = true
        
        view.addSubview(buttonView)
        view.addSubview(mainButton)
        
        mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        buttonView.anchor(top: mainButton.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(successIcon)
        successIcon.centerYAnchor.constraint(equalTo: userGraphic.topAnchor).isActive = true
        successIcon.centerXAnchor.constraint(equalTo: userGraphic.rightAnchor).isActive = true
        successIcon.heightAnchor.constraint(equalTo: successIcon.widthAnchor).isActive = true
        successIcon.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(dimmingView)
    }
    
    @objc func paymentButtonPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.6
        }) { (success) in
            self.paymentController.extendedDelegate = self
            let navigation = UINavigationController(rootViewController: self.paymentController)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    @objc func vehicleButtonPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.6
        }) { (success) in
            self.vehicleController.extendedDelegate = self
            let navigation = UINavigationController(rootViewController: self.vehicleController)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    @objc func mainButtonPressed() {
        if let title = mainButton.titleLabel?.text {
            if title == "Enter Payment Information" {
                paymentButtonPressed()
            } else if title == "Enter Vehicle Information" {
                vehicleButtonPressed()
            } else if title == "Confirm Booking" {
                delegate?.confirmBookingStep()
                backButtonPressed()
            }
        }
    }
    
    @objc func openHelp() {
        let controller = AddHelpView()
        controller.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func backButtonPressed() {
        UIView.animate(withDuration: animationOut) {
            tabDimmingView.alpha = 0
        }
        self.dismiss(animated: true) {
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

extension AddStepView: handleExtendPaymentMethod {
    
    func closeBackground() {
        UIView.animate(withDuration: animationOut) {
            self.dimmingView.alpha = 0
        }
    }

}
