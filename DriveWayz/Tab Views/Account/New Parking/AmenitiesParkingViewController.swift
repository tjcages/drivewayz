//
//  AmenitiesParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class AmenitiesParkingViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var coveredImageView: UIImageView = {
        let image = UIImage(named: "coveredParkingIcon-1")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var coveredIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Covered parking", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    lazy var coveredCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var coveredLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var chargingImageView: UIImageView = {
        let image = UIImage(named: "chargingParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var chargingIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Charging station", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var chargingCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var chargingLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var gatedImageView: UIImageView = {
        let image = UIImage(named: "gateParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var gatedIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Gated spot", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var gatedCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var gatedLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var stadiumImageView: UIImageView = {
        let image = UIImage(named: "stadiumParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var stadiumIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Stadium parking", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var stadiumCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var stadiumLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var nightImageView: UIImageView = {
        let image = UIImage(named: "nightParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var nightIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Nighttime parking", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var nightCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var nightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var airportImageView: UIImageView = {
        let image = UIImage(named: "airportParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var airportIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Near Airport", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var airportCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var airportLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var lightedImageView: UIImageView = {
        let image = UIImage(named: "lightingParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var lightedIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Lit space", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var lightCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var lightedLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var largeImageView: UIImageView = {
        let image = UIImage(named: "largeParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var largeIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Large space", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var largeCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var largeLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var smallImageView: UIImageView = {
        let image = UIImage(named: "smallParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var smallIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Compact space", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var smallCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var smallLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var easyImageView: UIImageView = {
        let image = UIImage(named: "easyParkingIcon")
        let view = UIImageView(image: image)
        view.image = view.image!.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var easyIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Easy to find", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var easyCheckmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.OFF_WHITE
        
        return button
    }()
    
    var easyLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var coveredInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Our most common parking space. The spot is usually owned or leased by the host and can be a driveway or shared parking lot."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var chargingInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A parking space that is owned by the property owner and leased by then tennant. Usually associated with one spot number in a lot."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var gatedInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Parking outside a residential home or apartment complex and on the main street, susceptible to other traffic."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var stadiumInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Covered parking is usually when the parking spot is in a parking garage, but can also be if the spot is covered by a patio or deck."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var nightInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "A large area for parking with multiple parking spaces for customers. Must own the parking lot to list with Drivewayz."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var airportInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Only select this option if your parking spot is in between two buildings or behind a residential home and it is generally described as in an alley."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var lightingInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var largeInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var smallInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    var easyInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If your parking space is in a gated complex. To list your spot through Drivewayz you must provide a gate code and a spot number."
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.alpha = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    var coveredAnchor: NSLayoutConstraint!
    var chargingAnchor: NSLayoutConstraint!
    var gatedAnchor: NSLayoutConstraint!
    var stadiumAnchor: NSLayoutConstraint!
    var nightAnchor: NSLayoutConstraint!
    var airportAnchor: NSLayoutConstraint!
    var lightingAnchor: NSLayoutConstraint!
    var largeAnchor: NSLayoutConstraint!
    var smallAnchor: NSLayoutConstraint!
    var easyAnchor: NSLayoutConstraint!
    
    func checkmarkPressed(bool: Bool, sender: UIButton) {
        if bool == true {
            UIView.animate(withDuration: 0.1, animations: {
                sender.tintColor = Theme.WHITE
                sender.backgroundColor = Theme.GREEN_PIGMENT
                sender.layer.borderColor = Theme.GREEN_PIGMENT.cgColor
            }) { (success) in
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                sender.tintColor = .clear
                sender.backgroundColor = Theme.OFF_WHITE
                sender.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
            }) { (success) in
            }
        }
    }
    
}

///////HANDLE CONSTRAINTS///////////////////////////////////////////////////////////////////////////////////
extension AmenitiesParkingViewController {
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 650)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(coveredImageView)
        coveredImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        coveredImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        coveredImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        coveredImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(coveredCheckmark)
        coveredCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        coveredCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        coveredCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        coveredCheckmark.centerYAnchor.constraint(equalTo: coveredImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(coveredIconLabel)
        coveredIconLabel.leftAnchor.constraint(equalTo: coveredImageView.rightAnchor, constant: 24).isActive = true
        coveredIconLabel.centerYAnchor.constraint(equalTo: coveredImageView.centerYAnchor).isActive = true
        coveredIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        coveredIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(coveredLine)
        coveredLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        coveredLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        coveredAnchor = coveredLine.topAnchor.constraint(equalTo: coveredIconLabel.bottomAnchor, constant: 5)
        coveredAnchor.isActive = true
        coveredLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(chargingImageView)
        chargingImageView.topAnchor.constraint(equalTo: coveredLine.bottomAnchor, constant: 10).isActive = true
        chargingImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        chargingImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        chargingImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(chargingCheckmark)
        chargingCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        chargingCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        chargingCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        chargingCheckmark.centerYAnchor.constraint(equalTo: chargingImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(chargingIconLabel)
        chargingIconLabel.leftAnchor.constraint(equalTo: chargingImageView.rightAnchor, constant: 24).isActive = true
        chargingIconLabel.centerYAnchor.constraint(equalTo: chargingImageView.centerYAnchor).isActive = true
        chargingIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        chargingIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(chargingLine)
        chargingLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        chargingLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        chargingAnchor = chargingLine.topAnchor.constraint(equalTo: chargingIconLabel.bottomAnchor, constant: 5)
        chargingAnchor.isActive = true
        chargingLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(gatedImageView)
        gatedImageView.topAnchor.constraint(equalTo: chargingLine.bottomAnchor, constant: 5).isActive = true
        gatedImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        gatedImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gatedImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(gatedCheckmark)
        gatedCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        gatedCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        gatedCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gatedCheckmark.centerYAnchor.constraint(equalTo: gatedImageView.centerYAnchor).isActive = true
        
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
        
        scrollView.addSubview(stadiumImageView)
        stadiumImageView.topAnchor.constraint(equalTo: gatedLine.bottomAnchor, constant: 5).isActive = true
        stadiumImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stadiumImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stadiumImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(stadiumCheckmark)
        stadiumCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        stadiumCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        stadiumCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stadiumCheckmark.centerYAnchor.constraint(equalTo: stadiumImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(stadiumIconLabel)
        stadiumIconLabel.leftAnchor.constraint(equalTo: stadiumImageView.rightAnchor, constant: 24).isActive = true
        stadiumIconLabel.centerYAnchor.constraint(equalTo: stadiumImageView.centerYAnchor).isActive = true
        stadiumIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stadiumIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(stadiumLine)
        stadiumLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stadiumLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        stadiumAnchor = stadiumLine.topAnchor.constraint(equalTo: stadiumIconLabel.bottomAnchor, constant: 5)
        stadiumAnchor.isActive = true
        stadiumLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(nightImageView)
        nightImageView.topAnchor.constraint(equalTo: stadiumLine.bottomAnchor, constant: 5).isActive = true
        nightImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        nightImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nightImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(nightCheckmark)
        nightCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nightCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        nightCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nightCheckmark.centerYAnchor.constraint(equalTo: nightImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(nightIconLabel)
        nightIconLabel.leftAnchor.constraint(equalTo: nightImageView.rightAnchor, constant: 24).isActive = true
        nightIconLabel.centerYAnchor.constraint(equalTo: nightImageView.centerYAnchor).isActive = true
        nightIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        nightIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(nightLine)
        nightLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nightLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        nightAnchor = nightLine.topAnchor.constraint(equalTo: nightIconLabel.bottomAnchor, constant: 5)
        nightAnchor.isActive = true
        nightLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(airportImageView)
        airportImageView.topAnchor.constraint(equalTo: nightLine.bottomAnchor, constant: 5).isActive = true
        airportImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        airportImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        airportImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(airportCheckmark)
        airportCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        airportCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        airportCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        airportCheckmark.centerYAnchor.constraint(equalTo: airportImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(airportIconLabel)
        airportIconLabel.leftAnchor.constraint(equalTo: airportImageView.rightAnchor, constant: 24).isActive = true
        airportIconLabel.centerYAnchor.constraint(equalTo: airportImageView.centerYAnchor).isActive = true
        airportIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        airportIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(airportLine)
        airportLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        airportLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        airportAnchor = airportLine.topAnchor.constraint(equalTo: airportIconLabel.bottomAnchor, constant: 5)
        airportAnchor.isActive = true
        airportLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(lightedImageView)
        lightedImageView.topAnchor.constraint(equalTo: airportLine.bottomAnchor, constant: 5).isActive = true
        lightedImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lightedImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lightedImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(lightCheckmark)
        lightCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        lightCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        lightCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lightCheckmark.centerYAnchor.constraint(equalTo: lightedImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(lightedIconLabel)
        lightedIconLabel.leftAnchor.constraint(equalTo: lightedImageView.rightAnchor, constant: 24).isActive = true
        lightedIconLabel.centerYAnchor.constraint(equalTo: lightedImageView.centerYAnchor).isActive = true
        lightedIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lightedIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(lightedLine)
        lightedLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lightedLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        lightingAnchor = lightedLine.topAnchor.constraint(equalTo: lightedIconLabel.bottomAnchor, constant: 5)
        lightingAnchor.isActive = true
        lightedLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(largeImageView)
        largeImageView.topAnchor.constraint(equalTo: lightedLine.bottomAnchor, constant: 5).isActive = true
        largeImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        largeImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        largeImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(largeCheckmark)
        largeCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        largeCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        largeCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        largeCheckmark.centerYAnchor.constraint(equalTo: largeImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(largeIconLabel)
        largeIconLabel.leftAnchor.constraint(equalTo: largeImageView.rightAnchor, constant: 24).isActive = true
        largeIconLabel.centerYAnchor.constraint(equalTo: largeImageView.centerYAnchor).isActive = true
        largeIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        largeIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(largeLine)
        largeLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        largeLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        largeAnchor = largeLine.topAnchor.constraint(equalTo: largeIconLabel.bottomAnchor, constant: 5)
        largeAnchor.isActive = true
        largeLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(smallImageView)
        smallImageView.topAnchor.constraint(equalTo: largeLine.bottomAnchor, constant: 5).isActive = true
        smallImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        smallImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        smallImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(smallCheckmark)
        smallCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        smallCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        smallCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        smallCheckmark.centerYAnchor.constraint(equalTo: smallImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(smallIconLabel)
        smallIconLabel.leftAnchor.constraint(equalTo: smallImageView.rightAnchor, constant: 24).isActive = true
        smallIconLabel.centerYAnchor.constraint(equalTo: smallImageView.centerYAnchor).isActive = true
        smallIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        smallIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(smallLine)
        smallLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        smallLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        smallAnchor = smallLine.topAnchor.constraint(equalTo: smallIconLabel.bottomAnchor, constant: 5)
        smallAnchor.isActive = true
        smallLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(easyImageView)
        easyImageView.topAnchor.constraint(equalTo: smallLine.bottomAnchor, constant: 5).isActive = true
        easyImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        easyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        easyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(easyCheckmark)
        easyCheckmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        easyCheckmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        easyCheckmark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        easyCheckmark.centerYAnchor.constraint(equalTo: easyImageView.centerYAnchor).isActive = true
        
        scrollView.addSubview(easyIconLabel)
        easyIconLabel.leftAnchor.constraint(equalTo: easyImageView.rightAnchor, constant: 24).isActive = true
        easyIconLabel.centerYAnchor.constraint(equalTo: easyImageView.centerYAnchor).isActive = true
        easyIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        easyIconLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(easyLine)
        easyLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        easyLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        easyAnchor = easyLine.topAnchor.constraint(equalTo: easyIconLabel.bottomAnchor, constant: 5)
        easyAnchor.isActive = true
        easyLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        setupExtraInformation()
    }
    
    func setupExtraInformation() {
        
        scrollView.addSubview(coveredInformation)
        coveredInformation.leftAnchor.constraint(equalTo: coveredIconLabel.leftAnchor).isActive = true
        coveredInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        coveredInformation.topAnchor.constraint(equalTo: coveredIconLabel.bottomAnchor, constant: -10).isActive = true
        coveredInformation.bottomAnchor.constraint(equalTo: coveredLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(chargingInformation)
        chargingInformation.leftAnchor.constraint(equalTo: chargingIconLabel.leftAnchor).isActive = true
        chargingInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        chargingInformation.topAnchor.constraint(equalTo: chargingIconLabel.bottomAnchor, constant: -10).isActive = true
        chargingInformation.bottomAnchor.constraint(equalTo: chargingLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(gatedInformation)
        gatedInformation.leftAnchor.constraint(equalTo: gatedIconLabel.leftAnchor).isActive = true
        gatedInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        gatedInformation.topAnchor.constraint(equalTo: gatedIconLabel.bottomAnchor, constant: -10).isActive = true
        gatedInformation.bottomAnchor.constraint(equalTo: gatedLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(stadiumInformation)
        stadiumInformation.leftAnchor.constraint(equalTo: stadiumIconLabel.leftAnchor).isActive = true
        stadiumInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        stadiumInformation.topAnchor.constraint(equalTo: stadiumIconLabel.bottomAnchor, constant: -10).isActive = true
        stadiumInformation.bottomAnchor.constraint(equalTo: stadiumLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(nightInformation)
        nightInformation.leftAnchor.constraint(equalTo: nightIconLabel.leftAnchor).isActive = true
        nightInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nightInformation.topAnchor.constraint(equalTo: nightIconLabel.bottomAnchor, constant: -10).isActive = true
        nightInformation.bottomAnchor.constraint(equalTo: nightLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(airportInformation)
        airportInformation.leftAnchor.constraint(equalTo: airportIconLabel.leftAnchor).isActive = true
        airportInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        airportInformation.topAnchor.constraint(equalTo: airportIconLabel.bottomAnchor, constant: -10).isActive = true
        airportInformation.bottomAnchor.constraint(equalTo: airportLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(lightingInformation)
        lightingInformation.leftAnchor.constraint(equalTo: lightedIconLabel.leftAnchor).isActive = true
        lightingInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        lightingInformation.topAnchor.constraint(equalTo: lightedIconLabel.bottomAnchor, constant: -10).isActive = true
        lightingInformation.bottomAnchor.constraint(equalTo: lightedLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(largeInformation)
        largeInformation.leftAnchor.constraint(equalTo: largeIconLabel.leftAnchor).isActive = true
        largeInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        largeInformation.topAnchor.constraint(equalTo: largeIconLabel.bottomAnchor, constant: -10).isActive = true
        largeInformation.bottomAnchor.constraint(equalTo: largeLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(smallInformation)
        smallInformation.leftAnchor.constraint(equalTo: smallIconLabel.leftAnchor).isActive = true
        smallInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        smallInformation.topAnchor.constraint(equalTo: smallIconLabel.bottomAnchor, constant: -10).isActive = true
        smallInformation.bottomAnchor.constraint(equalTo: smallLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(easyInformation)
        easyInformation.leftAnchor.constraint(equalTo: easyIconLabel.leftAnchor).isActive = true
        easyInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        easyInformation.topAnchor.constraint(equalTo: easyIconLabel.bottomAnchor, constant: -10).isActive = true
        easyInformation.bottomAnchor.constraint(equalTo: easyLine.topAnchor, constant: -12).isActive = true
        
    }
}


///////HANDLE SELECTION////////////////////////////////////////////////////////////////////////////////////
extension AmenitiesParkingViewController {
    @objc func optionTapped(sender: UIButton) {
        if sender == coveredIconLabel {
            if coveredImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetHouse()
                self.checkmarkPressed(bool: false, sender: self.coveredCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.coveredCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.coveredIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.coveredIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.coveredImageView.tintColor = Theme.PACIFIC_BLUE
                self.coveredImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.coveredAnchor.constant = 100
                self.coveredInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == chargingIconLabel {
            if chargingImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetApartment()
                self.checkmarkPressed(bool: false, sender: self.chargingCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.chargingCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.chargingIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.chargingIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.chargingImageView.tintColor = Theme.PACIFIC_BLUE
                self.chargingImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.chargingAnchor.constant = 100
                self.chargingInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == stadiumIconLabel {
            if stadiumImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetCovered()
                self.checkmarkPressed(bool: false, sender: self.stadiumCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.stadiumCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.stadiumIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.stadiumIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.stadiumImageView.tintColor = Theme.PACIFIC_BLUE
                self.stadiumImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.stadiumAnchor.constant = 100
                self.stadiumInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == gatedIconLabel {
            if gatedImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetStreet()
                self.checkmarkPressed(bool: false, sender: self.gatedCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.gatedCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.gatedIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.gatedIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.gatedImageView.tintColor = Theme.PACIFIC_BLUE
                self.gatedImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.gatedAnchor.constant = 100
                self.gatedInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == nightIconLabel {
            if nightImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetLot()
                self.checkmarkPressed(bool: false, sender: self.nightCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.nightCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.nightIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.nightIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.nightImageView.tintColor = Theme.PACIFIC_BLUE
                self.nightImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.nightAnchor.constant = 100
                self.nightInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == airportIconLabel {
            if airportImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetAlley()
                self.checkmarkPressed(bool: false, sender: self.airportCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.airportCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.airportIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.airportIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.airportImageView.tintColor = Theme.PACIFIC_BLUE
                self.airportImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.airportAnchor.constant = 100
                self.airportInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == lightedIconLabel {
            if lightedImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetGated()
                self.checkmarkPressed(bool: false, sender: self.lightCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.lightCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.lightedIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.lightedIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.lightedImageView.tintColor = Theme.PACIFIC_BLUE
                self.lightedImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.lightingAnchor.constant = 100
                self.lightingInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == largeIconLabel {
            if largeImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetLarge()
                self.checkmarkPressed(bool: false, sender: self.largeCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.largeCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.largeIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.largeIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.largeImageView.tintColor = Theme.PACIFIC_BLUE
                self.largeImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.largeAnchor.constant = 100
                self.largeInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == smallIconLabel {
            if smallImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetSmall()
                self.checkmarkPressed(bool: false, sender: self.smallCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.smallCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.smallIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.smallIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.smallImageView.tintColor = Theme.PACIFIC_BLUE
                self.smallImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.smallAnchor.constant = 100
                self.smallInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == easyIconLabel {
            if easyImageView.tintColor == Theme.PACIFIC_BLUE {
                self.resetEasy()
                self.checkmarkPressed(bool: false, sender: self.easyCheckmark)
                return
            }
            self.checkmarkPressed(bool: true, sender: self.easyCheckmark)
            UIView.animate(withDuration: 0.1) {
                self.easyIconLabel.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
                self.easyIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                self.easyImageView.tintColor = Theme.PACIFIC_BLUE
                self.easyImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.easyAnchor.constant = 100
                self.easyInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        }
    }
}


///////RESET OPTIONS////////////////////////////////////////////////////////////////////////////////////
extension AmenitiesParkingViewController {
    func resetHouse() {
        UIView.animate(withDuration: 0.1) {
            self.coveredIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.coveredIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.coveredImageView.tintColor = Theme.DARK_GRAY
            self.coveredImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.coveredAnchor.constant = 5
            self.coveredInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetApartment() {
        UIView.animate(withDuration: 0.1) {
            self.chargingIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.chargingIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.chargingImageView.tintColor = Theme.DARK_GRAY
            self.chargingImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.chargingAnchor.constant = 5
            self.chargingInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetStreet() {
        UIView.animate(withDuration: 0.1) {
            self.gatedIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.gatedIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.gatedImageView.tintColor = Theme.DARK_GRAY
            self.gatedImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gatedAnchor.constant = 5
            self.gatedInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetCovered() {
        UIView.animate(withDuration: 0.1) {
            self.stadiumIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.stadiumIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.stadiumImageView.tintColor = Theme.DARK_GRAY
            self.stadiumImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.stadiumAnchor.constant = 5
            self.stadiumInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetLot() {
        UIView.animate(withDuration: 0.1) {
            self.nightIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.nightIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.nightImageView.tintColor = Theme.DARK_GRAY
            self.nightImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.nightAnchor.constant = 5
            self.nightInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetAlley() {
        UIView.animate(withDuration: 0.1) {
            self.airportIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.airportIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.airportImageView.tintColor = Theme.DARK_GRAY
            self.airportImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.airportAnchor.constant = 5
            self.airportInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetGated() {
        UIView.animate(withDuration: 0.1) {
            self.lightedIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.lightedIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.lightedImageView.tintColor = Theme.DARK_GRAY
            self.lightedImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.lightingAnchor.constant = 5
            self.lightingInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetLarge() {
        UIView.animate(withDuration: 0.1) {
            self.largeIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.largeIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.largeImageView.tintColor = Theme.DARK_GRAY
            self.largeImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.largeAnchor.constant = 5
            self.largeInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetSmall() {
        UIView.animate(withDuration: 0.1) {
            self.smallIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.smallIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.smallImageView.tintColor = Theme.DARK_GRAY
            self.smallImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.smallAnchor.constant = 5
            self.smallInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetEasy() {
        UIView.animate(withDuration: 0.1) {
            self.easyIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.easyIconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
            self.easyImageView.tintColor = Theme.DARK_GRAY
            self.easyImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.easyAnchor.constant = 5
            self.easyInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
}
