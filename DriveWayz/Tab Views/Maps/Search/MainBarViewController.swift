//
//  MainBarViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleInviteControllers {
    func openEvents()
}

class MainBarViewController: UIViewController {
    
    var alreadyFoundParking: Bool = false
    var alreadyZoomedIn: Bool = true
    var fullSearchOpen: Bool = false
    var delegate: mainBarSearchDelegate?
    
    enum ParkingState {
        case foundParking
        case noParking
        case zoomIn
    }
    
    var shouldBeLoading: Bool = true
    var shouldRefresh: Bool = true
    var parkingState: ParkingState = .foundParking {
        didSet {
//            if self.searchBarHeightAnchor.constant == 89 || self.searchBarHeightAnchor.constant == 63 {
//                if parkingState == .foundParking && self.alreadyFoundParking == false {
//                    self.alreadyFoundParking = true
//                    self.endSearching(status: parkingState)
//                    delayWithSeconds(0.4) {
//                        self.alreadyZoomedIn = false
//                    }
//                } else if parkingState == .zoomIn && self.alreadyZoomedIn == false {
//                    self.alreadyZoomedIn = true
//                    self.endSearching(status: parkingState)
//                    delayWithSeconds(0.4) {
//                        self.alreadyFoundParking = false
//                    }
//                } else if parkingState == .noParking && self.shouldRefresh == true {
//                    self.shouldRefresh = false
//                    self.endSearching(status: parkingState)
//                    delayWithSeconds(0.4) {
//                        self.alreadyFoundParking = false
//                        self.alreadyZoomedIn = false
//                        delayWithSeconds(2, completion: {
//                            self.shouldRefresh = true
//                        })
//                    }
//                }
//            }
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.layer.cornerRadius = 8
        view.isScrollEnabled = false
        
        return view
    }()
    
    var scrollBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Where are you headed?"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var microphoneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK.withAlphaComponent(0.2)
        button.layer.cornerRadius = 18
        let origImage = UIImage(named: "calendarIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.STRAWBERRY_PINK
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    var homeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.layer.cornerRadius = 15
        button.tintColor = Theme.WHITE
        let image = UIImage(named: "coupon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        
        return button
    }()
    
    var homeLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Park today and receive 10% off!", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var recentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.4)
        button.layer.cornerRadius = 15
        button.tintColor = Theme.WHITE
        
        return button
    }()
    
    var recentLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    lazy var worksController: HowItWorksController = {
        let controller = HowItWorksController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var eventsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        
        return view
    }()
    
    var eventsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upcoming Events"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPBoldH3
        
        return label
    }()
    
    lazy var eventsController: EventsViewController = {
        let controller = EventsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainDelegate = self
        
        return controller
    }()
    
    var newHostController: NewHostBannerViewController = {
        let controller = NewHostBannerViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var inviteFriendController: InviteBannerViewController = {
        let controller = InviteBannerViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2

        scrollView.delegate = self
        
        checkRecentSearches()
        setupViews()
        setupSearch()
        setupRecents()
        setupWorks()
        setupInvite()
        setupEvents()
        setupHosting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.eventsController.checkEvents()
    }

    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 860)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(scrollBar)
        scrollBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollBar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        scrollBar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scrollBar.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
    }
    
    func setupSearch() {
        
        scrollView.addSubview(searchView)
        scrollView.bringSubviewToFront(scrollBar)
        
        searchView.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: scrollBar.bottomAnchor, constant: 16).isActive = true
        searchButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        searchButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        searchButton.addSubview(searchLabel)
        searchLabel.leftAnchor.constraint(equalTo: searchButton.leftAnchor, constant: 16).isActive = true
        searchLabel.rightAnchor.constraint(equalTo: searchButton.rightAnchor, constant: -16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        searchButton.addSubview(microphoneButton)
        microphoneButton.rightAnchor.constraint(equalTo: searchButton.rightAnchor, constant: -12).isActive = true
        microphoneButton.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        microphoneButton.topAnchor.constraint(equalTo: searchButton.topAnchor, constant: 12).isActive = true
        microphoneButton.widthAnchor.constraint(equalTo: microphoneButton.heightAnchor).isActive = true
        
    }
    
    func setupRecents() {
        
        searchView.addSubview(homeButton)
        homeButton.leftAnchor.constraint(equalTo: searchButton.leftAnchor).isActive = true
        homeButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        homeButton.widthAnchor.constraint(equalTo: homeButton.heightAnchor).isActive = true
        
        searchView.addSubview(homeLabel)
        homeLabel.leftAnchor.constraint(equalTo: homeButton.rightAnchor, constant: 6).isActive = true
        homeLabel.centerYAnchor.constraint(equalTo: homeButton.centerYAnchor).isActive = true
        homeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        homeLabel.sizeToFit()
        
        searchView.addSubview(recentButton)
        recentButton.leftAnchor.constraint(equalTo: homeLabel.rightAnchor, constant: 16).isActive = true
        recentButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16).isActive = true
        recentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        recentButton.widthAnchor.constraint(equalTo: homeButton.heightAnchor).isActive = true
        
        searchView.addSubview(recentLabel)
        recentLabel.leftAnchor.constraint(equalTo: recentButton.rightAnchor, constant: 6).isActive = true
        recentLabel.centerYAnchor.constraint(equalTo: recentButton.centerYAnchor).isActive = true
        recentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        recentLabel.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -12).isActive = true
        recentLabel.sizeToFit()
        
        searchView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        searchView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        searchView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        searchView.bottomAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 24).isActive = true
        
    }
    
    func setupWorks() {
        
        scrollView.addSubview(worksController.view)
        worksController.view.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 4).isActive = true
        worksController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        worksController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        worksController.view.heightAnchor.constraint(equalToConstant: 384).isActive = true
        
    }
    
    var inviteHeightAnchor: NSLayoutConstraint!
    
    func setupInvite() {
        
        scrollView.addSubview(inviteFriendController.view)
        inviteFriendController.view.topAnchor.constraint(equalTo: worksController.view.bottomAnchor, constant: 4).isActive = true
        inviteFriendController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inviteFriendController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inviteHeightAnchor = inviteFriendController.view.heightAnchor.constraint(equalToConstant: 112)
            inviteHeightAnchor.isActive = true
        let invite = UITapGestureRecognizer(target: self, action: #selector(inviteControllerPressed))
        inviteFriendController.view.addGestureRecognizer(invite)
        
    }
    
    var minimizeEvents: NSLayoutConstraint!
    var maximizeEvents: NSLayoutConstraint!
    
    func setupEvents() {
        
        scrollView.addSubview(eventsView)
        
        eventsView.addSubview(eventsLabel)
        eventsLabel.topAnchor.constraint(equalTo: eventsView.topAnchor, constant: 16).isActive = true
        eventsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        eventsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        eventsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        eventsView.addSubview(eventsController.view)
        eventsController.view.topAnchor.constraint(equalTo: eventsLabel.bottomAnchor, constant: 16).isActive = true
        eventsController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        eventsController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        eventsController.view.heightAnchor.constraint(equalToConstant: eventsController.cellHeight + 16).isActive = true
        
        eventsView.topAnchor.constraint(equalTo: inviteFriendController.view.bottomAnchor, constant: 4).isActive = true
        eventsView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        eventsView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        eventsView.bottomAnchor.constraint(equalTo: eventsController.view.bottomAnchor, constant: 24).isActive = true
        
    }
    
    func setupHosting() {
        
        scrollView.addSubview(newHostController.view)
        minimizeEvents = newHostController.view.topAnchor.constraint(equalTo: inviteFriendController.view.bottomAnchor, constant: 4)
            minimizeEvents.isActive = true
        maximizeEvents = newHostController.view.topAnchor.constraint(equalTo: eventsView.bottomAnchor, constant: 4)
            maximizeEvents.isActive = false
        newHostController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        newHostController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        newHostController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
        let host = UITapGestureRecognizer(target: self, action: #selector(newHostControllerPressed))
        newHostController.view.addGestureRecognizer(host)
        
    }
    
    func checkRecentSearches() {
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            var first = firstRecent as! String
            if let dotRange = first.range(of: ",") {
                first.removeSubrange(dotRange.lowerBound..<first.endIndex)
                self.homeLabel.setTitle(first, for: .normal)
                self.homeButton.alpha = 1
                self.homeLabel.alpha = 1
                let image = UIImage(named: "time")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.homeButton.setImage(tintedImage, for: .normal)
                self.homeButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                self.homeButton.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.8)
                self.homeLabel.addTarget(self, action: #selector(firstRecentPressed), for: .touchUpInside)
                self.homeButton.addTarget(self, action: #selector(firstRecentPressed), for: .touchUpInside)
            }
        }
        if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
            var second = secondRecent as! String
            if let dotRange = second.range(of: ",") {
                second.removeSubrange(dotRange.lowerBound..<second.endIndex)
                self.recentLabel.setTitle(second, for: .normal)
                self.recentButton.alpha = 1
                self.recentLabel.alpha = 1
                let image = UIImage(named: "time")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.recentButton.setImage(tintedImage, for: .normal)
                self.recentButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                self.recentButton.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.8)
                self.recentLabel.addTarget(self, action: #selector(secondRecentPressed), for: .touchUpInside)
                self.recentButton.addTarget(self, action: #selector(secondRecentPressed), for: .touchUpInside)
            }
        } else {
            self.recentButton.alpha = 0
            self.recentLabel.alpha = 0
        }
    }
    
    @objc func firstRecentPressed() {
        if let text = self.homeLabel.titleLabel?.text {
            self.delegate?.zoomToSearchLocation(address: text)
        }
    }
    
    @objc func secondRecentPressed() {
        if let text = self.recentLabel.titleLabel?.text {
            self.delegate?.zoomToSearchLocation(address: text)
        }
    }
    
}


extension MainBarViewController: handleInviteControllers {
    
    @objc func inviteControllerPressed() {
        if self.inviteHeightAnchor.constant == 112 {
            shouldDragMainBar = false
            self.delegate?.expandedMainBar()
            self.scrollView.isScrollEnabled = false
            self.inviteHeightAnchor.constant = 320
            self.scrollView.contentSize = CGSize(width: phoneWidth, height: 1348)
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 425.0), animated: true)
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        } else {
            shouldDragMainBar = true
            self.scrollView.isScrollEnabled = true
            self.inviteHeightAnchor.constant = 112
            scrollView.contentSize = CGSize(width: phoneWidth, height: 1140)
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func newHostControllerPressed() {
        self.scrollView.setContentOffset(.zero, animated: true)
        self.delegate?.mainBarWillClose()
        self.delegate?.becomeANewHost()
        delayWithSeconds(2) {
            self.scrollView.isScrollEnabled = false
        }
    }
    
    func openEvents() {
        self.minimizeEvents.isActive = false
        self.maximizeEvents.isActive = true
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: 1140)
        UIView.animate(withDuration: animationIn) {
            self.eventsView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
}


extension MainBarViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        let translation = scrollView.contentOffset.y
        if translation < 0 {
            scrollView.contentOffset.y = 0.0
            scrollView.isScrollEnabled = false
            self.delegate?.mainBarWillClose()
        }
    }
    
}
