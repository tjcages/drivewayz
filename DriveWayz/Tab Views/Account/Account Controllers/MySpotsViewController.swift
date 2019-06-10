//
//  MySpotsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/2/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostingReservations {
    func darkContentStatusBar()
    func lightContentStatusBar()
    func hostingPreviousPressed()
    func returnReservationsPressed()
    func hostingExpandedPressed()
    func returnExpandedPressed()
}

class MySpotsViewController: UIViewController {
    
    var delegate: moveControllers?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
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
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Hosted spaces"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH0
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.decelerationRate = .fast
        
        return view
    }()
    
    var profitsContainer: MyProfitsViewController = {
        let controller = MyProfitsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var reservationsContainer: MyOngoingViewController = {
        let controller = MyOngoingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var notificationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notifications"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var notificationsContainer: MyNotificationsViewController = {
        let controller = MyNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var hostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My parking spaces"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var hostContainer: MySpacesViewController = {
        let controller = MySpacesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var profitsDateContainer: ProfitsDateViewController = {
        let controller = ProfitsDateViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    var profitsEarningsContainer: ProfitsEarningsViewController = {
        let controller = ProfitsEarningsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()
    
    lazy var reservationsTableContainer: ReservationsTableViewController = {
        let controller = ReservationsTableViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var hostingPreviousContainer: HostingPreviousViewController = {
        let controller = HostingPreviousViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var hostingExpandedContainer: HostingExpandedViewController = {
        let controller = HostingExpandedViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupControllers()
    }

    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {

        self.view.addSubview(gradientContainer)
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1100)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 180)
                gradientHeightAnchor.isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
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
        
    }
    
    var profitsHeightAnchor: NSLayoutConstraint!
    var profitsDateTopAnchor: NSLayoutConstraint!
    var reservationsTopAnchor: NSLayoutConstraint!
    var hostingPreviousTopAnchor: NSLayoutConstraint!
    var hostingExpandedTopAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.addSubview(profitsContainer.view)
        profitsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsHeightAnchor = profitsContainer.view.heightAnchor.constraint(equalToConstant: 168)
            profitsHeightAnchor.isActive = true
        profitsContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        let profitsTap = UITapGestureRecognizer(target: self, action: #selector(expandProfitsContainer))
        profitsContainer.view.addGestureRecognizer(profitsTap)
        
        scrollView.addSubview(reservationsContainer.view)
        reservationsContainer.view.topAnchor.constraint(equalTo: profitsContainer.view.bottomAnchor, constant: 16).isActive = true
        reservationsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        reservationsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        reservationsContainer.view.heightAnchor.constraint(equalToConstant: 204).isActive = true
        let reservationsTap = UITapGestureRecognizer(target: self, action: #selector(expandReservationsContainer))
        reservationsContainer.view.addGestureRecognizer(reservationsTap)
        
        scrollView.addSubview(notificationsLabel)
        notificationsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        notificationsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        notificationsLabel.topAnchor.constraint(equalTo: reservationsContainer.view.bottomAnchor, constant: 20).isActive = true
        notificationsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(notificationsContainer.view)
        notificationsContainer.view.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 8).isActive = true
        notificationsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        notificationsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        notificationsContainer.view.heightAnchor.constraint(equalToConstant: 258).isActive = true
        
        scrollView.addSubview(hostLabel)
        hostLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        hostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        hostLabel.topAnchor.constraint(equalTo: notificationsContainer.view.bottomAnchor, constant: 20).isActive = true
        hostLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(hostContainer.view)
        hostContainer.view.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 8).isActive = true
        hostContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        hostContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        hostContainer.view.heightAnchor.constraint(equalToConstant: 192).isActive = true
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(hostingExpandedPressed))
        hostContainer.view.addGestureRecognizer(hostTap)
        
        scrollView.addSubview(profitsDateContainer.view)
        profitsDateTopAnchor = profitsDateContainer.view.topAnchor.constraint(equalTo: profitsContainer.view.bottomAnchor, constant: phoneHeight + 12)
            profitsDateTopAnchor.isActive = true
        profitsDateContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsDateContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsDateContainer.view.heightAnchor.constraint(equalToConstant: 460).isActive = true
        
        scrollView.addSubview(profitsEarningsContainer.view)
        profitsEarningsContainer.view.topAnchor.constraint(equalTo: profitsDateContainer.view.bottomAnchor, constant: 12).isActive = true
        profitsEarningsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsEarningsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsEarningsContainer.view.heightAnchor.constraint(equalToConstant: 142).isActive = true
        
        self.view.addSubview(reservationsTableContainer.view)
        self.view.bringSubviewToFront(backButton)
        reservationsTopAnchor = reservationsTableContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            reservationsTopAnchor.isActive = true
        reservationsTableContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        reservationsTableContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        reservationsTableContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight - 120).isActive = true
        
        self.view.addSubview(hostingPreviousContainer.view)
        hostingPreviousTopAnchor = hostingPreviousContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            hostingPreviousTopAnchor.isActive = true
        hostingPreviousContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostingPreviousContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostingPreviousContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight + statusHeight).isActive = true
        
        self.view.addSubview(hostingExpandedContainer.view)
        hostingExpandedTopAnchor = hostingExpandedContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            hostingExpandedTopAnchor.isActive = true
        hostingExpandedContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostingExpandedContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostingExpandedContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight + statusHeight).isActive = true
        
    }

}

extension MySpotsViewController: handleHostingReservations {
    
    func darkContentStatusBar() {
        self.delegate?.defaultContentStatusBar()
    }
    
    func lightContentStatusBar() {
        self.delegate?.lightContentStatusBar()
    }
    
    @objc func backButtonPressed() {
        self.reservationsTableContainer.gradientContainer.isHidden = true
        self.gradientContainer.isHidden = false
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: 1300)
        self.profitsHeightAnchor.constant = 168
        self.profitsDateTopAnchor.constant = phoneHeight + 24
        self.reservationsTopAnchor.constant = phoneHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.backButton.alpha = 0
            self.profitsContainer.transferButton.alpha = 0
            self.profitsDateContainer.view.alpha = 0
            self.profitsEarningsContainer.view.alpha = 0
            self.reservationsTableContainer.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.lightContentStatusBar()
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            self.delegate?.bringExitButton()
            UIView.animate(withDuration: animationIn, animations: {
                self.mainLabel.alpha = 1
                self.profitsContainer.line.alpha = 1
                self.reservationsContainer.view.alpha = 1
                self.notificationsLabel.alpha = 1
                self.notificationsContainer.view.alpha = 1
                self.profitsContainer.view.alpha = 1
                self.hostContainer.view.alpha = 1
                self.hostLabel.alpha = 1
            })
        }
    }
    
    @objc func expandProfitsContainer() {
        self.profitsDateContainer.resetCharts()
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        if self.profitsHeightAnchor.constant == 168 {
            self.profitsHeightAnchor.constant = 96
            self.profitsDateTopAnchor.constant = 12
            self.delegate?.hideExitButton()
            UIView.animate(withDuration: animationOut, animations: {
                self.profitsContainer.line.alpha = 0
                self.reservationsContainer.view.alpha = 0
                self.notificationsLabel.alpha = 0
                self.notificationsContainer.view.alpha = 0
                self.hostLabel.alpha = 0
                self.hostContainer.view.alpha = 0
                self.profitsDateContainer.view.alpha = 1
                self.profitsEarningsContainer.view.alpha = 1
                self.profitsContainer.transferButton.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                self.scrollView.contentSize = CGSize(width: phoneWidth, height: 900)
                UIView.animate(withDuration: animationOut, animations: {
                    self.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            self.scrollView.contentSize = CGSize(width: phoneWidth, height: 1300)
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            self.profitsHeightAnchor.constant = 168
            self.profitsDateTopAnchor.constant = phoneHeight + 24
            UIView.animate(withDuration: animationOut, animations: {
                self.backButton.alpha = 0
                self.profitsContainer.transferButton.alpha = 0
                self.profitsDateContainer.view.alpha = 0
                self.profitsEarningsContainer.view.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.delegate?.bringExitButton()
                UIView.animate(withDuration: animationIn, animations: {
                    self.profitsContainer.line.alpha = 1
                    self.reservationsContainer.view.alpha = 1
                    self.notificationsLabel.alpha = 1
                    self.notificationsContainer.view.alpha = 1
                    self.hostLabel.alpha = 1
                    self.hostContainer.view.alpha = 1
                })
            }
        }
    }
    
    @objc func expandReservationsContainer() {
        if self.reservationsTopAnchor.constant == phoneHeight {
            self.reservationsTopAnchor.constant = 0
            self.delegate?.hideExitButton()
            UIView.animate(withDuration: animationOut, animations: {
                self.mainLabel.alpha = 0
                self.backButton.alpha = 1
                self.reservationsTableContainer.view.alpha = 1
                self.profitsContainer.view.alpha = 0
                self.reservationsContainer.view.alpha = 0
                self.notificationsContainer.view.alpha = 0
                self.notificationsLabel.alpha = 0
                self.hostContainer.view.alpha = 0
                self.hostLabel.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.reservationsTableContainer.gradientContainer.isHidden = false
                self.gradientContainer.isHidden = true
                self.scrollView.isScrollEnabled = false
            }
        }
    }
    
    func hostingPreviousPressed() {
        self.hostingPreviousTopAnchor.constant = -statusHeight
        self.delegate?.defaultContentStatusBar()
        UIView.animate(withDuration: animationOut) {
            self.hostingPreviousContainer.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func returnReservationsPressed() {
        self.hostingPreviousTopAnchor.constant = phoneHeight
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationOut) {
            self.hostingPreviousContainer.view.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hostingExpandedPressed() {
        self.hostingExpandedTopAnchor.constant = -statusHeight
        self.delegate?.hideExitButton()
        self.scrollView.isScrollEnabled = false
        UIView.animate(withDuration: animationOut) {
            self.profitsContainer.view.alpha = 0
            self.reservationsContainer.view.alpha = 0
            self.notificationsLabel.alpha = 0
            self.notificationsContainer.view.alpha = 0
            self.hostLabel.alpha = 0
            self.hostContainer.view.alpha = 0
            self.hostingExpandedContainer.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func returnExpandedPressed() {
        self.hostingExpandedTopAnchor.constant = phoneHeight
        self.scrollView.isScrollEnabled = true
        self.lightContentStatusBar()
        UIView.animate(withDuration: animationOut) {
            self.profitsContainer.view.alpha = 1
            self.reservationsContainer.view.alpha = 1
            self.notificationsLabel.alpha = 1
            self.notificationsContainer.view.alpha = 1
            self.hostLabel.alpha = 1
            self.hostContainer.view.alpha = 1
            self.hostingExpandedContainer.view.alpha = 0
            self.view.layoutIfNeeded()
        }
        self.delegate?.bringExitButton()
    }
    
}


extension MySpotsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        let translation = scrollView.contentOffset.y
        if translation > 0 && translation < 80 {
            let percent = translation/80
            self.gradientHeightAnchor.constant = totalHeight - percent * 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } else if translation <= 0 {
            self.gradientHeightAnchor.constant = totalHeight
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}
