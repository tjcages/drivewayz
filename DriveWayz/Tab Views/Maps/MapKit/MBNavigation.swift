//
//  MBNavigation.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Mapbox
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

protocol handleRouteNavigation {
    func beginRouteNavigation()
    func userHasCurrentParking()
    func checkDismissStatusBar()
}

protocol handleCurrentNavigationViews {
    func minimizeBottomView()
    func beginRouteNavigation()
}

var currentSpotController: CurrentSpotViewController = {
    let controller = CurrentSpotViewController()
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    //        controller.delegate = self
    
    return controller
}()

var navigationControllerView: NavigationViewController?

extension MapKitViewController: NavigationViewControllerDelegate, handleRouteNavigation, handleCurrentNavigationViews {
    
    func setupNavigationControllers() {
        
        self.view.addSubview(currentSearchLocation)
        self.view.addSubview(currentBottomController.view)
        currentBottomBottomAnchor = currentBottomController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 200)
            currentBottomBottomAnchor.isActive = true
        currentBottomController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentBottomController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentBottomHeightAnchor = currentBottomController.view.heightAnchor.constraint(equalToConstant: 170)
            currentBottomHeightAnchor.isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(bottomPanned(sender:)))
        currentBottomController.view.addGestureRecognizer(pan)
        
        self.view.addSubview(currentTopController.view)
        currentTopTopAnchor = currentTopController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -200)
            currentTopTopAnchor.isActive = true
        currentTopController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentTopController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentTopHeightAnchor = currentTopController.view.heightAnchor.constraint(equalToConstant: 136)
            currentTopHeightAnchor.isActive = true
        
        currentSearchLocation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        currentSearchLocation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentSearchLocation.widthAnchor.constraint(equalTo: currentSearchLocation.heightAnchor).isActive = true
        currentSearchLocation.bottomAnchor.constraint(equalTo: currentBottomController.view.topAnchor, constant: -16).isActive = true
        
    }
    
    @objc func bottomPanned(sender: UIPanGestureRecognizer) {
        let position = -sender.translation(in: self.view).y
        let highestPosition = phoneHeight - 140
        if sender.state == .changed {
            if (self.currentBottomHeightAnchor.constant < (phoneHeight - 120) || position < 0) && self.currentBottomHeightAnchor.constant >= 150 {
                if position >= -(highestPosition - 200) && position <= (highestPosition - 300) {
                    if self.currentBottomHeightAnchor.constant > 150 && self.currentBottomHeightAnchor.constant <= phoneHeight - 120 {
                        let percent = position/(highestPosition - 200)
                        UIView.animate(withDuration: 0.05) {
                            self.currentBottomHeightAnchor.constant = self.previousAnchor + highestPosition * percent
                            self.view.layoutIfNeeded()
                        }
                    } else {
                        self.previousAnchor = 170
                        UIView.animate(withDuration: animationIn) {
                            self.currentBottomHeightAnchor.constant = 170
                            self.view.layoutIfNeeded()
                        }
                        return
                    }
                }
            }
        } else if sender.state == .ended {
            UIView.animate(withDuration: animationOut) {
                if self.currentBottomHeightAnchor.constant >= highestPosition - 240 && self.currentBottomHeightAnchor.constant <= phoneHeight - 120 {
                    self.previousAnchor = highestPosition
                    self.currentBottomHeightAnchor.constant = highestPosition
                    self.currentTopHeightAnchor.constant = 216
                    self.currentBottomController.scrollView.isScrollEnabled = true
                } else if self.currentBottomHeightAnchor.constant >= phoneHeight - 200 {
                    
                } else {
                    self.previousAnchor = 170
                    self.currentBottomHeightAnchor.constant = 170
                    self.currentTopHeightAnchor.constant = 136
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func openCurrentInformation() {
        self.delegate?.hideHamburger()
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationOut, animations: {
            self.confirmControllerBottomAnchor.constant = 380
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, animations: {
                self.currentSearchLocation.alpha = 1
                self.currentBottomBottomAnchor.constant = 0
                self.currentTopTopAnchor.constant = 0
                self.previousAnchor = 170
                self.currentBottomHeightAnchor.constant = 170
                self.currentTopHeightAnchor.constant = 136
                self.view.layoutIfNeeded()
            }) { (success) in
                self.currentBottomController.scrollView.isScrollEnabled = false
            }
        }
    }
    
    func minimizeBottomView() {
        UIView.animate(withDuration: animationOut, animations: {
            self.previousAnchor = 170
            self.currentBottomHeightAnchor.constant = 170
            self.currentTopHeightAnchor.constant = 136
            self.view.layoutIfNeeded()
        }) { (success) in
            self.currentBottomController.scrollView.isScrollEnabled = false
        }
    }
    
    func beginRouteNavigation() {
        if let route = finalParkingRoute {
            holdNavController.delegate = self
            self.view.addSubview(holdNavController.view)
            holdNavController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            holdNavController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            holdNavController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            holdNavController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            holdNavController.setupNavigation(route: route)
            self.delegate?.lightContentStatusBar()
        }
    }
    
    @objc func currentLocatorButtonPressed() {
        self.mapView.userTrackingMode = .followWithCourse
        delayWithSeconds(animationOut * 2, completion: {
            self.mapView.setZoomLevel(15, animated: true)
        })
    }
    
    func checkDismissStatusBar() {
        switch solar {
        case .day:
            self.delegate?.defaultContentStatusBar()
        case .night:
            self.delegate?.defaultContentStatusBar()
        }
    }
    
}

class HoldNavViewController: UIViewController {
    
    private var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!
    var delegate: handleRouteNavigation?
    
    func setupNavigation(route: Route) {
//        let controller = NavigationViewController(for: route, styles: [CustomDayStyle(), CustomNightStyle()])
        let controller = NavigationViewController(for: route, styles: [CustomDayStyle()])
        controller.showsReportFeedback = false
        controller.showsEndOfRouteFeedback = false
        detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
        controller.automaticallyAdjustsStyleForTimeOfDay = false
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        controller.delegate = self
//        controller.voiceController = nil
        navigationControllerView = controller
        present(controller, animated: true) {
//            delayWithSeconds(2, completion: {
//                navigationSpeechController = speech
//            })
        }
    }
    
}

extension HoldNavViewController: NavigationViewControllerDelegate {
    
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        self.dismiss(animated: true) {
            self.delegate?.checkDismissStatusBar()
            UIView.animate(withDuration: animationOut, animations: {
                self.view.alpha = 0
            }, completion: { (success) in
                self.removeFromParent()
            })
        }
    }
    
}
