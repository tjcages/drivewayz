//
//  BookingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation
import Stripe

class Booking: UIViewController {
    
    var delegate: HandleMapBooking?
    var spotType: SpotType = .Public
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
    
    var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var slideLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_1
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var slideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select a spot, or swipe up for more"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var buttonView: BookingBottomView = {
        let view = BookingBottomView()
        view.mainButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        bookingTableView.delegate = self
        bookingTableView.dataSource = self

        setupViews()
    }
    
    var bookingTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
     
        view.addSubview(container)
        bookingTopAnchor = container.topAnchor.constraint(equalTo: view.topAnchor)
            bookingTopAnchor.isActive = true
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
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
        
        view.addSubview(buttonView)
        buttonView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 156 + cancelBottomHeight)
        
    }
    
    @objc func mainButtonPressed() {
        if !isPurchasing {
            delegate?.presentPublicController(spotType: self.spotType)
//            switch self.spotType {
//            case .Private:
//
//                isPurchasing = true
//                delegate?.closeBooking()
//                delegate?.bookParkingPressed(parking: ParkingSpots(dictionary: [:]), type: spotType) // FAKE PARKING SPOT DICTIONARY
//                bookingTopAnchor.constant = parkingNormalHeight
//                UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
//                    self.view.layoutIfNeeded()
//                }) { (success) in
//
//                }
//                delayWithSeconds(animationIn/2) {
//                    self.purchaseTopAnchor.constant = 0
//                    UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
//                        self.view.layoutIfNeeded()
//                    }) { (success) in
//                        //
//                    }
//                }
//            case .Free:
//                self.delegate?.presentPublicController(spotType: self.spotType)
//            case .Public:
//                self.delegate?.presentPublicController(spotType: self.spotType)
//            }
        } else {
//            delegate?.bookingConfirmed()
        }
    }
    
//    func dismissPurchaseController() {
//        isPurchasing = false
//        purchaseTopAnchor.constant = phoneHeight
//        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseIn, animations: {
//            self.view.layoutIfNeeded()
//        }) { (success) in
//
//        }
//        delayWithSeconds(animationIn/2) {
//            self.view.layoutIfNeeded()
//            self.bookingTopAnchor.constant = 0
//            self.bookingTableView.scrollToTop(animated: false)
//            UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
//                self.view.layoutIfNeeded()
//            }) { (success) in
//                //
//            }
//        }
//    }
    
//    @objc func expandBanner() {
//        if bannerExpanded {
//            bannerExpanded = false
//            delegate?.minimizePurchaseBanner()
//            purchaseController.minimizeBanner()
//        } else {
//            bannerExpanded = true
//            delegate?.expandPurchaseBanner()
//            purchaseController.expandBanner()
//        }
//    }

//    func observePaymentMethod() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("users").child(userId).child("selectedPayment")
//        ref.observe(.childAdded) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//                let paymentMethod = PaymentMethod(dictionary: dictionary)
//                if let cardNumber = paymentMethod.last4 {
//                    let card = " •••• \(cardNumber)"
//                    self.buttonView.paymentButton.setTitle(card, for: .normal)
//                    let image = setDefaultPaymentMethod(method: paymentMethod)
//                    self.buttonView.paymentButton.setImage(image, for: .normal)
////                    self.currentPaymentMethod = paymentMethod
//                }
//            }
//        }
//        ref.observe(.childRemoved) { (snapshot) in
////                self.paymentButton.setTitle("Select payment", for: .normal)
//            self.buttonView.paymentButton.setImage(nil, for: .normal)
////            self.currentPaymentMethod = nil
//            ref.observe(.childAdded, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String: Any] {
//                    let paymentMethod = PaymentMethod(dictionary: dictionary)
//                    if let cardNumber = paymentMethod.last4 {
//                        let card = " •••• \(cardNumber)"
//                        self.buttonView.paymentButton.setTitle(card, for: .normal)
//                        let image = setDefaultPaymentMethod(method: paymentMethod)
//                        self.buttonView.paymentButton.setImage(image, for: .normal)
////                        self.currentPaymentMethod = paymentMethod
//                    }
//                }
//            })
//        }
//    }
    
    func selectFirstIndex() {
        let index = IndexPath(row: 0, section: 0)
        bookingTableView.selectRow(at: index, animated: true, scrollPosition: .top)
//        tableView(bookingTableView, didSelectRowAt: index)
    }
    
}

extension Booking: UITableViewDelegate, UITableViewDataSource {
    
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
//        if indexPath.row == 0 {
//            cell.privateSpot()
//        } else if indexPath.row == 1 {
//            cell.freeSpot()
//        } else if indexPath.row == 2 {
//            cell.publicSpot()
//        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedIndex = indexPath
//
//        guard let cell = tableView.cellForRow(at: indexPath) as? BookingSpotView else { return }
//        switch cell.aceButton.isHidden {
//        case true:
//            exactRouteLine = true
//            if indexPath.row == 0 {
//                let hostLocation = CLLocation(latitude: 32.744530, longitude: -117.188110)
//                delegate?.drawHostPolyline(hostLocation: hostLocation)
//                spotType = cell.spotType
//            } else if indexPath.row == 1 {
//                exactRouteLine = false
//                let hostLocation = CLLocation(latitude: 32.742010, longitude: -117.202870)
//                delegate?.drawHostPolyline(hostLocation: hostLocation)
//                spotType = cell.spotType
//            } else {
//                let hostLocation = CLLocation(latitude: 32.746530, longitude: -117.189110)
//                delegate?.drawHostPolyline(hostLocation: hostLocation)
//                spotType = cell.spotType
//            }
//        default:
//            exactRouteLine = false
//            let hostLocation = CLLocation(latitude: 32.744530, longitude: -117.188110)
//            delegate?.drawHostPolyline(hostLocation: hostLocation)
//            spotType = cell.spotType
//        }
//    }

}

extension Booking: UIScrollViewDelegate {
    
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

var paymentCardTextField = STPPaymentCardTextField()

func setDefaultPaymentMethod(method: PaymentMethod) -> UIImage {
    let params = STPCardParams()
    if let brand = method.brand?.lowercased() {
        let methodStyle = CardType(dictionary: brand)
        if let prefix = methodStyle.prefix {
            params.number = prefix
        }
    }
    paymentCardTextField.cardParams = STPPaymentMethodCardParams(cardSourceParams: params)
    if let image = paymentCardTextField.brandImage {
        return image
    } else {
        return UIImage()
    }
}
