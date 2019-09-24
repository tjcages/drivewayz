//
//  MainBarViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

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

        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = lineColor
        view.isScrollEnabled = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 3
        
        return view
    }()
    
    lazy var searchController: MainSearchViewController = {
        let controller = MainSearchViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var worksController: HowItWorksController = {
        let controller = HowItWorksController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var eventsController: MainEventsViewController = {
        let controller = MainEventsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var newHostController: NewHostBannerViewController = {
        let controller = NewHostBannerViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        let host = UITapGestureRecognizer(target: self, action: #selector(newHostControllerPressed))
        controller.view.addGestureRecognizer(host)
        
        return controller
    }()
    
    lazy var inviteFriendController: InviteBannerViewController = {
        let controller = InviteBannerViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        let invite = UITapGestureRecognizer(target: self, action: #selector(inviteControllerPressed))
        controller.view.addGestureRecognizer(invite)
        controller.parkingController.inviteButton.addTarget(self, action: #selector(inviteNewUser), for: .touchUpInside)
        
        return controller
    }()
    
    lazy var contactBannerController: BannerMessageViewController = {
        let controller = BannerMessageViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2

        scrollView.delegate = self
        
        setupStack()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.eventsController.eventsController.checkEvents()
    }
    
    func setupViews() {
        setupSearch(0, last: false)
        setupWorks(0, last: true)
        setupInviteBanner(0, last: true)
        setupEvents(0, last: true)
        setupHostBanner(0, last: true)
    }

    func setupStack() {

        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 860)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

    }
    
    func setupSearch(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(searchController.view)
        } else {
            stackView.insertArrangedSubview(searchController.view, at: index)
        }
        searchController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupWorks(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(worksController.view)
        } else {
            stackView.insertArrangedSubview(worksController.view, at: index)
        }
        worksController.view.heightAnchor.constraint(equalToConstant: 384).isActive = true
    }
    
    func setupEvents(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(eventsController.view)
        } else {
            stackView.insertArrangedSubview(eventsController.view, at: index)
        }
        eventsController.view.heightAnchor.constraint(equalToConstant: 284).isActive = true
    }
    
    var inviteHeightAnchor: NSLayoutConstraint!
    
    func setupInviteBanner(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(inviteFriendController.view)
        } else {
            stackView.insertArrangedSubview(inviteFriendController.view, at: index)
        }
        inviteHeightAnchor = inviteFriendController.view.heightAnchor.constraint(equalToConstant: 112)
            inviteHeightAnchor.isActive = true
    }
    
    func setupHostBanner(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(newHostController.view)
        } else {
            stackView.insertArrangedSubview(newHostController.view, at: index)
        }
        newHostController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }

    func setupContact(_ index: Int, last: Bool) {
        if stackView.arrangedSubviews.contains(contactBannerController.view) {
            self.stackView.removeArrangedSubview(self.contactBannerController.view)
        }
        
        if last {
            stackView.addArrangedSubview(contactBannerController.view)
        } else {
            stackView.insertArrangedSubview(contactBannerController.view, at: index)
        }
        contactBannerController.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
}


extension MainBarViewController: handleInviteControllers {
    func changeRecentsHeight(height: CGFloat) {
        
    }
    
    
    func searchRecentsPressed(address: String) {
        self.delegate?.zoomToSearchLocation(address: address)
    }
    
    @objc func inviteControllerPressed() {
        if self.inviteHeightAnchor.constant == 112 {
            shouldDragMainBar = false
//            self.delegate?.expandedMainBar()
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
        self.delegate?.closeMainBar()
        self.delegate?.becomeANewHost()
        delayWithSeconds(2) {
            self.scrollView.isScrollEnabled = false
        }
    }
    
    func openEvents() {
//        self.minimizeEvents.isActive = false
//        self.maximizeEvents.isActive = true
        self.scrollView.contentSize = CGSize(width: phoneWidth, height: 1140)
        UIView.animate(withDuration: animationIn) {
            self.eventsController.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func inviteNewUser() {
        if let url = self.inviteFriendController.parkingController.dynamicLink {
            let promoText = "Check out Drivewayz the parking rental app!"
            let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
            
            delayWithSeconds(4) {
                guard let currentUser = Auth.auth().currentUser?.uid else {return}
                let ref = Database.database().reference().child("users").child(currentUser)
                ref.child("Coupons").observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        if (dictionary["INVITE10"] as? String) != nil {
                            let alert = UIAlertController(title: "Sorry", message: "You can only get one 10% off coupon for sharing.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            return
                        } else {
                            ref.child("Coupons").updateChildValues(["INVITE10": "10% off coupon!"])
                            ref.child("CurrentCoupon").updateChildValues(["invite": 10])
                            let alert = UIAlertController(title: "Thanks for sharing!", message: "You have successfully invited your friend and recieved a 10% off coupon for your next rental.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
}


extension MainBarViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        shouldDragMainBar = true
        let translation = scrollView.contentOffset.y
        if translation < 0 {
            scrollView.contentOffset.y = 0.0
            scrollView.isScrollEnabled = false
            self.delegate?.closeMainBar()
        }
    }
    
}
