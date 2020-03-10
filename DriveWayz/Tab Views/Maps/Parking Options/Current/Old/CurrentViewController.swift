//
//  CurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol CurrentViewDelegate {
    func expandTrip()
    func minimizeTrip()
    
    func expandPayment()
    func minimizePayment()
}

class CurrentViewController: UIViewController {
    
//    var delegate: handleRouteNavigation?
    var checkedIn: Bool = false {
        didSet {
            monitorCheckedIn()
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.isScrollEnabled = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 0
        
        return view
    }()
    
    var messageController = CurrentMessageView()
    var routeController = CurrentRouteView()
    var detailsController = CurrentDetailsView()
    var tripController = CurrentTripView()
    var paymentController = CurrentPaymentView()
    var optionsController = CurrentOptionsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2

        scrollView.delegate = self
        
        setupViews()
        addViews()
    }
    
    func setupViews() {
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 2000)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
          // Attaching the content's edges to the scroll view's edges
          stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
          stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
          stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
          stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

          // Satisfying size constraints
          stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
    }
    
    var tripHeightAnchor: NSLayoutConstraint!
    var paymentHeightAnchor: NSLayoutConstraint!
    
    func addViews() {
        
        stackView.addArrangedSubview(detailsController)
        detailsController.heightAnchor.constraint(equalToConstant: 216).isActive = true
        detailsController.detailsButton.addTarget(self, action: #selector(presentParkingDetails), for: .touchUpInside)
    
        stackView.addArrangedSubview(routeController)
        routeController.checkInButton.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
        routeController.heightAnchor.constraint(equalToConstant: 636).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentParkingDetails))
        routeController.parkingView.addGestureRecognizer(tap)
        
        stackView.addArrangedSubview(tripController)
        tripController.delegate = self
        tripHeightAnchor = tripController.heightAnchor.constraint(equalToConstant: 369)
            tripHeightAnchor.isActive = true
        
        stackView.addArrangedSubview(paymentController)
        paymentController.delegate = self
        paymentHeightAnchor = paymentController.heightAnchor.constraint(equalToConstant: 136)
            paymentHeightAnchor.isActive = true
        
        stackView.addArrangedSubview(optionsController)
        optionsController.heightAnchor.constraint(equalToConstant: 242).isActive = true
        
        stackView.insertArrangedSubview(messageController, at: 0)
        messageController.heightAnchor.constraint(equalToConstant: 84).isActive = true
        messageController.closeButton.addTarget(self, action: #selector(removeMessage), for: .touchUpInside)
        
        let blankView = UIView()
        blankView.translatesAutoresizingMaskIntoConstraints = false
        blankView.backgroundColor = Theme.BLACK
        stackView.addArrangedSubview(blankView)
        blankView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
    }
    
    @objc func presentParkingDetails() {
        let controller = CurrentParkingController()
        controller.modalPresentationStyle = .overFullScreen
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.9
        }) { (success) in
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func monitorCheckedIn() {
        UIView.animate(withDuration: animationIn) {
            if self.checkedIn {
                self.detailsController.isHidden = false
                self.routeController.isHidden = true
            } else {
                self.detailsController.isHidden = true
                self.routeController.isHidden = false
            }
            self.stackView.layoutIfNeeded()
        }
    }
    
    @objc func checkIn() {
        checkedIn = true
//        delegate?.checkedIn()
        removeMessage()
    }
    
    @objc func removeMessage() {
//        delegate?.currentMessageRemoved()
        UIView.animate(withDuration: animationIn, animations: {
            self.messageController.isHidden = true
            self.stackView.layoutIfNeeded()
        }) { (success) in
            
        }
    }

}

extension CurrentViewController: CurrentViewDelegate {
    
    func closeToPark() {
        UIView.animate(withDuration: animationIn) {
            self.routeController.driveButton.backgroundColor = Theme.LINE_GRAY
            self.routeController.driveButton.tintColor = Theme.BLACK
            self.routeController.parkButton.backgroundColor = Theme.BLACK
            self.routeController.parkButton.tintColor = Theme.WHITE
        }
    }
    
    func expandTrip() {
        tripHeightAnchor.constant = 668
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func minimizeTrip() {
        tripHeightAnchor.constant = 365
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func expandPayment() {
        paymentHeightAnchor.constant = 345
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func minimizePayment() {
        paymentHeightAnchor.constant = 132
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension CurrentViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -40.0 {
//            scrollView.setContentOffset(.zero, animated: true)
//            self.delegate?.closeCurrentBooking()
        }
    }
    
}
