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

extension MapKitViewController: NavigationViewControllerDelegate, handleRouteNavigation {
    
    func beginRouteNavigation() {
        if let route = self.firstParkingRoute {
            let controller = HoldNavViewController()
            controller.delegate = self
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(controller.view)
            controller.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            controller.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            controller.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            controller.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            controller.setupNavigation(route: route)
            switch solar {
            case .day:
                self.delegate?.lightContentStatusBar()
            case .night:
                self.delegate?.lightContentStatusBar()
//                self.delegate?.defaultContentStatusBar()
            }
        }
    }
    
    func checkDismissStatusBar() {
        switch solar {
        case .day:
            self.delegate?.defaultContentStatusBar()
        case .night:
            self.delegate?.defaultContentStatusBar()
//            self.delegate?.lightContentStatusBar()
        }
    }
    
}

class HoldNavViewController: UIViewController {
    
    private var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!
    var delegate: handleRouteNavigation?
    
    func setupNavigation(route: Route) {
        let controller = NavigationViewController(for: route, styles: [CustomDayStyle(), CustomNightStyle()])
        detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
        controller.automaticallyAdjustsStyleForTimeOfDay = false
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        controller.delegate = self
        present(controller, animated: true, completion: nil)
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
