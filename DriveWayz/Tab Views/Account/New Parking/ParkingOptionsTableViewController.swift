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
        
        return view
    }()
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.GREEN_PIGMENT.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.GREEN_PIGMENT
        
        return button
    }()
    
    //RESIDENTIAL/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var drivewayImageView: UIImageView = {
        let image = UIImage(named: "drivewayParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.PACIFIC_BLUE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return view
    }()
    
    var drivewayIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Driveway", for: .normal)
        label.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var drivewayInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Our most common parking space. The spot is usually owned or leased by the host and can be a driveway or shared parking lot."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        return label
    }()
    
    var drivewayLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var sharedlotImageView: UIImageView = {
        let image = UIImage(named: "parkinglotIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var sharedlotIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Shared parking lot", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var sharedlotInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A parking space that is owned by the property owner and leased by then tennant. Usually associated with one spot number in a lot."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var sharedlotLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var sharedCoverImageView: UIImageView = {
        let image = UIImage(named: "coveredParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var sharedCoverIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Shared parking garage", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var sharedCoverInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Parking outside a residential home or apartment complex and on the main street, susceptible to other traffic."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var sharedCoverLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var alleyImageView: UIImageView = {
        let image = UIImage(named: "alleyParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var alleyIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Alley", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var alleyInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Covered parking is usually when the parking spot is in a parking garage, but can also be if the spot is covered by a patio or deck."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var alleyLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var gatedImageView: UIImageView = {
        let image = UIImage(named: "gatedParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var gatedIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Gated", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var gatedInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A large area for parking with multiple parking spaces for customers. Must own the parking lot to list with Drivewayz."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var gatedLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var streetImageView: UIImageView = {
        let image = UIImage(named: "streetParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var streetIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Street", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var streetInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Only select this option if your parking spot is in between two buildings or behind a residential home and it is generally described as in an alley."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var streetLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    //BUSINESS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var parkinglotImageView: UIImageView = {
        let image = UIImage(named: "parkinglotIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var parkinglotIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Parking lot", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var parkinglotInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var parkinglotLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var garageImageView: UIImageView = {
        let image = UIImage(named: "coveredParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var garageIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Garage/Structure lot", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var garageInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var garageLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var undergroundImageView: UIImageView = {
        let image = UIImage(named: "undergroundParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var undergroundIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Underground", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var undergroundInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var undergroundLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var condoImageView: UIImageView = {
        let image = UIImage(named: "condoParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var condoIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Condo parking", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var condoInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var condoLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var circularImageView: UIImageView = {
        let image = UIImage(named: "circularParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var circularIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Circular loop", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var circularInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var circularLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
    
    var checkDrivewayAnchor: NSLayoutConstraint!
    var checkSharedLotAnchor: NSLayoutConstraint!
    var checkSharedGarageAnchor: NSLayoutConstraint!
    var checkAlleyAnchor: NSLayoutConstraint!
    var checkGatedAnchor: NSLayoutConstraint!
    var checkStreetAnchor: NSLayoutConstraint!
    var checkParkingLotAnchor: NSLayoutConstraint!
    var checkGarageAnchor: NSLayoutConstraint!
    var checkUndergroundAnchor: NSLayoutConstraint!
    var checkCondoAnchor: NSLayoutConstraint!
    var checkCircularAnchor: NSLayoutConstraint!
    var previousCheckAnchor: NSLayoutConstraint!
    
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
        self.drivewayIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        self.drivewayIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.drivewayImageView.tintColor = Theme.PACIFIC_BLUE
        self.drivewayImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.drivewayAnchor.constant = 100
        self.drivewayInformation.alpha = 1
        self.previousCheckAnchor.isActive = false
        self.checkDrivewayAnchor.isActive = true
        self.previousCheckAnchor = self.checkDrivewayAnchor
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
        self.parkinglotIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        self.parkinglotIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.parkinglotImageView.tintColor = Theme.PACIFIC_BLUE
        self.parkinglotImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.parkinglotAnchor.constant = 100
        self.parkinglotInformation.alpha = 1
        self.previousCheckAnchor.isActive = false
        self.checkParkingLotAnchor.isActive = true
        self.previousCheckAnchor = self.checkParkingLotAnchor
        self.view.layoutIfNeeded()
        self.parkingType = "parkingLot"
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
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width * 2)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(drivewayImageView)
        drivewayImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        drivewayImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        drivewayImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        drivewayImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(drivewayIconLabel)
        drivewayIconLabel.leftAnchor.constraint(equalTo: drivewayImageView.rightAnchor, constant: 24).isActive = true
        drivewayIconLabel.centerYAnchor.constraint(equalTo: drivewayImageView.centerYAnchor).isActive = true
        drivewayIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        drivewayIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(drivewayLine)
        drivewayLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        drivewayLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        drivewayAnchor = drivewayLine.topAnchor.constraint(equalTo: drivewayIconLabel.bottomAnchor, constant: 100)
        drivewayAnchor.isActive = true
        drivewayLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(sharedlotImageView)
        sharedlotImageView.topAnchor.constraint(equalTo: drivewayLine.bottomAnchor, constant: 10).isActive = true
        sharedlotImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        sharedlotImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sharedlotImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(sharedlotIconLabel)
        sharedlotIconLabel.leftAnchor.constraint(equalTo: sharedlotImageView.rightAnchor, constant: 24).isActive = true
        sharedlotIconLabel.centerYAnchor.constraint(equalTo: sharedlotImageView.centerYAnchor).isActive = true
        sharedlotIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        sharedlotIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(sharedlotLine)
        sharedlotLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sharedlotLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        sharedlotAnchor = sharedlotLine.topAnchor.constraint(equalTo: sharedlotIconLabel.bottomAnchor, constant: 5)
        sharedlotAnchor.isActive = true
        sharedlotLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(sharedCoverImageView)
        sharedCoverImageView.topAnchor.constraint(equalTo: sharedlotLine.bottomAnchor, constant: 5).isActive = true
        sharedCoverImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        sharedCoverImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sharedCoverImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(sharedCoverIconLabel)
        sharedCoverIconLabel.leftAnchor.constraint(equalTo: sharedCoverImageView.rightAnchor, constant: 24).isActive = true
        sharedCoverIconLabel.centerYAnchor.constraint(equalTo: sharedCoverImageView.centerYAnchor).isActive = true
        sharedCoverIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        sharedCoverIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(sharedCoverLine)
        sharedCoverLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sharedCoverLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        sharedGarageAnchor = sharedCoverLine.topAnchor.constraint(equalTo: sharedCoverIconLabel.bottomAnchor, constant: 5)
        sharedGarageAnchor.isActive = true
        sharedCoverLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(alleyImageView)
        alleyImageView.topAnchor.constraint(equalTo: sharedCoverLine.bottomAnchor, constant: 5).isActive = true
        alleyImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        alleyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        alleyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(alleyIconLabel)
        alleyIconLabel.leftAnchor.constraint(equalTo: alleyImageView.rightAnchor, constant: 24).isActive = true
        alleyIconLabel.centerYAnchor.constraint(equalTo: alleyImageView.centerYAnchor).isActive = true
        alleyIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        alleyIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(alleyLine)
        alleyLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alleyLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        alleyAnchor = alleyLine.topAnchor.constraint(equalTo: alleyIconLabel.bottomAnchor, constant: 5)
        alleyAnchor.isActive = true
        alleyLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(gatedImageView)
        gatedImageView.topAnchor.constraint(equalTo: alleyLine.bottomAnchor, constant: 5).isActive = true
        gatedImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        gatedImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gatedImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(gatedIconLabel)
        gatedIconLabel.leftAnchor.constraint(equalTo: gatedImageView.rightAnchor, constant: 24).isActive = true
        gatedIconLabel.centerYAnchor.constraint(equalTo: gatedImageView.centerYAnchor).isActive = true
        gatedIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gatedIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(gatedLine)
        gatedLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        gatedLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        gatedAnchor = gatedLine.topAnchor.constraint(equalTo: gatedIconLabel.bottomAnchor, constant: 5)
        gatedAnchor.isActive = true
        gatedLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(streetImageView)
        streetImageView.topAnchor.constraint(equalTo: gatedLine.bottomAnchor, constant: 5).isActive = true
        streetImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        streetImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        streetImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(streetIconLabel)
        streetIconLabel.leftAnchor.constraint(equalTo: streetImageView.rightAnchor, constant: 24).isActive = true
        streetIconLabel.centerYAnchor.constraint(equalTo: streetImageView.centerYAnchor).isActive = true
        streetIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        streetIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(streetLine)
        streetLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        streetLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        streetAnchor = streetLine.topAnchor.constraint(equalTo: streetIconLabel.bottomAnchor, constant: 5)
        streetAnchor.isActive = true
        streetLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        setupBusinessViews()
    }
    
    func setupBusinessViews() {
        
        scrollView.addSubview(parkinglotImageView)
        parkinglotImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        parkinglotImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        parkinglotImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        parkinglotImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(parkinglotIconLabel)
        parkinglotIconLabel.leftAnchor.constraint(equalTo: parkinglotImageView.rightAnchor, constant: 24).isActive = true
        parkinglotIconLabel.centerYAnchor.constraint(equalTo: parkinglotImageView.centerYAnchor).isActive = true
        parkinglotIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        parkinglotIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(parkinglotLine)
        parkinglotLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkinglotLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        parkinglotAnchor = parkinglotLine.topAnchor.constraint(equalTo: parkinglotIconLabel.bottomAnchor, constant: 100)
        parkinglotAnchor.isActive = true
        parkinglotLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(garageImageView)
        garageImageView.topAnchor.constraint(equalTo: parkinglotLine.bottomAnchor, constant: 5).isActive = true
        garageImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        garageImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        garageImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(garageIconLabel)
        garageIconLabel.leftAnchor.constraint(equalTo: garageImageView.rightAnchor, constant: 24).isActive = true
        garageIconLabel.centerYAnchor.constraint(equalTo: garageImageView.centerYAnchor).isActive = true
        garageIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        garageIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(garageLine)
        garageLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        garageLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        garageAnchor = garageLine.topAnchor.constraint(equalTo: garageIconLabel.bottomAnchor, constant: 5)
        garageAnchor.isActive = true
        garageLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(undergroundImageView)
        undergroundImageView.topAnchor.constraint(equalTo: garageLine.bottomAnchor, constant: 5).isActive = true
        undergroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        undergroundImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        undergroundImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(undergroundIconLabel)
        undergroundIconLabel.leftAnchor.constraint(equalTo: undergroundImageView.rightAnchor, constant: 24).isActive = true
        undergroundIconLabel.centerYAnchor.constraint(equalTo: undergroundImageView.centerYAnchor).isActive = true
        undergroundIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        undergroundIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(undergroundLine)
        undergroundLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        undergroundLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        undergroundAnchor = undergroundLine.topAnchor.constraint(equalTo: undergroundIconLabel.bottomAnchor, constant: 5)
        undergroundAnchor.isActive = true
        undergroundLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(condoImageView)
        condoImageView.topAnchor.constraint(equalTo: undergroundLine.bottomAnchor, constant: 5).isActive = true
        condoImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        condoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        condoImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(condoIconLabel)
        condoIconLabel.leftAnchor.constraint(equalTo: condoImageView.rightAnchor, constant: 24).isActive = true
        condoIconLabel.centerYAnchor.constraint(equalTo: condoImageView.centerYAnchor).isActive = true
        condoIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        condoIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(condoLine)
        condoLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        condoLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        condoAnchor = condoLine.topAnchor.constraint(equalTo: condoIconLabel.bottomAnchor, constant: 5)
        condoAnchor.isActive = true
        condoLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(circularImageView)
        circularImageView.topAnchor.constraint(equalTo: condoLine.bottomAnchor, constant: 5).isActive = true
        circularImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        circularImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        circularImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(circularIconLabel)
        circularIconLabel.leftAnchor.constraint(equalTo: circularImageView.rightAnchor, constant: 24).isActive = true
        circularIconLabel.centerYAnchor.constraint(equalTo: circularImageView.centerYAnchor).isActive = true
        circularIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        circularIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(circularLine)
        circularLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        circularLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        circularAnchor = circularLine.topAnchor.constraint(equalTo: circularIconLabel.bottomAnchor, constant: 5)
        circularAnchor.isActive = true
        circularLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        setupExtraInformation()
    }
    
    func setupExtraInformation() {
        
        scrollView.addSubview(drivewayInformation)
        drivewayInformation.leftAnchor.constraint(equalTo: drivewayIconLabel.leftAnchor).isActive = true
        drivewayInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        drivewayInformation.topAnchor.constraint(equalTo: drivewayIconLabel.bottomAnchor, constant: -10).isActive = true
        drivewayInformation.bottomAnchor.constraint(equalTo: drivewayLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(sharedlotInformation)
        sharedlotInformation.leftAnchor.constraint(equalTo: sharedlotIconLabel.leftAnchor).isActive = true
        sharedlotInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        sharedlotInformation.topAnchor.constraint(equalTo: sharedlotIconLabel.bottomAnchor, constant: -10).isActive = true
        sharedlotInformation.bottomAnchor.constraint(equalTo: sharedlotLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(sharedCoverInformation)
        sharedCoverInformation.leftAnchor.constraint(equalTo: sharedCoverIconLabel.leftAnchor).isActive = true
        sharedCoverInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        sharedCoverInformation.topAnchor.constraint(equalTo: sharedCoverIconLabel.bottomAnchor, constant: -10).isActive = true
        sharedCoverInformation.bottomAnchor.constraint(equalTo: sharedCoverLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(alleyInformation)
        alleyInformation.leftAnchor.constraint(equalTo: alleyIconLabel.leftAnchor).isActive = true
        alleyInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        alleyInformation.topAnchor.constraint(equalTo: alleyIconLabel.bottomAnchor, constant: -10).isActive = true
        alleyInformation.bottomAnchor.constraint(equalTo: alleyLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(gatedInformation)
        gatedInformation.leftAnchor.constraint(equalTo: gatedIconLabel.leftAnchor).isActive = true
        gatedInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        gatedInformation.topAnchor.constraint(equalTo: gatedIconLabel.bottomAnchor, constant: -10).isActive = true
        gatedInformation.bottomAnchor.constraint(equalTo: gatedLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(streetInformation)
        streetInformation.leftAnchor.constraint(equalTo: streetIconLabel.leftAnchor).isActive = true
        streetInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        streetInformation.topAnchor.constraint(equalTo: streetIconLabel.bottomAnchor, constant: -10).isActive = true
        streetInformation.bottomAnchor.constraint(equalTo: streetLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(parkinglotInformation)
        parkinglotInformation.leftAnchor.constraint(equalTo: parkinglotIconLabel.leftAnchor).isActive = true
        parkinglotInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkinglotInformation.topAnchor.constraint(equalTo: parkinglotIconLabel.bottomAnchor, constant: -10).isActive = true
        parkinglotInformation.bottomAnchor.constraint(equalTo: parkinglotLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(garageInformation)
        garageInformation.leftAnchor.constraint(equalTo: garageIconLabel.leftAnchor).isActive = true
        garageInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        garageInformation.topAnchor.constraint(equalTo: garageIconLabel.bottomAnchor, constant: -10).isActive = true
        garageInformation.bottomAnchor.constraint(equalTo: garageLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(undergroundInformation)
        undergroundInformation.leftAnchor.constraint(equalTo: undergroundIconLabel.leftAnchor).isActive = true
        undergroundInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        undergroundInformation.topAnchor.constraint(equalTo: undergroundIconLabel.bottomAnchor, constant: -10).isActive = true
        undergroundInformation.bottomAnchor.constraint(equalTo: undergroundLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(condoInformation)
        condoInformation.leftAnchor.constraint(equalTo: condoIconLabel.leftAnchor).isActive = true
        condoInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        condoInformation.topAnchor.constraint(equalTo: condoIconLabel.bottomAnchor, constant: -10).isActive = true
        condoInformation.bottomAnchor.constraint(equalTo: condoLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(circularInformation)
        circularInformation.leftAnchor.constraint(equalTo: circularIconLabel.leftAnchor).isActive = true
        circularInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        circularInformation.topAnchor.constraint(equalTo: circularIconLabel.bottomAnchor, constant: -10).isActive = true
        circularInformation.bottomAnchor.constraint(equalTo: circularLine.topAnchor, constant: -12).isActive = true
        
        setupCheckmark()
    }
    
    func setupCheckmark() {
        
        scrollView.addSubview(checkmark)
        checkmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        checkDrivewayAnchor = checkmark.centerYAnchor.constraint(equalTo: drivewayIconLabel.centerYAnchor)
        checkDrivewayAnchor.isActive = true
        
        checkSharedLotAnchor = checkmark.centerYAnchor.constraint(equalTo: sharedlotIconLabel.centerYAnchor)
        checkSharedLotAnchor.isActive = false
        checkSharedGarageAnchor = checkmark.centerYAnchor.constraint(equalTo: sharedCoverIconLabel.centerYAnchor)
        checkSharedGarageAnchor.isActive = false
        checkAlleyAnchor = checkmark.centerYAnchor.constraint(equalTo: alleyIconLabel.centerYAnchor)
        checkAlleyAnchor.isActive = false
        checkGatedAnchor = checkmark.centerYAnchor.constraint(equalTo: gatedIconLabel.centerYAnchor)
        checkGatedAnchor.isActive = false
        checkStreetAnchor = checkmark.centerYAnchor.constraint(equalTo: streetIconLabel.centerYAnchor)
        checkStreetAnchor.isActive = false
        
        checkParkingLotAnchor = checkmark.centerYAnchor.constraint(equalTo: parkinglotIconLabel.centerYAnchor)
        checkParkingLotAnchor.isActive = false
        checkGarageAnchor = checkmark.centerYAnchor.constraint(equalTo: garageIconLabel.centerYAnchor)
        checkGarageAnchor.isActive = false
        checkUndergroundAnchor = checkmark.centerYAnchor.constraint(equalTo: undergroundIconLabel.centerYAnchor)
        checkUndergroundAnchor.isActive = false
        checkCondoAnchor = checkmark.centerYAnchor.constraint(equalTo: condoIconLabel.centerYAnchor)
        checkCondoAnchor.isActive = false
        checkCircularAnchor = checkmark.centerYAnchor.constraint(equalTo: circularIconLabel.centerYAnchor)
        checkCircularAnchor.isActive = false

        self.previousCheckAnchor = checkDrivewayAnchor
    }
}


///////HANDLE SELECTION////////////////////////////////////////////////////////////////////////////////////
extension ParkingOptionsViewController {
    @objc func optionTapped(sender: UIButton) {
        if sender == drivewayIconLabel {
            self.parkingType = "driveway"
            UIView.animate(withDuration: 0.1) {
                self.drivewayIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.drivewayIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.drivewayImageView.tintColor = Theme.PACIFIC_BLUE
                self.drivewayImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.drivewayAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkDrivewayAnchor)
            }
        } else if sender == sharedlotIconLabel {
            self.parkingType = "sharedLot"
            UIView.animate(withDuration: 0.1) {
                self.sharedlotIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.sharedlotIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.sharedlotImageView.tintColor = Theme.PACIFIC_BLUE
                self.sharedlotImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.sharedlotAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkSharedLotAnchor)
            }
        } else if sender == alleyIconLabel {
            self.parkingType = "alley"
            UIView.animate(withDuration: 0.1) {
                self.alleyIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.alleyIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.alleyImageView.tintColor = Theme.PACIFIC_BLUE
                self.alleyImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.alleyAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkAlleyAnchor)
            }
        } else if sender == sharedCoverIconLabel {
            self.parkingType = "sharedCover"
            UIView.animate(withDuration: 0.1) {
                self.sharedCoverIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.sharedCoverIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.sharedCoverImageView.tintColor = Theme.PACIFIC_BLUE
                self.sharedCoverImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.sharedGarageAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkSharedGarageAnchor)
            }
        } else if sender == gatedIconLabel {
            self.parkingType = "gated"
            UIView.animate(withDuration: 0.1) {
                self.gatedIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.gatedIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.gatedImageView.tintColor = Theme.PACIFIC_BLUE
                self.gatedImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.gatedAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkGatedAnchor)
            }
        } else if sender == streetIconLabel {
            self.parkingType = "street"
            UIView.animate(withDuration: 0.1) {
                self.streetIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.streetIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.streetImageView.tintColor = Theme.PACIFIC_BLUE
                self.streetImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.streetAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkStreetAnchor)
            }
        } else if sender == parkinglotIconLabel {
            self.parkingType = "parkingLot"
            UIView.animate(withDuration: 0.1) {
                self.parkinglotIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.parkinglotIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.parkinglotImageView.tintColor = Theme.PACIFIC_BLUE
                self.parkinglotImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.parkinglotAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkParkingLotAnchor)
            }
        } else if sender == garageIconLabel {
            self.parkingType = "garage"
            UIView.animate(withDuration: 0.1) {
                self.garageIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.garageIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.garageImageView.tintColor = Theme.PACIFIC_BLUE
                self.garageImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.garageAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkGarageAnchor)
            }
        } else if sender == undergroundIconLabel {
            self.parkingType = "underground"
            UIView.animate(withDuration: 0.1) {
                self.undergroundIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.undergroundIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.undergroundImageView.tintColor = Theme.PACIFIC_BLUE
                self.undergroundImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.undergroundAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkUndergroundAnchor)
            }
        } else if sender == condoIconLabel {
            self.parkingType = "condo"
            UIView.animate(withDuration: 0.1) {
                self.condoIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.condoIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.condoImageView.tintColor = Theme.PACIFIC_BLUE
                self.condoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.condoAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkCondoAnchor)
            }
        } else if sender == circularIconLabel {
            self.parkingType = "circular"
            UIView.animate(withDuration: 0.1) {
                self.circularIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.circularIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.circularImageView.tintColor = Theme.PACIFIC_BLUE
                self.circularImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.circularAnchor.constant = 100
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
                self.checkMarkSwitched(checkAnchor: self.checkCircularAnchor)
            }
        }
    }
    
    func checkMarkSwitched(checkAnchor: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.2, animations: {
            self.checkmark.alpha = 0
        }) { (success) in
            self.previousCheckAnchor.isActive = false
            self.view.layoutIfNeeded()
            checkAnchor.isActive = true
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.checkmark.alpha = 1
            })
            self.previousCheckAnchor = checkAnchor
        }
    }
}


///////RESET OPTIONS////////////////////////////////////////////////////////////////////////////////////
extension ParkingOptionsViewController {
    func resetDriveway() {
        UIView.animate(withDuration: 0.1) {
            self.drivewayIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.drivewayIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.drivewayImageView.tintColor = Theme.DARK_GRAY
            self.drivewayImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.drivewayAnchor.constant = 5
            self.drivewayInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetSharedLot() {
        UIView.animate(withDuration: 0.1) {
            self.sharedlotIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.sharedlotIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.sharedlotImageView.tintColor = Theme.DARK_GRAY
            self.sharedlotImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.sharedlotAnchor.constant = 5
            self.sharedlotInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetSharedCover() {
        UIView.animate(withDuration: 0.1) {
            self.sharedCoverIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.sharedCoverIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.sharedCoverImageView.tintColor = Theme.DARK_GRAY
            self.sharedCoverImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.sharedGarageAnchor.constant = 5
            self.sharedCoverInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetAlley() {
        UIView.animate(withDuration: 0.1) {
            self.alleyIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.alleyIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.alleyImageView.tintColor = Theme.DARK_GRAY
            self.alleyImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alleyAnchor.constant = 5
            self.alleyInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetGated() {
        UIView.animate(withDuration: 0.1) {
            self.gatedIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.gatedIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.gatedImageView.tintColor = Theme.DARK_GRAY
            self.gatedImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gatedAnchor.constant = 5
            self.gatedInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetStreet() {
        UIView.animate(withDuration: 0.1) {
            self.streetIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.streetIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.streetImageView.tintColor = Theme.DARK_GRAY
            self.streetImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.streetAnchor.constant = 5
            self.streetInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetParkingLot() {
        UIView.animate(withDuration: 0.1) {
            self.parkinglotIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.parkinglotIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.parkinglotImageView.tintColor = Theme.DARK_GRAY
            self.parkinglotImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.parkinglotAnchor.constant = 5
            self.parkinglotInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetGarage() {
        UIView.animate(withDuration: 0.1) {
            self.garageIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.garageIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.garageImageView.tintColor = Theme.DARK_GRAY
            self.garageImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.garageAnchor.constant = 5
            self.garageInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetUnderground() {
        UIView.animate(withDuration: 0.1) {
            self.undergroundIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.undergroundIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.undergroundImageView.tintColor = Theme.DARK_GRAY
            self.undergroundImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.undergroundAnchor.constant = 5
            self.undergroundInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetCondo() {
        UIView.animate(withDuration: 0.1) {
            self.condoIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.condoIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.condoImageView.tintColor = Theme.DARK_GRAY
            self.condoImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.condoAnchor.constant = 5
            self.condoInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func resetCircular() {
        UIView.animate(withDuration: 0.1) {
            self.circularIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.circularIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.circularImageView.tintColor = Theme.DARK_GRAY
            self.circularImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.circularAnchor.constant = 5
            self.circularInformation.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}
