//
//  TestHostSpacesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

protocol handleHostSpaces {
    func closeBackground()
    func observeData()
}

class HostSpacesViewController: UIViewController, handleHostSpaces {

    var delegate: handleHostingControllers?
    var hostedSpacesKey: [String] = []
    var hostedSpacesDict: [String: ParkingSpots] = [:]
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your spaces"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.alpha = 0
        //        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        return layout
    }()
    
    lazy var spacesPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        view.register(SpacesCell.self, forCellWithReuseIdentifier: "Cell")
        view.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        return view
    }()
    
    var newHostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.setTitle("Add a new spot", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        let icon = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.DarkPink
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.2
        button.addTarget(self, action: #selector(addANewSpot), for: .touchUpInside)
        
        return button
    }()
    
    lazy var specificHostSpace: AnimateMySpacesViewController = {
        let controller = AnimateMySpacesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        
        return controller
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func observeData() {
        self.loadingLine.startAnimating()
        self.hostedSpacesKey = []
        self.hostedSpacesDict = [:]
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
        ref.observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            let hostRef = Database.database().reference().child("ParkingSpots").child(key)
            hostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let hosting = ParkingSpots(dictionary: dictionary)
                    self.hostedSpacesKey.append(key)
                    self.hostedSpacesDict[key] = hosting
                    self.spacesPicker.reloadData()
                    
                    self.loadingLine.endAnimating()
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        spacesPicker.delegate = self
        spacesPicker.dataSource = self
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        setupViews()
        setupControllers()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: phoneWidth).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        }
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight + 280)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        self.view.addSubview(dimmingView)
        dimmingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dimmingView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    var spacesHeightAnchor: NSLayoutConstraint!
    var specificSpaceTopAnchor: NSLayoutConstraint!
    var specificSpaceHeightAnchor: NSLayoutConstraint!
    var specificSpaceWidthAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.addSubview(spacesPicker)
        spacesPicker.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        spacesPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        spacesPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        spacesHeightAnchor = spacesPicker.heightAnchor.constraint(equalToConstant: 220)
            spacesHeightAnchor.isActive = true
        
        scrollView.addSubview(newHostButton)
        newHostButton.topAnchor.constraint(equalTo: spacesPicker.bottomAnchor).isActive = true
        newHostButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        newHostButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        newHostButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(specificHostSpace.view)
        specificHostSpace.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        specificSpaceTopAnchor = specificHostSpace.view.centerYAnchor.constraint(equalTo: self.view.topAnchor)
            specificSpaceTopAnchor.isActive = true
        specificSpaceHeightAnchor = specificHostSpace.view.heightAnchor.constraint(equalToConstant: 200)
            specificSpaceHeightAnchor.isActive = true
        specificSpaceWidthAnchor = specificHostSpace.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24)
            specificSpaceWidthAnchor.isActive = true
        
    }
    
    @objc func addANewSpot() {
        let controller = ConfigureParkingViewController()
        controller.hostDelegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.isHidden = true
        self.delegate?.hideExitButton()
        self.delegate?.closeTabBar()
        UIView.animate(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 1
        }) { (success) in
            self.present(navigation, animated: true) {
                UIView.animate(withDuration: animationIn) {
                    controller.startHostingController.backButton.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func closeBackground() {
        self.delegate?.bringExitButton()
        self.delegate?.openTabBar()
        UIView.animate(withDuration: animationOut) {
            self.dimmingView.alpha = 0
        }
    }
    
}

// Populate spaces collectionView
extension HostSpacesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = self.hostedSpacesDict.count
        self.spacesHeightAnchor.constant = 216 * CGFloat(number)
        self.view.layoutIfNeeded()
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: phoneWidth - 24, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! SpacesCell
        
        if indexPath.row < self.hostedSpacesKey.count && indexPath.row < self.hostedSpacesDict.count {
            let key = self.hostedSpacesKey[indexPath.row]
            cell.hostingID = key
            cell.parkingSpot = self.hostedSpacesDict[key]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = self.spacesPicker.cellForItem(at: indexPath) as? SpacesCell else { return }
        let controller = ExpandedMySpacesViewController()
        controller.delegate = self
        
        if indexPath.row < self.hostedSpacesKey.count && indexPath.row < self.hostedSpacesDict.count {
            let key = self.hostedSpacesKey[indexPath.row]
            guard let parking = self.hostedSpacesDict[key] else { return }
            if let image = cell.spotImageView.image {
                self.specificHostSpace.setData(parking: parking, image: image)
                controller.setData(parking: parking, image: image)
            }
            
            self.delegate?.closeTabBar()
            let realCenter = self.spacesPicker.convert(cell.center, to: self.view)
            self.specificHostSpace.view.alpha = 1
            self.specificSpaceTopAnchor.constant = realCenter.y
            self.view.layoutIfNeeded()
            self.specificHostSpace.animateOpening()
            self.specificSpaceTopAnchor.constant = phoneHeight/2 + statusHeight
            self.specificSpaceHeightAnchor.constant = phoneHeight
            self.specificSpaceWidthAnchor.constant = phoneWidth
            UIView.animate(withDuration: animationIn * 2, animations: {
                self.dimmingView.alpha = 0.6
                self.spacesPicker.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                
                let navigation = UINavigationController(rootViewController: controller)
                navigation.navigationBar.isHidden = true
                navigation.modalPresentationStyle = .overFullScreen
                navigation.modalTransitionStyle = .crossDissolve
                
                self.present(navigation, animated: true, completion: {
                    navigation.modalTransitionStyle = .coverVertical
                    self.spacesPicker.alpha = 1
                    self.specificHostSpace.restartView()
                    self.specificHostSpace.view.alpha = 0
                    self.specificSpaceTopAnchor.constant = phoneHeight/2
                    self.specificSpaceHeightAnchor.constant = 200
                    self.specificSpaceWidthAnchor.constant = phoneWidth - 24
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
}



class SpacesCell: UICollectionViewCell {
    
    var hostingID: String?
    var parkingSpot: ParkingSpots? {
        didSet {
            if let parking = self.parkingSpot, var streetAddress = parking.streetAddress, let stateAddress = parking.stateAddress, let cityAddress = parking.cityAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType, let timestamp = parking.timestamp {
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
                    
                    if let firstImage = parking.firstImage, firstImage != "" {
                        self.spotImageView.loadImageUsingCacheWithUrlString(firstImage) { (bool) in
                            
                        }
                    }
                }
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        let background = CAGradientLayer().customColor(topColor: Theme.DarkPink, bottomColor: Theme.LightPink)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 220)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var spotImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_4.withAlphaComponent(0.2)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius =  4
        let image = UIImage(named: "exampleParking")
        view.image = image
        
        return view
    }()
    
    var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Two-Car Driveway"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.text = "University Avenue, Boulder CO"
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var destinationIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DarkPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return button
    }()
    
    var listedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK.withAlphaComponent(0.8)
        button.setTitle("Listed on 09/28/2019", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 4
        button.isUserInteractionEnabled = false
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
        view.settings.fillMode = .precise
        view.settings.updateOnTouch = false
        view.settings.starSize = 14
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.YELLOW
        view.settings.emptyBorderColor = Theme.BLACK.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.YELLOW
        view.settings.emptyColor = Theme.BLACK.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.settings.filledImage = UIImage(named: "Star Filled")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "Star Empty")?.withRenderingMode(.alwaysOriginal)
        view.text = "10"
        view.semanticContentAttribute = .forceRightToLeft
        view.settings.textColor = Theme.BLACK.withAlphaComponent(0.8)
        view.settings.textFont = Fonts.SSPSemiBoldH6
        
        return view
    }()
    
    var durationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Today, 10:00AM - 4:00PM", for: .normal)
        button.setTitleColor(Theme.BLACK.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH6
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        button.clipsToBounds = true
        let icon = UIImage(named: "time")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Theme.BLACK.withAlphaComponent(0.8)
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 3, bottom: 3, right: 1)
        button.contentHorizontalAlignment = .right
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowColor = Theme.BLACK.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        
        setupViews()
        setupContainer()
        setupImage()
        setupSpotLabel()
        setupTopButtons()
        setupMiddleButtons()
    }
    
    func setupViews() {
        
        self.addSubview(container)
        container.addSubview(imageContainer)
        container.addSubview(whiteView)
        container.addSubview(spotImageView)
        container.addSubview(spotLabel)
        container.addSubview(destinationIcon)
        container.addSubview(locationLabel)
        container.addSubview(listedButton)
        container.addSubview(availableButton)
        container.addSubview(stars)
        container.addSubview(durationButton)
        
    }
    
    func setupContainer() {
        
        container.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        whiteView.topAnchor.constraint(equalTo: availableButton.bottomAnchor, constant: 16).isActive = true
        whiteView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        whiteView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    func setupImage() {
        
        imageContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        imageContainer.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        imageContainer.widthAnchor.constraint(equalTo: imageContainer.heightAnchor).isActive = true
        imageContainer.heightAnchor.constraint(equalToConstant: 112).isActive = true
        
        spotImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor).isActive = true
        spotImageView.leftAnchor.constraint(equalTo: imageContainer.leftAnchor).isActive = true
        spotImageView.rightAnchor.constraint(equalTo: imageContainer.rightAnchor).isActive = true
        spotImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor).isActive = true
        
    }
    
    func setupSpotLabel() {
        
        spotLabel.bottomAnchor.constraint(equalTo: destinationIcon.topAnchor, constant: -2).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        spotLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        spotLabel.sizeToFit()
        
        destinationIcon.leftAnchor.constraint(equalTo: spotLabel.leftAnchor).isActive = true
        destinationIcon.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16).isActive = true
        destinationIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        destinationIcon.widthAnchor.constraint(equalTo: destinationIcon.heightAnchor).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: destinationIcon.rightAnchor, constant: 6).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: destinationIcon.bottomAnchor, constant: 4).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        locationLabel.sizeToFit()
        
    }
    
    var availableButtonWidth: NSLayoutConstraint!
    
    func setupTopButtons() {
        
        listedButton.topAnchor.constraint(equalTo: spotImageView.topAnchor).isActive = true
        listedButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        listedButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        listedButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        availableButton.topAnchor.constraint(equalTo: listedButton.bottomAnchor, constant: 4).isActive = true
        availableButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        availableButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        availableButtonWidth = availableButton.widthAnchor.constraint(equalToConstant: 78)
            availableButtonWidth.isActive = true
        
    }
    
    func setupMiddleButtons() {
        
        durationButton.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 12).isActive = true
        durationButton.rightAnchor.constraint(equalTo: stars.rightAnchor, constant: 6).isActive = true
        durationButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        durationButton.sizeToFit()
        
        stars.topAnchor.constraint(equalTo: durationButton.bottomAnchor, constant: 4).isActive = true
        stars.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stars.sizeToFit()
        
    }
    
    func makeActiveButton() {
        self.availableButton.setTitle("ACTIVE", for: .normal)
        self.availableButtonWidth.constant = 78
        let background = CAGradientLayer().customColor(topColor: Theme.LightGreen, bottomColor: Theme.DarkGreen)
        background.frame = CGRect(x: 0, y: 0, width: 92, height: 32)
        background.zPosition = -10
        self.availableButton.layer.addSublayer(background)
    }
    
    func makeInactiveButton() {
        self.availableButton.setTitle("INACTIVE", for: .normal)
        self.availableButtonWidth.constant = 86
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
            }
        } else {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                let parkingID = snapshot.key
                let parkingRef = Database.database().reference().child("ParkingSpots").child(parkingID).child("ParkingUnavailability")
                parkingRef.removeValue()
                self.makeActiveButton()
            }
        }
    }
    
    // Tell when the user hits the 'Active' button instead of just selecting the cell
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for i in (0..<subviews.count-1).reversed() {
            let newPoint = subviews[i].convert(point, from: self)
            if let view = subviews[i].hitTest(newPoint, with: event) {
                return view
            }
        }
        return super.hitTest(point, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension HostSpacesViewController: UIScrollViewDelegate {
    
    func resetScrolls() {
        //        self.profitsWallet.scrollView.setContentOffset(.zero, animated: true)
        //        self.profitsChart.scrollView.setContentOffset(.zero, animated: true)
        //        self.profitsRefund.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        self.resetScrolls()
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func dismissAll() {
        delayWithSeconds(0.4) {
            self.closeBackground()
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}

