//
//  FullCurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class FullInfoViewController: UIViewController {
    
    var delegate: handleParkingImageHeight?
    var driveTime: Double = 0.0
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        
        return view
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "$1.30 per hour"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.starSize = 20
        view.settings.starMargin = 4
        view.settings.filledColor = Theme.BLUE
        view.settings.emptyBorderColor = Theme.OFF_WHITE
        view.settings.filledBorderColor = Theme.BLUE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "10"
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var parkingMessage: String = "A secure and affordable parking spot in the heart of downtown Boulder. A quick 5 minute walk to Pearl St. makes this a great location whether you are shopping for the day or have a meeting in the busy area." {
        didSet {
            self.hostMessage.text = parkingMessage
            self.messageHeightAnchor.constant = parkingMessage.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPRegularH5) + 24
            self.view.layoutIfNeeded()
        }
    }
    
    var hostMessage: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "A secure and affordable parking spot in the heart of downtown Boulder. A quick 5 minute walk to Pearl St. makes this a great location whether you are shopping for the day or have a meeting in the busy area."
        label.font = Fonts.SSPRegularH5
        label.backgroundColor = UIColor.clear
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    lazy var currentAmenitiesController: CurrentAmenitiesViewController = {
        let controller = CurrentAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.clipsToBounds = false
        
        return controller
    }()
    
    var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = false
        
        setupViews()
    }
    
    var blackViewHeightAnchor: NSLayoutConstraint!
    var messageHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 940)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stars)
        stars.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18).isActive = true
        stars.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 120).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 4).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 8).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(hostMessage)
        hostMessage.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant:
            8).isActive = true
        hostMessage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        hostMessage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        messageHeightAnchor = hostMessage.heightAnchor.constraint(equalToConstant: hostMessage.text.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPRegularH5) + 24)
            messageHeightAnchor.isActive = true
        
        scrollView.addSubview(currentAmenitiesController.view)
        currentAmenitiesController.view.topAnchor.constraint(equalTo: hostMessage.bottomAnchor, constant: 8).isActive = true
        currentAmenitiesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentAmenitiesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentAmenitiesController.view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        scrollView.addSubview(spacerView)
        spacerView.topAnchor.constraint(equalTo: currentAmenitiesController.view.bottomAnchor, constant: 16).isActive = true
        spacerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spacerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 24).isActive = true
        spacerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
}
