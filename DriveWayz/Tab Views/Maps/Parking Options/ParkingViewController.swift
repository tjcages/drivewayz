//
//  ParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

protocol handleParkingImages {
    func setBestPriceImage(imageString: String)
    func setStandardImage(imageString: String)
    func setPrimeImage(imageString: String)
}

class ParkingViewController: UIViewController, handleParkingImages {
    
    var delegate: handleCheckoutParking?
    var navigationDelegate: handleRouteNavigation?
    var locatorDelegate: handleLocatorButton?
    var parkingDelegate: handleParkingOptions?
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var blankView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var primeSpotController: PrimeSpotViewController = {
        let controller = PrimeSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var standardSpotController: StandardSpotViewController = {
        let controller = StandardSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var bestPriceController: BestPriceViewController = {
        let controller = BestPriceViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    var primeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.textAlignment = .center
        label.text = "Prime spot"
        label.font = Fonts.SSPRegularH3
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var primeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
//        view.layer.cornerRadius = 60
        let image = UIImage(named: "background1")
        view.image = image
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var primeClearView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.8
        view.clipsToBounds = false
        
        return view
    }()
    
    var bestPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.text = "Best price"
        label.font = Fonts.SSPRegularH3
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        label.isUserInteractionEnabled = true

        return label
    }()
    
    var bestPriceImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
//        view.layer.cornerRadius = 60
        let image = UIImage(named: "background1")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        var transformation = CGAffineTransform.identity
        transformation = transformation.scaledBy(x: 0.5, y: 0.5)
        transformation = transformation.translatedBy(x: 0, y: 20)
        
        view.transform = transformation
        view.alpha = 0.5
        view.isUserInteractionEnabled = true
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0
        
        return view
    }()
    
    var bestClearView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0
        view.clipsToBounds = false
        
        var transformation = CGAffineTransform.identity
        transformation = transformation.scaledBy(x: 0.5, y: 0.5)
        transformation = transformation.translatedBy(x: 0, y: 20)
        
        view.transform = transformation
        
        return view
    }()
    
    var standardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.text = "Standard spot"
        label.font = Fonts.SSPRegularH3
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var standardImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
//        view.layer.cornerRadius = 60
        let image = UIImage(named: "background1")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        var transformation = CGAffineTransform.identity
        transformation = transformation.scaledBy(x: 0.5, y: 0.5)
        transformation = transformation.translatedBy(x: 0, y: 20)
        
        view.transform = transformation
        view.alpha = 0.5
        view.isUserInteractionEnabled = true
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0
        
        return view
    }()
    
    var standardClearView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0
        view.clipsToBounds = false
        
        var transformation = CGAffineTransform.identity
        transformation = transformation.scaledBy(x: 0.5, y: 0.5)
        transformation = transformation.translatedBy(x: 0, y: 20)
        
        view.transform = transformation
        
        return view
    }()
    
    lazy var bookSpotButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("BOOK SPOT", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.WHITE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(bookSpotPressed(sender:)), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
        return button
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        scrollView.delegate = self
        
        setupNoParking()
        setupViews()
        setupPrime()
        setupBestPrice()
        setupStandard()
        setupControllers()
    }
    
    func setData(closestParking: [ParkingSpots], cheapestParking: [ParkingSpots], overallDestination: CLLocationCoordinate2D) {
        var parkingClosest: ParkingSpots? = nil
        var parkingCheapest: ParkingSpots? = nil
        var parkingStandard: ParkingSpots? = nil
        if let parking = closestParking.first, let latitude = parking.latitude, let longitude = parking.longitude, let state = parking.stateAddress, let city = parking.cityAddress {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
            dynamicPricing.getDynamicPricing(place: location, state: state, city: city, overallDestination: overallDestination) { (dynamicPrice: CGFloat) in
                if let parking = parkingClosest { self.primeSpotController.configureDynamicParking(parking: parking, overallDestination: overallDestination) }
                if let parking = parkingCheapest { self.bestPriceController.configureDynamicParking(parking: parking, overallDestination: overallDestination) }
                if let parking = parkingStandard { self.standardSpotController.configureDynamicParking(parking: parking, overallDestination: overallDestination) }
            }
        }
        DispatchQueue.main.async {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: 320)
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: false)
            self.normalAnnotations()
            let closest = closestParking.sorted(by: { $0.parkingDistance! > $1.parkingDistance! })
            if let pClosest = closest.last {
                parkingClosest = pClosest
                self.primeLabel.alpha = 1
                self.bestPriceLabel.alpha = 1
                self.standardLabel.alpha = 1
                self.bookSpotButton.setTitle("BOOK SPOT", for: .normal)
                self.primeSpotController.setData(parking: pClosest)
                let parkingArray = cheapestParking.filter { $0 != parkingClosest }
                let cheapest = parkingArray.sorted(by: { $0.parkingCost! > $1.parkingCost! })
                if let pCheapest = cheapest.last {
                    parkingCheapest = pCheapest
                    self.bestPriceController.setData(parking: pCheapest)
                    if let pStandard = closest.dropLast().last {
                        parkingStandard = pStandard
                        self.standardSpotController.setData(parking: pStandard)
                        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: 320)
                        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: false)
                    } else {
                        self.standardLabel.alpha = 0
                        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: 320)
                        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: false)
                    }
                } else {
                    self.bestPriceLabel.alpha = 0
                    self.standardLabel.alpha = 0
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: 320)
                    self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: false)
                }
            } else {
                self.primeLabel.alpha = 0
                self.bestPriceLabel.alpha = 0
                self.standardLabel.alpha = 0
                self.noBookingFound()
                self.scrollView.contentSize = CGSize(width: self.view.frame.width * 1, height: 320)
                self.bookSpotButton.setTitle("BECOME A HOST", for: .normal)
                self.locatorDelegate?.locatorButtonPressed()
            }
        }
    }
    
    var spotLabelAnchor: NSLayoutConstraint!
    var scrollViewTopAnchor: NSLayoutConstraint!
    
    var bestPriceWidth: CGFloat = 0
    var primeWidth: CGFloat = 0
    var standardWidth: CGFloat = 0
    
    func setupNoParking() {
        
        self.view.addSubview(blankView)
        scrollViewTopAnchor = blankView.topAnchor.constraint(equalTo: self.view.topAnchor)
            scrollViewTopAnchor.isActive = true
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
        
    }
    
    func setupViews() {
        
        self.primeWidth = (self.primeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        self.bestPriceWidth = (self.bestPriceLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        self.standardWidth = (self.standardLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: 320)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(bookSpotButton)
        bookSpotButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bookSpotButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bookSpotButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            bookSpotButton.heightAnchor.constraint(equalToConstant: 62).isActive = true
            let background = CAGradientLayer().purpleColor()
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62)
            background.zPosition = -10
            bookSpotButton.layer.addSublayer(background)
        case .iphoneX:
            bookSpotButton.heightAnchor.constraint(equalToConstant: 82).isActive = true
            let background = CAGradientLayer().purpleColor()
            background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 82)
            background.zPosition = -10
            bookSpotButton.layer.addSublayer(background)
        }
    }
    
    func setupPrime() {
        
        scrollView.addSubview(primeImageView)
        scrollView.addSubview(primeLabel)
        scrollView.addSubview(primeClearView)
        
        primeImageView.topAnchor.constraint(equalTo: primeLabel.bottomAnchor, constant: 6).isActive = true
        spotLabelAnchor = primeImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        spotLabelAnchor.isActive = true
        primeImageView.heightAnchor.constraint(equalToConstant: 126).isActive = true
        primeImageView.widthAnchor.constraint(equalTo: primeImageView.heightAnchor, multiplier: 1.6).isActive = true
        let primeTap = UITapGestureRecognizer(target: self, action: #selector(primeLabelTapped))
        primeImageView.addGestureRecognizer(primeTap)
        
        primeClearView.topAnchor.constraint(equalTo: primeImageView.topAnchor).isActive = true
        primeClearView.leftAnchor.constraint(equalTo: primeImageView.leftAnchor).isActive = true
        primeClearView.rightAnchor.constraint(equalTo: primeImageView.rightAnchor).isActive = true
        primeClearView.bottomAnchor.constraint(equalTo: primeImageView.bottomAnchor).isActive = true
        
        primeLabel.centerXAnchor.constraint(equalTo: primeImageView.centerXAnchor).isActive = true
        primeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        primeLabel.widthAnchor.constraint(equalToConstant: primeWidth).isActive = true
        primeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let primeLabelTap = UITapGestureRecognizer(target: self, action: #selector(primeLabelTapped))
        primeLabel.addGestureRecognizer(primeLabelTap)
        
    }
    
    func setupBestPrice() {
        
        scrollView.addSubview(bestClearView)
        scrollView.addSubview(bestPriceImageView)
        scrollView.addSubview(bestPriceLabel)
        
        bestPriceImageView.topAnchor.constraint(equalTo: bestPriceLabel.bottomAnchor, constant: 6).isActive = true
        bestPriceImageView.centerXAnchor.constraint(equalTo: primeImageView.centerXAnchor, constant: -self.view.frame.width/2 + 40).isActive = true
        bestPriceImageView.heightAnchor.constraint(equalToConstant: 126).isActive = true
        bestPriceImageView.widthAnchor.constraint(equalTo: primeImageView.heightAnchor, multiplier: 1.6).isActive = true
        
        bestClearView.topAnchor.constraint(equalTo: bestPriceImageView.topAnchor).isActive = true
        bestClearView.leftAnchor.constraint(equalTo: bestPriceImageView.leftAnchor).isActive = true
        bestClearView.rightAnchor.constraint(equalTo: bestPriceImageView.rightAnchor).isActive = true
        bestClearView.bottomAnchor.constraint(equalTo: bestPriceImageView.bottomAnchor).isActive = true
        let bestPriceTap = UITapGestureRecognizer(target: self, action: #selector(bestPriceLabelTapped))
        bestPriceImageView.addGestureRecognizer(bestPriceTap)
        
        bestPriceLabel.centerXAnchor.constraint(equalTo: bestPriceImageView.centerXAnchor).isActive = true
        bestPriceLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        bestPriceLabel.widthAnchor.constraint(equalToConstant: bestPriceWidth).isActive = true
        bestPriceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let bestPriceLabelTap = UITapGestureRecognizer(target: self, action: #selector(bestPriceLabelTapped))
        bestPriceLabel.addGestureRecognizer(bestPriceLabelTap)
        
    }
    
    func setupStandard() {
        
        scrollView.addSubview(standardClearView)
        scrollView.addSubview(standardImageView)
        scrollView.addSubview(standardLabel)
        
        standardImageView.topAnchor.constraint(equalTo: standardLabel.bottomAnchor, constant: 6).isActive = true
        standardImageView.centerXAnchor.constraint(equalTo: primeImageView.centerXAnchor, constant: self.view.frame.width/2 - 40).isActive = true
        standardImageView.heightAnchor.constraint(equalToConstant: 126).isActive = true
        standardImageView.widthAnchor.constraint(equalTo: primeImageView.heightAnchor, multiplier: 1.6).isActive = true
        let standardTap = UITapGestureRecognizer(target: self, action: #selector(standardLabelTapped))
        standardImageView.addGestureRecognizer(standardTap)
        
        standardClearView.topAnchor.constraint(equalTo: standardImageView.topAnchor).isActive = true
        standardClearView.leftAnchor.constraint(equalTo: standardImageView.leftAnchor).isActive = true
        standardClearView.rightAnchor.constraint(equalTo: standardImageView.rightAnchor).isActive = true
        standardClearView.bottomAnchor.constraint(equalTo: standardImageView.bottomAnchor).isActive = true
        
        standardLabel.centerXAnchor.constraint(equalTo: standardImageView.centerXAnchor).isActive = true
        standardLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        standardLabel.widthAnchor.constraint(equalToConstant: standardWidth).isActive = true
        standardLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let standardLabelTap = UITapGestureRecognizer(target: self, action: #selector(standardLabelTapped))
        standardLabel.addGestureRecognizer(standardLabelTap)
        
    }
    
    func setupControllers() {
        
        scrollView.addSubview(bestPriceController.view)
        bestPriceController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        bestPriceController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        bestPriceController.view.topAnchor.constraint(equalTo: primeLabel.bottomAnchor).isActive = true
        bestPriceController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(primeSpotController.view)
        primeSpotController.view.leftAnchor.constraint(equalTo: bestPriceController.view.rightAnchor).isActive = true
        primeSpotController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        primeSpotController.view.topAnchor.constraint(equalTo: primeLabel.bottomAnchor).isActive = true
        primeSpotController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(standardSpotController.view)
        standardSpotController.view.leftAnchor.constraint(equalTo: primeSpotController.view.rightAnchor).isActive = true
        standardSpotController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        standardSpotController.view.topAnchor.constraint(equalTo: primeLabel.bottomAnchor).isActive = true
        standardSpotController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func noBookingFound() {
        self.scrollView.alpha = 0
        self.standardLabel.alpha = 0
        self.primeLabel.alpha = 0
        self.bestPriceLabel.alpha = 0
    }
    
    func parkingSelected() {
        self.scrollView.bringSubviewToFront(self.primeImageView)
        UIView.animate(withDuration: animationIn) {
            self.scrollView.alpha = 1
            self.standardLabel.alpha = 1
            self.primeLabel.alpha = 1
            self.bestPriceLabel.alpha = 1
            self.primeSpotController.view.alpha = 1
            self.primeClearView.alpha = 1
            self.bestClearView.alpha = 1
            self.standardClearView.alpha = 1
        }
    }
    
    @objc func bookSpotPressed(sender: UIButton) {
        if sender.titleLabel?.text == "BECOME A HOST" {
            self.delegate?.becomeAHost()
        } else {
            if self.primeSpotController.view.alpha == 1 {
                if let purchaseString = self.primeSpotController.priceLabel.text {
                    let amount = purchaseString.replacingOccurrences(of: " per hour", with: "")
                    if let price = Double(amount.replacingOccurrences(of: "$", with: "")) {
                        self.delegate?.bookSpotPressed(amount: price)
                    }
                }
            } else if self.bestPriceController.view.alpha == 1 {
                if let purchaseString = self.bestPriceController.priceLabel.text {
                    let amount = purchaseString.replacingOccurrences(of: " per hour", with: "")
                    if let price = Double(amount.replacingOccurrences(of: "$", with: "")) {
                        self.delegate?.bookSpotPressed(amount: price)
                    }
                }
            } else if self.standardSpotController.view.alpha == 1 {
                if let purchaseString = self.standardSpotController.priceLabel.text {
                    let amount = purchaseString.replacingOccurrences(of: " per hour", with: "")
                    if let price = Double(amount.replacingOccurrences(of: "$", with: "")) {
                        self.delegate?.bookSpotPressed(amount: price)
                    }
                }
            }
        }
    }
    
    func selectedAnnotation() {
        self.primeLabel.alpha = 0
        self.standardLabel.alpha = 0
        self.bestPriceLabel.alpha = 0
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: 320)
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: false)
        self.scrollView.isScrollEnabled = false
        self.scrollViewTopAnchor.constant = 40
        self.view.layoutIfNeeded()
    }
    
    func normalAnnotations() {
        self.primeLabel.alpha = 1
        self.standardLabel.alpha = 1
        self.bestPriceLabel.alpha = 1
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: 320)
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: false)
        self.scrollView.isScrollEnabled = true
        self.scrollViewTopAnchor.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func confirmPurchasePressed() {
       ///////
    }
    
    func setBestPriceImage(imageString: String) {
        self.bestPriceImageView.loadImageUsingCacheWithUrlString(imageString)
    }
    
    func setStandardImage(imageString: String) {
        self.standardImageView.loadImageUsingCacheWithUrlString(imageString)
    }
    
    func setPrimeImage(imageString: String) {
        self.primeImageView.loadImageUsingCacheWithUrlString(imageString)
    }
    
}


extension ParkingViewController: UIScrollViewDelegate {
    
    @objc func primeLabelTapped() {
        UIView.animate(withDuration: animationIn) {
            self.scrollView.contentOffset.x = self.view.frame.width
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4)
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            var transformation = CGAffineTransform.identity
            transformation = transformation.scaledBy(x: 0.5, y: 0.5)
            transformation = transformation.translatedBy(x: 0, y: 20)
            self.standardImageView.transform = transformation
            self.standardClearView.transform = transformation
            self.standardImageView.alpha = 0.5
        }
        if self.primeLabel.textColor == Theme.BLACK || self.bestPriceLabel.textColor == Theme.BLACK || self.standardLabel.textColor == Theme.BLACK {
            self.monitorPolylineRoutes()
        }
    }
    @objc func bestPriceLabelTapped() { UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = 0 }
        if self.primeLabel.textColor == Theme.BLACK || self.bestPriceLabel.textColor == Theme.BLACK || self.standardLabel.textColor == Theme.BLACK {
            self.monitorPolylineRoutes()
        }
    }
    @objc func standardLabelTapped() { UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = self.view.frame.width*2 }
        if self.primeLabel.textColor == Theme.BLACK || self.bestPriceLabel.textColor == Theme.BLACK || self.standardLabel.textColor == Theme.BLACK {
            self.monitorPolylineRoutes()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        var percentage = offset/self.view.frame.width
        if offset < 0 {
            percentage = abs(percentage)
            self.spotLabelAnchor.constant = ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) + ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) * percentage
            self.bestPriceLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.bestPriceLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.bestPriceImageView.alpha = 0.5 + 0.5 * (1 - percentage)
            var transformation = CGAffineTransform.identity
            transformation = transformation.scaledBy(x: 0.5 + 0.5 * (1 - percentage), y: 0.5 + 0.5 * (1 - percentage))
            transformation = transformation.translatedBy(x: 0, y: 20 * percentage)
            transformation = transformation.rotated(by: -CGFloat.pi/32 * percentage)
            self.bestPriceImageView.transform = transformation
            self.bestClearView.transform = transformation
        } else if offset >= 0 && offset <= self.view.frame.width {
            self.spotLabelAnchor.constant = ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) * (1 - percentage)
            self.bestPriceLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.bestPriceLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.bestPriceImageView.alpha = 0.5 + 0.5 * (1 - percentage)
            var transformation = CGAffineTransform.identity
            transformation = transformation.scaledBy(x: 0.5 + 0.5 * (1 - percentage), y: 0.5 + 0.5 * (1 - percentage))
            transformation = transformation.translatedBy(x: 0, y: 20 * percentage)
            self.bestPriceImageView.transform = transformation
            self.bestClearView.transform = transformation
            self.primeLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * percentage)
            self.primeLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentage, y: 0.8 + 0.2 * percentage)
            self.primeImageView.alpha = 0.5 + 0.5 * percentage
            var transformation2 = CGAffineTransform.identity
            transformation2 = transformation2.scaledBy(x: 0.5 + 0.5 * percentage, y: 0.5 + 0.5 * percentage)
            transformation2 = transformation2.translatedBy(x: 0, y: 20 * (1 - percentage))
            self.primeImageView.transform = transformation2
            self.primeClearView.transform = transformation2
        } else if offset > self.view.frame.width && offset <= self.view.frame.width * 2 {
            percentage = percentage - 1
            self.spotLabelAnchor.constant = -(((self.standardWidth/2 + 24) + (self.primeWidth/2)) * (percentage))
            self.primeLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.primeLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.primeImageView.alpha = 0.5 + 0.5 * (1 - percentage)
            var transformation = CGAffineTransform.identity
            transformation = transformation.scaledBy(x: 0.5 + 0.5 * (1 - percentage), y: 0.5 + 0.5 * (1 - percentage))
            transformation = transformation.translatedBy(x: 0, y: 20 * percentage)
            self.primeImageView.transform = transformation
            self.primeClearView.transform = transformation
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * percentage)
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentage, y: 0.8 + 0.2 * percentage)
            self.standardImageView.alpha = 0.5 + 0.5 * percentage
            var transformation2 = CGAffineTransform.identity
            transformation2 = transformation2.scaledBy(x: 0.5 + 0.5 * percentage, y: 0.5 + 0.5 * percentage)
            transformation2 = transformation2.translatedBy(x: 0, y: 20 * (1 - percentage))
            self.standardImageView.transform = transformation2
            self.standardClearView.transform = transformation2
        } else if offset > self.view.frame.width * 2 {
            percentage = percentage - 2
            self.spotLabelAnchor.constant = -((self.standardWidth/2 + 24) + (self.primeWidth/2)) + ((self.standardWidth/2 + 24) + (self.primeWidth/2)) * -percentage
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.standardImageView.alpha = 0.5 + 0.5 * (1 - percentage)
            var transformation = CGAffineTransform.identity
            transformation = transformation.scaledBy(x: 0.5 + 0.5 * (1 - percentage), y: 0.5 + 0.5 * (1 - percentage))
            transformation = transformation.translatedBy(x: 0, y: 20 * percentage)
            transformation = transformation.rotated(by: CGFloat.pi/32 * percentage)
            self.standardImageView.transform = transformation
            self.standardClearView.transform = transformation
        }
        self.view.layoutIfNeeded()
        if self.primeLabel.textColor == Theme.BLACK || self.bestPriceLabel.textColor == Theme.BLACK || self.standardLabel.textColor == Theme.BLACK {
            self.monitorPolylineRoutes()
        }
    }
    
}


extension ParkingViewController {
    
    func monitorPolylineRoutes() {
        if DestinationAnnotationLocation != nil {
            if self.primeLabel.textColor == Theme.BLACK && self.primeLabel.alpha == 1 {
                self.scrollView.bringSubviewToFront(self.primeImageView)
                UIView.animate(withDuration: animationIn) {
                    self.primeSpotController.view.alpha = 1
                    self.standardSpotController.view.alpha = 0
                    self.bestPriceController.view.alpha = 0
                    self.primeClearView.layer.shadowOpacity = 0.8
                    self.standardClearView.layer.shadowOpacity = 0
                    self.bestClearView.layer.shadowOpacity = 0
                    self.view.layoutIfNeeded()
                }
                self.parkingDelegate?.applyFirstPolyline()
            } else if self.bestPriceLabel.textColor == Theme.BLACK && self.bestPriceLabel.alpha == 1 {
                self.scrollView.bringSubviewToFront(self.bestPriceImageView)
                UIView.animate(withDuration: animationIn) {
                    self.primeSpotController.view.alpha = 0
                    self.standardSpotController.view.alpha = 0
                    self.bestPriceController.view.alpha = 1
                    self.primeClearView.layer.shadowOpacity = 0
                    self.standardClearView.layer.shadowOpacity = 0
                    self.bestClearView.layer.shadowOpacity = 0.8
                    self.view.layoutIfNeeded()
                }
                self.parkingDelegate?.applySecondPolyline()
            } else if self.standardLabel.textColor == Theme.BLACK && self.standardLabel.alpha == 1 {
                self.scrollView.bringSubviewToFront(self.standardImageView)
                UIView.animate(withDuration: animationIn) {
                    self.primeSpotController.view.alpha = 0
                    self.standardSpotController.view.alpha = 1
                    self.bestPriceController.view.alpha = 0
                    self.primeClearView.layer.shadowOpacity = 0
                    self.standardClearView.layer.shadowOpacity = 0.8
                    self.bestClearView.layer.shadowOpacity = 0
                    self.view.layoutIfNeeded()
                }
                self.parkingDelegate?.applyThirdPolyline()
            }
        }
    }
    
}

