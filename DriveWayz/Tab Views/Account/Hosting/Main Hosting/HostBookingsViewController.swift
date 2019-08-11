//
//  TestHostBookingsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleBookingInformation {
    func expandBooking()
    func bookingInformation()
    func hideOrganizer()
    func bringOrganizer()
    func beginLoading()
    func endLoading()
    
    func closeBackground()
}

class HostBookingsViewController: UIViewController {
    
    var delegate: handleHostingControllers?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Bookings"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.isPagingEnabled = true
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.alpha = 0
        //        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    lazy var profitsOrganizer: ProfitsOrganizerViewController = {
        let controller = ProfitsOrganizerViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.firstOption.setTitle("UPCOMING", for: .normal)
        controller.secondOption.setTitle("PREVIOUS", for: .normal)
        controller.thirdOption.setTitle("CALENDAR", for: .normal)
        controller.setupViews()
        
        return controller
    }()
    
    lazy var upcomingBookings: UpcomingViewController = {
        let controller = UpcomingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        controller.bookingDelegate = self
        
        return controller
    }()
    
    lazy var previousBookings: PreviousViewController = {
        let controller = PreviousViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        controller.bookingDelegate = self
        
        return controller
    }()
    
    lazy var hostCalendar: CalendarViewController = {
        let controller = CalendarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        controller.bookingDelegate = self
        
        return controller
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func observeData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.OFF_WHITE
        
        setupViews()
        setupControllers()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        scrollView.contentSize = CGSize(width: phoneWidth * 3, height: phoneHeight - 180)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
    func setupControllers() {
        
        scrollView.addSubview(upcomingBookings.view)
        upcomingBookings.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        upcomingBookings.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        upcomingBookings.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        upcomingBookings.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(previousBookings.view)
        previousBookings.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        previousBookings.view.leftAnchor.constraint(equalTo: upcomingBookings.view.rightAnchor).isActive = true
        previousBookings.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        previousBookings.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(hostCalendar.view)
        hostCalendar.view.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        hostCalendar.view.leftAnchor.constraint(equalTo: previousBookings.view.rightAnchor).isActive = true
        hostCalendar.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        hostCalendar.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(profitsOrganizer.view)
        profitsOrganizer.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        profitsOrganizer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        profitsOrganizer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        profitsOrganizer.view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        profitsOrganizer.firstOption.addTarget(self, action: #selector(moveOrganizer(sender:)), for: .touchUpInside)
        profitsOrganizer.secondOption.addTarget(self, action: #selector(moveOrganizer(sender:)), for: .touchUpInside)
        profitsOrganizer.thirdOption.addTarget(self, action: #selector(moveOrganizer(sender:)), for: .touchUpInside)
        
        self.view.addSubview(dimmingView)
        dimmingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmingView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    @objc func moveOrganizer(sender: UIButton) {
        if sender == self.profitsOrganizer.firstOption {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.hostCalendar.closeScheduleView()
        } else if sender == self.profitsOrganizer.secondOption {
            self.scrollView.setContentOffset(CGPoint(x: phoneWidth, y: 0), animated: true)
            self.hostCalendar.closeScheduleView()
        } else {
            self.scrollView.setContentOffset(CGPoint(x: phoneWidth * 2, y: 0), animated: true)
            delayWithSeconds(animationOut) {
                self.hostCalendar.openScheduleView()
            }
        }
    }
    
    func hideOrganizer() {
        UIView.animate(withDuration: animationIn) {
            self.profitsOrganizer.view.alpha = 0
        }
    }
    
    func bringOrganizer() {
        UIView.animate(withDuration: animationIn) {
            self.profitsOrganizer.view.alpha = 1
        }
    }
    
    func closeBackground() {
        self.delegate?.openTabBar()
        UIView.animate(withDuration: animationOut) {
            self.dimmingView.alpha = 0
        }
    }
    
    func beginLoading() {
        self.loadingLine.startAnimating()
    }
    
    func endLoading() {
        self.loadingLine.endAnimating()
    }
    
}


extension HostBookingsViewController: handleBookingInformation {
    
    // Open options to information on each booking
    func expandBooking() {
        self.delegate?.closeTabBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.6
        }) { (success) in
            let controller = ExpandedBookingsViewController()
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overCurrentContext
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    @objc func bookingInformation() {
        self.delegate?.closeTabBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0.6
        }) { (success) in
            let controller = UpcomingStatusViewController()
            controller.delegate = self
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}


extension HostBookingsViewController: UIScrollViewDelegate, handleHostScrolling {
    
    func openTabBar() {
        self.delegate?.openTabBar()
    }
    
    func closeTabBar() {
        self.delegate?.closeTabBar()
    }
    
    func resetScrolls() {
        //        self.profitsWallet.scrollView.setContentOffset(.zero, animated: true)
        //        self.profitsChart.scrollView.setContentOffset(.zero, animated: true)
        //        self.profitsRefund.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        self.profitsOrganizer.translation = translation
        let percentage = translation/phoneWidth
        let isInteger = floor(percentage) == percentage
        if isInteger {
            self.scrollExpanded()
        }
    }
    
    func makeScrollViewScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation >= 20 && self.profitsOrganizer.view.alpha == 1 {
                UIView.animate(withDuration: animationIn) {
                    self.profitsOrganizer.view.alpha = 0
                }
            } else if translation <= 20 && self.profitsOrganizer.view.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.profitsOrganizer.view.alpha = 1
                }
            }
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func makeScrollViewEnd(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        self.resetScrolls()
        UIView.animate(withDuration: animationOut, animations: {
            if self.hostCalendar.undoButton.alpha == 0 {
                self.profitsOrganizer.view.alpha = 1
            }
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.profitsOrganizer.view.alpha = 0
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func dismissAll() {
        delayWithSeconds(0.4) {
            self.closeBackground()
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}
