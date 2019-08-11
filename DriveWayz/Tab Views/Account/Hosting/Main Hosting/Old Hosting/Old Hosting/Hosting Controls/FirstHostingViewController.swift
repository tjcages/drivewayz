//
//  FirstHostingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FirstHostingViewController: UIViewController {

    var delegate: handleHostingScroll?
//    var hostDelegate: handleHostEditing?
    var guestsOpened: Bool = false
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        
        return view
    }()
    
    lazy var mainExpandedInformationView: HostingExpandedViewController = {
        let controller = HostingExpandedViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.hostDelegate = self
        
        return controller
    }()
    
    lazy var mainProfitsView: HostingProfitsViewController = {
        let controller = HostingProfitsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var mainDestinationView: HostingDestinationViewController = {
        let controller = HostingDestinationViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var mainHoursView: HostingHoursViewController = {
        let controller = HostingHoursViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var mainUsersView: HostingUsersViewController = {
        let controller = HostingUsersViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var mainGraphView: HostingGraphsViewController = {
        let controller = HostingGraphsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var mainGuestsView: HostingGuestsViewController = {
        let controller = HostingGuestsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var mainReviewsView: HostingReviewsViewController = {
        let controller = HostingReviewsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var mainOptionsView: HostingOptionsViewController = {
        let controller = HostingOptionsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.delegate = self
//        controller.hostDelegate = self
        
        return controller
    }()
    
    var analyticsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.text = "Information"
        label.font = Fonts.SSPRegularH3
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.textAlignment = .center
        label.text = "Guests"
        label.font = Fonts.SSPRegularH3
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var guestsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.text = "Analytics"
        label.font = Fonts.SSPRegularH3
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var optionsLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.alpha = 0
        
        return view
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        return loading
    }()
    
    var imageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight)
        view.backgroundColor = UIColor.clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.showsVerticalScrollIndicator = true
        view.flashScrollIndicators()
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 6.0
        view.alpha = 0
        
        return view
    }()
    
    var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var dimmedImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        let image = UIImage(named: "background1")
        view.image = image
        view.contentMode = .scaleAspectFill
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        beginLoading()
    }
    
    func beginLoading() {
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
        loadingActivity.startAnimating()
    }
    
    func setData(hosting: ParkingSpots) {
        mainExpandedInformationView.setData(hosting: hosting)
        
        setupViews()
        setupInformation()
        setupAnalytics()
        setupGuests()
        addDimmedView()
        
        loadingActivity.stopAnimating()
    }
    
    var spotLabelAnchor: NSLayoutConstraint!
    
    var bestPriceWidth: CGFloat = 0
    var primeWidth: CGFloat = 0
    var standardWidth: CGFloat = 0
    
    func setupViews() {
        
        self.primeWidth = (self.analyticsLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        self.bestPriceWidth = (self.informationLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        self.standardWidth = (self.guestsLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(analyticsLabel)
        spotLabelAnchor = analyticsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)))
            spotLabelAnchor.isActive = true
        analyticsLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        analyticsLabel.widthAnchor.constraint(equalToConstant: primeWidth).isActive = true
        analyticsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let primeTap = UITapGestureRecognizer(target: self, action: #selector(analyticsLabelTapped))
        guestsLabel.addGestureRecognizer(primeTap)
        
        self.view.addSubview(informationLabel)
        informationLabel.rightAnchor.constraint(equalTo: analyticsLabel.leftAnchor, constant: -24).isActive = true
        informationLabel.topAnchor.constraint(equalTo: analyticsLabel.topAnchor).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: bestPriceWidth).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let bestPriceTap = UITapGestureRecognizer(target: self, action: #selector(informationLabelTapped))
        analyticsLabel.addGestureRecognizer(bestPriceTap)
        
        self.view.addSubview(guestsLabel)
        guestsLabel.leftAnchor.constraint(equalTo: analyticsLabel.rightAnchor, constant: 24).isActive = true
        guestsLabel.topAnchor.constraint(equalTo: analyticsLabel.topAnchor).isActive = true
        guestsLabel.widthAnchor.constraint(equalToConstant: standardWidth).isActive = true
        guestsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let standardTap = UITapGestureRecognizer(target: self, action: #selector(guestsLabelTapped))
        informationLabel.addGestureRecognizer(standardTap)
        
        self.view.addSubview(optionsLine)
        optionsLine.bottomAnchor.constraint(equalTo: analyticsLabel.bottomAnchor, constant: 12).isActive = true
        optionsLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        optionsLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        optionsLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
    }
    
    func setupInformation() {
        
        scrollView.addSubview(mainExpandedInformationView.view)
        mainExpandedInformationView.view.topAnchor.constraint(equalTo: optionsLine.bottomAnchor).isActive = true
        mainExpandedInformationView.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: self.view.frame.width).isActive = true
        mainExpandedInformationView.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        mainExpandedInformationView.view.heightAnchor.constraint(equalToConstant: mainExpandedInformationView.height).isActive = true
        self.handleScroll(height: mainExpandedInformationView.height + 266)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage(sender:)))
        mainExpandedInformationView.expandedImages.view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(mainOptionsView.view)
        mainOptionsView.view.topAnchor.constraint(equalTo: mainExpandedInformationView.view.bottomAnchor, constant: 12).isActive = true
        mainOptionsView.view.leftAnchor.constraint(equalTo: mainExpandedInformationView.view.leftAnchor).isActive = true
        mainOptionsView.view.rightAnchor.constraint(equalTo: mainExpandedInformationView.view.rightAnchor).isActive = true
        mainOptionsView.view.heightAnchor.constraint(equalToConstant: 207).isActive = true
        
    }
    
    func setupAnalytics() {
        
        scrollView.addSubview(mainGraphView.view)
        mainGraphView.view.leftAnchor.constraint(equalTo: mainExpandedInformationView.view.rightAnchor).isActive = true
        mainGraphView.view.topAnchor.constraint(equalTo: mainExpandedInformationView.view.topAnchor).isActive = true
        mainGraphView.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        mainGraphView.view.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        scrollView.addSubview(mainProfitsView.view)
        mainProfitsView.view.topAnchor.constraint(equalTo: mainGraphView.view.bottomAnchor, constant: 12).isActive = true
        mainProfitsView.view.leftAnchor.constraint(equalTo: mainGraphView.view.leftAnchor, constant: 12).isActive = true
        mainProfitsView.view.rightAnchor.constraint(equalTo: mainGraphView.view.centerXAnchor, constant: -6).isActive = true
        mainProfitsView.view.heightAnchor.constraint(equalToConstant: 155).isActive = true
        
        scrollView.addSubview(mainUsersView.view)
        mainUsersView.view.topAnchor.constraint(equalTo: mainGraphView.view.bottomAnchor, constant: 12).isActive = true
        mainUsersView.view.leftAnchor.constraint(equalTo: mainGraphView.view.centerXAnchor, constant: 6).isActive = true
        mainUsersView.view.rightAnchor.constraint(equalTo: mainGraphView.view.rightAnchor, constant: -12).isActive = true
        mainUsersView.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        scrollView.addSubview(mainDestinationView.view)
        mainDestinationView.view.topAnchor.constraint(equalTo: mainUsersView.view.bottomAnchor, constant: 12).isActive = true
        mainDestinationView.view.leftAnchor.constraint(equalTo: mainGraphView.view.centerXAnchor, constant: 6).isActive = true
        mainDestinationView.view.rightAnchor.constraint(equalTo: mainGraphView.view.rightAnchor, constant: -12).isActive = true
        mainDestinationView.view.heightAnchor.constraint(equalToConstant: 155).isActive = true
        
        scrollView.addSubview(mainHoursView.view)
        mainHoursView.view.topAnchor.constraint(equalTo: mainProfitsView.view.bottomAnchor, constant: 12).isActive = true
        mainHoursView.view.leftAnchor.constraint(equalTo: mainGraphView.view.leftAnchor, constant: 12).isActive = true
        mainHoursView.view.rightAnchor.constraint(equalTo: mainGraphView.view.centerXAnchor, constant: -6).isActive = true
        mainHoursView.view.heightAnchor.constraint(equalToConstant: 95).isActive = true

    }
    
    func setupGuests() {
        
        scrollView.addSubview(mainGuestsView.view)
        mainGuestsView.view.topAnchor.constraint(equalTo: mainExpandedInformationView.view.topAnchor).isActive = true
        mainGuestsView.view.rightAnchor.constraint(equalTo: mainExpandedInformationView.view.leftAnchor).isActive = true
        mainGuestsView.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        mainGuestsView.view.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(allGuestsPressed))
        mainGuestsView.view.addGestureRecognizer(tap)
        informationLabelTapped()
    }
    
    func setupReviews() {
    
        self.view.addSubview(mainReviewsView.view)
        mainReviewsView.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 48).isActive = true
        mainReviewsView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        mainReviewsView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        mainReviewsView.view.heightAnchor.constraint(equalToConstant: 204).isActive = true
        
    }
    
    func addDimmedView() {
        
        self.view.addSubview(dimmedView)
        dimmedView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmedView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        dimmedView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage(sender:)))
        imageScrollView.addGestureRecognizer(tapGesture)
        
        imageScrollView.delegate = self
        
        self.view.addSubview(imageScrollView)
        imageScrollView.addSubview(dimmedImageView)
        dimmedImageView.centerXAnchor.constraint(equalTo: imageScrollView.centerXAnchor).isActive = true
        dimmedImageView.centerYAnchor.constraint(equalTo: imageScrollView.centerYAnchor).isActive = true
        dimmedImageView.widthAnchor.constraint(equalTo: dimmedView.widthAnchor).isActive = true
        dimmedImageView.heightAnchor.constraint(equalTo: dimmedImageView.widthAnchor).isActive = true
        
    }
    
    @objc func tappedImage(sender: UITapGestureRecognizer) {
        self.dimmedImageView.image = self.mainExpandedInformationView.expandedImages.firstImageView.image
        UIView.animate(withDuration: animationIn) {
            if self.dimmedView.alpha == 0 {
                self.dimmedView.alpha = 0.9
                self.dimmedImageView.alpha = 1
                self.imageScrollView.alpha = 1
            } else {
                self.dimmedView.alpha = 0
                self.dimmedImageView.alpha = 0
                self.imageScrollView.alpha = 0
            }
        }
    }
    
    @objc func allGuestsPressed() {
        if guestsOpened == false {
            self.delegate?.allGuestsPressed()
            self.guestsOpened = true
        } else {
            self.delegate?.hideAllGuests()
            self.guestsOpened = false
        }
    }
    
    func handleScroll(height: CGFloat) {
        self.delegate?.handleScroll(height: height)
    }
    
    func bringNewHostingController() {
        self.delegate?.bringNewHostingController()
    }
    
}

extension FirstHostingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        var percentage = offset/self.view.frame.width
        if offset < 0 {
            percentage = abs(percentage)
            self.spotLabelAnchor.constant = ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) + ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) * percentage
            self.informationLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.informationLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
        } else if offset >= 0 && offset <= self.view.frame.width {
            self.spotLabelAnchor.constant = ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) * (1 - percentage)
            self.informationLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.informationLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.analyticsLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * percentage)
            self.analyticsLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentage, y: 0.8 + 0.2 * percentage)
        } else if offset > self.view.frame.width && offset <= self.view.frame.width * 2 {
            percentage = percentage - 1
            self.spotLabelAnchor.constant = -(((self.standardWidth/2 + 24) + (self.primeWidth/2)) * (percentage))
            self.analyticsLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.analyticsLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.guestsLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * percentage)
            self.guestsLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentage, y: 0.8 + 0.2 * percentage)
        } else if offset > self.view.frame.width * 2 {
            percentage = percentage - 2
            self.spotLabelAnchor.constant = -((self.standardWidth/2 + 24) + (self.primeWidth/2)) + ((self.standardWidth/2 + 24) + (self.primeWidth/2)) * -percentage
            self.guestsLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.guestsLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
        }
        if informationLabel.textColor == Theme.BLACK {
            self.handleScroll(height: 520)
        } else if analyticsLabel.textColor == Theme.BLACK {
            self.handleScroll(height: mainExpandedInformationView.height + 270)
        } else if guestsLabel.textColor == Theme.BLACK {
            self.handleScroll(height: 680)
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func analyticsLabelTapped() {
        self.handleScroll(height: 680)
        UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = self.view.frame.width * 2 }
    }
    @objc func informationLabelTapped() {
        self.handleScroll(height: mainExpandedInformationView.height + 270)
        UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = self.view.frame.width }
    }
    @objc func guestsLabelTapped() {
        self.handleScroll(height: 520)
        UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = 0 }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.dimmedImageView
    }
    
}
