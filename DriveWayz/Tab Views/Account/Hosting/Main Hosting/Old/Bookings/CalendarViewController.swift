//
//  CalendarViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleCalendarHeight {
    func changeCalendarHeight(amount: CGFloat)
    func bringSaveButton()
    func hideSaveButton()
    func closeScheduleView()
}

class CalendarViewController: UIViewController, handleCalendarHeight {

    var delegate: handleHostScrolling?
    var bookingDelegate: handleBookingInformation?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
//        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var hostCalendar: HostCalendarViewController = {
        let controller = HostCalendarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.calendarDelegate = self
        
        return controller
    }()
    
    lazy var calendarOptions: CalendarOptionsViewController = {
        let controller = CalendarOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    lazy var undoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Undo", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.GRAY_WHITE_4
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.layer.cornerRadius = 35/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setupViews()
    }
    
    var calendarHeightAnchor: NSLayoutConstraint!
    var optionsHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight * 2)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(hostCalendar.view)
        hostCalendar.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        hostCalendar.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostCalendar.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostCalendar.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(calendarOptions.view)
        calendarOptions.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        calendarOptions.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        optionsHeightAnchor = calendarOptions.view.heightAnchor.constraint(equalToConstant: 0)
            optionsHeightAnchor.isActive = true
        switch device {
        case .iphone8:
            calendarOptions.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64).isActive = true
        case .iphoneX:
            calendarOptions.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -76).isActive = true
        }
        
        self.view.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nextButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 32).isActive = true
        switch device {
        case .iphone8:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        case .iphoneX:
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -92).isActive = true
        }
        
        self.view.addSubview(undoButton)
        undoButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        undoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    func bringSaveButton() {
        self.bookingDelegate?.hideOrganizer()
        self.nextButton.backgroundColor = Theme.BLUE
        self.closeScheduleView()
        delayWithSeconds(animationOut) {
            UIView.animate(withDuration: animationIn, animations: {
                self.undoButton.alpha = 1
                self.nextButton.alpha = 1
            })
        }
    }
    
    func hideSaveButton() {
        self.bookingDelegate?.bringOrganizer()
        UIView.animate(withDuration: animationOut, animations: {
            self.undoButton.alpha = 0
            self.nextButton.alpha = 0
        }) { (success) in
            self.openScheduleView()
        }
    }
    
    @objc func undoButtonPressed() {
        self.hostCalendar.setupPreviousAvailability()
        self.hideSaveButton()
    }
    
    @objc func saveButtonPressed() {
        self.bookingDelegate?.beginLoading()
        self.nextButton.backgroundColor = Theme.GRAY_WHITE_4
        self.nextButton.isUserInteractionEnabled = false
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                if let value = snapshot.value as? String {
                    let hostRef = Database.database().reference().child("ParkingSpots").child(value)
                    
                    let mondayUnavailable = self.hostCalendar.selectedMondays
                    let tuesdayUnavailable = self.hostCalendar.selectedTuesdays
                    let wednesdayUnavailable = self.hostCalendar.selectedWednesdays
                    let thursdayUnavailable = self.hostCalendar.selectedThursdays
                    let fridayUnavailable = self.hostCalendar.selectedFridays
                    let saturdayUnavailable = self.hostCalendar.selectedSaturdays
                    let sundayUnavailable = self.hostCalendar.selectedSundays
                    
                    let unavailableRef = hostRef.child("UnavailableDays")
                    let unavailableMonday = unavailableRef.child("Monday")
                    let unavailableTuesday = unavailableRef.child("Tuesday")
                    let unavailableWednesday = unavailableRef.child("Wednesday")
                    let unavailableThursday = unavailableRef.child("Thursday")
                    let unavailableFriday = unavailableRef.child("Friday")
                    let unavailableSaturday = unavailableRef.child("Saturday")
                    let unavailableSunday = unavailableRef.child("Sunday")
                    
                    unavailableMonday.setValue(mondayUnavailable)
                    unavailableTuesday.setValue(tuesdayUnavailable)
                    unavailableWednesday.setValue(wednesdayUnavailable)
                    unavailableThursday.setValue(thursdayUnavailable)
                    unavailableFriday.setValue(fridayUnavailable)
                    unavailableSaturday.setValue(saturdayUnavailable)
                    unavailableSunday.setValue(sundayUnavailable)
                    
                    delayWithSeconds(0.8) {
                        self.bookingDelegate?.endLoading()
                        self.nextButton.isUserInteractionEnabled = true
                        self.hideSaveButton()
                    }
                }
            }
        }
    }
    
    func openScheduleView() {
        self.optionsHeightAnchor.constant = 68
        UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func closeScheduleView() {
        self.optionsHeightAnchor.constant = 0
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func changeCalendarHeight(amount: CGFloat) {
        scrollView.contentSize = CGSize(width: phoneWidth, height: amount + 100)
        self.view.layoutIfNeeded()
    }
    
}


extension CalendarViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.makeScrollViewScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.makeScrollViewEnd(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.makeScrollViewEnd(scrollView)
    }
    
}
