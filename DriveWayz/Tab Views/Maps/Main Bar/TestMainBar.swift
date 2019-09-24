//
//  TestMainBar.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleInviteControllers {
    func searchRecentsPressed(address: String)
    func changeRecentsHeight(height: CGFloat)
    func openEvents()
}

class TestMainBar: UIViewController {
    
    var delegate: mainBarSearchDelegate?
    
    var reservationsOpen: Bool = false
    
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
        view.spacing = 6
        
        return view
    }()
    
    lazy var searchController: TestSearchViewController = {
        let controller = TestSearchViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
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
    
    lazy var inviteController: RecommendViewController = {
        let controller = RecommendViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.inviteButton.addTarget(self, action: #selector(inviteNewUser), for: .touchUpInside)
        
        return controller
    }()
    
    lazy var eventsController: TestEventsViewController = {
        let controller = TestEventsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var reservationsController: ReservationBannerView = {
        let controller = ReservationBannerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        scrollView.delegate = self
        
        setupStack()
        setupViews()
    }
    
    func setupViews() {
        setupSearch(0, last: false)
        setupInvite(0, last: true)
        setupHostBanner(0, last: true)
        setupEvents(0, last: true)
        setupReservations(0, last: false)
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
    
    var searchHeightAnchor: NSLayoutConstraint!
    
    func setupSearch(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(searchController.view)
        } else {
            stackView.insertArrangedSubview(searchController.view, at: index)
        }
        searchHeightAnchor = searchController.view.heightAnchor.constraint(equalToConstant: 176)
            searchHeightAnchor.isActive = true
    }
    
    func setupHostBanner(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(newHostController.view)
        } else {
            stackView.insertArrangedSubview(newHostController.view, at: index)
        }
        newHostController.view.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    func setupInvite(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(inviteController.view)
        } else {
            stackView.insertArrangedSubview(inviteController.view, at: index)
        }
        inviteController.view.heightAnchor.constraint(equalToConstant: 178).isActive = true
    }
    
    func setupEvents(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(eventsController.view)
        } else {
            stackView.insertArrangedSubview(eventsController.view, at: index)
        }
        eventsController.view.heightAnchor.constraint(equalToConstant: eventsController.cellHeight).isActive = true
    }
    
    var reservationsHeightAnchor: NSLayoutConstraint!
    
    func setupReservations(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(reservationsController.view)
        } else {
            stackView.insertArrangedSubview(reservationsController.view, at: index)
        }
        reservationsHeightAnchor = reservationsController.view.heightAnchor.constraint(equalToConstant: 72)
            reservationsHeightAnchor.isActive = true
    }
    
}

extension TestMainBar {
    
    func changeRecentsHeight(height: CGFloat) {
        searchHeightAnchor.constant = 156 + height
        UIView.animate(withDuration: animationIn) {
            self.searchController.recentsTableView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func expandReservations() {
        reservationsOpen = true
        reservationsHeightAnchor.constant += 100
        reservationsController.expandBanner()
    }
    
    func closeReservations() {
        reservationsOpen = false
        reservationsHeightAnchor.constant -= 100
        reservationsController.closeBanner()
    }
    
}

extension TestMainBar: handleInviteControllers {
    
    func searchRecentsPressed(address: String) {
        self.delegate?.zoomToSearchLocation(address: address)
    }
    
    @objc func newHostControllerPressed() {
        self.scrollView.setContentOffset(.zero, animated: true)
        self.delegate?.becomeANewHost()
        delayWithSeconds(2) {
            self.scrollView.isScrollEnabled = false
        }
    }
    
    func openEvents() {

    }
    
    @objc func inviteNewUser() {
        if let url = self.inviteController.dynamicLink {
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

extension TestMainBar: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        shouldDragMainBar = true
        let translation = scrollView.contentOffset.y
        if translation < 0 {
            scrollView.contentOffset.y = 0.0
            scrollView.isScrollEnabled = false
            self.delegate?.closeMainBar()
        }
    }
    
}
