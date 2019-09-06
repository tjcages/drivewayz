//
//  CurrentDetailsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class CurrentDetailsView: UIViewController {
    
    var delegate: handleCurrentBooking?
    var extensionDynamicPrice: CGFloat?
    var options: [BookingOptions] = [BookingOptions(mainText: "Extend parking duration", subText: "$4.23 per hour", iconImage: UIImage(named: "setTimeIcon")?.withRenderingMode(.alwaysTemplate)), BookingOptions(mainText: "Have an issue?", subText: nil, iconImage: UIImage(named: "issueIcon")?.withRenderingMode(.alwaysTemplate))] {
        didSet {
            self.optionsTableView.reloadData()
        }
    }
    
    var secondaryType: String = "driveway" {
        didSet {
            if secondaryType == "driveway" {
                let image = UIImage(named: "Residential Home Driveway")
                self.spotIcon.image = image
            } else if secondaryType == "parking lot" {
                let image = UIImage(named: "Parking Lot")
                self.spotIcon.image = image
            } else if secondaryType == "apartment" {
                let image = UIImage(named: "Apartment Parking")
                self.spotIcon.image = image
            } else if secondaryType == "alley" {
                let image = UIImage(named: "Alley Parking")
                self.spotIcon.image = image
            } else if secondaryType == "garage" {
                let image = UIImage(named: "Parking Garage")
                self.spotIcon.image = image
            } else if secondaryType == "gated spot" {
                let image = UIImage(named: "Gated Spot")
                self.spotIcon.image = image
            } else if secondaryType == "street spot" {
                let image = UIImage(named: "Street Parking")
                self.spotIcon.image = image
            } else if secondaryType == "underground spot" {
                let image = UIImage(named: "UnderGround Parking")
                self.spotIcon.image = image
            } else if secondaryType == "condo" {
                let image = UIImage(named: "Residential Home Driveway")
                self.spotIcon.image = image
            } else if secondaryType == "circular" {
                let image = UIImage(named: "Other Parking")
                self.spotIcon.image = image
            }
        }
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Currently Parked"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        button.setTitle("Share Location", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.alpha = 0
        
        return button
    }()
    
    var shareIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "sharingIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.alpha = 0
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 40
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        
        return view
    }()
    
    var starView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 14
        view.alpha = 0
        
        return view
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.totalStars = 1
        view.settings.updateOnTouch = false
        view.settings.starSize = 14
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.WHITE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.text = "4.80"
        view.settings.textFont = Fonts.SSPSemiBoldH5
        view.settings.textColor = Theme.WHITE
        view.settings.textMargin = 8
        view.settings.filledImage = UIImage(named: "Star Filled White")
        
        return view
    }()

    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 Car Driveway"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var subSpotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Residential space"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 4
        button.setTitle("Leave at 9:30pm", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return button
    }()
    
    var transferButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "openDots")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BookingOptionsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.separatorStyle = .none
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
        setupDetails()
        setupOptions()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        view.addSubview(shareButton)
        shareButton.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        shareButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        shareButton.sizeToFit()
        
        view.addSubview(shareIcon)
        shareIcon.rightAnchor.constraint(equalTo: shareButton.leftAnchor, constant: -4).isActive = true
        shareIcon.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor).isActive = true
        shareIcon.widthAnchor.constraint(equalTo: shareIcon.heightAnchor).isActive = true
        shareIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(line)
        line.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20).isActive = true
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    var spotLabelBottomAnchor: NSLayoutConstraint!
    
    func setupDetails() {
        
        view.addSubview(spotIcon)
        spotIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        spotIcon.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        view.addSubview(starView)
        starView.centerXAnchor.constraint(equalTo: spotIcon.centerXAnchor).isActive = true
        starView.centerYAnchor.constraint(equalTo: spotIcon.bottomAnchor).isActive = true
        starView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        starView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        starView.addSubview(stars)
        stars.centerXAnchor.constraint(equalTo: starView.centerXAnchor).isActive = true
        stars.centerYAnchor.constraint(equalTo: starView.centerYAnchor, constant: 1).isActive = true
        stars.sizeToFit()
        
        view.addSubview(spotLabel)
        spotLabelBottomAnchor = spotLabel.bottomAnchor.constraint(equalTo: spotIcon.centerYAnchor, constant: -20)
            spotLabelBottomAnchor.isActive = true
        spotLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 16).isActive = true
        spotLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48).isActive = true
        spotLabel.sizeToFit()
        
        view.addSubview(subSpotLabel)
        subSpotLabel.topAnchor.constraint(equalTo: spotLabel.bottomAnchor, constant: 0).isActive = true
        subSpotLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 16).isActive = true
        subSpotLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48).isActive = true
        subSpotLabel.sizeToFit()
        
        view.addSubview(durationButton)
        durationButton.leftAnchor.constraint(equalTo: spotLabel.leftAnchor).isActive = true
        durationButton.topAnchor.constraint(equalTo: subSpotLabel.bottomAnchor, constant: 8).isActive = true
        durationButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        durationButton.widthAnchor.constraint(equalToConstant: 156).isActive = true
        
        view.addSubview(transferButton)
        transferButton.centerYAnchor.constraint(equalTo: spotLabel.centerYAnchor).isActive = true
        transferButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: 6).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: 24).isActive = true

    }
    
    func setupOptions() {
        
        view.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 24).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func changeScrollAmount(percentage: CGFloat) {
        spotLabelBottomAnchor.constant = -12 + 4 * percentage
    }
    
    @objc func openCurrentBooking() {
        spotLabelBottomAnchor.constant = -8
        UIView.animate(withDuration: animationOut) {
            self.starView.alpha = 1
            self.starView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.layoutIfNeeded()
        }
    }
    
    func closeCurrentBooking() {
        spotLabelBottomAnchor.constant = -12
        UIView.animate(withDuration: animationOut) {
            self.starView.alpha = 0
            self.starView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.view.layoutIfNeeded()
        }
    }

}

extension CurrentDetailsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookingOptionsCell
        cell.selectionStyle = .none
        
        if indexPath.row < options.count {
            cell.option = options[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! BookingOptionsCell
        if cell.mainLabel.text == "Have an issue?" {
            delegate?.parkingSpotOptionsPressed()
        } else if cell.mainLabel.text == "Extend parking duration" {
            delegate?.extendDurationPressed()
        }
    }
    
}

