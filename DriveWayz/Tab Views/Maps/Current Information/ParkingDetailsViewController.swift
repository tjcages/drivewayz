//
//  ParkingDetailsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/15/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingDetailsViewController: UIViewController {
    
    let buttonHeight: CGFloat = 40
    
    var detailsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var amenitiesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = Fonts.SSPLightH2
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let amenitiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Amenities"
        label.font = Fonts.SSPLightH2
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        
        return view
    }()
    
    lazy var whiteBlurViewRight: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().lightBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        view.alpha = 0.8
        
        return view
    }()
    
    lazy var whiteBlurViewLeft: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().lightBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        view.alpha = 0.7
        
        return view
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "Home")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        
        return button
    }()
    
    lazy var secondaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "drivewayParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        
        return button
    }()
    
    lazy var numberButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        button.setTitle("4", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPBoldH2
        
        return button
    }()
    
    lazy var coveredButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "coveredParkingIcon-1")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        button.layer.borderColor = Theme.PACIFIC_BLUE.cgColor
        button.layer.borderWidth = 2
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return button
    }()
    
    lazy var chargingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "chargingParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var gatedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "gateParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var stadiumButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "stadiumParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "nightParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var airportButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "airportParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var lightedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "lightingParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var largeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "largeParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var smallButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "smallParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var easyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.layer.cornerRadius = buttonHeight/2
        let image = UIImage(named: "easyParkingIcon")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        button.addTarget(self, action: #selector(amenityPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var detailsInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "This spot is a residential garage with 4 different parking spaces."
        label.font = Fonts.SSPLightH4
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    var amenitiesInformationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var amenitiesTriangle: TriangleView = {
        let triangle = TriangleView()
        triangle.backgroundColor = UIColor.clear
        triangle.translatesAutoresizingMaskIntoConstraints = false
        
        return triangle
    }()
    
    var amenitiesInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "These spots keep cars out of poor weather or the hot sun."
        label.font = Fonts.SSPLightH4
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.sizeToFit()
        
        return label
    }()
    
    func setData(formattedAddress: String, message: String, parkingID: String, id: String) {
        
    }
    
    var leftGesture: UITapGestureRecognizer!
    var rightGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        scrollView.delegate = self
        lastButton = coveredButton

        setupViews()
        
        leftGesture = UITapGestureRecognizer(target: self, action: #selector(otherTapped(sender:)))
        rightGesture = UITapGestureRecognizer(target: self, action: #selector(otherTapped(sender:)))
        whiteBlurViewLeft.addGestureRecognizer(leftGesture)
        whiteBlurViewRight.addGestureRecognizer(rightGesture)
    }
    
    @objc func otherTapped(sender: UITapGestureRecognizer) {
        if sender == leftGesture {
            self.scrollView.setContentOffset(.zero, animated: true)
        } else if sender == rightGesture {
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
        }
    }
    
    var lastButton: UIButton?
    
    @objc func amenityPressed(sender: UIButton) {
        self.amenitySelected(sender: sender)
        UIView.animate(withDuration: 0.1) {
            self.lastButton?.layer.borderColor = UIColor.clear.cgColor
            self.lastButton?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            sender.layer.borderColor = Theme.PACIFIC_BLUE.cgColor
            sender.layer.borderWidth = 2
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.amenitiesTriangle.center.x = sender.center.x-12
        }
        lastButton = sender
    }
    
    var amenitiesAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width*2, height: self.view.frame.width)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(amenitiesLabel)
        amenitiesAnchor = amenitiesLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            amenitiesAnchor.isActive = true
        amenitiesLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        amenitiesLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        amenitiesLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(detailsLabel)
        detailsLabel.centerXAnchor.constraint(equalTo: amenitiesLabel.centerXAnchor, constant: self.view.frame.width/2).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        detailsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(whiteBlurViewRight)
        whiteBlurViewRight.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 60).isActive = true
        whiteBlurViewRight.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        whiteBlurViewRight.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        whiteBlurViewRight.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(whiteBlurViewLeft)
        whiteBlurViewLeft.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -60).isActive = true
        whiteBlurViewLeft.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        whiteBlurViewLeft.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        whiteBlurViewLeft.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        setupAmenities()
        setupDetails()
    }
    
    func setupDetails() {
        
        scrollView.addSubview(detailsView)
        detailsView.leftAnchor.constraint(equalTo: amenitiesView.rightAnchor).isActive = true
        detailsView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        detailsView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8).isActive = true
        detailsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        detailsView.addSubview(mainButton)
        mainButton.leftAnchor.constraint(equalTo: detailsView.leftAnchor, constant: 20).isActive = true
        mainButton.topAnchor.constraint(equalTo: detailsView.topAnchor).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        mainButton.heightAnchor.constraint(equalTo: mainButton.widthAnchor).isActive = true
        
        detailsView.addSubview(secondaryButton)
        secondaryButton.leftAnchor.constraint(equalTo: mainButton.rightAnchor, constant: 8).isActive = true
        secondaryButton.topAnchor.constraint(equalTo: detailsView.topAnchor).isActive = true
        secondaryButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        secondaryButton.heightAnchor.constraint(equalTo: secondaryButton.widthAnchor).isActive = true
        
        detailsView.addSubview(numberButton)
        numberButton.leftAnchor.constraint(equalTo: secondaryButton.rightAnchor, constant: 8).isActive = true
        numberButton.topAnchor.constraint(equalTo: detailsView.topAnchor).isActive = true
        numberButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        numberButton.heightAnchor.constraint(equalTo: numberButton.widthAnchor).isActive = true
        
        detailsView.addSubview(detailsInformationLabel)
        detailsInformationLabel.leftAnchor.constraint(equalTo: detailsView.leftAnchor, constant: 20).isActive = true
        detailsInformationLabel.rightAnchor.constraint(equalTo: detailsView.rightAnchor, constant: -20).isActive = true
        detailsInformationLabel.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 10).isActive = true
        detailsInformationLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    var amenitiesInformationHeightAnchor: NSLayoutConstraint!
    
    func setupAmenities() {
        
        scrollView.addSubview(amenitiesView)
        amenitiesView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        amenitiesView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        amenitiesView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8).isActive = true
        amenitiesView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        amenitiesView.addSubview(coveredButton)
        coveredButton.leftAnchor.constraint(equalTo: amenitiesView.leftAnchor, constant: 20).isActive = true
        coveredButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        coveredButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        coveredButton.heightAnchor.constraint(equalTo: coveredButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(chargingButton)
        chargingButton.leftAnchor.constraint(equalTo: coveredButton.rightAnchor, constant: 8).isActive = true
        chargingButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        chargingButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        chargingButton.heightAnchor.constraint(equalTo: chargingButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(gatedButton)
        gatedButton.leftAnchor.constraint(equalTo: chargingButton.rightAnchor, constant: 8).isActive = true
        gatedButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        gatedButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        gatedButton.heightAnchor.constraint(equalTo: gatedButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(stadiumButton)
        stadiumButton.leftAnchor.constraint(equalTo: gatedButton.rightAnchor, constant: 8).isActive = true
        stadiumButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        stadiumButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        stadiumButton.heightAnchor.constraint(equalTo: stadiumButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(nightButton)
        nightButton.leftAnchor.constraint(equalTo: stadiumButton.rightAnchor, constant: 8).isActive = true
        nightButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        nightButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        nightButton.heightAnchor.constraint(equalTo: nightButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(airportButton)
        airportButton.leftAnchor.constraint(equalTo: nightButton.rightAnchor, constant: 8).isActive = true
        airportButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        airportButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        airportButton.heightAnchor.constraint(equalTo: airportButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(lightedButton)
        lightedButton.leftAnchor.constraint(equalTo: airportButton.rightAnchor, constant: 8).isActive = true
        lightedButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        lightedButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        lightedButton.heightAnchor.constraint(equalTo: lightedButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(largeButton)
        largeButton.leftAnchor.constraint(equalTo: lightedButton.rightAnchor, constant: 8).isActive = true
        largeButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        largeButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        largeButton.heightAnchor.constraint(equalTo: largeButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(smallButton)
        smallButton.leftAnchor.constraint(equalTo: largeButton.rightAnchor, constant: 8).isActive = true
        smallButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        smallButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        smallButton.heightAnchor.constraint(equalTo: smallButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(easyButton)
        easyButton.leftAnchor.constraint(equalTo: smallButton.rightAnchor, constant: 8).isActive = true
        easyButton.topAnchor.constraint(equalTo: amenitiesView.topAnchor).isActive = true
        easyButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        easyButton.heightAnchor.constraint(equalTo: easyButton.widthAnchor).isActive = true
        
        amenitiesView.addSubview(amenitiesInformationView)
        amenitiesInformationView.leftAnchor.constraint(equalTo: amenitiesView.leftAnchor, constant: 12).isActive = true
        amenitiesInformationView.rightAnchor.constraint(equalTo: amenitiesView.rightAnchor, constant: -12).isActive = true
        amenitiesInformationView.topAnchor.constraint(equalTo: coveredButton.bottomAnchor, constant: 20).isActive = true
        
        amenitiesInformationView.addSubview(amenitiesTriangle)
        amenitiesTriangle.centerXAnchor.constraint(equalTo: coveredButton.centerXAnchor).isActive = true
        amenitiesTriangle.bottomAnchor.constraint(equalTo: amenitiesInformationView.topAnchor).isActive = true
        amenitiesTriangle.widthAnchor.constraint(equalToConstant: 30).isActive = true
        amenitiesTriangle.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        amenitiesView.addSubview(amenitiesInformationLabel)
        amenitiesInformationLabel.leftAnchor.constraint(equalTo: amenitiesView.leftAnchor, constant: 20).isActive = true
        amenitiesInformationLabel.rightAnchor.constraint(equalTo: amenitiesView.rightAnchor, constant: -20).isActive = true
        amenitiesInformationLabel.topAnchor.constraint(equalTo: amenitiesInformationView.topAnchor, constant: 4).isActive = true
        amenitiesInformationHeightAnchor = amenitiesInformationLabel.heightAnchor.constraint(equalToConstant: 50)
            amenitiesInformationHeightAnchor.isActive = true
        amenitiesInformationView.bottomAnchor.constraint(equalTo: amenitiesInformationLabel.bottomAnchor, constant: 4).isActive = true
        
    }
    

}


extension ParkingDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        self.amenitiesAnchor.constant = -translation/2
        self.view.layoutIfNeeded()
    }
}


extension ParkingDetailsViewController {
    
    func amenitySelected(sender: UIButton) {
        if sender == coveredButton {
            self.amenitiesInformationLabel.text = "These spots keep cars out of poor weather or the hot sun."
        } else if sender == chargingButton {
            self.amenitiesInformationLabel.text = "A universal car charger is accessible from the parking spot listed and is readily available for instant use."
        } else if sender == gatedButton {
            self.amenitiesInformationLabel.text = "A gated parking space. The gate code will only be available to you after you purchase this spot."
        } else if sender == stadiumButton {
            self.amenitiesInformationLabel.text = "This parking spot is within walking distance of a stadium or event center."
        } else if sender == nightButton {
            self.amenitiesInformationLabel.text = "This parking spot is available from 8 pm to 8 am for a reduced rate."
        } else if sender == airportButton {
            self.amenitiesInformationLabel.text = "This parking spot is within one mile of an airport."
        } else if sender == lightedButton {
            self.amenitiesInformationLabel.text = "Well-lit parking spots provide an added form of security, especially at night."
        } else if sender == largeButton {
            self.amenitiesInformationLabel.text = "These parking spots are a minimum of 7 ft. tall, with easy access for a large pickup truck."
        } else if sender == smallButton {
            self.amenitiesInformationLabel.text = "These parking spots are generally used for compact vehicles, with no height minimum."
        } else if sender == easyButton {
            self.amenitiesInformationLabel.text = "If most people can find your location without a hassle or if GPS is able to easily guide individuals to your parking spot."
        }
        if let height = self.amenitiesInformationLabel.text?.height(withConstrainedWidth: self.view.frame.width-40, font: Fonts.SSPLightH4) {
            self.amenitiesInformationHeightAnchor.constant = height
            UIView.animate(withDuration: animationIn) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
