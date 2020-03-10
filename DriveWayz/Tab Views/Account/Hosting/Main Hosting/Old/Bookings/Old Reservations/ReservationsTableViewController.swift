//
//  ReservationsTableViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos
//import Mapbox
import FirebaseDatabase

class ReservationsTableViewController: UIViewController {
    
//    var delegate: handlePreviousBookings?
    
    let cellHeight: CGFloat = 202
    var parkingSpot: ParkingSpots?
    var bookingIDs: [String] = []
    var previousBookings: [Bookings] = [] {
        didSet {
            for arrayIndex in stride(from: self.previousBookings.count - 1, through: 0, by: -1) {
                self.previousBookingsReversed.append(self.previousBookings[arrayIndex])
            }
        }
    }
    var upcomingBookings: [Bookings] = [] {
        didSet {
            for arrayIndex in stride(from: self.upcomingBookings.count - 1, through: 0, by: -1) {
                self.upcomingBookingsReversed.append(self.upcomingBookings[arrayIndex])
            }
        }
    }
    var previousBookingsReversed: [Bookings] = []
    var upcomingBookingsReversed: [Bookings] = []
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        
        return button
    }()

    var reservationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "History"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var upcomingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upcoming"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH1
        label.alpha = 0.4
        
        return label
    }()
    
    var selectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN
        view.layer.cornerRadius = 1.5
        
        return view
    }()
    
    var backgroundCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BACKGROUND_GRAY
        view.layer.borderColor = Theme.GRAY_WHITE.withAlphaComponent(0.05).cgColor
        view.layer.borderWidth = 80
        view.layer.cornerRadius = 180
        
        return view
    }()
    
    var horizontalScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = false
        
        return view
    }()
    
    var reservationsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = UIColor.clear
        view.register(ReservationsView.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        view.contentOffset = CGPoint.zero
        view.decelerationRate = .fast
        view.clipsToBounds = true
        
        return view
    }()
    
    var upcomingTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = UIColor.clear
        view.register(ReservationsView.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        view.contentOffset = CGPoint.zero
        view.decelerationRate = .fast
        view.clipsToBounds = true
        
        return view
    }()
    
    var noHistoryParking: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have no previous bookings"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        label.sizeToFit()
        
        return view
    }()
    
    var noUpcomingParking: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 4
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have no upcoming bookings"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        label.sizeToFit()
        
        return view
    }()
    
    func setData(parking: ParkingSpots) {
        self.parkingSpot = parking
        if let parkingID = parking.parkingID {
            self.previousBookings = []
            self.upcomingBookings = []
            self.bookingIDs = []
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID).child("Bookings")
            ref.observe(.childAdded) { (snapshot) in
                let bookings = snapshot.key
                let bookingRef = Database.database().reference().child("UserBookings").child(bookings)
                bookingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        if !self.bookingIDs.contains(bookings) {
                            let singleBooking = Bookings(dictionary: dictionary)
                            let date = Date().timeIntervalSince1970
                            if let fromDate = singleBooking.fromDate, fromDate > date {
                                self.upcomingBookings.append(singleBooking)
                                self.bookingIDs.append(bookings)
                            } else {
                                self.previousBookings.append(singleBooking)
                                self.bookingIDs.append(bookings)
                            }
                            self.reservationsTableView.reloadData()
                            self.upcomingTableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = false

        horizontalScrollView.delegate = self
        reservationsTableView.delegate = self
        reservationsTableView.dataSource = self
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        setupViews()
    }
    
    var reservationsLabelCenterAnchor: NSLayoutConstraint!
    var reservationsWidth: CGFloat = 0.0

    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
        }
        
        self.view.addSubview(backgroundCircle)
        backgroundCircle.centerXAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        backgroundCircle.widthAnchor.constraint(equalToConstant: 360).isActive = true
        backgroundCircle.heightAnchor.constraint(equalTo: backgroundCircle.widthAnchor).isActive = true
        
        self.view.addSubview(horizontalScrollView)
        self.view.bringSubviewToFront(gradientContainer)
        horizontalScrollView.contentSize = CGSize(width: phoneWidth * 2, height: self.view.frame.height)
        horizontalScrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        horizontalScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        horizontalScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        horizontalScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        horizontalScrollView.addSubview(noHistoryParking)
        horizontalScrollView.addSubview(reservationsTableView)
        reservationsTableView.leftAnchor.constraint(equalTo: horizontalScrollView.leftAnchor).isActive = true
        reservationsTableView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 12).isActive = true
        reservationsTableView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        reservationsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80).isActive = true
        
        noHistoryParking.topAnchor.constraint(equalTo: reservationsTableView.topAnchor, constant: 6).isActive = true
        noHistoryParking.widthAnchor.constraint(equalTo: reservationsTableView.widthAnchor, constant: -24).isActive = true
        noHistoryParking.heightAnchor.constraint(equalToConstant: 85).isActive = true
        noHistoryParking.centerXAnchor.constraint(equalTo: reservationsTableView.centerXAnchor).isActive = true
        
        horizontalScrollView.addSubview(noUpcomingParking)
        horizontalScrollView.addSubview(upcomingTableView)
        upcomingTableView.leftAnchor.constraint(equalTo: reservationsTableView.rightAnchor).isActive = true
        upcomingTableView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 12).isActive = true
        upcomingTableView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        upcomingTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80).isActive = true
        
        noUpcomingParking.topAnchor.constraint(equalTo: upcomingTableView.topAnchor, constant: 6).isActive = true
        noUpcomingParking.widthAnchor.constraint(equalTo: upcomingTableView.widthAnchor, constant: -24).isActive = true
        noUpcomingParking.heightAnchor.constraint(equalToConstant: 85).isActive = true
        noUpcomingParking.centerXAnchor.constraint(equalTo: upcomingTableView.centerXAnchor).isActive = true
        
        self.view.addSubview(reservationsLabel)
        reservationsWidth = (reservationsLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPBoldH1))!
        reservationsLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -24).isActive = true
        reservationsLabelCenterAnchor = reservationsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24)
        reservationsLabelCenterAnchor.isActive = true
        reservationsLabel.widthAnchor.constraint(equalToConstant: reservationsWidth).isActive = true
        reservationsLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        self.view.addSubview(upcomingLabel)
        upcomingLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -24).isActive = true
        upcomingLabel.leftAnchor.constraint(equalTo: reservationsLabel.rightAnchor, constant: 62).isActive = true
        upcomingLabel.widthAnchor.constraint(equalToConstant: (upcomingLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPBoldH1))!).isActive = true
        upcomingLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        selectionLine.topAnchor.constraint(equalTo: reservationsLabel.bottomAnchor, constant: 6).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
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

}

extension ReservationsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let parking = self.parkingSpot else { return }
        if tableView == self.upcomingTableView {
            if self.upcomingBookings.count > indexPath.row {
                let booking = self.upcomingBookings[indexPath.row]
//                self.delegate?.hostingPreviousPressed(booking: booking, parking: parking)
            }
        } else {
            if self.previousBookings.count > indexPath.row {
                let booking = self.previousBookings[indexPath.row]
//                self.delegate?.hostingPreviousPressed(booking: booking, parking: parking)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.upcomingTableView {
            if self.upcomingBookings.count == 0 {
                self.noUpcomingParking.alpha = 1
            } else {
                self.noUpcomingParking.alpha = 0
            }
            return self.upcomingBookings.count
        } else {
            if self.previousBookings.count == 0 {
                self.noHistoryParking.alpha = 1
            } else {
                self.noHistoryParking.alpha = 0
            }
            return self.previousBookings.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? ReservationsView {
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            if self.previousBookingsReversed.count > indexPath.row {
                let booking = self.previousBookingsReversed[indexPath.row]
                if let userName = booking.userName, let userDuration = booking.userDuration, let userProfileURL = booking.userProfileURL, let userRating = booking.userRating, let parkingLong = booking.parkingLong, let parkingLat = booking.parkingLat, let fromInterval = booking.fromDate {
//                    if let hours = booking.hours, let price = booking.price {
//                        cell.paymentAmount.text = String(format:"$%.02f", hours * price * 0.75)
//                    }
//                    cell.stars.rating = userRating
//                    cell.starsLabel.text = "\(userRating)"
//                    let nameArray = userName.split(separator: " ")
//                    cell.userName.text = String(nameArray[0])
//
//                    let fromDate = Date(timeIntervalSince1970: fromInterval)
//                    if fromInterval < Date().addingTimeInterval(604800).timeIntervalSince1970 {
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "EEEE d, "
//                        let dateString = dateFormatter.string(from: fromDate)
//                        cell.dateLabel.text = dateString + userDuration
//                    } else {
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "MMM d, "
//                        let dateString = dateFormatter.string(from: fromDate)
//                        cell.dateLabel.text = dateString + userDuration
//                    }
//
//                    if userProfileURL == "" {
//                        cell.profileImageView.image = UIImage(named: "background4")
//                    } else {
//                        cell.profileImageView.loadImageUsingCacheWithUrlString(userProfileURL) { (bool) in
//                            if !bool {
//                                cell.profileImageView.image = UIImage(named: "background4")
//                            }
//                        }
//                    }
//                    let parkingLocation = CLLocationCoordinate2D(latitude: parkingLat, longitude: parkingLong)
//                    cell.mapView.setCenter(parkingLocation, zoomLevel: 16, animated: false)
//                    let annotation = MGLPointAnnotation()
//                    annotation.coordinate = parkingLocation
//                    cell.mapView.addAnnotation(annotation)
                }
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            let translation = scrollView.contentOffset.x
            var percentage = translation/phoneWidth
            if percentage >= 0 && percentage <= 0.9 {
                percentage = percentage/0.9
                self.reservationsLabel.alpha = 1 - 0.4 * percentage
                self.upcomingLabel.alpha = 0.4 + 0.6 * percentage
                self.reservationsLabelCenterAnchor.constant = 24 - (self.reservationsWidth + 64) * percentage
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
