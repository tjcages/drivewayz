//
//  MapKitMainBar.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import AVFoundation

extension MapKitViewController {
    
    func setupMainBar() {
    
        self.view.addSubview(mainBar)
        mainBarWidthAnchor = mainBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -72)
        mainBarWidthAnchor.isActive = true
        mainBarCenterAnchor = mainBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        mainBarCenterAnchor.isActive = true
        mainBarHeightAnchor = mainBar.heightAnchor.constraint(equalToConstant: 60)
        mainBarHeightAnchor.isActive = true
        switch device {
        case .iphone8:
            mainBarTopAnchor = mainBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
            mainBarTopAnchor.isActive = true
        case .iphoneX:
            mainBarTopAnchor = mainBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
            mainBarTopAnchor.isActive = true
        }
        
        mapView.addSubview(hamburgerButton)
        hamburgerButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 24).isActive = true
        hamburgerButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        hamburgerButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            hamburgerButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40).isActive = true
        case .iphoneX:
            hamburgerButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50).isActive = true
        }
        
        mainBar.addSubview(locatorButton)
        locatorButton.rightAnchor.constraint(equalTo: mainBar.rightAnchor, constant: -6).isActive = true
        locatorButton.centerYAnchor.constraint(equalTo: mainBar.centerYAnchor).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        locatorButton.widthAnchor.constraint(equalTo: locatorButton.heightAnchor).isActive = true
        
        mainBar.addSubview(diamondView)
        diamondView.leftAnchor.constraint(equalTo: mainBar.leftAnchor, constant: 20).isActive = true
        diamondTopAnchor = diamondView.centerYAnchor.constraint(equalTo: locatorButton.centerYAnchor)
        diamondTopAnchor.isActive = true
        diamondView.widthAnchor.constraint(equalToConstant: 6).isActive = true
        diamondView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        mainBar.addSubview(microphoneButton)
        microphoneRightAnchor = microphoneButton.rightAnchor.constraint(equalTo: locatorButton.leftAnchor, constant: 4)
        microphoneRightAnchor.isActive = true
        microphoneButton.centerYAnchor.constraint(equalTo: mainBar.centerYAnchor, constant: 30).isActive = true
        microphoneButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        microphoneButton.widthAnchor.constraint(equalTo: microphoneButton.heightAnchor).isActive = true
        
        mainBar.addSubview(searchBar)
        searchBar.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        searchBar.leftAnchor.constraint(equalTo: diamondView.rightAnchor, constant: 12).isActive = true
        searchBar.rightAnchor.constraint(equalTo: microphoneButton.leftAnchor, constant: -2).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: diamondView.centerYAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalTo: mainBar.heightAnchor).isActive = true
        
        mainBar.addSubview(searchLabel)
        searchLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        searchLabel.rightAnchor.constraint(equalTo: mainBar.rightAnchor).isActive = true
        searchLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            searchLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            searchLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 40).isActive = true
        }
        
        self.view.addSubview(resultsScrollView)
        resultsScrollView.contentSize = CGSize.zero
        resultsScrollView.leftAnchor.constraint(equalTo: mapView.leftAnchor).isActive = true
        resultsScrollView.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true
        resultsScrollView.topAnchor.constraint(equalTo: mainBar.bottomAnchor, constant: -10).isActive = true
        resultsScrollAnchor = resultsScrollView.heightAnchor.constraint(equalToConstant: 0)
        resultsScrollAnchor.isActive = true
        
        resultsScrollView.addSubview(clearView)
        resultsScrollView.addSubview(locationRecentResults.view)
        locationRecentResults.view.topAnchor.constraint(equalTo: resultsScrollView.topAnchor).isActive = true
        locationRecentResults.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        locationRecentResults.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        locationRecentHeightAnchor = locationRecentResults.view.heightAnchor.constraint(equalToConstant: 110)
        locationRecentHeightAnchor.isActive = true
        
        clearView.topAnchor.constraint(equalTo: locationRecentResults.view.topAnchor).isActive = true
        clearView.leftAnchor.constraint(equalTo: locationRecentResults.view.leftAnchor).isActive = true
        clearView.rightAnchor.constraint(equalTo: locationRecentResults.view.rightAnchor).isActive = true
        clearView.bottomAnchor.constraint(equalTo: locationRecentResults.view.bottomAnchor).isActive = true
        
        resultsScrollView.addSubview(locationsSearchResults.view)
        locationsSearchResults.view.topAnchor.constraint(equalTo: locationRecentResults.view.bottomAnchor).isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        locationsSearchResults.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    
        let pan = UIPanGestureRecognizer(target: self, action: #selector(mainBarSwiped(sender:)))
        mainBar.addGestureRecognizer(pan)
    }
    
    @objc func mainBarSwiped(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if sender.state == .changed && abs(translation.x) <= 16 && abs(translation.y) <= 16 {
            if self.mainBarCenterAnchor.constant < 16 && self.mainBarCenterAnchor.constant > -16 {
                self.mainBarCenterAnchor.constant = translation.x
            }
            var constant: CGFloat = 0
            switch device {
            case .iphone8:
                constant = 100
            case .iphoneX:
                constant = 120
            }
            if self.mainBarTopAnchor.constant < constant + 16 && self.mainBarTopAnchor.constant > constant - 16 {
                self.mainBarTopAnchor.constant = self.mainBarTopAnchor.constant + translation.y
            }
            self.view.layoutIfNeeded()
        } else if sender.state == .ended {
            UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.mainBarCenterAnchor.constant = 0
                switch device {
                case .iphone8:
                    self.mainBarTopAnchor.constant = 100
                case .iphoneX:
                    self.mainBarTopAnchor.constant = 120
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func microphoneButtonPressed(sender: UIButton) {
        self.dismissKeyboard()
        UIView.animate(withDuration: animationIn, animations: {
            self.speechSearchResults.view.alpha = 1
        }) { (success) in
            self.speechSearchResults.recordAndRecognizeSpeech()
        }
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.WHITE
        toolBar.tintColor = Theme.PRUSSIAN_BLUE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.searchBar.inputAccessoryView = toolBar
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text":textField.text!])
        if textField.text == "" {
            UIView.animate(withDuration: animationOut) {
                self.locationsSearchResults.view.alpha = 0
            }
        }
    }
    
}


extension MapKitViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard !synthesizer.isSpeaking else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
}
