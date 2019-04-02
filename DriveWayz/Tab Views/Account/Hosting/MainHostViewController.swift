//
//  MainHostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Firebase

protocol handleHostingScroll {
    func handleScroll(height: CGFloat)
    func allGuestsPressed()
    func hideAllGuests()
    func animateScroll(translation: CGFloat, active: Bool)
    func changeMainLabel(text: String)
    func bringNewHostingController()
}

protocol handleNewHosting {
    func bringNewHostingController()
}

class MainHostViewController: UIViewController, UIScrollViewDelegate, handleHostingScroll {
    
    var delegate: controlsAccountOptions?
    var moveDelegate: moveControllers?
    
    var hostingSpots = [ParkingSpots]()
    var hostingSpotsDictionary = [String: ParkingSpots]()
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.decelerationRate = .fast
        view.showsHorizontalScrollIndicator = false
        view.scrollsToTop = true
        
        return view
    }()
    
    lazy var firstParkingController: FirstHostingViewController = {
        let controller = FirstHostingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.hostDelegate = self
        
        return controller
    }()
    
    lazy var secondParkingController: SecondHostingsController = {
        let controller = SecondHostingsController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.hostDelegate = self
        
        return controller
    }()
    
    lazy var thirdParkingController: ThirdHostingsController = {
        let controller = ThirdHostingsController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        controller.hostDelegate = self
        
        return controller
    }()
    
    lazy var allGuestsView: HostingAllGuestsViewController = {
        let controller = HostingAllGuestsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(hideAllGuests), for: .touchUpInside)
        
        return button
    }()
    
    lazy var editCalendarView: EditCalendarViewController = {
        let controller = EditCalendarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var editInformationView: EditInformationViewController = {
        let controller = EditInformationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var editCostView: EditCostViewController = {
        let controller = EditCostViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var editSpotView: EditSpotsViewController = {
        let controller = EditSpotsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var editAmenitiesView: EditAmenitiesViewController = {
        let controller = EditAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
        scrollView.delegate = self
        
        checkUserStatus()
        setupViews()
        setupControllers()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var containerAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        containerAnchor = container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            containerAnchor.isActive = true
        containerHeightAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 160)
            containerHeightAnchor.isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        container.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1890)
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func checkUserStatus() {
        var i = 0
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observe(.childAdded) { (snapshot) in
                i += 1
                let hostKey = snapshot.key
                let hostRef = Database.database().reference().child("ParkingSpots").child(hostKey)
                hostRef.observeSingleEvent(of: .value, with: { (hostSnap) in
                    if let dictionary = hostSnap.value as? [String:AnyObject] {
                        let hosting = ParkingSpots(dictionary: dictionary)
                        DispatchQueue.main.async(execute: {
                            let hostingID = dictionary["parkingID"] as! String
                            self.hostingSpotsDictionary[hostingID] = hosting
                            if i == 1 {
                                self.setupFirstController()
                                self.firstParkingController.setData(hosting: hosting)
                            } else if i == 2 {
                                self.setupSecondController()
//                                self.secondParkingController.setData(hosting: hosting)
                            } else if i == 3 {
                                self.setupThirdController()
//                                self.thirdParkingController.setData(hosting: hosting)
                            }
                        })
                    }
                })
            }
        }
    }
    
    var mainParkingAnchor: NSLayoutConstraint!
    var allParkingAnchor: NSLayoutConstraint!
    var editCalendarAnchor: NSLayoutConstraint!
    var editInformationAnchor: NSLayoutConstraint!
    var editCostAnchor: NSLayoutConstraint!
    var editSpotsAnchor: NSLayoutConstraint!
    var editAmenitiesAnchor: NSLayoutConstraint!
    
    func setupFirstController() {
        scrollView.addSubview(firstParkingController.view)
        firstParkingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainParkingAnchor = firstParkingController.view.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        mainParkingAnchor.isActive = true
        firstParkingController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        firstParkingController.view.heightAnchor.constraint(equalToConstant: 3000).isActive = true
    }
    
    func setupSecondController() {
        scrollView.addSubview(secondParkingController.view)
        secondParkingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        secondParkingController.view.leftAnchor.constraint(equalTo: firstParkingController.view.rightAnchor).isActive = true
        secondParkingController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        secondParkingController.view.heightAnchor.constraint(equalToConstant: 3000).isActive = true
    }
    
    func setupThirdController() {
        scrollView.addSubview(thirdParkingController.view)
        thirdParkingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        thirdParkingController.view.leftAnchor.constraint(equalTo: secondParkingController.view.rightAnchor).isActive = true
        thirdParkingController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        thirdParkingController.view.heightAnchor.constraint(equalToConstant: 3000).isActive = true
    }
    
    func setupControllers() {
        
//        let left = UISwipeGestureRecognizer(target: self, action: #selector(parkingSpotSwiped(sender:)))
//        left.direction = .left
//        let right = UISwipeGestureRecognizer(target: self, action: #selector(parkingSpotSwiped(sender:)))
//        right.direction = .right
//        self.view.addGestureRecognizer(left)
//        self.view.addGestureRecognizer(right)
        
        self.view.addSubview(allGuestsView.view)
        allGuestsView.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        allParkingAnchor = allGuestsView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.frame.width)
            allParkingAnchor.isActive = true
        allGuestsView.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        allGuestsView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 26).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 38).isActive = true
        }
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideAllGuests))
        swipeGesture.direction = .right
        allGuestsView.view.addGestureRecognizer(swipeGesture)
    }
    
    func allGuestsPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.containerAnchor.constant = -self.view.frame.width/2
            self.backButton.alpha = 1
            self.allParkingAnchor.constant = 0
            self.moveDelegate?.hideExitButton()
            self.view.layoutIfNeeded()
        }) { (success) in
            self.moveDelegate?.changeMainLabel(text: "My guests")
            UIView.animate(withDuration: animationIn, animations: {
                self.containerHeightAnchor.constant = 160
                self.moveDelegate?.moveMainLabel(percent: 0)
                self.view.layoutIfNeeded()
            }) { (success) in
                self.scrollView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    @objc func hideAllGuests() {
        if allGuestsView.previousAnchor.constant == 0 {
            self.moveDelegate?.changeMainLabel(text: "My guests")
            UIView.animate(withDuration: animationOut) {
                self.allGuestsView.previousAnchor.constant = self.view.frame.width
                self.allGuestsView.tableViewCenterAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        } else {
            self.firstParkingController.guestsOpened = false
            self.moveDelegate?.changeMainLabel(text: "My parking spots")
            UIView.animate(withDuration: animationOut, animations: {
                self.containerAnchor.constant = 0
                self.backButton.alpha = 0
                self.allParkingAnchor.constant = self.view.frame.width
                self.moveDelegate?.bringExitButton()
                self.containerHeightAnchor.constant = 160
                self.moveDelegate?.moveMainLabel(percent: 0)
                self.view.layoutIfNeeded()
            }) {(success) in
                self.firstParkingController.view.layoutIfNeeded()
                self.allGuestsView.tableView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    func changeMainLabel(text: String) {
        self.moveDelegate?.changeMainLabel(text: text)
    }
    
    @objc func parkingSpotSwiped(sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: animationOut) {
            if sender.direction == .left && self.mainParkingAnchor.constant == 0 {
                self.mainParkingAnchor.constant = -self.view.frame.width
            } else if sender.direction == .left && self.mainParkingAnchor.constant == -self.view.frame.width {
                self.mainParkingAnchor.constant = -self.view.frame.width * 2
            } else if sender.direction == .right && self.mainParkingAnchor.constant == -self.view.frame.width * 2 {
                self.mainParkingAnchor.constant = -self.view.frame.width
            } else if sender.direction == .right && self.mainParkingAnchor.constant == -self.view.frame.width {
                self.mainParkingAnchor.constant = 0
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > self.view.frame.height {
            let translation = scrollView.contentOffset.y
            self.animateScroll(translation: translation, active: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        self.animateScroll(translation: translation, active: false)
    }
    
    func animateScroll(translation: CGFloat, active: Bool) {
        if active == true {
            if translation <= 50 && translation >= 10 {
                let percent = (translation-10)/40
                switch device {
                case .iphone8:
                    self.containerHeightAnchor.constant = 160 - (percent * 80)
                case .iphoneX:
                    self.containerHeightAnchor.constant = 160 - (percent * 70)
                }
                self.moveDelegate?.moveMainLabel(percent: percent)
            } else if translation < 10 {
                self.containerHeightAnchor.constant = 160
                self.moveDelegate?.moveMainLabel(percent: 0)
            } else {
                self.moveDelegate?.moveMainLabel(percent: 1)
                switch device {
                case .iphone8:
                    self.containerHeightAnchor.constant = 80
                case .iphoneX:
                    self.containerHeightAnchor.constant = 90
                }
            }
        } else {
            if translation < 30 {
                UIView.animate(withDuration: 0.2) {
                    self.scrollView.contentOffset.y = 0
                }
            } else if translation >= 30 && translation <= 50 {
                UIView.animate(withDuration: 0.2) {
                    self.scrollView.contentOffset.y = 50
                }
            }
        }
    }
    
    func handleScroll(height: CGFloat) {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
    }
    
    func bringNewHostingController() {
        self.delegate?.hideHostingController()
        self.delegate?.bringNewHostingController()
        delayWithSeconds(2) {
            self.scrollView.setContentOffset(.zero, animated: false)
        }
    }
    
}


extension MainHostViewController: handleHostEditing {
    
    func setupEditingCalendar() {
        self.view.addSubview(editCalendarView.view)
        editCalendarView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editCalendarAnchor = editCalendarView.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
        editCalendarAnchor.isActive = true
        editCalendarView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editCalendarView.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationIn) {
            self.moveDelegate?.hideExitButton()
            self.editCalendarAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupEditingInformation() {
        self.view.addSubview(editInformationView.view)
        editInformationView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editInformationAnchor = editInformationView.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            editInformationAnchor.isActive = true
        editInformationView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editInformationView.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationIn) {
            self.moveDelegate?.hideExitButton()
            self.editInformationAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupEditingCost() {
        self.view.addSubview(editCostView.view)
        editCostView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editCostAnchor = editCostView.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            editCostAnchor.isActive = true
        editCostView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editCostView.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationIn) {
            self.moveDelegate?.hideExitButton()
            self.editCostAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupEditingSpots() {
        self.view.addSubview(editSpotView.view)
        editSpotView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editSpotsAnchor = editSpotView.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            editSpotsAnchor.isActive = true
        editSpotView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editSpotView.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationIn) {
            self.moveDelegate?.hideExitButton()
            self.editSpotsAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupEditingAmenities() {
        self.view.addSubview(editAmenitiesView.view)
        editAmenitiesView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        editAmenitiesAnchor = editAmenitiesView.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
            editAmenitiesAnchor.isActive = true
        editAmenitiesView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        editAmenitiesView.view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationIn) {
            self.moveDelegate?.hideExitButton()
            self.editAmenitiesAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideEditingCalendar() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editCalendarAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.moveDelegate?.bringExitButton()
            self.editCalendarView.willMove(toParent: nil)
            self.editCalendarView.view.removeFromSuperview()
            self.editCalendarView.removeFromParent()
        }
    }
    
    func hideEditingInformation() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editInformationAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.moveDelegate?.bringExitButton()
            self.editInformationView.willMove(toParent: nil)
            self.editInformationView.view.removeFromSuperview()
            self.editInformationView.removeFromParent()
        }
    }
    
    func hideEditingCost() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editCostAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.moveDelegate?.bringExitButton()
            self.editCostView.willMove(toParent: nil)
            self.editCostView.view.removeFromSuperview()
            self.editCostView.removeFromParent()
        }
    }
    
    func hideEditingSpots() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editSpotsAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.moveDelegate?.bringExitButton()
            self.editSpotView.willMove(toParent: nil)
            self.editSpotView.view.removeFromSuperview()
            self.editSpotView.removeFromParent()
        }
    }
    
    func hideEditingAmenities() {
        UIView.animate(withDuration: animationOut, animations: {
            self.editAmenitiesAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (success) in
            self.moveDelegate?.bringExitButton()
            self.editAmenitiesView.willMove(toParent: nil)
            self.editAmenitiesView.view.removeFromSuperview()
            self.editAmenitiesView.removeFromParent()
        }
    }
    
}

protocol handleHostEditing {
    func setupEditingCalendar()
    func setupEditingInformation()
    func setupEditingCost()
    func setupEditingSpots()
    func setupEditingAmenities()
    
    func hideEditingCalendar()
    func hideEditingInformation()
    func hideEditingCost()
    func hideEditingSpots()
    func hideEditingAmenities()
}
