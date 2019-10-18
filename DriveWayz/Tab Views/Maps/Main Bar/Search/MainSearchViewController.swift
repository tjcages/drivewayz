//
//  MainSearchViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MainSearchViewController: UIViewController {
    
    var delegate: handleInviteControllers?
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Where are you headed?"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var microphoneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        button.layer.cornerRadius = 18
        let origImage = UIImage(named: "calendarIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    var homeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.layer.cornerRadius = 15
        button.tintColor = Theme.WHITE
        let image = UIImage(named: "coupon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        
        return button
    }()
    
    var homeLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Park today and receive 10% off!", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var recentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.4)
        button.layer.cornerRadius = 15
        button.tintColor = Theme.WHITE
        
        return button
    }()
    
    var recentLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        checkRecentSearches()
        setupViews()
        setupSearch()
    }
    
    func setupViews() {
        
        self.view.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        searchButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        searchButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        searchButton.addSubview(searchLabel)
        searchLabel.leftAnchor.constraint(equalTo: searchButton.leftAnchor, constant: 16).isActive = true
        searchLabel.rightAnchor.constraint(equalTo: searchButton.rightAnchor, constant: -16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        searchButton.addSubview(microphoneButton)
        microphoneButton.rightAnchor.constraint(equalTo: searchButton.rightAnchor, constant: -12).isActive = true
        microphoneButton.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        microphoneButton.topAnchor.constraint(equalTo: searchButton.topAnchor, constant: 12).isActive = true
        microphoneButton.widthAnchor.constraint(equalTo: microphoneButton.heightAnchor).isActive = true
        
    }
    
    func setupSearch() {
        
        self.view.addSubview(homeButton)
        homeButton.leftAnchor.constraint(equalTo: searchButton.leftAnchor).isActive = true
        homeButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        homeButton.widthAnchor.constraint(equalTo: homeButton.heightAnchor).isActive = true
        
        self.view.addSubview(homeLabel)
        homeLabel.leftAnchor.constraint(equalTo: homeButton.rightAnchor, constant: 6).isActive = true
        homeLabel.centerYAnchor.constraint(equalTo: homeButton.centerYAnchor).isActive = true
        homeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        homeLabel.sizeToFit()
        
        self.view.addSubview(recentButton)
        recentButton.leftAnchor.constraint(equalTo: homeLabel.rightAnchor, constant: 16).isActive = true
        recentButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16).isActive = true
        recentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        recentButton.widthAnchor.constraint(equalTo: homeButton.heightAnchor).isActive = true
        
        self.view.addSubview(recentLabel)
        recentLabel.leftAnchor.constraint(equalTo: recentButton.rightAnchor, constant: 6).isActive = true
        recentLabel.centerYAnchor.constraint(equalTo: recentButton.centerYAnchor).isActive = true
        recentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        recentLabel.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -12).isActive = true
        recentLabel.sizeToFit()

    }
    
    func checkRecentSearches() {
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            var first = firstRecent as! String
            if let dotRange = first.range(of: ",") {
                first.removeSubrange(dotRange.lowerBound..<first.endIndex)
                self.homeLabel.setTitle(first, for: .normal)
                self.homeButton.alpha = 1
                self.homeLabel.alpha = 1
                let image = UIImage(named: "time")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.homeButton.setImage(tintedImage, for: .normal)
                self.homeButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                self.homeButton.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.8)
                self.homeLabel.addTarget(self, action: #selector(firstRecentPressed), for: .touchUpInside)
                self.homeButton.addTarget(self, action: #selector(firstRecentPressed), for: .touchUpInside)
            }
        }
        if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
            var second = secondRecent as! String
            if let dotRange = second.range(of: ",") {
                second.removeSubrange(dotRange.lowerBound..<second.endIndex)
                self.recentLabel.setTitle(second, for: .normal)
                self.recentButton.alpha = 1
                self.recentLabel.alpha = 1
                let image = UIImage(named: "time")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.recentButton.setImage(tintedImage, for: .normal)
                self.recentButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                self.recentButton.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.8)
                self.recentLabel.addTarget(self, action: #selector(secondRecentPressed), for: .touchUpInside)
                self.recentButton.addTarget(self, action: #selector(secondRecentPressed), for: .touchUpInside)
            }
        } else {
            self.recentButton.alpha = 0
            self.recentLabel.alpha = 0
        }
    }
    
    @objc func firstRecentPressed() {
        if let text = self.homeLabel.titleLabel?.text {
//            self.delegate?.searchRecentsPressed(address: text)
        }
    }
    
    @objc func secondRecentPressed() {
        if let text = self.recentLabel.titleLabel?.text {
//            self.delegate?.searchRecentsPressed(address: text)
        }
    }

}
