//
//  MapKitMainBar.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation
import AVFoundation
import Mapbox

var headingImageView: UIImageView?
var userHeading: CLLocationDirection?

protocol mainBarSearchDelegate {
    func mainBarWillOpen()
    func mainBarWillClose()
    func expandSearchBar()
}

extension MapKitViewController: mainBarSearchDelegate {
    
    func setupMainBar() {
    
        self.view.addSubview(mainBarController.view)
        mainBarWidthAnchor = mainBarController.view.widthAnchor.constraint(equalToConstant: 327)
            mainBarWidthAnchor.isActive = true
        mainBarHeightAnchor = mainBarController.view.heightAnchor.constraint(equalToConstant: 89)
            mainBarHeightAnchor.isActive = true
        mainBarController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        switch device {
        case .iphone8:
            mainBarTopAnchor = mainBarController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
                mainBarTopAnchor.isActive = true
        case .iphoneX:
            mainBarTopAnchor = mainBarController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120)
                mainBarTopAnchor.isActive = true
        }
        
        self.view.addSubview(summaryController.view)
        summaryController.view.widthAnchor.constraint(equalToConstant: 327).isActive = true
        summaryController.view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        summaryController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        switch device {
        case .iphone8:
            summaryController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        case .iphoneX:
            summaryController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        }

        setupEvents()
        
        self.view.addSubview(locationsSearchResults.view)
        self.view.bringSubviewToFront(mainBarController.view)
        locationsSearchResults.view.topAnchor.constraint(equalTo: mainBarController.view.bottomAnchor, constant: -10).isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: mainBarController.view.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: mainBarController.view.rightAnchor).isActive = true
        locationResultsHeightAnchor = locationsSearchResults.view.heightAnchor.constraint(equalToConstant: 0)
            locationResultsHeightAnchor.isActive = true

    }
    
    func mainBarWillOpen() {
        self.delegate?.hideHamburger()
        self.takeAwayEvents()
        self.mainBarTopAnchor.constant = 0
        self.mainBarWidthAnchor.constant = phoneWidth
        switch device {
        case .iphone8:
            self.mainBarHeightAnchor.constant = 188
        case .iphoneX:
            self.mainBarHeightAnchor.constant = 208
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func mainBarWillClose() {
        self.hideSearchBar(regular: true)
        self.delegate?.bringHamburger()
        self.mainBarWidthAnchor.constant = 327
        self.mainBarHeightAnchor.constant = 89
        switch device {
        case .iphone8:
            self.mainBarTopAnchor.constant = 100
        case .iphoneX:
            self.mainBarTopAnchor.constant = 120
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
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
    
}


extension MapKitViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard !synthesizer.isSpeaking else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
}
