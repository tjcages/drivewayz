//
//  ParkingDetailsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

var parkingAddress: String?
var parkingDistances: String?
var imageURL: String?
var parkingCost: String?
var formattedLocation: String?
var hours: Int?
var timestamps: NSNumber?
var ids: String?
var parkingIDs: String?

var Monday: Int?
var Tuesday: Int?
var Wednesday: Int?
var Thursday: Int?
var Friday: Int?
var Saturday: Int?
var Sunday: Int?

var MondayFrom: String?
var MondayTo: String?
var TuesdayFrom: String?
var TuesdayTo: String?
var WednesdayFrom: String?
var WednesdayTo: String?
var ThursdayFrom: String?
var ThursdayTo: String?
var FridayFrom: String?
var FridayTo: String?
var SaturdayFrom: String?
var SaturdayTo: String?
var SundayFrom: String?
var SundayTo: String?

class ParkingDetailsViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var account: String? = "No account."
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        return view
    }()
    
    lazy var infoController: ParkingInfoViewController = {
        let controller = ParkingInfoViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Info"
        return controller
    }()
    
    lazy var availabilityController: ParkingAvailabilityViewController = {
        let controller = ParkingAvailabilityViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Availability"
        return controller
    }()
    
    lazy var reviewsController: ParkingReviewsViewController = {
        let controller = ParkingReviewsViewController()
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.title = "Reviews"
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.OFF_WHITE
        self.navigationController?.navigationBar.isHidden = true

        hoursView.delegate = self
        hoursView.dataSource = self
        
        checkAccount()
        setupViews()
        setupViewControllers()
        setupSegments()
    }
    
    func setData(cityAddress: String, imageURL: String, parkingCost: String, formattedAddress: String, timestamp: NSNumber, id: String, parkingID: String, parkingDistance: String) {
        labelTitle.text = "Parking in \(cityAddress)"
        parkingAddress = cityAddress
        parkingDistances = parkingDistance
        labelDistance.text = "\(parkingDistance) miles"
        imageView.loadImageUsingCacheWithUrlString(imageURL)
        labelCost.text = parkingCost
        formattedLocation = formattedAddress
        timestamps = timestamp
        ids = id
        parkingIDs = parkingID
    }
    
    var parkingViewTopAnchor: NSLayoutConstraint!
    var titleLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        myScrollView.delegate = self

        self.view.addSubview(myScrollView)
        myScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -statusHeight).isActive = true
        myScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 240)
        
        myScrollView.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: myScrollView.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 4).isActive = true
        exitButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(reserveContainer)
        reserveContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        reserveContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        reserveContainer.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        reserveContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        self.view.addSubview(labelTitle)
        labelTitle.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        labelTitle.topAnchor.constraint(equalTo: reserveContainer.topAnchor).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.OFF_WHITE
        reserveContainer.addSubview(line)
        line.topAnchor.constraint(equalTo: labelTitle.bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: reserveContainer.widthAnchor).isActive = true
        line.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true

        self.view.addSubview(hoursButton)
        hoursButton.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        hoursButton.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 1).isActive = true
        hoursButton.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3).isActive = true
        hoursButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        self.view.addSubview(hoursView)
        hoursView.bottomAnchor.constraint(equalTo: hoursButton.topAnchor).isActive = true
        hoursView.centerXAnchor.constraint(equalTo: hoursButton.centerXAnchor).isActive = true
        hoursView.widthAnchor.constraint(equalTo: hoursButton.widthAnchor).isActive = true
        height = hoursView.heightAnchor.constraint(equalToConstant: 0)

        self.view.addSubview(labelDistance)
        labelDistance.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        labelDistance.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 1).isActive = true
        labelDistance.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3).isActive = true
        labelDistance.heightAnchor.constraint(equalTo: hoursButton.heightAnchor).isActive = true

        self.view.addSubview(labelCost)
        labelCost.rightAnchor.constraint(equalTo: hoursButton.leftAnchor).isActive = true
        labelCost.leftAnchor.constraint(equalTo: labelDistance.rightAnchor).isActive = true
        labelCost.heightAnchor.constraint(equalTo: hoursButton.heightAnchor).isActive = true
        labelCost.centerYAnchor.constraint(equalTo: hoursButton.centerYAnchor).isActive = true

        self.view.addSubview(saveReservationButton)
        saveReservationButton.rightAnchor.constraint(equalTo: reserveContainer.rightAnchor).isActive = true
        saveReservationButton.bottomAnchor.constraint(equalTo: reserveContainer.bottomAnchor).isActive = true
        saveReservationButton.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true
        saveReservationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let line1 = UIView()
        line1.translatesAutoresizingMaskIntoConstraints = false
        line1.backgroundColor = Theme.OFF_WHITE
        self.view.addSubview(line1)
        line1.bottomAnchor.constraint(equalTo: saveReservationButton.topAnchor).isActive = true
        line1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line1.widthAnchor.constraint(equalTo: reserveContainer.widthAnchor).isActive = true
        line1.leftAnchor.constraint(equalTo: reserveContainer.leftAnchor).isActive = true

        let line2 = UIView()
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.backgroundColor = Theme.OFF_WHITE
        self.view.addSubview(line2)
        line2.bottomAnchor.constraint(equalTo: saveReservationButton.topAnchor).isActive = true
        line2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line2.rightAnchor.constraint(equalTo: hoursButton.leftAnchor).isActive = true

        let line3 = UIView()
        line3.translatesAutoresizingMaskIntoConstraints = false
        line3.backgroundColor = Theme.OFF_WHITE
        self.view.addSubview(line3)
        line3.bottomAnchor.constraint(equalTo: saveReservationButton.topAnchor).isActive = true
        line3.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        line3.leftAnchor.constraint(equalTo: labelDistance.rightAnchor).isActive = true
        
        unavailable.addTarget(self, action: #selector(availabilityPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(unavailable)
        unavailable.centerXAnchor.constraint(equalTo: reserveContainer.centerXAnchor).isActive = true
        unavailable.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        unavailable.widthAnchor.constraint(equalTo: reserveContainer.widthAnchor).isActive = true
        unavailable.bottomAnchor.constraint(equalTo: saveReservationButton.topAnchor, constant: -1).isActive = true
        
    }
    
    var controlTopAnchor1: NSLayoutConstraint!
    var controlTopAnchor2: NSLayoutConstraint!
    var segmentLineLeftAnchor1: NSLayoutConstraint!
    var segmentLineLeftAnchor2: NSLayoutConstraint!
    var segmentLineLeftAnchor3: NSLayoutConstraint!
    
    func setupSegments() {
        
        self.view.addSubview(segmentControlView)
        controlTopAnchor1 = segmentControlView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        controlTopAnchor1.isActive = true
        controlTopAnchor2 = segmentControlView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        controlTopAnchor2.isActive = false
        segmentControlView.widthAnchor.constraint(equalToConstant: self.view.frame.width * 5/6).isActive = true
        segmentControlView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentControlView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.view.addSubview(infoSegment)
        infoSegment.leftAnchor.constraint(equalTo: segmentControlView.leftAnchor).isActive = true
        infoSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        infoSegment.bottomAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        infoSegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
        self.view.addSubview(reviewsSegment)
        reviewsSegment.rightAnchor.constraint(equalTo: segmentControlView.rightAnchor).isActive = true
        reviewsSegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        reviewsSegment.bottomAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        reviewsSegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
        self.view.addSubview(availabilitySegment)
        availabilitySegment.leftAnchor.constraint(equalTo: infoSegment.rightAnchor).isActive = true
        availabilitySegment.topAnchor.constraint(equalTo: segmentControlView.topAnchor).isActive = true
        availabilitySegment.bottomAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        availabilitySegment.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionLine.topAnchor.constraint(equalTo: segmentControlView.bottomAnchor).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: (self.view.frame.width * 5/6) / 3).isActive = true
        segmentLineLeftAnchor1 = selectionLine.leftAnchor.constraint(equalTo: infoSegment.leftAnchor)
        segmentLineLeftAnchor1.isActive = true
        segmentLineLeftAnchor2 = selectionLine.leftAnchor.constraint(equalTo: availabilitySegment.leftAnchor)
        segmentLineLeftAnchor2.isActive = false
        segmentLineLeftAnchor3 = selectionLine.leftAnchor.constraint(equalTo: reviewsSegment.leftAnchor)
        segmentLineLeftAnchor3.isActive = false
        
    }
    
    var infoViewAnchor: NSLayoutConstraint!
    var availabilityViewAnchor: NSLayoutConstraint!
    var reviewsViewAnchor: NSLayoutConstraint!
    
    func setupViewControllers() {
        
        myScrollView.addSubview(infoController.view)
        infoController.didMove(toParentViewController: self)
        infoViewAnchor = infoController.view.leftAnchor.constraint(equalTo: myScrollView.leftAnchor)
        infoViewAnchor.isActive = true
        infoController.view.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        infoController.view.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        infoController.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        myScrollView.addSubview(availabilityController.view)
        availabilityController.didMove(toParentViewController: self)
        availabilityViewAnchor = availabilityController.view.leftAnchor.constraint(equalTo: myScrollView.leftAnchor, constant: self.view.frame.width)
        availabilityViewAnchor.isActive = true
        availabilityController.view.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        availabilityController.view.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        availabilityController.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        myScrollView.addSubview(reviewsController.view)
        reviewsController.didMove(toParentViewController: self)
        reviewsViewAnchor = reviewsController.view.leftAnchor.constraint(equalTo: myScrollView.leftAnchor, constant: (self.view.frame.width) * 2)
        reviewsViewAnchor.isActive = true
        reviewsController.view.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        reviewsController.view.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        reviewsController.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
    }
    
    func spotIsAvailable() {
        unavailable.alpha = 0
    }
    
    func spotIsNotAvailable() {
        unavailable.alpha = 1
    }
    
    @objc func infoPressed(sender: UIButton) {
        myScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 240)
        segmentLineLeftAnchor1.isActive = true
        segmentLineLeftAnchor2.isActive = false
        segmentLineLeftAnchor3.isActive = false
        infoViewAnchor.constant = 0
        availabilityViewAnchor.constant = self.view.frame.width
        reviewsViewAnchor.constant = (self.view.frame.width) * 2
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func availabilityPressed(sender: UIButton) {
        myScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 240)
        segmentLineLeftAnchor1.isActive = false
        segmentLineLeftAnchor2.isActive = true
        segmentLineLeftAnchor3.isActive = false
        infoViewAnchor.constant = -self.view.frame.width
        availabilityViewAnchor.constant = 0
        reviewsViewAnchor.constant = self.view.frame.width
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func reviewPressed(sender: UIButton) {
        myScrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height) * 2)
        segmentLineLeftAnchor1.isActive = false
        segmentLineLeftAnchor2.isActive = false
        segmentLineLeftAnchor3.isActive = true
        infoViewAnchor.constant = -(self.view.frame.width) * 2
        availabilityViewAnchor.constant = -self.view.frame.width
        reviewsViewAnchor.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func saveReservationButtonPressed(sender: UIButton) {

        let product = labelTitle.text
        
        let price = labelCost.text
        let edited = price?.replacingOccurrences(of: "$", with: "")
        let editedPrice = edited?.replacingOccurrences(of: ".", with: "")
        let editedHour = editedPrice?.replacingOccurrences(of: "/hour", with: "")
        let cost: Int = Int(editedHour!)!
        
        let totalCost = cost * hours!
        let checkoutViewController = CheckoutViewController(product: product!,
                                                            price: totalCost,
                                                            hours: hours!,
                                                            ID: ids!,
                                                            account: account!,
                                                            parkingID: parkingIDs!)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(formattedLocation!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let _ = placemarks.first?.location
                else {
                    print("No associated location")
                    return
            }
        }
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
    }
    
    func checkAccount() {
        if let currentUser = Auth.auth().currentUser?.uid {
            let checkRef = Database.database().reference().child("users").child(currentUser)
            checkRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let account = dictionary["accountID"] as? String {
                        self.account = account
                    } else {
                        return
                    }
                }
            }, withCancel: nil)
        }
    }
    
    private var lastContentOffset: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == myScrollView {
            if scrollView.contentOffset.y >= 220 {
                self.controlTopAnchor1.isActive = false
                self.controlTopAnchor2.isActive = true
                UIApplication.shared.statusBarStyle = .default
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            } else {
                UIApplication.shared.statusBarStyle = .lightContent
                self.controlTopAnchor1.isActive = true
                self.controlTopAnchor2.isActive = false
            }
        }
        
//        if scrollView.contentOffset.y >= 220 {
//            let statusHeight = UIApplication.shared.statusBarFrame.height
//            self.parkingViewTopAnchor.constant = scrollView.contentOffset.y - 240 + statusHeight
//            UIApplication.shared.statusBarStyle = .default
//        } else {
//            self.parkingViewTopAnchor.constant = 0
//            UIApplication.shared.statusBarStyle = .lightContent
//        }
//        if scrollView.contentOffset.y >= 220 && scrollView.contentOffset.y <= 260 {
//            let alpha = (scrollView.contentOffset.y - 220) / 20
//            let image = UIImage(named: "Expand")
//            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
//            exitButton.setImage(tintedImage, for: .normal)
//            exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
//            exitButton.tintColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(alpha)
//        } else if scrollView.contentOffset.y < 220 {
//            let image = UIImage(named: "Expand")
//            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
//            exitButton.setImage(tintedImage, for: .normal)
//            exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
//            exitButton.tintColor = Theme.WHITE
//        }
//        if scrollView.contentOffset.y >= 220 && scrollView.contentOffset.y <= 260 {
//            let alpha = (scrollView.contentOffset.y - 220)
//            self.titleLeftAnchor.constant = 4 + alpha
//        } else if scrollView.contentOffset.y > 260 {
//            let image = UIImage(named: "Expand")
//            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
//            exitButton.setImage(tintedImage, for: .normal)
//            exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
//            exitButton.tintColor = Theme.PRIMARY_DARK_COLOR
//        } else {
//            let image = UIImage(named: "Expand")
//            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
//            exitButton.setImage(tintedImage, for: .normal)
//            exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
//            exitButton.tintColor = Theme.WHITE
//        }
    }
    
    @objc func dismissDetails(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        saveReservationButton.alpha = 0.5
        saveReservationButton.isUserInteractionEnabled = false
        UIApplication.shared.statusBarStyle = .lightContent
    }

    let myScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var segmentControlView: UIView = {
        let segmentControlView = UIView()
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.backgroundColor = Theme.OFF_WHITE
        segmentControlView.layer.cornerRadius = 5
        
        return segmentControlView
    }()
    
    var infoSegment: UIButton = {
        let info = UIButton()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = UIColor.clear
        info.setTitle("Info", for: .normal)
        info.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        info.setTitleColor(Theme.DARK_GRAY, for: .normal)
        info.titleLabel?.textAlignment = .center
        info.addTarget(self, action: #selector(infoPressed(sender:)), for: .touchUpInside)
        
        return info
    }()
    
    var availabilitySegment: UIButton = {
        let availability = UIButton()
        availability.translatesAutoresizingMaskIntoConstraints = false
        availability.backgroundColor = UIColor.clear
        availability.setTitle("Availability", for: .normal)
        availability.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        availability.setTitleColor(Theme.DARK_GRAY, for: .normal)
        availability.titleLabel?.textAlignment = .center
        availability.addTarget(self, action: #selector(availabilityPressed(sender:)), for: .touchUpInside)
        
        return availability
    }()
    
    var reviewsSegment: UIButton = {
        let reviews = UIButton()
        reviews.translatesAutoresizingMaskIntoConstraints = false
        reviews.backgroundColor = UIColor.clear
        reviews.setTitle("Reviews", for: .normal)
        reviews.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        reviews.setTitleColor(Theme.DARK_GRAY, for: .normal)
        reviews.titleLabel?.textAlignment = .center
        reviews.addTarget(self, action: #selector(reviewPressed(sender:)), for: .touchUpInside)
        
        return reviews
    }()
    
    var selectionLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.PRIMARY_COLOR
        
        return line
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let parkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "home-4")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let exitButton: UIButton = {
        let exitButton = UIButton()
        let exitImage = UIImage(named: "Expand")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(dismissDetails(sender:)), for: .touchUpInside)
        exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        return exitButton
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = Theme.PRIMARY_COLOR.cgColor
        border.frame = CGRect(x: 0, y: label.frame.size.height - width, width: label.frame.size.width, height: label.frame.size.height)
        border.borderWidth = width
        label.layer.addSublayer(border)
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let labelDistance: UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let labelCost: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Theme.PRIMARY_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let labelReserve: UILabel = {
        let label = UILabel()
        label.text = "Reserve:"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Theme.PRIMARY_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var reserveContainer: UIView = {
        let reserve = UIView()
        reserve.translatesAutoresizingMaskIntoConstraints = false
        reserve.backgroundColor = Theme.WHITE
        reserve.layer.cornerRadius = 5
        reserve.clipsToBounds = false
        
        return reserve
    }()
    
    let fiveStarControl: FiveStarRating = {
        let five = FiveStarRating(frame: CGRect(x: 0, y: 0, width: Int((5 * kStarSize)) + (4 * kSpacing), height: Int(kStarSize)))
        five.translatesAutoresizingMaskIntoConstraints = false
        
        return five
    }()
    
    var hoursButton: dropDownButton = {
       let hours = dropDownButton()
        hours.translatesAutoresizingMaskIntoConstraints = false
        hours.backgroundColor = Theme.WHITE
        hours.setTitleColor(Theme.DARK_GRAY, for: .normal)
        hours.setTitle("^ hours", for: .normal)
        hours.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dropDownOptions = ["1 hour", "2 hours", "3 hours", "4 hours", "5 hours", "6 hours", "7 hours", "8 hours", "9 hours", "10 hours", "11 hours", "12 hours"]
        hours.addTarget(self, action: #selector(hourButtonTouched(sender:)), for: .touchUpInside)
        
        return hours
    }()
    
    var hoursView: UITableView = {
        let hours = UITableView()
        hours.translatesAutoresizingMaskIntoConstraints = false
        return hours
    }()
    
    var saveReservationButton: UIButton = {
        let saveParkingButton = UIButton()
        saveParkingButton.setTitle("Reserve Spot", for: .normal)
        saveParkingButton.setTitle("", for: .selected)
        saveParkingButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        saveParkingButton.backgroundColor = UIColor.clear
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = Theme.PRIMARY_COLOR.cgColor
        border.frame = CGRect(x: 0, y: saveParkingButton.frame.size.height - width, width: saveParkingButton.frame.size.width, height: saveParkingButton.frame.size.height)
        border.borderWidth = width
        saveParkingButton.layer.addSublayer(border)
        saveParkingButton.alpha = 0.5
        saveParkingButton.translatesAutoresizingMaskIntoConstraints = false
        saveParkingButton.addTarget(self, action: #selector(saveReservationButtonPressed(sender:)), for: .touchUpInside)
        saveParkingButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
        saveParkingButton.isUserInteractionEnabled = false
        
        return saveParkingButton
    }()
    
    var isOpen: Bool = false
    
   @objc func hourButtonTouched(sender: dropDownButton) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([height])
            
            if hoursView.contentSize.height > 150 {
                height.constant = 150
            } else {
                height.constant = hoursView.contentSize.height
            }
            
            NSLayoutConstraint.activate([height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.hoursView.layoutIfNeeded()
                self.hoursView.center.y -= self.hoursView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            NSLayoutConstraint.deactivate([height])
            height.constant = 0
            NSLayoutConstraint.activate([height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.hoursView.center.y += self.hoursView.frame.height / 2
                self.hoursView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dropDownPressed(string: String) {
        hoursButton.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([height])
        height.constant = 0
        NSLayoutConstraint.activate([height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.hoursView.center.y += self.hoursView.frame.height / 2
            self.hoursView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = Theme.OFF_WHITE
        cell.textLabel?.textColor = Theme.DARK_GRAY
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownPressed(string: dropDownOptions[indexPath.row])
        hoursView.deselectRow(at: indexPath, animated: true)
        saveReservationButton.isUserInteractionEnabled = true
        saveReservationButton.alpha = 1
        
        let value = dropDownOptions[indexPath.row]
        let integer = value.replacingOccurrences(of: " hours", with: "")
        let integer2 = integer.replacingOccurrences(of: " hour", with: "")
        hours = Int(integer2)
    }
    
}

var height = NSLayoutConstraint()
var dropDownOptions = [String]()

class dropDownButton: UIButton {
    
    var dropView = dropDownView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Theme.OFF_WHITE
        
        dropView = dropDownView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropView.translatesAutoresizingMaskIntoConstraints = false
    
    }
    
    var isOpen: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView {
    var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = Theme.OFF_WHITE
        self.backgroundColor = Theme.OFF_WHITE
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var unavailable: UIButton = {
    let button = UIButton()
    button.backgroundColor = Theme.PRIMARY_COLOR
    button.setTitle("Unavailable currently", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.alpha = 1
    button.clipsToBounds = true
    
    return button
}()






