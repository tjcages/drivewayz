//
//  TestParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

protocol handleTestParking {
    func bookSpotPressed(amount: Double)
}

class ParkingViewController: UIViewController, handleTestParking {
    
    var delegate: handleCheckoutParking?
    var navigationDelegate: handleRouteNavigation?
    var locatorDelegate: handleLocatorButton?
    var parkingDelegate: handleParkingOptions?
    
    let identifier = "cellID"
    let cellHeight: CGFloat = 242
    let cellWidth: CGFloat = phoneWidth
    var selectedParkingSpot: ParkingSpots?
    var parkingSpots: [ParkingSpots] = [] {
        didSet {
            self.selectedParkingSpot = parkingSpots.first
            self.bookingPicker.reloadData()
            delayWithSeconds(animationIn) {
                self.bookingPicker.alpha = 1
                self.loadingPicker.alpha = 0
                self.bookingSliderController.view.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    var bookingLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    var loadingLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var bookingPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: bookingLayout)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor.clear
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(BookingCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        picker.isPagingEnabled = true
        picker.alpha = 0
        
        return picker
    }()
    
    lazy var loadingPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: loadingLayout)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor.clear
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(BookingCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        picker.isPagingEnabled = true
        picker.alpha = 1
        
        return picker
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STRAWBERRY_PINK
        button.setTitle("Book Prime Spot", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var bookingSliderController: BookingSliderViewController = {
        let controller = BookingSliderViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var timeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "time")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var timeLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("2 hours 15 minutes", for: .normal)
        label.setTitleColor(Theme.PRUSSIAN_BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var walkingButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "locationArrow")
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var walkingLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("0.45 miles", for: .normal)
        label.setTitleColor(Theme.PRUSSIAN_BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH5
        label.contentHorizontalAlignment = .right
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingPicker.delegate = self
        bookingPicker.dataSource = self
        loadingPicker.delegate = self
        loadingPicker.dataSource = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 8
        
        setupViews()
        setupCalendar()
    }
    
    func setData(closestParking: [ParkingSpots], cheapestParking: [ParkingSpots], overallDestination: CLLocationCoordinate2D) {

    }
    
    func setupViews() {
        
        self.view.addSubview(mainButton)
        self.view.addSubview(bookingPicker)
        self.view.addSubview(bookingSliderController.view)
        self.view.addSubview(loadingPicker)
        
        bookingPicker.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        bookingPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bookingPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bookingPicker.bottomAnchor.constraint(equalTo: mainButton.topAnchor).isActive = true
        
        loadingPicker.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        loadingPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingPicker.bottomAnchor.constraint(equalTo: mainButton.topAnchor).isActive = true
        
        mainButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -28).isActive = true
        mainButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        bookingSliderController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bookingSliderController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bookingSliderController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bookingSliderController.view.bottomAnchor.constraint(equalTo: bookingPicker.topAnchor).isActive = true
        
    }
    
    func setupCalendar() {
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(timeButton)
        timeLabel.leftAnchor.constraint(equalTo: timeButton.rightAnchor, constant: 10).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        timeLabel.sizeToFit()
        
        timeButton.leftAnchor.constraint(equalTo: mainButton.leftAnchor, constant: 12).isActive = true
        timeButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -16).isActive = true
        timeButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        timeButton.widthAnchor.constraint(equalTo: timeButton.heightAnchor).isActive = true
        
        self.view.addSubview(walkingLabel)
        self.view.addSubview(walkingButton)
        walkingLabel.rightAnchor.constraint(equalTo: mainButton.rightAnchor, constant: -12).isActive = true
        walkingLabel.centerYAnchor.constraint(equalTo: walkingButton.centerYAnchor).isActive = true
        walkingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        walkingLabel.sizeToFit()
        
        walkingButton.rightAnchor.constraint(equalTo: walkingLabel.leftAnchor, constant: -8).isActive = true
        walkingButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -16).isActive = true
        walkingButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        walkingButton.widthAnchor.constraint(equalTo: walkingButton.heightAnchor).isActive = true
        
        self.view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: timeButton.topAnchor, constant: -14).isActive = true
        line.leftAnchor.constraint(equalTo: mainButton.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: mainButton.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func loadBookings() {
        self.bookingPicker.alpha = 0
        self.loadingPicker.alpha = 1
        self.bookingSliderController.view.alpha = 0
        self.view.layoutIfNeeded()
    }
    
    func bookSpotPressed(amount: Double) {

    }
    
    @objc func becomeAHost(sender: UIButton) {
        self.delegate?.becomeAHost()
    }
    
    func changeDates(fromDate: Date, totalTime: String) {
        var timeString = totalTime
        timeString = timeString.replacingOccurrences(of: "hrs", with: "hours")
        timeString = timeString.replacingOccurrences(of: "hr", with: "hour")
        timeString = timeString.replacingOccurrences(of: "min", with: "minutes")
        self.timeLabel.setTitle(timeString, for: .normal)
    }

}


extension ParkingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bookingPicker {
            let contentSize = collectionView.contentSize
            self.bookingSliderController.scrollView.contentSize = contentSize
            if parkingSpots.count > 0 {
                self.bookingPicker.alpha = 1
                self.loadingPicker.alpha = 0
                self.bookingSliderController.view.alpha = 1
                self.view.layoutIfNeeded()
                delayWithSeconds(animationIn) {
                    self.checkPolyline(percentage: 0)
                    self.getCellAtIndex(index: 0)
                }
            }
            return parkingSpots.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! BookingCell
        if collectionView == bookingPicker && parkingSpots.count > indexPath.row {
            cell.endAnimations()
            cell.minimizePrice()
            let parking = parkingSpots[indexPath.row]
            if let secondaryType = parking.secondaryType, let numberSpots = parking.numberSpots, let streetAddress = parking.streetAddress {
                cell.secondaryType = secondaryType
                cell.numberSpots = numberSpots
                cell.streetAddress = streetAddress
            }
            if let totalRating = parking.totalRating, let totalBookings = parking.ParkingReviews?.count {
                let averageRating = Double(totalRating)/Double(totalBookings)
                cell.stars.rating = averageRating
                cell.starLabel.text = "\(totalBookings)"
            } else {
                cell.stars.rating = 5.0
                cell.starLabel.text = "0"
            }
            if let parkingCost = parking.dynamicCost {
                let cost = String(format: "$%.2f/hour", parkingCost)
                cell.price = cost
            }
            if indexPath.row > 2 {
                cell.expandPrice()
            }
        } else {
            cell.beginAnimations()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        self.bookingSliderController.translation = translation
        let percentage = translation/phoneWidth
        if percentage == 0 && self.mainButton.titleLabel?.text != "Book Prime Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Prime Spot", for: .normal)
                    self.bookingSliderController.firstIcon.alpha = 1
                    self.bookingSliderController.firstIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
            }
        } else if percentage == 0 {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.bookingSliderController.firstIcon.alpha = 1
                self.bookingSliderController.firstIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        } else if percentage == 1 && self.mainButton.titleLabel?.text != "Book Economy Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Economy Spot", for: .normal)
                    self.bookingSliderController.secondIcon.alpha = 1
                    self.bookingSliderController.secondIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
            }
        } else if percentage == 1 {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.bookingSliderController.secondIcon.alpha = 1
                self.bookingSliderController.secondIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        } else if percentage == 2 && self.mainButton.titleLabel?.text != "Book Standard Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Standard Spot", for: .normal)
                }, completion: nil)
            }
        }
    }
    
    func getCellAtIndex(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = self.bookingPicker.cellForItem(at: indexPath) as? BookingCell {
            cell.expandPrice()
            if let parking = self.selectedParkingSpot, let distance = parking.parkingDistance {
                if distance > 0 {
                    self.walkingLabel.alpha = 1
                    self.walkingButton.alpha = 1
                    if distance < 650 {
                        let string = String(format: "%.0f ft", round(distance/10)*10)
                        self.walkingButton.alpha = 0
                        UIView.transition(with: self.walkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                            self.walkingLabel.setTitle("", for: .normal)
                        }) { (success) in
                            UIView.transition(with: self.walkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                                self.walkingLabel.setTitle(string, for: .normal)
                                self.walkingButton.alpha = 1
                            }, completion: nil)
                        }
                    } else {
                        let miles = distance/5280
                        let string = "\(miles.rounded(toPlaces: 2)) miles"
                        self.walkingButton.alpha = 0
                        UIView.transition(with: self.walkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                            self.walkingLabel.setTitle("", for: .normal)
                        }) { (success) in
                            UIView.transition(with: self.walkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                                self.walkingLabel.setTitle(string, for: .normal)
                                self.walkingButton.alpha = 1
                            }, completion: nil)
                        }
                    }
                } else {
                    self.walkingLabel.alpha = 0
                    self.walkingButton.alpha = 0
                }
            }
        }
    }
    
    func closeCellAtIndex(index: Int) {
        delayWithSeconds(animationOut) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.bookingPicker.cellForItem(at: indexPath) as? BookingCell {
                cell.minimizePrice()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        let percentage = translation/phoneWidth
        self.checkPolyline(percentage: Int(percentage))
    }
    
    func checkPolyline(percentage: Int) {
        self.selectedParkingSpot = parkingSpots[percentage]
        self.getCellAtIndex(index: percentage)
        self.closeCellAtIndex(index: percentage - 1)
        self.closeCellAtIndex(index: percentage + 1)
        if let latitude = self.selectedParkingSpot?.latitude, let longitude = self.selectedParkingSpot?.longitude {
            let location = CLLocation(latitude: latitude , longitude: longitude )
            self.parkingDelegate?.drawHostPolyline(fromLocation: location)
        }
    }
    
}

