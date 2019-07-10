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
var userMostRecentLocation: CLLocationCoordinate2D?

var shouldDragMainBar: Bool = true

protocol mainBarSearchDelegate {
    func mainBarWillOpen()
    func mainBarWillClose()
    func expandedMainBar()
    func showCurrentLocation()
    func hideCurrentLocation()
    func zoomToSearchLocation(address: String)
    func becomeANewHost()
}

extension MapKitViewController: mainBarSearchDelegate {
    
    func setupMainBar() {
    
        self.view.addSubview(mainBarController.view)
        mainBarController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mainBarController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mainBarTopAnchor = mainBarController.view.heightAnchor.constraint(equalToConstant: 354)
            mainBarTopAnchor.isActive = true
        mainBarController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(mainBarIsScrolling(sender:)))
        mainBarController.view.addGestureRecognizer(pan)
        mainBarController.searchButton.addTarget(self, action: #selector(mainBarWillOpen), for: .touchUpInside)
        mainBarController.microphoneButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        
        self.view.addSubview(summaryController.view)
        summaryTopAnchor = summaryController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -260)
            summaryTopAnchor.isActive = true
        summaryController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        summaryController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            summaryController.view.heightAnchor.constraint(equalToConstant: 222).isActive = true
        case .iphoneX:
            summaryController.view.heightAnchor.constraint(equalToConstant: 234).isActive = true
        }
        summaryController.calendarButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        summaryController.calendarLabel.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        summaryController.timeButton.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        summaryController.timeLabel.addTarget(self, action: #selector(changeDatesPressed), for: .touchUpInside)
        
        self.view.addSubview(searchBarController.view)
        searchBarController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        searchBarController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        searchBarController.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        switch device {
        case .iphone8:
            searchBarController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            searchBarController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        let touch = UITapGestureRecognizer(target: self, action: #selector(mainBarWillOpen))
        quickDestinationController.view.addGestureRecognizer(touch)

        self.view.addSubview(locatorButton)
        locatorButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        locatorButton.widthAnchor.constraint(equalTo: locatorButton.heightAnchor).isActive = true
        locatorMainBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: mainBarController.view.topAnchor, constant: -12)
            locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: parkingBackButton.bottomAnchor, constant: 0)
            locatorParkingBottomAnchor.isActive = false
        
        self.view.addSubview(locationsSearchResults.view)
        self.view.bringSubviewToFront(summaryController.view)
        locationsSearchResults.view.topAnchor.constraint(equalTo: summaryController.view.bottomAnchor, constant: -10).isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: summaryController.view.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: summaryController.view.rightAnchor).isActive = true
        locationResultsHeightAnchor = locationsSearchResults.view.heightAnchor.constraint(equalToConstant: 0)
            locationResultsHeightAnchor.isActive = true

    }
    
    func removeMainBar() {
        self.view.endEditing(true)
        self.summaryTopAnchor.constant = -260
        self.mainBarTopAnchor.constant = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.mainBarController.scrollView.alpha = 1
            self.mainBarController.view.backgroundColor = UIColor.clear
            self.fullBackgroundView.alpha = 0
            self.locationResultsHeightAnchor.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.view.bringSubviewToFront(self.fullBackgroundView)
            self.view.bringSubviewToFront(self.mainBarController.view)
            self.view.bringSubviewToFront(self.parkingController.view)
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.mainBarHighest = false
                self.delegate?.defaultContentStatusBar()
            })
        }
    }
    
    @objc func mainBarWillOpen() {
        if self.fullBackgroundView.alpha <= 0.85 {
            if let currentLocation = self.locationManager.location?.coordinate {
                userMostRecentLocation = currentLocation
            }
            self.summaryTopAnchor.constant = 0
            self.parkingControllerBottomAnchor.constant = 400
            self.confirmControllerBottomAnchor.constant = 360
            self.mainBarTopAnchor.constant = phoneHeight
            self.delegate?.hideHamburger()
            self.delegate?.defaultContentStatusBar()
            self.view.bringSubviewToFront(locationsSearchResults.view)
            self.view.bringSubviewToFront(summaryController.view)
            self.summaryController.searchTextField.text = ""
            UIView.animate(withDuration: animationOut, animations: {
                self.mainBarController.scrollView.alpha = 0
                self.mainBarController.view.backgroundColor = Theme.WHITE
                self.fullBackgroundView.alpha = 0.4
                self.view.layoutIfNeeded()
            }) { (success) in
                self.mainBarController.scrollView.isScrollEnabled = true
                self.mainBarController.scrollView.setContentOffset(.zero, animated: false)
                UIView.animate(withDuration: animationIn, animations: {
                    self.locationsSearchResults.checkRecentSearches()
                    self.locationResultsHeightAnchor.constant = self.view.frame.height - 100
                    self.view.layoutIfNeeded()
                }) { (success) in
                    self.summaryController.searchTextField.becomeFirstResponder()
                    self.mainBarController.scrollView.isScrollEnabled = false
                }
            }
        } else {
            self.mainBarTopAnchor.constant = phoneHeight - 150
            self.delegate?.lightContentStatusBar()
            self.delegate?.hideHamburger()
            UIView.animate(withDuration: animationIn, animations: {
                self.fullBackgroundView.alpha = 0.7
                self.locatorButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.mainBarController.scrollView.isScrollEnabled = false
                self.mainBarHighest = true
                self.mainBarWillOpen()
            }
        }
    }
    
    func mainBarWillClose() {
        self.view.endEditing(true)
        self.summaryTopAnchor.constant = -260
        self.mainBarTopAnchor.constant = 354
        UIView.animate(withDuration: animationOut, animations: {
            self.locationResultsHeightAnchor.constant = 0
            self.mainBarController.scrollView.alpha = 1
            self.mainBarController.view.backgroundColor = UIColor.clear
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.view.bringSubviewToFront(self.mainBarController.view)
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.mainBarHighest = false
                self.delegate?.bringHamburger()
                self.delegate?.defaultContentStatusBar()
            })
        }
    }
    
    func bringMainBar() {
        if let userLocation = locationManager.location {
            let camera = MGLMapCamera(lookingAtCenter: userLocation.coordinate, altitude: CLLocationDistance(exactly: 18000)!, pitch: 0, heading: CLLocationDirection(0))
            self.mapView.setCamera(camera, withDuration: animationOut * 2, animationTimingFunction: nil, edgePadding: UIEdgeInsets(top: phoneHeight/4 + 60, left: phoneWidth/2, bottom: phoneHeight*3/4 - 60, right: phoneWidth/2), completionHandler: nil)
        }
        self.mainBarTopAnchor.constant = 354
        UIView.animate(withDuration: animationOut, animations: {
            self.mainBarController.scrollView.alpha = 1
            self.mainBarController.view.backgroundColor = UIColor.clear
            self.fullBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.mainBarHighest = false
            self.delegate?.bringHamburger()
            self.delegate?.defaultContentStatusBar()
        })
    }
    
    func expandedMainBar() {
        self.mainBarTopAnchor.constant = phoneHeight - statusHeight
        UIView.animate(withDuration: animationIn, animations: {
            self.fullBackgroundView.alpha = 0.9
            self.view.layoutIfNeeded()
        }) { (success) in
            self.mainBarController.scrollView.isScrollEnabled = true
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
    
    @objc func mainBarIsScrolling(sender: UIPanGestureRecognizer) {
        if shouldDragMainBar {
            let position = -sender.translation(in: self.view).y
            let highestHeight = phoneHeight - 150
            let lowestHeight: CGFloat = 354
            var minimizedHeight: CGFloat = 150
            switch device {
            case .iphone8:
                minimizedHeight = 150
            case .iphoneX:
                minimizedHeight = 164
            }
            if sender.state == .changed {
                let difference = position - self.mainBarPreviousPosition
                if self.mainBarTopAnchor.constant >= lowestHeight - 40 || (self.mainBarHighest == true && self.mainBarTopAnchor.constant <= 772) {
                    let difference = position - self.mainBarPreviousPosition
                    self.mainBarTopAnchor.constant = self.mainBarTopAnchor.constant + difference
                    let percent = (self.mainBarTopAnchor.constant - lowestHeight)/highestHeight
                    self.fullBackgroundView.alpha = 1.2 * percent
                    if percent >= 0.2 {
                        self.delegate?.lightContentStatusBar()
                        self.delegate?.hideHamburger()
                    } else {
                        self.delegate?.defaultContentStatusBar()
                    }
                } else if self.mainBarTopAnchor.constant <= lowestHeight - 40 && difference <= 0 {
                    self.mainBarTopAnchor.constant = minimizedHeight
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                } else if difference <= 0 {
                    self.mainBarTopAnchor.constant = highestHeight
//                    self.mainBarController.scrollView.isScrollEnabled = true
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                } else {
                    self.mainBarTopAnchor.constant = lowestHeight
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else if sender.state == .ended {
                let difference = position - self.mainBarPreviousPosition
                if (self.mainBarTopAnchor.constant < highestHeight && self.mainBarHighest == false) || self.mainBarTopAnchor.constant <= highestHeight {
                    if self.mainBarTopAnchor.constant >= phoneHeight/3 && difference < 0 && self.mainBarTopAnchor.constant <= phoneHeight * 2/3 {
                        self.mainBarTopAnchor.constant = lowestHeight
                        UIView.animate(withDuration: animationOut, animations: {
                            self.fullBackgroundView.alpha = 0
                            self.view.layoutIfNeeded()
                        }) { (success) in
                            self.mainBarHighest = false
                            self.delegate?.bringHamburger()
                            self.delegate?.defaultContentStatusBar()
                        }
                    } else if self.mainBarTopAnchor.constant >= phoneHeight/3 && difference >= 0 {
                        if self.mainBarHighest == true && self.mainBarTopAnchor.constant < highestHeight - 40 {
                            self.mainBarTopAnchor.constant = lowestHeight
                            UIView.animate(withDuration: animationIn, animations: {
                                self.fullBackgroundView.alpha = 0
                                self.view.layoutIfNeeded()
                            }) { (success) in
                                self.mainBarHighest = false
                                self.delegate?.bringHamburger()
                                self.delegate?.defaultContentStatusBar()
                            }
                        } else {
                            self.mainBarTopAnchor.constant = highestHeight
                            self.delegate?.lightContentStatusBar()
                            self.delegate?.hideHamburger()
                            UIView.animate(withDuration: animationIn, animations: {
                                self.fullBackgroundView.alpha = 0.7
                                self.locatorButton.alpha = 0
                                self.view.layoutIfNeeded()
                            }) { (success) in
                                self.mainBarController.scrollView.isScrollEnabled = false
                                self.mainBarHighest = true
                            }
                        }
                    } else if self.mainBarTopAnchor.constant <= minimizedHeight + 20 {
                        self.mainBarTopAnchor.constant = minimizedHeight
                        UIView.animate(withDuration: animationOut, animations: {
                            self.fullBackgroundView.alpha = 0
                            self.view.layoutIfNeeded()
                        }) { (success) in
                            self.mainBarHighest = false
                            self.delegate?.bringHamburger()
                            self.delegate?.defaultContentStatusBar()
                        }
                    } else {
                        self.mainBarTopAnchor.constant = lowestHeight
                        UIView.animate(withDuration: animationOut, animations: {
                            self.fullBackgroundView.alpha = 0
                            self.view.layoutIfNeeded()
                        }) { (success) in
                            self.mainBarHighest = false
                            self.delegate?.bringHamburger()
                            self.delegate?.defaultContentStatusBar()
                        }
                    }
                } else {
                    self.mainBarTopAnchor.constant = phoneHeight - statusHeight
                    UIView.animate(withDuration: animationIn, animations: {
                        self.fullBackgroundView.alpha = 0.9
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        self.mainBarController.scrollView.isScrollEnabled = true
                    }
                }
            }
            self.mainBarPreviousPosition = position
        }
    }
    
    func becomeANewHost() {
        self.delegate?.bringNewHostingController()
    }
    
    func monitorCoupons() {
        if !isCurrentlyBooked {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("CurrentCoupon")
            ref.observe(.childAdded) { (snapshot) in
                if let percent = snapshot.value as? Int {
                    self.quickCouponController.percentage = percent
                    self.newMessageTopAnchor.constant = self.newMessageTopAnchor.constant + 62
                    UIView.animate(withDuration: animationIn, animations: {
                        self.quickCouponController.view.alpha = 1
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                        self.quickCouponController.maximizeController()
                        self.quickCouponController.expandController()
                    })
                }
            }
            ref.observe(.childRemoved) { (snapshot) in
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.childrenCount == 0 {
                        self.quickCouponController.closeController()
                        delayWithSeconds(animationOut, completion: {
                            self.newMessageTopAnchor.constant = self.newMessageTopAnchor.constant - 62
                            UIView.animate(withDuration: animationIn, animations: {
                                self.quickCouponController.view.alpha = 0
                                self.view.layoutIfNeeded()
                            })
                        })
                    } else {
                        if let dictionary = snapshot.value as? [String: Any] {
                            if let coupon = dictionary["coupon"] as? Int {
                                self.quickCouponController.percentage = coupon
                            } else if let invite = dictionary["invite"] as? Int {
                                self.quickCouponController.percentage = invite
                            }
                        }
                        self.newMessageTopAnchor.constant = self.newMessageTopAnchor.constant + 62
                        UIView.animate(withDuration: animationIn, animations: {
                            self.quickCouponController.view.alpha = 1
                            self.view.layoutIfNeeded()
                        }, completion: { (success) in
                            self.quickCouponController.expandController()
                        })
                    }
                })
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
