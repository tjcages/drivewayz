//
//  ParkingOptionsTableViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/24/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingOptionsViewController: UIViewController {

    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    //RESIDENTIAL/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var drivewayImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "drivewayParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var drivewayIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Driveway", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var drivewayInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "A large area for parking with multiple parking spaces for customers. Must own the parking lot to list with Drivewayz."
        label.numberOfLines = 3
        label.font = Fonts.SSPLightH5
        
        return label
    }()
    
    var drivewayLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var sharedlotImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "parkinglotIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var sharedlotIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Shared parking lot", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var sharedlotInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "A parking space that is owned by the property owner and leased by then tenant. Usually associated with one spot number in a lot."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var sharedlotLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var sharedCoverImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "coveredParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var sharedCoverIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Shared parking garage", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var sharedCoverInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Covered parking is usually when the parking spot is in a parking garage, but can also be if the spot is covered by a patio or deck."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var sharedCoverLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var alleyImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "alleyParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var alleyIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Alley", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var alleyInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Only select this option if your parking spot is in between two buildings or behind a residential home and it is generally described as in an alley."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var alleyLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var gatedImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "gatedParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var gatedIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Gated", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var gatedInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var gatedLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var streetImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "streetParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var streetIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Street", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var streetInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Parking is on the street near a residential home. You must own this spot to list it through Drivewayz."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var streetLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    //BUSINESS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var parkinglotImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "parkinglotIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var parkinglotIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Parking lot", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var parkinglotInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Only select this option if you are the business owner of a parking lot. Drivewayz will reach out to you to confirm the information is correct."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        
        return label
    }()
    
    var parkinglotLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var garageImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "coveredParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var garageIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Garage/Structure lot", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var garageInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Only select this option if you are the business owner of a parking garage structure. Drivewayz will reach out to you to confirm the information is correct."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var garageLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var undergroundImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "undergroundParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var undergroundIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Underground", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var undergroundInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "Only select this option if you are the business owner of a parking garage structure. Drivewayz will reach out to you to confirm the information is correct."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var undergroundLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var condoImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "condoParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var condoIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Condo parking", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var condoInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "A condo parking space is similar to a residential space but generally is shared with another unit and requires the driver to pull off on one side of the driveway."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var condoLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var circularImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "circularParkingIcon");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var circularIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Circular loop", for: .normal)
        label.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var circularInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "A circular loop parking spot is one that requires someone to park in a roundabout and pull up as far forward as possible."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var circularLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        onlyShowBusinessOptions()
    }
    
    var drivewayAnchor: NSLayoutConstraint!
    var sharedlotAnchor: NSLayoutConstraint!
    var sharedGarageAnchor: NSLayoutConstraint!
    var alleyAnchor: NSLayoutConstraint!
    var gatedAnchor: NSLayoutConstraint!
    var streetAnchor: NSLayoutConstraint!
    
    var parkinglotAnchor: NSLayoutConstraint!
    var garageAnchor: NSLayoutConstraint!
    var undergroundAnchor: NSLayoutConstraint!
    var condoAnchor: NSLayoutConstraint!
    var circularAnchor: NSLayoutConstraint!
    
    var parkingType: String = "driveway"
    
    func onlyShowRegularOptions() {
        self.resetDriveway()
        self.resetStreet()
        self.resetSharedLot()
        self.resetSharedCover()
        self.resetAlley()
        self.resetGated()
        self.resetStreet()
        self.resetParkingLot()
        self.resetGarage()
        self.resetUnderground()
        self.resetCondo()
        self.resetCircular()
        self.drivewayIconLabel.setTitleColor(Theme.WHITE, for: .normal)
        self.drivewayIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
        self.drivewayImageView.tintColor = Theme.WHITE
        self.drivewayImageView.backgroundColor = Theme.PACIFIC_BLUE
        self.drivewayImageView.layer.shadowOpacity = 1
        self.drivewayAnchor.constant = 80
        self.drivewayInformation.alpha = 1
        self.view.layoutIfNeeded()
        self.parkingType = "driveway"
        self.drivewayImageView.alpha = 1
        self.drivewayIconLabel.alpha = 1
        self.drivewayInformation.alpha = 1
        self.drivewayLine.alpha = 1
        self.sharedlotImageView.alpha = 1
        self.sharedlotIconLabel.alpha = 1
        self.sharedlotLine.alpha = 1
        self.sharedCoverImageView.alpha = 1
        self.sharedCoverIconLabel.alpha = 1
        self.sharedCoverLine.alpha = 1
        self.alleyImageView.alpha = 1
        self.alleyIconLabel.alpha = 1
        self.alleyLine.alpha = 1
        self.gatedImageView.alpha = 1
        self.gatedIconLabel.alpha = 1
        self.gatedLine.alpha = 1
        self.streetImageView.alpha = 1
        self.streetIconLabel.alpha = 1
        self.streetLine.alpha = 1
        self.parkinglotImageView.alpha = 0
        self.parkinglotIconLabel.alpha = 0
        self.parkinglotInformation.alpha = 0
        self.parkinglotLine.alpha = 0
        self.garageImageView.alpha = 0
        self.garageIconLabel.alpha = 0
        self.garageInformation.alpha = 0
        self.garageLine.alpha = 0
        self.undergroundImageView.alpha = 0
        self.undergroundIconLabel.alpha = 0
        self.undergroundInformation.alpha = 0
        self.undergroundLine.alpha = 0
        self.condoImageView.alpha = 0
        self.condoIconLabel.alpha = 0
        self.condoInformation.alpha = 0
        self.condoLine.alpha = 0
        self.circularImageView.alpha = 0
        self.circularIconLabel.alpha = 0
        self.circularInformation.alpha = 0
        self.circularLine.alpha = 0
    
    }
    
    func onlyShowBusinessOptions() {
        self.resetDriveway()
        self.resetStreet()
        self.resetSharedLot()
        self.resetSharedCover()
        self.resetAlley()
        self.resetGated()
        self.resetStreet()
        self.resetParkingLot()
        self.resetGarage()
        self.resetUnderground()
        self.resetCondo()
        self.resetCircular()
        self.parkinglotIconLabel.setTitleColor(Theme.WHITE, for: .normal)
        self.parkinglotIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
        self.parkinglotImageView.tintColor = Theme.WHITE
        self.parkinglotImageView.backgroundColor = Theme.PACIFIC_BLUE
        self.parkinglotImageView.layer.shadowOpacity = 1
        self.parkinglotAnchor.constant = 80
        self.parkinglotInformation.alpha = 1
        self.view.layoutIfNeeded()
        self.parkingType = "parking lot"
        self.drivewayImageView.alpha = 0
        self.drivewayIconLabel.alpha = 0
        self.drivewayInformation.alpha = 0
        self.drivewayLine.alpha = 0
        self.sharedlotImageView.alpha = 0
        self.sharedlotIconLabel.alpha = 0
        self.sharedlotInformation.alpha = 0
        self.sharedlotLine.alpha = 0
        self.sharedCoverImageView.alpha = 0
        self.sharedCoverIconLabel.alpha = 0
        self.sharedCoverInformation.alpha = 0
        self.sharedCoverLine.alpha = 0
        self.alleyImageView.alpha = 0
        self.alleyIconLabel.alpha = 0
        self.alleyInformation.alpha = 0
        self.alleyLine.alpha = 0
        self.gatedImageView.alpha = 0
        self.gatedIconLabel.alpha = 0
        self.gatedInformation.alpha = 0
        self.gatedLine.alpha = 0
        self.streetImageView.alpha = 0
        self.streetIconLabel.alpha = 0
        self.streetInformation.alpha = 0
        self.streetLine.alpha = 0
        self.parkinglotImageView.alpha = 1
        self.parkinglotIconLabel.alpha = 1
        self.parkinglotInformation.alpha = 1
        self.parkinglotLine.alpha = 1
        self.garageImageView.alpha = 1
        self.garageIconLabel.alpha = 1
        self.garageLine.alpha = 1
        self.undergroundImageView.alpha = 1
        self.undergroundIconLabel.alpha = 1
        self.undergroundLine.alpha = 1
        self.condoImageView.alpha = 1
        self.condoIconLabel.alpha = 1
        self.condoLine.alpha = 1
        self.circularImageView.alpha = 1
        self.circularIconLabel.alpha = 1
        self.circularLine.alpha = 1
    }
    

}


///////HANDLE CONSTRAINTS///////////////////////////////////////////////////////////////////////////////////
extension ParkingOptionsViewController {
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width * 1.5)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(drivewayImageView)
        drivewayImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        drivewayImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        drivewayImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        drivewayImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(drivewayIconLabel)
        drivewayIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        drivewayIconLabel.topAnchor.constraint(equalTo: drivewayImageView.topAnchor).isActive = true
        drivewayIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        drivewayIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(drivewayLine)
        drivewayLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        drivewayLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        drivewayAnchor = drivewayLine.topAnchor.constraint(equalTo: drivewayIconLabel.bottomAnchor, constant: 90)
        drivewayAnchor.isActive = true
        drivewayLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(sharedlotImageView)
        sharedlotImageView.topAnchor.constraint(equalTo: drivewayLine.bottomAnchor, constant: 10).isActive = true
        sharedlotImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        sharedlotImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sharedlotImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(sharedlotIconLabel)
        sharedlotIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        sharedlotIconLabel.topAnchor.constraint(equalTo: sharedlotImageView.topAnchor).isActive = true
        sharedlotIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        sharedlotIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(sharedlotLine)
        sharedlotLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sharedlotLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        sharedlotAnchor = sharedlotLine.topAnchor.constraint(equalTo: sharedlotIconLabel.bottomAnchor, constant: 35)
        sharedlotAnchor.isActive = true
        sharedlotLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(sharedCoverImageView)
        sharedCoverImageView.topAnchor.constraint(equalTo: sharedlotLine.bottomAnchor, constant: 10).isActive = true
        sharedCoverImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        sharedCoverImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sharedCoverImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(sharedCoverIconLabel)
        sharedCoverIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        sharedCoverIconLabel.topAnchor.constraint(equalTo: sharedCoverImageView.topAnchor).isActive = true
        sharedCoverIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        sharedCoverIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(sharedCoverLine)
        sharedCoverLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sharedCoverLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        sharedGarageAnchor = sharedCoverLine.topAnchor.constraint(equalTo: sharedCoverIconLabel.bottomAnchor, constant: 35)
        sharedGarageAnchor.isActive = true
        sharedCoverLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(alleyImageView)
        alleyImageView.topAnchor.constraint(equalTo: sharedCoverLine.bottomAnchor, constant: 10).isActive = true
        alleyImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        alleyImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        alleyImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(alleyIconLabel)
        alleyIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        alleyIconLabel.topAnchor.constraint(equalTo: alleyImageView.topAnchor).isActive = true
        alleyIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        alleyIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(alleyLine)
        alleyLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alleyLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        alleyAnchor = alleyLine.topAnchor.constraint(equalTo: alleyIconLabel.bottomAnchor, constant: 35)
        alleyAnchor.isActive = true
        alleyLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(gatedImageView)
        gatedImageView.topAnchor.constraint(equalTo: alleyLine.bottomAnchor, constant: 10).isActive = true
        gatedImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        gatedImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        gatedImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(gatedIconLabel)
        gatedIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        gatedIconLabel.topAnchor.constraint(equalTo: gatedImageView.topAnchor).isActive = true
        gatedIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gatedIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(gatedLine)
        gatedLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        gatedLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        gatedAnchor = gatedLine.topAnchor.constraint(equalTo: gatedIconLabel.bottomAnchor, constant: 35)
        gatedAnchor.isActive = true
        gatedLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(streetImageView)
        streetImageView.topAnchor.constraint(equalTo: gatedLine.bottomAnchor, constant: 10).isActive = true
        streetImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        streetImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        streetImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(streetIconLabel)
        streetIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        streetIconLabel.topAnchor.constraint(equalTo: streetImageView.topAnchor).isActive = true
        streetIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        streetIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(streetLine)
        streetLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        streetLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        streetAnchor = streetLine.topAnchor.constraint(equalTo: streetIconLabel.bottomAnchor, constant: 35)
        streetAnchor.isActive = true
        streetLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        setupBusinessViews()
    }
    
    func setupBusinessViews() {
        
        scrollView.addSubview(parkinglotImageView)
        parkinglotImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        parkinglotImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkinglotImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        parkinglotImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(parkinglotIconLabel)
        parkinglotIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        parkinglotIconLabel.topAnchor.constraint(equalTo: parkinglotImageView.topAnchor).isActive = true
        parkinglotIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkinglotIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(parkinglotLine)
        parkinglotLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkinglotLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        parkinglotAnchor = parkinglotLine.topAnchor.constraint(equalTo: parkinglotIconLabel.bottomAnchor, constant: 80)
        parkinglotAnchor.isActive = true
        parkinglotLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(garageImageView)
        garageImageView.topAnchor.constraint(equalTo: parkinglotLine.bottomAnchor, constant: 10).isActive = true
        garageImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        garageImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        garageImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(garageIconLabel)
        garageIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        garageIconLabel.topAnchor.constraint(equalTo: garageImageView.topAnchor).isActive = true
        garageIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        garageIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(garageLine)
        garageLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        garageLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        garageAnchor = garageLine.topAnchor.constraint(equalTo: garageIconLabel.bottomAnchor, constant: 35)
        garageAnchor.isActive = true
        garageLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(undergroundImageView)
        undergroundImageView.topAnchor.constraint(equalTo: garageLine.bottomAnchor, constant: 10).isActive = true
        undergroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        undergroundImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        undergroundImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(undergroundIconLabel)
        undergroundIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        undergroundIconLabel.topAnchor.constraint(equalTo: undergroundImageView.topAnchor).isActive = true
        undergroundIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        undergroundIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(undergroundLine)
        undergroundLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        undergroundLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        undergroundAnchor = undergroundLine.topAnchor.constraint(equalTo: undergroundIconLabel.bottomAnchor, constant: 35)
        undergroundAnchor.isActive = true
        undergroundLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(condoImageView)
        condoImageView.topAnchor.constraint(equalTo: undergroundLine.bottomAnchor, constant: 10).isActive = true
        condoImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        condoImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        condoImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(condoIconLabel)
        condoIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        condoIconLabel.topAnchor.constraint(equalTo: condoImageView.topAnchor).isActive = true
        condoIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        condoIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(condoLine)
        condoLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        condoLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        condoAnchor = condoLine.topAnchor.constraint(equalTo: condoIconLabel.bottomAnchor, constant: 35)
        condoAnchor.isActive = true
        condoLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(circularImageView)
        circularImageView.topAnchor.constraint(equalTo: condoLine.bottomAnchor, constant: 10).isActive = true
        circularImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        circularImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        circularImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(circularIconLabel)
        circularIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        circularIconLabel.topAnchor.constraint(equalTo: circularImageView.topAnchor).isActive = true
        circularIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        circularIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(circularLine)
        circularLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        circularLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        circularAnchor = circularLine.topAnchor.constraint(equalTo: circularIconLabel.bottomAnchor, constant: 35)
        circularAnchor.isActive = true
        circularLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        setupExtraInformation()
    }
    
    func setupExtraInformation() {
        
        scrollView.addSubview(drivewayInformation)
        drivewayInformation.leftAnchor.constraint(equalTo: drivewayIconLabel.leftAnchor).isActive = true
        drivewayInformation.rightAnchor.constraint(equalTo: drivewayImageView.leftAnchor, constant: -10).isActive = true
        drivewayInformation.topAnchor.constraint(equalTo: drivewayIconLabel.bottomAnchor).isActive = true
        drivewayInformation.bottomAnchor.constraint(equalTo: drivewayLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(sharedlotInformation)
        sharedlotInformation.leftAnchor.constraint(equalTo: sharedlotIconLabel.leftAnchor).isActive = true
        sharedlotInformation.rightAnchor.constraint(equalTo: sharedlotImageView.leftAnchor, constant: -10).isActive = true
        sharedlotInformation.topAnchor.constraint(equalTo: sharedlotIconLabel.bottomAnchor).isActive = true
        sharedlotInformation.bottomAnchor.constraint(equalTo: sharedlotLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(sharedCoverInformation)
        sharedCoverInformation.leftAnchor.constraint(equalTo: sharedCoverIconLabel.leftAnchor).isActive = true
        sharedCoverInformation.rightAnchor.constraint(equalTo: sharedCoverImageView.leftAnchor, constant: -10).isActive = true
        sharedCoverInformation.topAnchor.constraint(equalTo: sharedCoverIconLabel.bottomAnchor).isActive = true
        sharedCoverInformation.bottomAnchor.constraint(equalTo: sharedCoverLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(alleyInformation)
        alleyInformation.leftAnchor.constraint(equalTo: alleyIconLabel.leftAnchor).isActive = true
        alleyInformation.rightAnchor.constraint(equalTo: alleyImageView.leftAnchor, constant: -10).isActive = true
        alleyInformation.topAnchor.constraint(equalTo: alleyIconLabel.bottomAnchor).isActive = true
        alleyInformation.bottomAnchor.constraint(equalTo: alleyLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(gatedInformation)
        gatedInformation.leftAnchor.constraint(equalTo: gatedIconLabel.leftAnchor).isActive = true
        gatedInformation.rightAnchor.constraint(equalTo: gatedImageView.leftAnchor, constant: -10).isActive = true
        gatedInformation.topAnchor.constraint(equalTo: gatedIconLabel.bottomAnchor).isActive = true
        gatedInformation.bottomAnchor.constraint(equalTo: gatedLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(streetInformation)
        streetInformation.leftAnchor.constraint(equalTo: streetIconLabel.leftAnchor).isActive = true
        streetInformation.rightAnchor.constraint(equalTo: streetImageView.leftAnchor, constant: -10).isActive = true
        streetInformation.topAnchor.constraint(equalTo: streetIconLabel.bottomAnchor).isActive = true
        streetInformation.bottomAnchor.constraint(equalTo: streetLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(parkinglotInformation)
        parkinglotInformation.leftAnchor.constraint(equalTo: parkinglotIconLabel.leftAnchor).isActive = true
        parkinglotInformation.rightAnchor.constraint(equalTo: parkinglotImageView.leftAnchor, constant: -10).isActive = true
        parkinglotInformation.topAnchor.constraint(equalTo: parkinglotIconLabel.bottomAnchor).isActive = true
        parkinglotInformation.bottomAnchor.constraint(equalTo: parkinglotLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(garageInformation)
        garageInformation.leftAnchor.constraint(equalTo: garageIconLabel.leftAnchor).isActive = true
        garageInformation.rightAnchor.constraint(equalTo: garageImageView.leftAnchor, constant: -10).isActive = true
        garageInformation.topAnchor.constraint(equalTo: garageIconLabel.bottomAnchor).isActive = true
        garageInformation.bottomAnchor.constraint(equalTo: garageLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(undergroundInformation)
        undergroundInformation.leftAnchor.constraint(equalTo: undergroundIconLabel.leftAnchor).isActive = true
        undergroundInformation.rightAnchor.constraint(equalTo: undergroundImageView.leftAnchor, constant: -10).isActive = true
        undergroundInformation.topAnchor.constraint(equalTo: undergroundIconLabel.bottomAnchor).isActive = true
        undergroundInformation.bottomAnchor.constraint(equalTo: undergroundLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(condoInformation)
        condoInformation.leftAnchor.constraint(equalTo: condoIconLabel.leftAnchor).isActive = true
        condoInformation.rightAnchor.constraint(equalTo: condoImageView.leftAnchor, constant: -10).isActive = true
        condoInformation.topAnchor.constraint(equalTo: condoIconLabel.bottomAnchor).isActive = true
        condoInformation.bottomAnchor.constraint(equalTo: condoLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(circularInformation)
        circularInformation.leftAnchor.constraint(equalTo: circularIconLabel.leftAnchor).isActive = true
        circularInformation.rightAnchor.constraint(equalTo: circularImageView.leftAnchor, constant: -10).isActive = true
        circularInformation.topAnchor.constraint(equalTo: circularIconLabel.bottomAnchor).isActive = true
        circularInformation.bottomAnchor.constraint(equalTo: circularLine.topAnchor, constant: -12).isActive = true
        
    }

}


///////HANDLE SELECTION////////////////////////////////////////////////////////////////////////////////////
extension ParkingOptionsViewController {
    @objc func optionTapped(sender: UIButton) {
        if sender == drivewayIconLabel || sender == drivewayImageView {
            self.parkingType = "driveway"
            UIView.animate(withDuration: 0.1) {
                self.drivewayIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.drivewayIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.drivewayImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.drivewayImageView.tintColor = Theme.WHITE
                self.drivewayImageView.layer.shadowOpacity = 1
                self.drivewayAnchor.constant = 95
                self.drivewayInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetSharedLot()
                self.resetStreet()
                self.resetSharedCover()
                self.resetAlley()
                self.resetGated()
                self.resetStreet()
                self.resetParkingLot()
                self.resetGarage()
                self.resetUnderground()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == sharedlotIconLabel || sender == sharedlotImageView {
            self.parkingType = "lot"
            UIView.animate(withDuration: 0.1) {
                self.sharedlotIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.sharedlotIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.sharedlotImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.sharedlotImageView.tintColor = Theme.WHITE
                self.sharedlotImageView.layer.shadowOpacity = 1
                self.sharedlotAnchor.constant = 110
                self.sharedlotInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetStreet()
                self.resetSharedCover()
                self.resetAlley()
                self.resetGated()
                self.resetStreet()
                self.resetParkingLot()
                self.resetGarage()
                self.resetUnderground()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == alleyIconLabel || sender == alleyImageView {
            self.parkingType = "alley"
            UIView.animate(withDuration: 0.1) {
                self.alleyIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.alleyIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.alleyImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.alleyImageView.tintColor = Theme.WHITE
                self.alleyImageView.layer.shadowOpacity = 1
                self.alleyAnchor.constant = 110
                self.alleyInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetSharedCover()
                self.resetStreet()
                self.resetGated()
                self.resetStreet()
                self.resetParkingLot()
                self.resetGarage()
                self.resetUnderground()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == sharedCoverIconLabel || sender == sharedCoverImageView {
            self.parkingType = "garage"
            UIView.animate(withDuration: 0.1) {
                self.sharedCoverIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.sharedCoverIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.sharedCoverImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.sharedCoverImageView.tintColor = Theme.WHITE
                self.sharedCoverImageView.layer.shadowOpacity = 1
                self.sharedGarageAnchor.constant = 110
                self.sharedCoverInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetAlley()
                self.resetGated()
                self.resetStreet()
                self.resetParkingLot()
                self.resetGarage()
                self.resetUnderground()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == gatedIconLabel || sender == gatedImageView {
            self.parkingType = "gated"
            UIView.animate(withDuration: 0.1) {
                self.gatedIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.gatedIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.gatedImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.gatedImageView.tintColor = Theme.WHITE
                self.gatedImageView.layer.shadowOpacity = 1
                self.gatedAnchor.constant = 110
                self.gatedInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetSharedCover()
                self.resetStreet()
                self.resetAlley()
                self.resetStreet()
                self.resetParkingLot()
                self.resetGarage()
                self.resetUnderground()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == streetIconLabel || sender == streetImageView {
            self.parkingType = "street"
            UIView.animate(withDuration: 0.1) {
                self.streetIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.streetIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.streetImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.streetImageView.tintColor = Theme.WHITE
                self.streetImageView.layer.shadowOpacity = 1
                self.streetAnchor.constant = 110
                self.streetInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetSharedCover()
                self.resetAlley()
                self.resetGated()
                self.resetParkingLot()
                self.resetGarage()
                self.resetUnderground()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == parkinglotIconLabel || sender == parkinglotImageView {
            self.parkingType = "lot"
            UIView.animate(withDuration: 0.1) {
                self.parkinglotIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.parkinglotIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.parkinglotImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.parkinglotImageView.tintColor = Theme.WHITE
                self.parkinglotImageView.layer.shadowOpacity = 1
                self.parkinglotAnchor.constant = 110
                self.parkinglotInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetSharedCover()
                self.resetStreet()
                self.resetAlley()
                self.resetGated()
                self.resetStreet()
                self.resetGarage()
                self.resetUnderground()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == garageIconLabel || sender == garageImageView {
            self.parkingType = "garage"
            UIView.animate(withDuration: 0.1) {
                self.garageIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.garageIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.garageImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.garageImageView.tintColor = Theme.WHITE
                self.garageImageView.layer.shadowOpacity = 1
                self.garageAnchor.constant = 110
                self.garageInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetSharedCover()
                self.resetStreet()
                self.resetAlley()
                self.resetGated()
                self.resetParkingLot()
                self.resetUnderground()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == undergroundIconLabel || sender == undergroundImageView {
            self.parkingType = "underground"
            UIView.animate(withDuration: 0.1) {
                self.undergroundIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.undergroundIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.undergroundImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.undergroundImageView.tintColor = Theme.WHITE
                self.undergroundImageView.layer.shadowOpacity = 1
                self.undergroundAnchor.constant = 110
                self.undergroundInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetSharedCover()
                self.resetStreet()
                self.resetAlley()
                self.resetGated()
                self.resetParkingLot()
                self.resetGarage()
                self.resetCondo()
                self.resetCircular()
            }
        } else if sender == condoIconLabel || sender == condoImageView {
            self.parkingType = "condo"
            UIView.animate(withDuration: 0.1) {
                self.condoIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.condoIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.condoImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.condoImageView.tintColor = Theme.WHITE
                self.condoImageView.layer.shadowOpacity = 1
                self.condoAnchor.constant = 110
                self.condoInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetSharedCover()
                self.resetStreet()
                self.resetAlley()
                self.resetGated()
                self.resetParkingLot()
                self.resetGarage()
                self.resetUnderground()
                self.resetCircular()
            }
        } else if sender == circularIconLabel || sender == circularImageView {
            self.parkingType = "circular"
            UIView.animate(withDuration: 0.1) {
                self.circularIconLabel.setTitleColor(Theme.WHITE, for: .normal)
                self.circularIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.circularImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.circularImageView.tintColor = Theme.WHITE
                self.circularImageView.layer.shadowOpacity = 1
                self.circularAnchor.constant = 110
                self.circularInformation.alpha = 1
                self.view.layoutIfNeeded()
                
                self.resetDriveway()
                self.resetSharedLot()
                self.resetSharedCover()
                self.resetStreet()
                self.resetAlley()
                self.resetGated()
                self.resetParkingLot()
                self.resetGarage()
                self.resetUnderground()
                self.resetCondo()
            }
        }
    }
    
}


///////RESET OPTIONS////////////////////////////////////////////////////////////////////////////////////
extension ParkingOptionsViewController {
    func resetDriveway() {
        UIView.animate(withDuration: 0.1) {
            self.drivewayIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.drivewayIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.drivewayImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.drivewayImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.drivewayImageView.layer.shadowOpacity = 0
            self.drivewayAnchor.constant = 35
            self.drivewayInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetSharedLot() {
        UIView.animate(withDuration: 0.1) {
            self.sharedlotIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.sharedlotIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.sharedlotImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.sharedlotImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.sharedlotImageView.layer.shadowOpacity = 0
            self.sharedlotAnchor.constant = 35
            self.sharedlotInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetSharedCover() {
        UIView.animate(withDuration: 0.1) {
            self.sharedCoverIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.sharedCoverIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.sharedCoverImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.sharedCoverImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.sharedCoverImageView.layer.shadowOpacity = 0
            self.sharedGarageAnchor.constant = 35
            self.sharedCoverInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetAlley() {
        UIView.animate(withDuration: 0.1) {
            self.alleyIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.alleyIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.alleyImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.alleyImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.alleyImageView.layer.shadowOpacity = 0
            self.alleyAnchor.constant = 35
            self.alleyInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetGated() {
        UIView.animate(withDuration: 0.1) {
            self.gatedIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.gatedIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.gatedImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.gatedImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.gatedImageView.layer.shadowOpacity = 0
            self.gatedAnchor.constant = 35
            self.gatedInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetStreet() {
        UIView.animate(withDuration: 0.1) {
            self.streetIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.streetIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.streetImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.streetImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.streetImageView.layer.shadowOpacity = 0
            self.streetAnchor.constant = 35
            self.streetInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetParkingLot() {
        UIView.animate(withDuration: 0.1) {
            self.parkinglotIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.parkinglotIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.parkinglotImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.parkinglotImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.parkinglotImageView.layer.shadowOpacity = 0
            self.parkinglotAnchor.constant =  35
            self.parkinglotInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetGarage() {
        UIView.animate(withDuration: 0.1) {
            self.garageIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.garageIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.garageImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.garageImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.garageImageView.layer.shadowOpacity = 0
            self.garageAnchor.constant = 35
            self.garageInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetUnderground() {
        UIView.animate(withDuration: 0.1) {
            self.undergroundIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.undergroundIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.undergroundImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.undergroundImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.undergroundImageView.layer.shadowOpacity = 0
            self.undergroundAnchor.constant = 35
            self.undergroundInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetCondo() {
        UIView.animate(withDuration: 0.1) {
            self.condoIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.condoIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.condoImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.condoImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.condoImageView.layer.shadowOpacity = 0
            self.condoAnchor.constant = 35
            self.condoInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetCircular() {
        UIView.animate(withDuration: 0.1) {
            self.circularIconLabel.setTitleColor(Theme.WHITE.withAlphaComponent(0.6), for: .normal)
            self.circularIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.circularImageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            self.circularImageView.tintColor = Theme.WHITE.withAlphaComponent(0.5)
            self.circularImageView.layer.shadowOpacity = 0
            self.circularAnchor.constant = 35
            self.circularInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}
