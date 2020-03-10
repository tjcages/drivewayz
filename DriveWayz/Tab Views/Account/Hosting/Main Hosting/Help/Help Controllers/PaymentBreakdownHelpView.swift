//
//  PaymentBreakdownHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PaymentBreakdownHelpView: UIViewController {

    var delegate: HelpMenuDelegate?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BACKGROUND_GRAY
        button.layer.cornerRadius = 2.5
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Payment breakdown"
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The total amount charged to the consumer includes the hourly cost plus processing and payment fees. \n\nDrivewayz takes 20-25% of the total before fees for listing costs."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 8
        
        return label
    }()
    
    var reservationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.tintColor = Theme.BLACK
        let image = UIImage(named: "hostEarningsIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$8.80 for 2.25 hours"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Last payment"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total cost"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var balanceAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$11.73"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var hourlyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hourly price"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
          
        return label
    }()
      
    var hourlyAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$5.21/hour"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
          
        return label
    }()
    
    var bookingFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booking fee"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
          
        return label
    }()
      
    var bookingFeeAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$0.30"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
          
        return label
    }()
    
    var processingFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Processing fee"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
          
        return label
    }()
      
    var processingFeeAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$0.34"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
          
        return label
    }()
    
    var drivewayzFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz fee"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
          
        return label
    }()
      
    var drivewayzFeeAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$2.93"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
          
        return label
    }()
    
    var balanceLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
        
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
        setupListing()
        setupPrevious()
        setupContainer()
    }
    
    var panBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        view.addSubview(mainButton)
        panBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight)
            panBottomAnchor.isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    func setupListing() {
        
        view.addSubview(drivewayzFeeLabel)
        view.addSubview(drivewayzFeeAmount)
        
        drivewayzFeeLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -32).isActive = true
        drivewayzFeeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        drivewayzFeeLabel.sizeToFit()
        
        drivewayzFeeAmount.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -32).isActive = true
        drivewayzFeeAmount.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        drivewayzFeeAmount.sizeToFit()
        
        view.addSubview(processingFeeLabel)
        view.addSubview(processingFeeAmount)
        
        processingFeeLabel.bottomAnchor.constraint(equalTo: drivewayzFeeLabel.topAnchor, constant: -12).isActive = true
        processingFeeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        processingFeeLabel.sizeToFit()
        
        processingFeeAmount.bottomAnchor.constraint(equalTo: drivewayzFeeLabel.topAnchor, constant: -12).isActive = true
        processingFeeAmount.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        processingFeeAmount.sizeToFit()
        
        view.addSubview(bookingFeeLabel)
        view.addSubview(bookingFeeAmount)
        
        bookingFeeLabel.bottomAnchor.constraint(equalTo: processingFeeLabel.topAnchor, constant: -12).isActive = true
        bookingFeeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        bookingFeeLabel.sizeToFit()
        
        bookingFeeAmount.bottomAnchor.constraint(equalTo: processingFeeLabel.topAnchor, constant: -12).isActive = true
        bookingFeeAmount.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        bookingFeeAmount.sizeToFit()
        
        view.addSubview(hourlyLabel)
        view.addSubview(hourlyAmount)
        
        hourlyLabel.bottomAnchor.constraint(equalTo: bookingFeeLabel.topAnchor, constant: -12).isActive = true
        hourlyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        hourlyLabel.sizeToFit()
        
        hourlyAmount.bottomAnchor.constraint(equalTo: bookingFeeLabel.topAnchor, constant: -12).isActive = true
        hourlyAmount.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        hourlyAmount.sizeToFit()
        
        view.addSubview(balanceLine)
        view.addSubview(balanceLabel)
        view.addSubview(balanceAmount)
        
        balanceLine.anchor(top: nil, left: view.leftAnchor, bottom: hourlyLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 1)
        
        balanceLabel.bottomAnchor.constraint(equalTo: balanceLine.topAnchor, constant: -12).isActive = true
        balanceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        balanceLabel.sizeToFit()
        
        balanceAmount.bottomAnchor.constraint(equalTo: balanceLine.topAnchor, constant: -12).isActive = true
        balanceAmount.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        balanceAmount.sizeToFit()
        
    }
    
    func setupPrevious() {
        
        view.addSubview(reservationIcon)
        view.addSubview(titleLabel)
        view.addSubview(subLabel)
        
        reservationIcon.anchor(top: nil, left: view.leftAnchor, bottom: balanceLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 45, height: 45)
        
        subLabel.topAnchor.constraint(equalTo: reservationIcon.topAnchor, constant: -2).isActive = true
        subLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        titleLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        titleLabel.sizeToFit()
        
        view.addSubview(informationLabel)
        informationLabel.bottomAnchor.constraint(equalTo: reservationIcon.topAnchor, constant: -32).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        informationLabel.sizeToFit()
        
    }
    
    func setupContainer() {
        
        container.addSubview(line)
        container.addSubview(mainLabel)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: informationLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        
    }
    
    @objc func mainButtonPressed() {
        dismissView()
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.panBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.panBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.panBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        delegate?.removeDim()
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
