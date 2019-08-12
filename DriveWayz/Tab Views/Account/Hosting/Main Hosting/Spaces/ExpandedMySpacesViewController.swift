//
//  TestMySpacesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

protocol changeExpandedInformation {
    func resetParking()
    func backButtonPressed()
}

class ExpandedMySpacesViewController: UIViewController {
    
    var delegate: handleHostSpaces?
    var parkingImages: [UIImage] = []
    var selectedParking: ParkingSpots?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()

    var gradientContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        let background = CAGradientLayer().customColor(topColor: Theme.DarkPink, bottomColor: Theme.LightPink)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 220)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        button.layer.cornerRadius = 15
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    var whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var spacesPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(SpacesImage.self, forCellWithReuseIdentifier: "Cell")
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 24
        
        return view
    }()
    
    var editInformation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(openImages), for: .touchUpInside)
        
        return button
    }()
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Two-Car Driveway"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "University Avenue, Boulder CO"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var destinationIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return button
    }()
    
    var listedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        button.setTitle("Listed on 09/28/2019", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 4
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        return button
    }()
    
    var availableButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("ACTIVE", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.layer.cornerRadius = 4
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 8)
        let background = CAGradientLayer().customColor(topColor: Theme.LightGreen, bottomColor: Theme.DarkGreen)
        background.frame = CGRect(x: 0, y: 0, width: 92, height: 32)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.clipsToBounds = true
        let icon = UIImage(named: "liveCircle")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.WHITE
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.addTarget(self, action: #selector(availabilityButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.starSize = 14
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.GOLD
        view.settings.emptyBorderColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.GOLD
        view.settings.emptyColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.settings.filledImage = UIImage(named: "Star Filled")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "Star Empty")?.withRenderingMode(.alwaysOriginal)
        view.text = "10"
        view.semanticContentAttribute = .forceRightToLeft
        view.settings.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        view.settings.textFont = Fonts.SSPSemiBoldH6
        
        return view
    }()
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Today, 10:00AM - 4:00PM", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        button.clipsToBounds = true
        let icon = UIImage(named: "time")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 3, bottom: 3, right: 1)
        button.contentHorizontalAlignment = .right
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        return button
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var hostExpanded: HostingExpandedViewController = {
        let controller = HostingExpandedViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    var blankImageView = UIImageView()
    
    func setData(parking: ParkingSpots, image: UIImage) {
        self.selectedParking = parking
        self.parkingImages = []
        self.hostExpanded.setData(hosting: parking)
        self.parkingImages.insert(image, at: 0)
        self.checkImages(parking: parking)
        if var streetAddress = parking.streetAddress, let stateAddress = parking.stateAddress, let cityAddress = parking.cityAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType, let timestamp = parking.timestamp {
            if let spaceRange = streetAddress.range(of: " ") {
                streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                if let number = Int(numberSpots) {
                    let wordString = number.asWord
                    let descriptionAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter())"
                    self.spotLabel.text = descriptionAddress
                    self.locationLabel.text = "\(streetAddress), \(cityAddress) \(stateAddress)"
                }
                let date = Date(timeIntervalSince1970: timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dateString = dateFormatter.string(from: date)
                self.listedButton.setTitle("Listed on \(dateString)", for: .normal)
                
                let available = parking.isSpotAvailable
                if available {
                    self.makeActiveButton()
                } else {
                    self.makeInactiveButton()
                }
                
                if let totalRating = parking.totalRating, let totalBookings = parking.totalBookings {
                    self.stars.text = "\(totalBookings)"
                    self.stars.rating = Double(totalRating)/Double(totalBookings)
                } else {
                    self.stars.text = "0"
                    self.stars.rating = 5.0
                }
            }
        }
    }
    
    func checkImages(parking: ParkingSpots) {
        self.spacesPicker.reloadData()
        if let image = parking.secondImage {
            self.appendNewImage(url: image, index: 1)
        }
        if let image = parking.thirdImage {
            self.appendNewImage(url: image, index: 2)
        }
        if let image = parking.fourthImage {
            self.appendNewImage(url: image, index: 3)
        }
        if let image = parking.fifthImage {
            self.appendNewImage(url: image, index: 4)
        }
        if let image = parking.sixthImage {
            self.appendNewImage(url: image, index: 5)
        }
        if let image = parking.seventhImage {
            self.appendNewImage(url: image, index: 6)
        }
        if let image = parking.eighthImage {
            self.appendNewImage(url: image, index: 7)
        }
        if let image = parking.ninethImage {
            self.appendNewImage(url: image, index: 8)
        }
        if let image = parking.tenthImage {
            self.appendNewImage(url: image, index: 9)
        }
    }
    
    func appendNewImage(url: String, index: Int) {
        self.blankImageView.loadImageUsingCacheWithUrlString(url) { (bool) in
            if let image = self.blankImageView.image {
                if index < self.parkingImages.count {
                    self.parkingImages.insert(image, at: index)
                } else {
                    self.parkingImages.append(image)
                }
                self.spacesPicker.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        spacesPicker.delegate = self
        spacesPicker.dataSource = self
        
        setupViews()
        setupContainer()
        setupImage()
        setupSpotLabel()
        setupTopButtons()
        setupControllers()
    }
    
    var scrollViewTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 2070)
        scrollViewTopAnchor = scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusHeight)
            scrollViewTopAnchor.isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30).isActive = true
        
        scrollView.addSubview(gradientContainer)
        scrollView.addSubview(whiteView)
        scrollView.addSubview(spacesPicker)
        scrollView.addSubview(editInformation)
        scrollView.addSubview(spotLabel)
        scrollView.addSubview(destinationIcon)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(listedButton)
        scrollView.addSubview(availableButton)
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        
        self.view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: spacesPicker.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
    }
    
    func setupContainer() {
        
        gradientContainer.topAnchor.constraint(equalTo: spacesPicker.bottomAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gradientContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        whiteView.topAnchor.constraint(equalTo: availableButton.bottomAnchor, constant: 16).isActive = true
        whiteView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupImage() {
        
        spacesPicker.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        spacesPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        spacesPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        spacesPicker.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        editInformation.bottomAnchor.constraint(equalTo: spacesPicker.bottomAnchor, constant: -12).isActive = true
        editInformation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        editInformation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func setupSpotLabel() {
        
        spotLabel.centerYAnchor.constraint(equalTo: listedButton.centerYAnchor).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: gradientContainer.leftAnchor, constant: 20).isActive = true
        spotLabel.rightAnchor.constraint(equalTo: listedButton.leftAnchor, constant: -8).isActive = true
        spotLabel.sizeToFit()
        
        destinationIcon.leftAnchor.constraint(equalTo: spotLabel.leftAnchor).isActive = true
        destinationIcon.centerYAnchor.constraint(equalTo: availableButton.centerYAnchor).isActive = true
        destinationIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        destinationIcon.widthAnchor.constraint(equalTo: destinationIcon.heightAnchor).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: destinationIcon.rightAnchor, constant: 6).isActive = true
        locationLabel.centerYAnchor.constraint(equalTo: destinationIcon.centerYAnchor).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: availableButton.leftAnchor, constant: -8).isActive = true
        locationLabel.sizeToFit()
        
    }
    
    var availableStarter: CGFloat = 78
    var availableButtonWidth: NSLayoutConstraint?
    
    func setupTopButtons() {
        
        listedButton.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 16).isActive = true
        listedButton.rightAnchor.constraint(equalTo: gradientContainer.rightAnchor, constant: -20).isActive = true
        listedButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        listedButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        availableButton.topAnchor.constraint(equalTo: listedButton.bottomAnchor, constant: 4).isActive = true
        availableButton.rightAnchor.constraint(equalTo: gradientContainer.rightAnchor, constant: -20).isActive = true
        availableButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        availableButtonWidth = availableButton.widthAnchor.constraint(equalToConstant: self.availableStarter)
            availableButtonWidth!.isActive = true
        
    }
    
    func setupControllers() {
        
        scrollView.addSubview(hostExpanded.view)
        hostExpanded.view.topAnchor.constraint(equalTo: whiteView.topAnchor).isActive = true
        hostExpanded.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostExpanded.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostExpanded.view.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        
        let height = hostExpanded.expandedInformation.height + 100 + 200 + 215 + 800
        scrollView.contentSize = CGSize(width: phoneWidth, height: height)
        
    }
    
    func makeActiveButton() {
        self.availableButton.setTitle("ACTIVE", for: .normal)
        self.availableStarter = 78
        if self.availableButtonWidth != nil {
            self.availableButtonWidth!.constant = 78
        }
        let background = CAGradientLayer().customColor(topColor: Theme.LightGreen, bottomColor: Theme.DarkGreen)
        background.frame = CGRect(x: 0, y: 0, width: 92, height: 32)
        background.zPosition = -10
        self.availableButton.layer.addSublayer(background)
    }
    
    func makeInactiveButton() {
        self.availableButton.setTitle("INACTIVE", for: .normal)
        self.availableStarter = 86
        if self.availableButtonWidth != nil {
            self.availableButtonWidth!.constant = 86
        }
        let background = CAGradientLayer().customColor(topColor: Theme.LightBlue, bottomColor: Theme.BLUE)
        background.frame = CGRect(x: 0, y: 0, width: 92, height: 32)
        background.zPosition = -10
        self.availableButton.layer.addSublayer(background)
    }
    
    @objc func availabilityButtonPressed() {
        if availableButton.titleLabel?.text == "ACTIVE" {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                let parkingID = snapshot.key
                let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID)
                let timestamp = Date().timeIntervalSince1970
                parkingRef.updateChildValues(["ParkingUnavailability": timestamp])
                self.makeInactiveButton()
                self.delegate?.observeData()
            }
        } else {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                let parkingID = snapshot.key
                let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("ParkingUnavailability")
                parkingRef.removeValue()
                self.makeActiveButton()
                self.delegate?.observeData()
            }
        }
    }
    
    @objc func openImages() {
        let controller = EditImagesViewController()
        controller.delegate = self
        if let hosting = self.selectedParking {
            controller.setData(parking: hosting)
            controller.parkingImages = self.parkingImages
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func backButtonPressed() {
        self.delegate?.closeBackground()
        self.dismiss(animated: true, completion: nil)
    }
    
}


// Populate spaces collectionView
extension ExpandedMySpacesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.parkingImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: phoneWidth, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! SpacesImage
        
        if indexPath.row < self.parkingImages.count {
            cell.spotImageView.image = self.parkingImages[indexPath.row]
            cell.imageNumber.setTitle("\(indexPath.row + 1)", for: .normal)
        }
        let count = self.parkingImages.count
        if count == 1 || count == 0 {
            cell.imageNumber.alpha = 0
        } else {
            cell.imageNumber.alpha = 1
        }
        
        return cell
    }
    
}



class SpacesImage: UICollectionViewCell {

    var spotImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true

        return view
    }()
    
    lazy var imageNumber: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        button.setTitle("1", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPBoldH5
        
        return button
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {

        self.addSubview(spotImageView)
        spotImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        spotImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        spotImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        spotImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(imageNumber)
        imageNumber.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        imageNumber.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageNumber.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageNumber.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Update hosting information if an editing change takes place
extension ExpandedMySpacesViewController: changeExpandedInformation {
    
    func resetParking() {
        self.delegate?.observeData()
        if let hosting = self.selectedParking, let parkingID = hosting.parkingID {
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    let parking = ParkingSpots(dictionary: dictionary)
                    if let firstImage = parking.firstImage {
                        self.blankImageView.loadImageUsingCacheWithUrlString(firstImage, completion: { (bool) in
                            if !bool {
                                if let image = UIImage(named: "flat-photos") {
                                    self.setData(parking: parking, image: image)
                                }
                            } else {
                                if let image = self.blankImageView.image {
                                    self.setData(parking: parking, image: image)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
}


extension ExpandedMySpacesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -120 {
            self.backButtonPressed()
        } else if translation <= -16 {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.alpha = 0
            }
        } else if translation >= 312 {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
                self.exitButton.tintColor = Theme.DARK_GRAY
                self.exitButton.layer.borderColor = Theme.DARK_GRAY.cgColor
            }
        } else {
            UIView.animate(withDuration: animationIn) {
                self.exitButton.alpha = 1
                self.exitButton.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
                self.exitButton.tintColor = Theme.WHITE
                self.exitButton.layer.borderColor = Theme.WHITE.cgColor
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
