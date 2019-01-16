//
//  ParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ParkingViewController: UIViewController, UIScrollViewDelegate {
    
    var delegate: handleCheckoutParking?
    var navigationDelegate: handleRouteNavigation?
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        
        return view
    }()
    
    lazy var primeSpotController: PrimeSpotViewController = {
        let controller = PrimeSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        self.addChild(controller)
        
        return controller
    }()
    
    lazy var standardSpotController: StandardSpotViewController = {
        let controller = StandardSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var bestPriceController: BestPriceViewController = {
        let controller = BestPriceViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var reserveSpotController: ReservationsViewController = {
        let controller = ReservationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
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
    
    var standardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.text = "Standard spots"
        label.font = Fonts.SSPRegularH3
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    lazy var bookSpotButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("BOOK SPOT", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.WHITE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 16, height: 60)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var confirmPurchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONFIRM PURCHASE", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLACK
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(confirmPurchasePressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    var searchingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "SEARCHING"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        scrollView.delegate = self
        
        setupViews()
    }
    
    var spotLabelAnchor: NSLayoutConstraint!
    
    var bestPriceWidth: CGFloat = 0
    var primeWidth: CGFloat = 0
    var standardWidth: CGFloat = 0
    
    @objc func primeLabelTapped() {
        UIView.animate(withDuration: animationIn) {
            self.scrollView.contentOffset.x = self.view.frame.width
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4)
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    @objc func bestPriceLabelTapped() { UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = 0 }}
    @objc func standardLabelTapped() { UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = self.view.frame.width*2 }}
    
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
        
        self.view.addSubview(primeLabel)
        spotLabelAnchor = primeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            spotLabelAnchor.isActive = true
        primeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        primeLabel.widthAnchor.constraint(equalToConstant: primeWidth).isActive = true
        primeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let primeTap = UITapGestureRecognizer(target: self, action: #selector(primeLabelTapped))
        primeLabel.addGestureRecognizer(primeTap)
        
        self.view.addSubview(bestPriceLabel)
        bestPriceLabel.rightAnchor.constraint(equalTo: primeLabel.leftAnchor, constant: -24).isActive = true
        bestPriceLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        bestPriceLabel.widthAnchor.constraint(equalToConstant: bestPriceWidth).isActive = true
        bestPriceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let bestPriceTap = UITapGestureRecognizer(target: self, action: #selector(bestPriceLabelTapped))
        bestPriceLabel.addGestureRecognizer(bestPriceTap)
        
        self.view.addSubview(standardLabel)
        standardLabel.leftAnchor.constraint(equalTo: primeLabel.rightAnchor, constant: 24).isActive = true
        standardLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        standardLabel.widthAnchor.constraint(equalToConstant: standardWidth).isActive = true
        standardLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let standardTap = UITapGestureRecognizer(target: self, action: #selector(standardLabelTapped))
        standardLabel.addGestureRecognizer(standardTap)
        
        self.view.addSubview(searchingLabel)
        searchingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        searchingLabel.widthAnchor.constraint(equalToConstant: (searchingLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 4).isActive = true
        searchingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
        searchingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.leftAnchor.constraint(equalTo: searchingLabel.rightAnchor).isActive = true
        loadingActivity.bottomAnchor.constraint(equalTo: searchingLabel.bottomAnchor, constant: 0).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 20).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
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
        
        self.view.addSubview(bookSpotButton)
        bookSpotButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bookSpotButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        bookSpotButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        bookSpotButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        
        self.view.addSubview(confirmPurchaseButton)
        confirmPurchaseButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        confirmPurchaseButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        confirmPurchaseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        confirmPurchaseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        var percentage = offset/self.view.frame.width
        if offset < 0 {
            percentage = abs(percentage)
            self.spotLabelAnchor.constant = ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) + ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) * percentage
            self.bestPriceLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.bestPriceLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
        } else if offset >= 0 && offset <= self.view.frame.width {
            self.spotLabelAnchor.constant = ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) * (1 - percentage)
            self.bestPriceLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.bestPriceLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.primeLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * percentage)
            self.primeLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentage, y: 0.8 + 0.2 * percentage)
        } else if offset > self.view.frame.width && offset <= self.view.frame.width * 2 {
            percentage = percentage - 1
            self.spotLabelAnchor.constant = -(((self.standardWidth/2 + 24) + (self.primeWidth/2)) * (percentage))
            self.primeLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.primeLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * percentage)
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentage, y: 0.8 + 0.2 * percentage)
        } else if offset > self.view.frame.width * 2 {
            percentage = percentage - 2
            self.spotLabelAnchor.constant = -((self.standardWidth/2 + 24) + (self.primeWidth/2)) + ((self.standardWidth/2 + 24) + (self.primeWidth/2)) * -percentage
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
        }
        self.view.layoutIfNeeded()
    }
    
    func bringUpSearch() {
        self.bookSpotButton.removeTarget(nil, action: nil, for: .allEvents)
        self.bookSpotButton.setTitle("", for: .normal)
        self.scrollView.alpha = 0
        self.primeLabel.alpha = 0
        self.bestPriceLabel.alpha = 0
        self.standardLabel.alpha = 0
        self.searchingLabel.alpha = 1
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
    }
    
    func parkingSelected() {
        self.bookSpotButton.addTarget(self, action: #selector(bookSpotPressed(sender:)), for: .touchUpInside)
        UIView.animate(withDuration: animationIn) {
            self.primeLabel.alpha = 1
            self.bestPriceLabel.alpha = 1
            self.standardLabel.alpha = 1
            self.scrollView.alpha = 1
            self.searchingLabel.alpha = 0
            self.loadingActivity.alpha = 0
            self.loadingActivity.stopAnimating()
        }
        self.bookSpotButton.setTitle("BOOK SPOT", for: .normal)
    }
    
    @objc func bookSpotPressed(sender: UIButton) {
        self.delegate?.bookSpotPressed()
        self.scrollView.isScrollEnabled = false
        UIView.animate(withDuration: animationIn) {
            self.confirmPurchaseButton.alpha = 1
            self.bookSpotButton.alpha = 0
            self.standardLabel.alpha = 0
            self.bestPriceLabel.alpha = 0
        }
        self.primeSpotController.bookSpotPressed()
    }
    
    func backToBook() {
        self.primeSpotController.backToBook()
        self.scrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationIn) {
            self.confirmPurchaseButton.alpha = 0
            self.bookSpotButton.alpha = 1
            self.standardLabel.alpha = 1
            self.bestPriceLabel.alpha = 1
        }
    }
    
    @objc func confirmPurchasePressed(sender: UIButton) {
        self.navigationDelegate?.beginRouteNavigation()
    }
    
}
