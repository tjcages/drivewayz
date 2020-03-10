//
//  DurationViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/15/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class DurationViewController: UIViewController {
    
    var delegate: handleCheckoutParking?
    
    var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tell us how long you plan on staying"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today, 2:00pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to 3:45pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var sliderView: DurationSliderView = {
        let view = DurationSliderView()
        
        return view
    }()
    
    var leaveNowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 16
        button.setTitle("Leave now", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        
        return button
    }()
    
    var departAtButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Depart at", for: .normal)
        button.setTitleColor(Theme.GRAY_WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.alpha = 0.5
        
        return button
    }()
    
    var arriveByButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Arrive by", for: .normal)
        button.setTitleColor(Theme.GRAY_WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.alpha = 0.5
        
        return button
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Set Duration", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 2
        
        return button
    }()
    
    var buttonLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 25
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        dimView.addGestureRecognizer(tap)
        
        setupButtons()
        setupDuration()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.backButton.alpha = 1
        }, completion: nil)
    }
    
    func setupButtons() {
        
        view.addSubview(dimView)
        dimView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(container)
        view.addSubview(mainButton)
        view.addSubview(leaveNowButton)
        view.addSubview(departAtButton)
        view.addSubview(arriveByButton)
        view.addSubview(buttonLine)
        
        switch device {
        case .iphoneX:
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .iphone8:
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        }
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        leaveNowButton.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 16, paddingRight: 0, width: 100, height: 32)
        
        departAtButton.anchor(top: nil, left: leaveNowButton.rightAnchor, bottom: mainButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 16, paddingRight: 0, width: 92, height: 32)
        
        arriveByButton.anchor(top: nil, left: departAtButton.rightAnchor, bottom: mainButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 16, paddingRight: 0, width: 92, height: 32)
        
        buttonLine.anchor(top: nil, left: view.leftAnchor, bottom: leaveNowButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 1)
        
    }
    
    func setupDuration() {
        
        view.addSubview(sliderView)
        sliderView.anchor(top: nil, left: view.leftAnchor, bottom: buttonLine.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 0, height: 164)
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -4).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.bottomAnchor.constraint(equalTo: sliderView.topAnchor, constant: -20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
    }
    
    func setupViews() {
        
        view.addSubview(informationLabel)
        view.addSubview(line)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: mainLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        informationLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        container.anchor(top: informationLabel.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(backButton)
        backButton.anchor(top: nil, left: view.leftAnchor, bottom: container.topAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 0, width: 50, height: 50)
        
    }
    
    @objc func mainButtonPressed() {
        
    }
    
    @objc func backButtonPressed() {
        delegate?.parkingMaximized()
        UIView.animateOut(withDuration: animationOut, animations: {
            tabDimmingView.alpha = 0
        }, completion: nil)
        dismiss(animated: true, completion: nil)
    }

}
