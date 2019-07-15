//
//  AmenitiesParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class AmenitiesParkingViewController: UIViewController {
    
    var selectedAmenities: [String] = []
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    var coveredImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "coveredParkingIcon-1")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.2
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var coveredIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Covered parking", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var coveredLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var chargingImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "chargingParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var chargingIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Charging station", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var chargingLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var gatedImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "gateParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var gatedIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Gated spot", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var gatedLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var stadiumImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "stadiumParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var stadiumIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Stadium parking", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()

    var stadiumLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var nightImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "nightParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var nightIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Nighttime parking", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var nightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var airportImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "airportParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var airportIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Near Airport", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var airportLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var lightedImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "lightingParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var lightedIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Lit space", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var lightedLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var largeImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "largeParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var largeIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Large space", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var largeLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var smallImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "smallParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var smallIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Compact space", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var smallLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var easyImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "easyParkingIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var easyIconLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Easy to find", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        label.titleLabel?.font = Fonts.SSPRegularH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var easyLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var coveredInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "These spots keep cars out of poor weather or the hot sun. Please do not select this amenity if cars will not be completely covered."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var chargingInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If selected, a universal car charger must be accessible from the parking spot listed and must be readily available for instant use."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var gatedInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "By selecting this option, you agree to abide by our privacy policy regarding access to gated properties. Users will only be able to view the code after paying for the spot."
        label.numberOfLines = 5
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var stadiumInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Your parking spot must be within 1 mile of a stadium or event center."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var nightInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Your parking spot must be available from 9 PM to 7 AM"
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var airportInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Your parking spot must be no further than 5 miles from an airport."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var lightingInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "Well-lit parking spots provide an added form of security, especially at night."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var largeInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "These parking spots must be a minimum of 7 ft. tall, with easy access for a large pickup truck."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var smallInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "These parking spots are generally used for compact vehicles, with no height minimum."
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
        label.alpha = 0
        
        return label
    }()
    
    var easyInformation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.text = "If most people can find your location without a hassle or if GPS is able to easily guide individuals to your parking spot, this amenity is highly sought after!"
        label.numberOfLines = 4
        label.font = Fonts.SSPLightH5
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
    
}

///////HANDLE CONSTRAINTS///////////////////////////////////////////////////////////////////////////////////
extension AmenitiesParkingViewController {
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1050)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(coveredImageView)
        coveredImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        coveredImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        coveredImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        coveredImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(coveredIconLabel)
        coveredIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        coveredIconLabel.topAnchor.constraint(equalTo: coveredImageView.topAnchor).isActive = true
        coveredIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        coveredIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(coveredLine)
        coveredLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        coveredLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        coveredAnchor = coveredLine.topAnchor.constraint(equalTo: coveredIconLabel.bottomAnchor, constant: 35)
        coveredAnchor.isActive = true
        coveredLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(chargingImageView)
        chargingImageView.topAnchor.constraint(equalTo: coveredLine.bottomAnchor, constant: 15).isActive = true
        chargingImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        chargingImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chargingImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(chargingIconLabel)
        chargingIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        chargingIconLabel.topAnchor.constraint(equalTo: chargingImageView.topAnchor).isActive = true
        chargingIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        chargingIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(chargingLine)
        chargingLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        chargingLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        chargingAnchor = chargingLine.topAnchor.constraint(equalTo: chargingIconLabel.bottomAnchor, constant: 35)
        chargingAnchor.isActive = true
        chargingLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(gatedImageView)
        gatedImageView.topAnchor.constraint(equalTo: chargingLine.bottomAnchor, constant: 15).isActive = true
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
        
        scrollView.addSubview(stadiumImageView)
        stadiumImageView.topAnchor.constraint(equalTo: gatedLine.bottomAnchor, constant: 15).isActive = true
        stadiumImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        stadiumImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stadiumImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(stadiumIconLabel)
        stadiumIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stadiumIconLabel.topAnchor.constraint(equalTo: stadiumImageView.topAnchor).isActive = true
        stadiumIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stadiumIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(stadiumLine)
        stadiumLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stadiumLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        stadiumAnchor = stadiumLine.topAnchor.constraint(equalTo: stadiumIconLabel.bottomAnchor, constant: 35)
        stadiumAnchor.isActive = true
        stadiumLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(nightImageView)
        nightImageView.topAnchor.constraint(equalTo: stadiumLine.bottomAnchor, constant: 15).isActive = true
        nightImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        nightImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nightImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(nightIconLabel)
        nightIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        nightIconLabel.topAnchor.constraint(equalTo: nightImageView.topAnchor).isActive = true
        nightIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        nightIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(nightLine)
        nightLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nightLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        nightAnchor = nightLine.topAnchor.constraint(equalTo: nightIconLabel.bottomAnchor, constant: 35)
        nightAnchor.isActive = true
        nightLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(airportImageView)
        airportImageView.topAnchor.constraint(equalTo: nightLine.bottomAnchor, constant: 15).isActive = true
        airportImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        airportImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        airportImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(airportIconLabel)
        airportIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        airportIconLabel.topAnchor.constraint(equalTo: airportImageView.topAnchor).isActive = true
        airportIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        airportIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(airportLine)
        airportLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        airportLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        airportAnchor = airportLine.topAnchor.constraint(equalTo: airportIconLabel.bottomAnchor, constant: 35)
        airportAnchor.isActive = true
        airportLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    
        scrollView.addSubview(lightedImageView)
        lightedImageView.topAnchor.constraint(equalTo: airportLine.bottomAnchor, constant: 15).isActive = true
        lightedImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        lightedImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lightedImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(lightedIconLabel)
        lightedIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lightedIconLabel.topAnchor.constraint(equalTo: lightedImageView.topAnchor).isActive = true
        lightedIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lightedIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(lightedLine)
        lightedLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lightedLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        lightingAnchor = lightedLine.topAnchor.constraint(equalTo: lightedIconLabel.bottomAnchor, constant: 35)
        lightingAnchor.isActive = true
        lightedLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(largeImageView)
        largeImageView.topAnchor.constraint(equalTo: lightedLine.bottomAnchor, constant: 15).isActive = true
        largeImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        largeImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        largeImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(largeIconLabel)
        largeIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        largeIconLabel.topAnchor.constraint(equalTo: largeImageView.topAnchor).isActive = true
        largeIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        largeIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(largeLine)
        largeLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        largeLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        largeAnchor = largeLine.topAnchor.constraint(equalTo: largeIconLabel.bottomAnchor, constant: 35)
        largeAnchor.isActive = true
        largeLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(smallImageView)
        smallImageView.topAnchor.constraint(equalTo: largeLine.bottomAnchor, constant: 15).isActive = true
        smallImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        smallImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        smallImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(smallIconLabel)
        smallIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        smallIconLabel.topAnchor.constraint(equalTo: smallImageView.topAnchor).isActive = true
        smallIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        smallIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(smallLine)
        smallLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        smallLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        smallAnchor = smallLine.topAnchor.constraint(equalTo: smallIconLabel.bottomAnchor, constant: 35)
        smallAnchor.isActive = true
        smallLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollView.addSubview(easyImageView)
        easyImageView.topAnchor.constraint(equalTo: smallLine.bottomAnchor, constant: 15).isActive = true
        easyImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        easyImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        easyImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(easyIconLabel)
        easyIconLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        easyIconLabel.topAnchor.constraint(equalTo: easyImageView.topAnchor).isActive = true
        easyIconLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        easyIconLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(easyLine)
        easyLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        easyLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        easyAnchor = easyLine.topAnchor.constraint(equalTo: easyIconLabel.bottomAnchor, constant: 35)
        easyAnchor.isActive = true
        easyLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        setupExtraInformation()
    }
    
    func setupExtraInformation() {
        
        scrollView.addSubview(coveredInformation)
        coveredInformation.leftAnchor.constraint(equalTo: coveredIconLabel.leftAnchor).isActive = true
        coveredInformation.rightAnchor.constraint(equalTo: coveredImageView.leftAnchor, constant: -10).isActive = true
        coveredInformation.topAnchor.constraint(equalTo: coveredIconLabel.bottomAnchor).isActive = true
        coveredInformation.bottomAnchor.constraint(equalTo: coveredLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(chargingInformation)
        chargingInformation.leftAnchor.constraint(equalTo: chargingIconLabel.leftAnchor).isActive = true
        chargingInformation.rightAnchor.constraint(equalTo: chargingImageView.leftAnchor, constant: -10).isActive = true
        chargingInformation.topAnchor.constraint(equalTo: chargingIconLabel.bottomAnchor).isActive = true
        chargingInformation.bottomAnchor.constraint(equalTo: chargingLine.topAnchor, constant: -12).isActive = true
    
        scrollView.addSubview(gatedInformation)
        gatedInformation.leftAnchor.constraint(equalTo: gatedIconLabel.leftAnchor).isActive = true
        gatedInformation.rightAnchor.constraint(equalTo: gatedImageView.leftAnchor, constant: -10).isActive = true
        gatedInformation.topAnchor.constraint(equalTo: gatedIconLabel.bottomAnchor).isActive = true
        gatedInformation.bottomAnchor.constraint(equalTo: gatedLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(stadiumInformation)
        stadiumInformation.leftAnchor.constraint(equalTo: stadiumIconLabel.leftAnchor).isActive = true
        stadiumInformation.rightAnchor.constraint(equalTo: stadiumImageView.leftAnchor, constant: -10).isActive = true
        stadiumInformation.topAnchor.constraint(equalTo: stadiumIconLabel.bottomAnchor).isActive = true
        stadiumInformation.bottomAnchor.constraint(equalTo: stadiumLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(nightInformation)
        nightInformation.leftAnchor.constraint(equalTo: nightIconLabel.leftAnchor).isActive = true
        nightInformation.rightAnchor.constraint(equalTo: nightImageView.leftAnchor, constant: -10).isActive = true
        nightInformation.topAnchor.constraint(equalTo: nightIconLabel.bottomAnchor).isActive = true
        nightInformation.bottomAnchor.constraint(equalTo: nightLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(airportInformation)
        airportInformation.leftAnchor.constraint(equalTo: airportIconLabel.leftAnchor).isActive = true
        airportInformation.rightAnchor.constraint(equalTo: airportImageView.leftAnchor, constant: -10).isActive = true
        airportInformation.topAnchor.constraint(equalTo: airportIconLabel.bottomAnchor).isActive = true
        airportInformation.bottomAnchor.constraint(equalTo: airportLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(lightingInformation)
        lightingInformation.leftAnchor.constraint(equalTo: lightedIconLabel.leftAnchor).isActive = true
        lightingInformation.rightAnchor.constraint(equalTo: lightedImageView.leftAnchor, constant: -10).isActive = true
        lightingInformation.topAnchor.constraint(equalTo: lightedIconLabel.bottomAnchor).isActive = true
        lightingInformation.bottomAnchor.constraint(equalTo: lightedLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(largeInformation)
        largeInformation.leftAnchor.constraint(equalTo: largeIconLabel.leftAnchor).isActive = true
        largeInformation.rightAnchor.constraint(equalTo: largeImageView.leftAnchor, constant: -10).isActive = true
        largeInformation.topAnchor.constraint(equalTo: largeIconLabel.bottomAnchor).isActive = true
        largeInformation.bottomAnchor.constraint(equalTo: largeLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(smallInformation)
        smallInformation.leftAnchor.constraint(equalTo: smallIconLabel.leftAnchor).isActive = true
        smallInformation.rightAnchor.constraint(equalTo: smallImageView.leftAnchor, constant: -10).isActive = true
        smallInformation.topAnchor.constraint(equalTo: smallIconLabel.bottomAnchor).isActive = true
        smallInformation.bottomAnchor.constraint(equalTo: smallLine.topAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(easyInformation)
        easyInformation.leftAnchor.constraint(equalTo: easyIconLabel.leftAnchor).isActive = true
        easyInformation.rightAnchor.constraint(equalTo: easyImageView.leftAnchor, constant: -10).isActive = true
        easyInformation.topAnchor.constraint(equalTo: easyIconLabel.bottomAnchor).isActive = true
        easyInformation.bottomAnchor.constraint(equalTo: easyLine.topAnchor, constant: -12).isActive = true
        
    }
}

///////HANDLE SELECTION////////////////////////////////////////////////////////////////////////////////////
extension AmenitiesParkingViewController {
    @objc func optionTapped(sender: UIButton) {
        if sender == coveredIconLabel {
            if coveredImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetHouse()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Covered parking" }
                return
            }
            self.selectedAmenities.append("Covered parking")
            UIView.animate(withDuration: 0.1) {
                self.coveredIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.coveredIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.coveredImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.coveredImageView.tintColor = Theme.WHITE
                self.coveredImageView.layer.shadowOpacity = 0.2
                self.coveredAnchor.constant = 95
                self.coveredInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == chargingIconLabel {
            if chargingImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetApartment()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Charging station" }
                return
            }
            self.selectedAmenities.append("Charging station")
            UIView.animate(withDuration: 0.1) {
                self.chargingIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.chargingIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.chargingImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.chargingImageView.tintColor = Theme.WHITE
                self.chargingImageView.layer.shadowOpacity = 0.2
                self.chargingAnchor.constant = 95
                self.chargingInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == stadiumIconLabel {
            if stadiumImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetCovered()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Stadium parking" }
                return
            }
            self.selectedAmenities.append("Stadium parking")
            UIView.animate(withDuration: 0.1) {
                self.stadiumIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.stadiumIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.stadiumImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.stadiumImageView.tintColor = Theme.WHITE
                self.stadiumImageView.layer.shadowOpacity = 0.2
                self.stadiumAnchor.constant = 95
                self.stadiumInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == gatedIconLabel {
            if gatedImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetStreet()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Gated spot" }
                return
            }
            self.selectedAmenities.append("Gated spot")
            UIView.animate(withDuration: 0.1) {
                self.gatedIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.gatedIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.gatedImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.gatedImageView.tintColor = Theme.WHITE
                self.gatedImageView.layer.shadowOpacity = 0.2
                self.gatedAnchor.constant = 115
                self.gatedInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == nightIconLabel {
            if nightImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetLot()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Nighttime parking" }
                return
            }
            self.selectedAmenities.append("Nighttime parking")
            UIView.animate(withDuration: 0.1) {
                self.nightIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.nightIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.nightImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.nightImageView.tintColor = Theme.WHITE
                self.nightImageView.layer.shadowOpacity = 0.2
                self.nightAnchor.constant = 95
                self.nightInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == airportIconLabel {
            if airportImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetAlley()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Near Airport" }
                return
            }
            self.selectedAmenities.append("Near Airport")
            UIView.animate(withDuration: 0.1) {
                self.airportIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.airportIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.airportImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.airportImageView.tintColor = Theme.WHITE
                self.airportImageView.layer.shadowOpacity = 0.2
                self.airportAnchor.constant = 95
                self.airportInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == lightedIconLabel {
            if lightedImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetGated()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Lit space" }
                return
            }
            self.selectedAmenities.append("Lit space")
            UIView.animate(withDuration: 0.1) {
                self.lightedIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.lightedIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.lightedImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.lightedImageView.tintColor = Theme.WHITE
                self.lightedImageView.layer.shadowOpacity = 0.2
                self.lightingAnchor.constant = 95
                self.lightingInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == largeIconLabel {
            if largeImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetLarge()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Large space" }
                return
            }
            self.selectedAmenities.append("Large space")
            self.resetSmall()
            UIView.animate(withDuration: 0.1) {
                self.largeIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.largeIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.largeImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.largeImageView.tintColor = Theme.WHITE
                self.largeImageView.layer.shadowOpacity = 0.2
                self.largeAnchor.constant = 95
                self.largeInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == smallIconLabel {
            if smallImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetSmall()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Compact space" }
                return
            }
            self.selectedAmenities.append("Compact space")
            self.resetLarge()
            UIView.animate(withDuration: 0.1) {
                self.smallIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.smallIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.smallImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.smallImageView.tintColor = Theme.WHITE
                self.smallImageView.layer.shadowOpacity = 0.2
                self.smallAnchor.constant = 95
                self.smallInformation.alpha = 1
                self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95
                self.view.layoutIfNeeded()
            }
        } else if sender == easyIconLabel {
            if easyImageView.backgroundColor == Theme.PACIFIC_BLUE {
                self.resetEasy()
                self.selectedAmenities = self.selectedAmenities.filter { $0 != "Easy to find" }
                return
            }
            self.selectedAmenities.append("Easy to find")
            UIView.animate(withDuration: 0.1) {
                self.easyIconLabel.setTitleColor(Theme.DARK_GRAY, for: .normal)
                self.easyIconLabel.titleLabel?.font = Fonts.SSPSemiBoldH2
                self.easyImageView.backgroundColor = Theme.PACIFIC_BLUE
                self.easyImageView.tintColor = Theme.WHITE
                self.easyImageView.layer.shadowOpacity = 0.2
                self.easyAnchor.constant = 95
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
            self.coveredIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.coveredIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.coveredImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.coveredImageView.tintColor = Theme.WHITE
            self.coveredImageView.layer.shadowOpacity = 0
            self.coveredAnchor.constant = 35
            self.coveredInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetApartment() {
        UIView.animate(withDuration: 0.1) {
            self.chargingIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.chargingIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.chargingImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.chargingImageView.tintColor = Theme.WHITE
            self.chargingImageView.layer.shadowOpacity = 0
            self.chargingAnchor.constant = 35
            self.chargingInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetStreet() {
        UIView.animate(withDuration: 0.1) {
            self.gatedIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.gatedIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.gatedImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.gatedImageView.tintColor = Theme.WHITE
            self.gatedImageView.layer.shadowOpacity = 0
            self.gatedAnchor.constant = 35
            self.gatedInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetCovered() {
        UIView.animate(withDuration: 0.1) {
            self.stadiumIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.stadiumIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.stadiumImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.stadiumImageView.tintColor = Theme.WHITE
            self.stadiumImageView.layer.shadowOpacity = 0
            self.stadiumImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.stadiumAnchor.constant = 35
            self.stadiumInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetLot() {
        UIView.animate(withDuration: 0.1) {
            self.nightIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.nightIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.nightImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.nightImageView.tintColor = Theme.WHITE
            self.nightImageView.layer.shadowOpacity = 0
            self.nightAnchor.constant = 35
            self.nightInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetAlley() {
        UIView.animate(withDuration: 0.1) {
            self.airportIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.airportIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.airportImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.airportImageView.tintColor = Theme.WHITE
            self.airportImageView.layer.shadowOpacity = 0
            self.airportAnchor.constant = 35
            self.airportInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetGated() {
        UIView.animate(withDuration: 0.1) {
            self.lightedIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.lightedIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.lightedImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.lightedImageView.tintColor = Theme.WHITE
            self.lightedImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.lightingAnchor.constant = 35
            self.lightingInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetLarge() {
        UIView.animate(withDuration: 0.1) {
            self.largeIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.largeIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.largeImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.largeImageView.tintColor = Theme.WHITE
            self.largeImageView.layer.shadowOpacity = 0
            self.largeAnchor.constant = 35
            self.largeInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetSmall() {
        UIView.animate(withDuration: 0.1) {
            self.smallIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.smallIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.smallImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.smallImageView.tintColor = Theme.WHITE
            self.smallImageView.layer.shadowOpacity = 0
            self.smallAnchor.constant = 35
            self.smallInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
    func resetEasy() {
        UIView.animate(withDuration: 0.1) {
            self.easyIconLabel.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
            self.easyIconLabel.titleLabel?.font = Fonts.SSPRegularH2
            self.easyImageView.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
            self.easyImageView.tintColor = Theme.WHITE
            self.easyImageView.layer.shadowOpacity = 0
            self.easyAnchor.constant = 35
            self.easyInformation.alpha = 0
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - 95
            self.view.layoutIfNeeded()
        }
    }
    
}
