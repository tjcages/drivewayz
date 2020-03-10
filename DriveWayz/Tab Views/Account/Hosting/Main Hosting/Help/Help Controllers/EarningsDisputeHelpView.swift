//
//  EarningsDisputeHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol EarningsDisputeDelegate {
    func removeDim()
}

class EarningsDisputeHelpView: UIViewController {

    var delegate: HelpMenuDelegate?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    lazy var blackView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
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
        label.text = "Earnings Dispute"
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var reservationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.tintColor = Theme.BLACK
        let image = UIImage(named: "helpPayment")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Thu 12, Nov 2019"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Last payout"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "If you believe the total earnings amount after the most recent payout does not correctly correspond to the amount shown, after applicable fees, please open a dispute claim."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 8
        
        return label
    }()
    
    lazy var checkmark: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.borderWidth = 0
        check.borderStyle = .roundedSquare(radius: 2)
        check.checkedBorderColor = Theme.BLUE
        check.uncheckedBorderColor = Theme.LINE_GRAY
        check.backgroundColor = Theme.LINE_GRAY
        check.layer.cornerRadius = 2
        check.clipsToBounds = true
        check.checkmarkColor = Theme.WHITE
        check.isChecked = false
        check.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        
        return check
    }()
    
    var checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I understand my current balance should reflect the amount after all applicable fees are collected."
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 5
        
        return label
    }()
    
    var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current balance"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var balanceAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$45.23"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
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
        button.backgroundColor = Theme.LINE_GRAY
        button.setTitle("Open Dispute Claim", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
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
        
        view.addSubview(balanceLabel)
        view.addSubview(balanceAmount)
        view.addSubview(balanceLine)
        
        balanceLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -20).isActive = true
        balanceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        balanceLabel.sizeToFit()
        
        balanceAmount.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -20).isActive = true
        balanceAmount.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        balanceAmount.sizeToFit()
        
        balanceLine.anchor(top: nil, left: view.leftAnchor, bottom: balanceLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        view.addSubview(informationLabel)
        view.addSubview(checkmark)
        view.addSubview(checkLabel)
        
        checkLabel.anchor(top: nil, left: checkmark.rightAnchor, bottom: balanceLine.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 32, width: 0, height: 0)
        checkLabel.sizeToFit()
        
        checkmark.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        checkmark.centerYAnchor.constraint(equalTo: checkLabel.centerYAnchor).isActive = true
        
        informationLabel.bottomAnchor.constraint(equalTo: checkLabel.topAnchor, constant: -32).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(reservationIcon)
        view.addSubview(titleLabel)
        view.addSubview(subLabel)
        
        reservationIcon.anchor(top: nil, left: view.leftAnchor, bottom: informationLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 45, height: 45)
        
        subLabel.topAnchor.constraint(equalTo: reservationIcon.topAnchor, constant: -2).isActive = true
        subLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        titleLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        titleLabel.sizeToFit()
        
    }
    
    func setupContainer() {
        
        container.addSubview(line)
        container.addSubview(mainLabel)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: subLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        
        view.addSubview(blackView)
        
    }
    
    @objc func mainButtonPressed() {
        mainButton.backgroundColor = Theme.LINE_GRAY
        mainButton.setTitleColor(Theme.BLACK, for: .normal)
        UIView.animate(withDuration: animationIn, animations: {
            self.blackView.alpha = 0.2
        }) { (success) in
            let controller = SuccessfulDisputeHelpView()
            controller.delegate = self
            controller.loadingActivity.startAnimating()
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true) {
                controller.animateSuccess()
            }
        }
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        if sender.isChecked {
            sender.backgroundColor = Theme.BLUE
            mainButton.backgroundColor = Theme.BLACK
            mainButton.setTitleColor(Theme.WHITE, for: .normal)
        } else {
            sender.backgroundColor = Theme.LINE_GRAY
            mainButton.backgroundColor = Theme.LINE_GRAY
            mainButton.setTitleColor(Theme.BLACK, for: .normal)
        }
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

extension EarningsDisputeHelpView: EarningsDisputeDelegate {
    
    func removeDim() {
        UIView.animate(withDuration: animationIn, animations: {
            self.blackView.alpha = 0
        }) { (success) in
            self.dismissView()
        }
    }
    
}
