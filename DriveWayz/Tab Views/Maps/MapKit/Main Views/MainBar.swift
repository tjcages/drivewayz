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

//var headingImageView: UIImageView?
//var userHeading: CLLocationDirection?
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

//var ParkingRoutePolyLine: [MKOverlay] = []
//var DestinationRoutePolyLine = MKPolyline()
//var DestinationAnnotation: MKAnnotation?
var ZoomMapView: MGLCoordinateBounds?
var ZoomPurchaseMapView: MGLCoordinateBounds?
var IncreasedZoomMapView: CLLocationCoordinate2D?
var CurrentDestinationLocation: CLLocation?
var ClosestParkingLocation: CLLocation?

extension MapKitViewController: mainBarSearchDelegate {
    
    func setupLocator() {

        self.view.addSubview(locatorButton)
        locatorButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        locatorButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        locatorButton.widthAnchor.constraint(equalTo: locatorButton.heightAnchor).isActive = true
        locatorMainBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: mainBarController.view.topAnchor, constant: -12)
            locatorMainBottomAnchor.isActive = true
        locatorParkingBottomAnchor = locatorButton.bottomAnchor.constraint(equalTo: parkingBackButton.bottomAnchor, constant: 0)
            locatorParkingBottomAnchor.isActive = false
        
        self.view.addSubview(locationsSearchResults.view)
        locationsSearchResults.view.topAnchor.constraint(equalTo: summaryController.view.bottomAnchor, constant: -10).isActive = true
        locationsSearchResults.view.leftAnchor.constraint(equalTo: summaryController.view.leftAnchor).isActive = true
        locationsSearchResults.view.rightAnchor.constraint(equalTo: summaryController.view.rightAnchor).isActive = true
        locationResultsHeightAnchor = locationsSearchResults.view.heightAnchor.constraint(equalToConstant: 0)
            locationResultsHeightAnchor.isActive = true
        
        self.view.bringSubviewToFront(fullBackgroundView)
        self.view.bringSubviewToFront(mainBarController.view)
        self.view.bringSubviewToFront(parkingController.view)
        self.view.bringSubviewToFront(durationController.view)
        self.view.bringSubviewToFront(confirmPaymentController.view)
        self.view.bringSubviewToFront(currentBottomController.view)

    }
    
    func removeMainBar() {
        self.view.endEditing(true)
        self.summaryTopAnchor.constant = -260
        self.mainBarTopAnchor.constant = 0
        UIView.animate(withDuration: animationOut, animations: {
            self.mainBarController.scrollView.alpha = 1
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
        self.mainBarTopAnchor.constant = self.lowestHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.locationResultsHeightAnchor.constant = 0
            self.mainBarController.scrollView.alpha = 1
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
        self.view.bringSubviewToFront(mainBarController.view)
        self.mainBarTopAnchor.constant = self.lowestHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.mainBarController.scrollView.alpha = 1
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
    
//    @objc func microphoneButtonPressed(sender: UIButton) {
//        self.dismissKeyboard()
//        UIView.animate(withDuration: animationIn, animations: {
//            self.speechSearchResults.view.alpha = 1
//        }) { (success) in
//            self.speechSearchResults.recordAndRecognizeSpeech()
//        }
//    }
    
    @objc func mainBarIsScrolling(sender: UIPanGestureRecognizer) {
        if shouldDragMainBar {
            let position = -sender.translation(in: self.view).y
            let highestHeight = phoneHeight - 150
            if sender.state == .changed {
                let difference = position - self.mainBarPreviousPosition
                if self.mainBarTopAnchor.constant >= self.lowestHeight - 40 || (self.mainBarHighest == true && self.mainBarTopAnchor.constant <= 772) {
                    let difference = position - self.mainBarPreviousPosition
                    self.mainBarTopAnchor.constant = self.mainBarTopAnchor.constant + difference
                    let percent = (self.mainBarTopAnchor.constant - self.lowestHeight)/highestHeight
                    self.fullBackgroundView.alpha = 1.2 * percent
                    if percent >= 0.2 {
                        self.delegate?.lightContentStatusBar()
                        self.delegate?.hideHamburger()
                    } else {
                        self.delegate?.defaultContentStatusBar()
                    }
                } else if self.mainBarTopAnchor.constant <= self.lowestHeight - 40 && difference <= 0 {
                    self.mainBarTopAnchor.constant = self.minimizedHeight
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
                    self.mainBarTopAnchor.constant = self.lowestHeight
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else if sender.state == .ended {
                let difference = position - self.mainBarPreviousPosition
                if (self.mainBarTopAnchor.constant < highestHeight && self.mainBarHighest == false) || self.mainBarTopAnchor.constant <= highestHeight {
                    if self.mainBarTopAnchor.constant >= phoneHeight/3 && difference < 0 && self.mainBarTopAnchor.constant <= phoneHeight * 2/3 {
                        self.mainBarTopAnchor.constant = self.lowestHeight
                        UIView.animate(withDuration: animationOut, animations: {
                            self.fullBackgroundView.alpha = 0
                            self.view.layoutIfNeeded()
                        }) { (success) in
                            self.mainBarHighest = false
                            self.delegate?.bringHamburger()
                            self.delegate?.defaultContentStatusBar()
                            self.mainBarController.scrollView.isScrollEnabled = false
                        }
                    } else if self.mainBarTopAnchor.constant >= phoneHeight/3 && difference >= 0 {
                        if self.mainBarHighest == true && self.mainBarTopAnchor.constant < highestHeight - 40 {
                            self.mainBarTopAnchor.constant = self.lowestHeight
                            UIView.animate(withDuration: animationIn, animations: {
                                self.fullBackgroundView.alpha = 0
                                self.view.layoutIfNeeded()
                            }) { (success) in
                                self.mainBarHighest = false
                                self.delegate?.bringHamburger()
                                self.delegate?.defaultContentStatusBar()
                                self.mainBarController.scrollView.isScrollEnabled = false
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
                    } else if self.mainBarTopAnchor.constant <= self.minimizedHeight + 20 {
                        self.mainBarTopAnchor.constant = self.minimizedHeight
                        UIView.animate(withDuration: animationOut, animations: {
                            self.fullBackgroundView.alpha = 0
                            self.view.layoutIfNeeded()
                        }) { (success) in
                            self.mainBarHighest = false
                            self.delegate?.bringHamburger()
                            self.delegate?.defaultContentStatusBar()
                            self.mainBarController.scrollView.isScrollEnabled = false
                        }
                    } else {
                        self.mainBarTopAnchor.constant = self.lowestHeight
                        UIView.animate(withDuration: animationOut, animations: {
                            self.fullBackgroundView.alpha = 0
                            self.view.layoutIfNeeded()
                        }) { (success) in
                            self.mainBarHighest = false
                            self.delegate?.bringHamburger()
                            self.delegate?.defaultContentStatusBar()
                            self.mainBarController.scrollView.isScrollEnabled = false
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
    
}
