//
//  BookingIssueHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol BookingHelpDelegate {
    func removeDim()
}

class BookingIssueHelpView: UIViewController {

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
        label.text = "Booking issue"
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var firstBookingIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.HOST_BLUE
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.tintColor = Theme.BLUE
        let image = UIImage(named: "hostAvailabilityIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return button
    }()
    
    var firstTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today, 11:00am • 3:30pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var firstSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current booking"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var firstSelection: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(firstSelectionPressed), for: .touchUpInside)
        
        return button
    }()
    
    var secondBookingIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.tintColor = Theme.BLACK
        let image = UIImage(named: "hostAvailabilityIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return button
    }()
    
    var secondTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wed 18, Nov 2019"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var secondSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Previous booking"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var secondSelection: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(secondSelectionPressed), for: .touchUpInside)
        
        return button
    }()
        
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
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
        
        view.addSubview(secondBookingIcon)
        view.addSubview(secondTitleLabel)
        view.addSubview(secondSubLabel)
        view.addSubview(secondSelection)
        
        secondBookingIcon.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 0, width: 45, height: 45)
        
        secondSubLabel.topAnchor.constraint(equalTo: secondBookingIcon.topAnchor, constant: -2).isActive = true
        secondSubLabel.leftAnchor.constraint(equalTo: secondBookingIcon.rightAnchor, constant: 20).isActive = true
        secondSubLabel.sizeToFit()
        
        secondTitleLabel.topAnchor.constraint(equalTo: secondSubLabel.bottomAnchor).isActive = true
        secondTitleLabel.leftAnchor.constraint(equalTo: secondBookingIcon.rightAnchor, constant: 20).isActive = true
        secondTitleLabel.sizeToFit()
        
        secondSelection.anchor(top: secondBookingIcon.topAnchor, left: view.leftAnchor, bottom: secondBookingIcon.bottomAnchor, right: view.rightAnchor, paddingTop: -16, paddingLeft: 0, paddingBottom: -16, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(firstBookingIcon)
        view.addSubview(firstTitleLabel)
        view.addSubview(firstSubLabel)
        view.addSubview(firstSelection)
        
        firstBookingIcon.anchor(top: nil, left: view.leftAnchor, bottom: secondBookingIcon.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 0, width: 45, height: 45)
        
        firstSubLabel.topAnchor.constraint(equalTo: firstBookingIcon.topAnchor, constant: -2).isActive = true
        firstSubLabel.leftAnchor.constraint(equalTo: firstBookingIcon.rightAnchor, constant: 20).isActive = true
        firstSubLabel.sizeToFit()
        
        firstTitleLabel.topAnchor.constraint(equalTo: firstSubLabel.bottomAnchor).isActive = true
        firstTitleLabel.leftAnchor.constraint(equalTo: firstBookingIcon.rightAnchor, constant: 20).isActive = true
        firstTitleLabel.sizeToFit()
        
        firstSelection.anchor(top: firstBookingIcon.topAnchor, left: view.leftAnchor, bottom: firstBookingIcon.bottomAnchor, right: view.rightAnchor, paddingTop: -16, paddingLeft: 0, paddingBottom: -16, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func setupContainer() {
        
        container.addSubview(line)
        container.addSubview(mainLabel)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: firstSubLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        
    }

    @objc func firstSelectionPressed() {
        showBookingHelp()
    }
    
    @objc func secondSelectionPressed() {
        showBookingHelp()
    }
    
    func showBookingHelp() {
        hideCurrentView()
        let controller = BookingHelpView()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.isHidden = true
        present(navigation, animated: true, completion: nil)
    }
    
    func hideCurrentView() {
        panBottomAnchor.constant = bottomAnchor + 120
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
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

extension BookingIssueHelpView: BookingHelpDelegate {
    
    func removeDim() {
        panBottomAnchor.constant = bottomAnchor
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
}
