//
//  BookingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

var parkingNormalHeight: CGFloat = 462
var exactRouteLine: Bool = true
var userEnteredDestination: Bool = true

class BookingViewController: UIViewController {
    
    var delegate: HandleMapBooking?
    var isPurchasing: Bool = false
    var bannerExpanded: Bool = false
    
    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 72
    let scrollBottomInset: CGFloat = 122
    
    var selectedIndex = IndexPath(row: 0, section: 0) {
        didSet {
            bookingTableView.reloadData()
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()

    lazy var bookingTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BookingSpotView.self, forCellReuseIdentifier: "cellId")
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.contentInset = UIEdgeInsets(top: -28, left: 0, bottom: scrollBottomInset, right: 0)
        view.clipsToBounds = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var purchaseController: PurchaseViewController = {
        let controller = PurchaseViewController()
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandBanner))
        controller.bannerView.addGestureRecognizer(tap)

        return controller
    }()
    
    var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var slideLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var slideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select a spot, or swipe up for more"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        line.backgroundColor = lineColor
        view.addSubview(line)
        
        return view
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Book Private", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var timeIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hostAvailabilityIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        
        return button
    }()
    
    var timeValue: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("11:15am to 2:30pm", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var paymentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(paymentButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var profileIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookingProfile")
        button.setImage(image, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        bookingTableView.delegate = self
        bookingTableView.dataSource = self

        setupViews()
        setupButtons()
        observePaymentMethod()
    }
    
    var bookingTopAnchor: NSLayoutConstraint!
    var purchaseTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
     
        view.addSubview(container)
        bookingTopAnchor = container.topAnchor.constraint(equalTo: view.topAnchor)
            bookingTopAnchor.isActive = true
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(purchaseController.view)
        purchaseTopAnchor = purchaseController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: phoneHeight)
            purchaseTopAnchor.isActive = true
        purchaseController.view.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(bookingTableView)
        bookingTableView.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: view.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(headerView)
        headerView.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 48)
        
        headerView.addSubview(slideLine)
        headerView.addSubview(slideLabel)
        headerView.addSubview(line)
        
        slideLine.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        slideLine.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        slideLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        slideLine.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        slideLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        slideLabel.topAnchor.constraint(equalTo: slideLine.bottomAnchor, constant: 4).isActive = true
        slideLabel.sizeToFit()
        
        line.anchor(top: nil, left: container.leftAnchor, bottom: headerView.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    var paymentRightAnchor: NSLayoutConstraint!
    var paymentWidthAnchor: NSLayoutConstraint!
    var profileLeftAnchor: NSLayoutConstraint!
    
    func setupButtons() {
        
        view.addSubview(buttonView)
        view.addSubview(mainButton)
        view.addSubview(timeIcon)
        view.addSubview(timeValue)
        
        buttonView.anchor(top: timeIcon.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        switch device {
        case .iphoneX:
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .iphone8:
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        }
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        timeIcon.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 24, paddingRight: 0, width: 16, height: 16)
        
        timeValue.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        timeValue.leftAnchor.constraint(equalTo: timeIcon.rightAnchor, constant: 8).isActive = true
        timeValue.sizeToFit()
        
        view.addSubview(paymentButton)
        view.addSubview(profileIcon)
        
        paymentButton.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        paymentRightAnchor = paymentButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
            paymentRightAnchor.isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymentWidthAnchor = paymentButton.widthAnchor.constraint(equalToConstant: 32)
            paymentWidthAnchor.isActive = true
        
        profileLeftAnchor = profileIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
            profileLeftAnchor.isActive = false
        profileIcon.bottomAnchor.constraint(equalTo: paymentButton.bottomAnchor).isActive = true
        profileIcon.rightAnchor.constraint(equalTo: paymentButton.leftAnchor, constant: -4).isActive = true
        profileIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        profileIcon.widthAnchor.constraint(equalTo: profileIcon.heightAnchor).isActive = true
        
    }
    
    @objc func mainButtonPressed() {
        if !isPurchasing {
            isPurchasing = true
            delegate?.closeBooking()
            delegate?.bookParkingPressed(parking: ParkingSpots(dictionary: [:]))
            bookingTopAnchor.constant = parkingNormalHeight
            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
                self.timeIcon.alpha = 0
                self.timeValue.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                
            }
            delayWithSeconds(animationIn/2) {
                self.mainButton.setTitle("Confirm Private", for: .normal)
                self.view.layoutIfNeeded()
                self.purchaseTopAnchor.constant = 0
                self.paymentRightAnchor.isActive = false
                self.profileLeftAnchor.isActive = true
                self.paymentWidthAnchor.constant = 120
                UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }) { (success) in
                    //
                }
            }
        } else {
            delegate?.bookingConfirmed()
        }
    }
    
    func dismissPurchaseController() {
        isPurchasing = false
        purchaseTopAnchor.constant = phoneHeight
        paymentRightAnchor.isActive = true
        profileLeftAnchor.isActive = false
        self.paymentWidthAnchor.constant = 32
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
        
        }
        delayWithSeconds(animationIn/2) {
            self.mainButton.setTitle("Book Private", for: .normal)
            self.view.layoutIfNeeded()
            self.bookingTopAnchor.constant = 0
            self.bookingTableView.scrollToTop(animated: false)
            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
                self.timeIcon.alpha = 1
                self.timeValue.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                //
            }
        }
    }
    
    @objc func expandBanner() {
        if bannerExpanded {
            bannerExpanded = false
            delegate?.minimizePurchaseBanner()
            purchaseController.minimizeBanner()
        } else {
            bannerExpanded = true
            delegate?.expandPurchaseBanner()
            purchaseController.expandBanner()
        }
    }

    func observePaymentMethod() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userId).child("selectedPayment")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let paymentMethod = PaymentMethod(dictionary: dictionary)
                if let cardNumber = paymentMethod.last4 {
                    let card = " •••• \(cardNumber)"
                    self.paymentButton.setTitle(card, for: .normal)
                    let image = setDefaultPaymentMethod(method: paymentMethod)
                    self.paymentButton.setImage(image, for: .normal)
//                    self.currentPaymentMethod = paymentMethod
                }
            }
        }
        ref.observe(.childRemoved) { (snapshot) in
//                self.paymentButton.setTitle("Select payment", for: .normal)
            self.paymentButton.setImage(nil, for: .normal)
//            self.currentPaymentMethod = nil
            ref.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let paymentMethod = PaymentMethod(dictionary: dictionary)
                    if let cardNumber = paymentMethod.last4 {
                        let card = " •••• \(cardNumber)"
                        self.paymentButton.setTitle(card, for: .normal)
                        let image = setDefaultPaymentMethod(method: paymentMethod)
                        self.paymentButton.setImage(image, for: .normal)
//                        self.currentPaymentMethod = paymentMethod
                    }
                }
            })
        }
    }
    
    func selectFirstIndex() {
        let index = IndexPath(row: 0, section: 0)
        bookingTableView.selectRow(at: index, animated: true, scrollPosition: .top)
        tableView(bookingTableView, didSelectRowAt: index)
    }
    
}

extension BookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NotificationsHeader()
        if section == 0 {
            view.mainLabel.text = "Convenience"
            view.newLabel.text = "6 total"
        } else if section == 1 {
            view.mainLabel.text = "Economy"
            view.newLabel.text = "18 total"
        } else {
            view.mainLabel.text = "Standard"
            view.newLabel.text = "32 total"
        }
        view.backgroundColor = Theme.WHITE
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookingSpotView
        cell.selectionStyle = .none
        
        if indexPath == selectedIndex {
            cell.selectedView()
        } else {
            cell.unselectedView()
        }
        
        if indexPath.row == 1 {
            cell.mainLabel.text = "Shared"
            cell.subLabel.text = "Apartment parking"
            cell.costLabel.text = "$7.32"
            cell.pinLabel.text = "1"
        } else if indexPath.row == 2 {
            cell.mainLabel.text = "Public"
            cell.subLabel.text = "Parking garage"
            cell.costLabel.text = "$9.50"
            cell.pinLabel.text = "72"
            cell.subCostLabel.text = "Pay at Kiosk"
            cell.subCostLine.isHidden = true
            cell.aceButton.isHidden = false
            cell.saleIcon.isHidden = true
            cell.informationIcon.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        guard let cell = tableView.cellForRow(at: indexPath) as? BookingSpotView else { return }
        switch cell.aceButton.isHidden {
        case true:
            exactRouteLine = true
            if indexPath.row == 0 {
                let hostLocation = CLLocation(latitude: 32.744530, longitude: -117.188110)
                delegate?.drawHostPolyline(hostLocation: hostLocation)
            } else {
                let hostLocation = CLLocation(latitude: 32.742010, longitude: -117.202870)
                delegate?.drawHostPolyline(hostLocation: hostLocation)
            }
        default:
            exactRouteLine = false
            let hostLocation = CLLocation(latitude: 32.744530, longitude: -117.188110)
            delegate?.drawHostPolyline(hostLocation: hostLocation)
        }
    }

}

extension BookingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if headerView.alpha == 1 {
//            scrollView.isScrollEnabled = false
//        }
        let translation = scrollView.contentOffset.y
        if translation <= 0.0 {
            let percentage = -translation/40
            if headerView.alpha == 0 {
                delegate?.changeBookingScroll(percentage: percentage)
            }
            if percentage >= 1.0 {
                delegate?.closeBooking()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if headerView.alpha != 0 {
            bookingTableView.isScrollEnabled = false
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if headerView.alpha != 0 {
            bookingTableView.isScrollEnabled = false
        }
    }
    
    func changeBookingScrollAmount(percentage: CGFloat) {
        if percentage <= 0.5 {
            bookingTableView.contentInset = UIEdgeInsets(top: -28 + 28 * percentage, left: 0, bottom: scrollBottomInset, right: 0)
            bookingTableView.scrollToTop(animated: false)
            slideLine.alpha = 1 - percentage * 2
            slideLabel.alpha = 1 - percentage * 2
            line.alpha = 1 - percentage * 2
        } else {
            headerView.alpha = 1 - (percentage - 0.5) * 2
        }
        
        view.layoutIfNeeded()
    }
    
    func openBooking() {
        bookingTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: scrollBottomInset, right: 0)
        bookingTableView.scrollToTop(animated: true)
        UIView.animate(withDuration: animationIn) {
            self.headerView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func closeBooking() {
        bookingTableView.contentInset = UIEdgeInsets(top: -28, left: 0, bottom: scrollBottomInset, right: 0)
//        bookingTableView.scrollToTop(animated: true)
        UIView.animate(withDuration: animationIn) {
            self.bookingTableView.isScrollEnabled = false
            self.headerView.alpha = 1
            self.slideLine.alpha = 1
            self.slideLabel.alpha = 1
            self.line.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
}
