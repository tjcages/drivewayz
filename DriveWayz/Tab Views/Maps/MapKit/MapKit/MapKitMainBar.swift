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
        mainBarWidthAnchor = mainBar.widthAnchor.constraint(equalToConstant: 300)
            mainBarWidthAnchor.isActive = true
        mainBarHeightAnchor = mainBar.heightAnchor.constraint(equalToConstant: 60)
            mainBarHeightAnchor.isActive = true
        mainBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        switch device {
        case .iphone8:
            mainBarTopAnchor = mainBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
                mainBarTopAnchor.isActive = true
        case .iphoneX:
            mainBarTopAnchor = mainBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
                mainBarTopAnchor.isActive = true
        }
        
        mainBar.addSubview(mainBarView)
        mainBarView.topAnchor.constraint(equalTo: mainBar.topAnchor, constant: 4).isActive = true
        mainBarView.leftAnchor.constraint(equalTo: mainBar.leftAnchor).isActive = true
        mainBarView.rightAnchor.constraint(equalTo: mainBar.rightAnchor).isActive = true
        mainBarView.bottomAnchor.constraint(equalTo: mainBar.bottomAnchor).isActive = true
        
        mainBar.addSubview(couponView.view)
        mainBar.sendSubviewToBack(couponView.view)
        couponView.view.topAnchor.constraint(equalTo: mainBar.bottomAnchor, constant: -16).isActive = true
        couponView.view.heightAnchor.constraint(equalToConstant: 42).isActive = true
        couponView.view.leftAnchor.constraint(equalTo: mainBar.leftAnchor).isActive = true
        couponView.view.rightAnchor.constraint(equalTo: mainBar.rightAnchor).isActive = true
    
        setupFirstSearch()
        setupSecondSearch()
        setupResults()
        setupEvents()
    }
    
    func setupFirstSearch() {
        
        mainBar.addSubview(microphoneButton)
        microphoneRightAnchor = microphoneButton.rightAnchor.constraint(equalTo: mainBarView.rightAnchor, constant: -14)
        microphoneRightAnchor.isActive = true
        microphoneButton.centerYAnchor.constraint(equalTo: mainBar.centerYAnchor, constant: 30).isActive = true
        microphoneButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        microphoneButton.widthAnchor.constraint(equalTo: microphoneButton.heightAnchor).isActive = true
        
        mainBar.addSubview(searchBar)
        mainBar.addSubview(locatorArrow)
        mainBar.addSubview(searchLocation)
        searchBar.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        searchBar.leftAnchor.constraint(equalTo: locatorArrow.leftAnchor, constant: 36).isActive = true
        searchBar.rightAnchor.constraint(equalTo: searchLocation.leftAnchor, constant: -4).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBarBottomAnchor = searchBar.centerYAnchor.constraint(equalTo: mainBarView.bottomAnchor, constant: -30)
        searchBarBottomAnchor.isActive = true
        
        searchBarLeftAnchor = locatorArrow.leftAnchor.constraint(equalTo: mainBar.leftAnchor, constant: 16)
        searchBarLeftAnchor.isActive = true
        locatorArrow.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        locatorArrow.widthAnchor.constraint(equalToConstant: 26).isActive = true
        locatorArrow.heightAnchor.constraint(equalTo: locatorArrow.widthAnchor).isActive = true
        
        let width: CGFloat = (self.view.frame.width - 300)/2
        searchLocation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -width).isActive = true
        searchLocation.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        searchLocation.widthAnchor.constraint(equalToConstant: 24).isActive = true
        searchLocation.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
    }
    
    func setupSecondSearch() {
        
        mainBar.addSubview(fromSearchBar)
        mainBar.addSubview(fromSearchLocation)
        fromSearchBar.leftAnchor.constraint(equalTo: searchBar.leftAnchor).isActive = true
        fromSearchBar.rightAnchor.constraint(equalTo: fromSearchLocation.leftAnchor, constant: -4).isActive = true
        fromSeachTopAnchor = fromSearchBar.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -10)
            fromSeachTopAnchor.isActive = true
        fromSearchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fromSearchBar.addSubview(fromSearchIcon)
        fromSearchIcon.centerXAnchor.constraint(equalTo: locatorArrow.centerXAnchor).isActive = true
        fromSearchIcon.centerYAnchor.constraint(equalTo: fromSearchBar.centerYAnchor).isActive = true
        fromSearchIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        fromSearchIcon.widthAnchor.constraint(equalTo: fromSearchIcon.heightAnchor).isActive = true
        
        fromSearchBar.addSubview(fromSearchLine)
        fromSearchBar.bringSubviewToFront(fromSearchIcon)
        mainBar.bringSubviewToFront(locatorArrow)
        fromSearchLine.centerXAnchor.constraint(equalTo: locatorArrow.centerXAnchor).isActive = true
        fromSearchLine.topAnchor.constraint(equalTo: fromSearchIcon.centerYAnchor).isActive = true
        fromSearchLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        fromSearchLine.bottomAnchor.constraint(equalTo: searchLocation.centerYAnchor).isActive = true
        
        fromSearchLocation.centerXAnchor.constraint(equalTo: searchLocation.centerXAnchor).isActive = true
        fromSearchLocation.centerYAnchor.constraint(equalTo: fromSearchBar.centerYAnchor).isActive = true
        fromSearchLocation.widthAnchor.constraint(equalToConstant: 26).isActive = true
        fromSearchLocation.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
    }
    
    func setupResults() {
        
        self.view.addSubview(locationsSearchResults.view)
        self.view.bringSubviewToFront(mainBar)
        locationsSearchResults.view.topAnchor.constraint(equalTo: mainBar.bottomAnchor, constant: -10).isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: mainBar.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: mainBar.rightAnchor).isActive = true
        locationResultsHeightAnchor = locationsSearchResults.view.heightAnchor.constraint(equalToConstant: 0)
            locationResultsHeightAnchor.isActive = true
        
        self.view.addSubview(loadingParkingLine)
        loadingParkingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        loadingParkingLine.bottomAnchor.constraint(equalTo: mainBarView.bottomAnchor).isActive = true
        loadingParkingLeftAnchor = loadingParkingLine.leftAnchor.constraint(equalTo: mainBar.leftAnchor)
            loadingParkingLeftAnchor.isActive = true
        loadingParkingRightAnchor = loadingParkingLine.rightAnchor.constraint(equalTo: mainBar.rightAnchor)
            loadingParkingRightAnchor.isActive = false
        loadingParkingWidthAnchor = loadingParkingLine.widthAnchor.constraint(equalToConstant: 0)
            loadingParkingWidthAnchor.isActive = true
        
        mainBar.addSubview(searchBackButton)
        searchBackButton.leftAnchor.constraint(equalTo: mainBar.leftAnchor, constant: 24).isActive = true
        searchBackButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        searchBackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            searchBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            searchBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        }
        
    }
    
    @objc func searchLocationPressed() {
        self.view.endEditing(true)
        self.fromSearchBar.text = "Current location"
        self.fromSearchBar.textColor = Theme.PACIFIC_BLUE
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
    }
}


extension MapKitViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard !synthesizer.isSpeaking else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
}
