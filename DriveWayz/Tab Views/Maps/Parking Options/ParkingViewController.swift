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
    
    var primeParking: ParkingSpots?
    var bestPriceParking: ParkingSpots?
    var standardParking: ParkingSpots?
    var selectedPrice: Double = 1.5
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
//        view.isPagingEnabled = true
        view.backgroundColor = Theme.WHITE
        view.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 18)
        
        return view
    }()
    
    lazy var primeController: ParkingOptionViewController = {
        let controller = ParkingOptionViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var bestPriceController: ParkingOptionViewController = {
        let controller = ParkingOptionViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    lazy var standardController: ParkingOptionViewController = {
        let controller = ParkingOptionViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var blankView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var noParkingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.text = "There's no parking in this area"
        
        return label
    }()
    
    var contributeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.text = "Help contribute to your parking community by becoming a host today"
        label.numberOfLines = 2
        
        return label
    }()
    
    var noParkingGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "noParkingGraphic")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    var becomeAHostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Become a host", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPRegularH2
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(becomeAHost(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var primeLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.setTitle("Prime spot", for: .normal)
        label.titleLabel?.font = Fonts.SSPBoldH2
        label.backgroundColor = UIColor.clear
        label.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 12, right: 4)
        label.layer.cornerRadius = 4
        
        return label
    }()
    
    var bestPriceLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.setTitle("Best price", for: .normal)
        label.titleLabel?.font = Fonts.SSPBoldH2
        label.backgroundColor = UIColor.clear
        label.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 12, right: 4)
        label.layer.cornerRadius = 4
        label.alpha = 0.2
        
        return label
    }()
    
    var standardLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.setTitle("Standard spot", for: .normal)
        label.titleLabel?.font = Fonts.SSPBoldH2
        label.backgroundColor = UIColor.clear
        label.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 12, right: 4)
        label.layer.cornerRadius = 4
        label.alpha = 0.2
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupNoParking()
        setupViews()
        setupLabels()
    }
    
    func setData(closestParking: [ParkingSpots], cheapestParking: [ParkingSpots], overallDestination: CLLocationCoordinate2D) {
        var parkingClosest: ParkingSpots? = nil
        var parkingCheapest: ParkingSpots? = nil
        var parkingStandard: ParkingSpots? = nil
        if let parking = closestParking.first, let latitude = parking.latitude, let longitude = parking.longitude, let state = parking.stateAddress, let city = parking.cityAddress {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
            dynamicPricing.getDynamicPricing(place: location, state: state, city: city, overallDestination: overallDestination) { (dynamicPrice: CGFloat) in
                if let parking = parkingClosest { self.primeController.configureDynamicParking(parking: parking, overallDestination: overallDestination); self.primeParking = parking}
                if let parking = parkingCheapest { self.bestPriceController.configureDynamicParking(parking: parking, overallDestination: overallDestination); self.bestPriceParking = parking }
                if let parking = parkingStandard { self.standardController.configureDynamicParking(parking: parking, overallDestination: overallDestination); self.standardParking = parking }
            }
        }
        DispatchQueue.main.async {
            self.primeLabel.setTitle("Prime spot", for: .normal)
            self.scrollView.contentSize = CGSize(width: (phoneWidth - 72) * 3, height: self.view.frame.height)
            self.bookingFound()
            let closest = closestParking.sorted(by: { $0.parkingDistance! > $1.parkingDistance! })
            if let pClosest = closest.last {
                parkingClosest = pClosest
//                self.bookSpotButton.setTitle("BOOK SPOT", for: .normal)
                self.primeController.setData(parking: pClosest)
                let parkingArray = cheapestParking.filter { $0 != parkingClosest }
                let cheapest = parkingArray.sorted(by: { $0.parkingCost! > $1.parkingCost! })
                if let pCheapest = cheapest.last {
                    parkingCheapest = pCheapest
                    self.bestPriceController.setData(parking: pCheapest)
                    if let pStandard = closest.dropLast().last {
                        parkingStandard = pStandard
                        self.standardController.setData(parking: pStandard)
                        self.scrollView.contentSize = CGSize(width: (phoneWidth - 72) * 3, height: self.view.frame.height)
                        self.primeController.view.alpha = 1
                        self.primeLabel.isHidden = false
                        self.bestPriceController.view.alpha = 1
                        self.bestPriceLabel.isHidden = false
                        self.standardController.view.alpha = 1
                        self.standardLabel.isHidden = false
                    } else {
                        self.scrollView.contentSize = CGSize(width: (phoneWidth - 72) * 2, height: self.view.frame.height)
                        self.primeController.view.alpha = 1
                        self.primeLabel.isHidden = false
                        self.bestPriceController.view.alpha = 1
                        self.bestPriceLabel.isHidden = false
                        self.standardController.view.alpha = 0
                        self.standardLabel.isHidden = true
                    }
                } else {
                    self.scrollView.contentSize = CGSize(width: (phoneWidth - 72) * 1, height: self.view.frame.height)
                    self.primeController.view.alpha = 1
                    self.primeLabel.isHidden = false
                    self.bestPriceController.view.alpha = 0
                    self.bestPriceLabel.isHidden = true
                    self.standardController.view.alpha = 0
                    self.standardLabel.isHidden = true
                }
            } else {
                self.noBookingFound()
                self.scrollView.contentSize = CGSize(width: (phoneWidth - 72) * 1, height: self.view.frame.height)
                self.primeController.view.alpha = 0
                self.primeLabel.isHidden = true
                self.standardController.view.alpha = 0
                self.standardLabel.isHidden = true
                self.bestPriceController.view.alpha = 0
                self.bestPriceLabel.isHidden = true
//                self.bookSpotButton.setTitle("BECOME A HOST", for: .normal)
                self.locatorDelegate?.locatorButtonPressed()
            }
        }
    }
    
    func setupNoParking() {
        
        self.view.addSubview(blankView)
        blankView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blankView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blankView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        blankView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        blankView.addSubview(noParkingLabel)
        noParkingLabel.leftAnchor.constraint(equalTo: blankView.leftAnchor, constant: 24).isActive = true
        noParkingLabel.rightAnchor.constraint(equalTo: blankView.rightAnchor, constant: -24).isActive = true
        noParkingLabel.topAnchor.constraint(equalTo: blankView.topAnchor, constant: 18).isActive = true
        noParkingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        blankView.addSubview(contributeLabel)
        contributeLabel.leftAnchor.constraint(equalTo: blankView.leftAnchor, constant: 24).isActive = true
        contributeLabel.rightAnchor.constraint(equalTo: blankView.rightAnchor, constant: -24).isActive = true
        contributeLabel.topAnchor.constraint(equalTo: noParkingLabel.bottomAnchor, constant: -8).isActive = true
        contributeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        blankView.addSubview(noParkingGraphic)
        noParkingGraphic.centerXAnchor.constraint(equalTo: blankView.centerXAnchor).isActive = true
        noParkingGraphic.topAnchor.constraint(equalTo: contributeLabel.bottomAnchor, constant: -12).isActive = true
        noParkingGraphic.widthAnchor.constraint(equalToConstant: 200).isActive = true
        noParkingGraphic.heightAnchor.constraint(equalTo: noParkingGraphic.widthAnchor).isActive = true
        
        blankView.addSubview(becomeAHostButton)
        becomeAHostButton.leftAnchor.constraint(equalTo: blankView.leftAnchor, constant: 24).isActive = true
        becomeAHostButton.rightAnchor.constraint(equalTo: blankView.rightAnchor, constant: -24).isActive = true
        becomeAHostButton.bottomAnchor.constraint(equalTo: blankView.bottomAnchor, constant: -36).isActive = true
        becomeAHostButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: (phoneWidth - 72) * 3, height: self.view.frame.height)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(primeController.view)
        primeController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        primeController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        primeController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        primeController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -72).isActive = true
        
        scrollView.addSubview(bestPriceController.view)
        bestPriceController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bestPriceController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bestPriceController.view.leftAnchor.constraint(equalTo: primeController.view.rightAnchor, constant: 6).isActive = true
        bestPriceController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -72).isActive = true
        
        scrollView.addSubview(standardController.view)
        standardController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        standardController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        standardController.view.leftAnchor.constraint(equalTo: bestPriceController.view.rightAnchor, constant: 6).isActive = true
        standardController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -72).isActive = true
     
        let primeTap = UITapGestureRecognizer(target: self, action: #selector(expandPrimeSpot))
        primeController.view.addGestureRecognizer(primeTap)
        let bestPriceTap = UITapGestureRecognizer(target: self, action: #selector(expandBestPriceSpot))
        bestPriceController.view.addGestureRecognizer(bestPriceTap)
        let standardTap = UITapGestureRecognizer(target: self, action: #selector(expandStandardSpot))
        standardController.view.addGestureRecognizer(standardTap)
        
    }
    
    @objc func expandPrimeSpot() {
        if let parking = self.primeParking, let price = primeController.priceLabel.text {
            self.delegate?.didTapParking(parking: parking, price: price)
        }
    }
    
    @objc func expandBestPriceSpot() {
        if let parking = self.bestPriceParking, let price = bestPriceController.priceLabel.text {
            self.delegate?.didTapParking(parking: parking, price: price)
        }
    }
    
    @objc func expandStandardSpot() {
        if let parking = self.standardParking, let price = standardController.priceLabel.text {
            self.delegate?.didTapParking(parking: parking, price: price)
        }
    }
    
    func setupLabels() {
        
        scrollView.addSubview(primeLabel)
        primeLabel.leftAnchor.constraint(equalTo: primeController.view.leftAnchor).isActive = true
        primeLabel.bottomAnchor.constraint(equalTo: primeController.view.topAnchor, constant: 64).isActive = true
        primeLabel.widthAnchor.constraint(equalToConstant: (primeLabel.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPBoldH1))! + 8).isActive = true
        primeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(bestPriceLabel)
        bestPriceLabel.leftAnchor.constraint(equalTo: bestPriceController.view.leftAnchor).isActive = true
        bestPriceLabel.bottomAnchor.constraint(equalTo: bestPriceController.view.topAnchor, constant: 64).isActive = true
        bestPriceLabel.widthAnchor.constraint(equalToConstant: (bestPriceLabel.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPBoldH1))! + 8).isActive = true
        bestPriceLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(standardLabel)
        standardLabel.leftAnchor.constraint(equalTo: standardController.view.leftAnchor).isActive = true
        standardLabel.bottomAnchor.constraint(equalTo: standardController.view.topAnchor, constant: 64).isActive = true
        standardLabel.widthAnchor.constraint(equalToConstant: (standardLabel.titleLabel?.text?.width(withConstrainedHeight: 40, font: Fonts.SSPBoldH1))! + 8).isActive = true
        standardLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func bookSpotPressed(amount: Double) {
        self.selectedPrice = amount
        self.delegate?.bookSpotPressed(amount: amount)
        if self.primeLabel.alpha == 1 {
            finalWalkingRoute = firstWalkingRoute
            finalParkingRoute = firstParkingRoute
            finalPolyline = firstPolyline
            finalPickupCoordinate = firstPickupCoordinate
            finalDestinationCoordinate = firstDestinationCoordinate
            finalDriveTime = firstDriveTime
            destinationFinalCoordinates = destinationFirstCoordinates
            finalPurchaseMapView = firstPurchaseMapView
            finalMapView = firstMapView
            FinalAnnotationLocation = FirstAnnotationLocation
        } else if self.bestPriceLabel.alpha == 1 {
            finalWalkingRoute = secondWalkingRoute
            finalParkingRoute = secondParkingRoute
            finalPolyline = secondPolyline
            finalPickupCoordinate = secondPickupCoordinate
            finalDestinationCoordinate = secondDestinationCoordinate
            finalDriveTime = secondDriveTime
            destinationFinalCoordinates = destinationSecondCoordinates
            finalPurchaseMapView = secondPurchaseMapView
            finalMapView = secondMapView
            FinalAnnotationLocation = SecondAnnotationLocation
        } else if self.standardLabel.alpha == 1 {
            finalWalkingRoute = thirdWalkingRoute
            finalParkingRoute = thirdParkingRoute
            finalPolyline = thirdPolyline
            finalPickupCoordinate = thirdPickupCoordinate
            finalDestinationCoordinate = thirdDestinationCoordinate
            finalDriveTime = thirdDriveTime
            destinationFinalCoordinates = destinationThirdCoordinates
            finalPurchaseMapView = thirdPurchaseMapView
            finalMapView = thirdMapView
            FinalAnnotationLocation = ThirdAnnotationLocation
        }
    }
    
    func noBookingFound() {
        self.scrollView.alpha = 0
        self.blankView.alpha = 1
    }
    
    func bookingFound() {
        self.scrollView.alpha = 1
        self.blankView.alpha = 0
    }
    
    @objc func becomeAHost(sender: UIButton) {
        self.delegate?.becomeAHost()
    }

}


extension ParkingViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // Calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        if indexOfMajorCell == 0 {
            UIView.animate(withDuration: animationIn) {
                self.primeLabel.alpha = 1
                self.bestPriceLabel.alpha = 0.2
                self.standardLabel.alpha = 0.2
            }
            self.parkingDelegate?.applyFirstPolyline()
        } else if indexOfMajorCell == 1 {
            UIView.animate(withDuration: animationIn) {
                self.primeLabel.alpha = 0.2
                self.bestPriceLabel.alpha = 1
                self.standardLabel.alpha = 0.2
            }
            self.parkingDelegate?.applySecondPolyline()
        } else if indexOfMajorCell == 2 {
            UIView.animate(withDuration: animationIn) {
                self.primeLabel.alpha = 0.2
                self.bestPriceLabel.alpha = 0.2
                self.standardLabel.alpha = 1
            }
            self.parkingDelegate?.applyThirdPolyline()
        }
        let width = phoneWidth - 72
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(indexOfMajorCell) * width, y: 0), animated: true)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = phoneWidth - 124
        let proportionalOffset = self.scrollView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(2, index))
        
        return safeIndex
    }
    
}
