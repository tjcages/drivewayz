//
//  BookingInfoViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class BookingImageViewController: UIViewController {
    
    var parkingImages: [UIImage] = []
    
    var destinationIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.SALMON
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "University Heights Avenue"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "One-Car Driveway"
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = StarFillMode.precise
        view.settings.starSize = 20
        view.settings.starMargin = 0
        view.settings.filledColor = Theme.YELLOW
        view.settings.emptyBorderColor = Theme.BLACK.withAlphaComponent(0.2)
        view.settings.filledBorderColor = Theme.YELLOW
        view.settings.emptyColor = Theme.BLACK.withAlphaComponent(0.2)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    var starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5.0"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
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
        
        return view
    }()
    
    var overviewButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Overview", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var paymentButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Payment", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        label.alpha = 0.2
        
        return label
    }()
    
    var reviewsButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Reviews", for: .normal)
        label.setTitleColor(Theme.BLACK, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        label.alpha = 0.2
        
        return label
    }()
    
    var selectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GREEN
        
        return view
    }()
    
    var blankImageView = UIImageView()
    
    func checkImages(parking: ParkingSpots) {
        self.spacesPicker.reloadData()
        if let image = parking.firstImage {
            self.appendNewImage(url: image, index: 0)
        }
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

        view.backgroundColor = Theme.WHITE
        
        spacesPicker.delegate = self
        spacesPicker.dataSource = self
        
        setupViews()
        setupImage()
        setupOptions()
    }
    
    func setupViews() {
        
        self.view.addSubview(destinationIcon)
        destinationIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        destinationIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        destinationIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        destinationIcon.widthAnchor.constraint(equalTo: destinationIcon.heightAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: destinationIcon.rightAnchor, constant: 6).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: destinationIcon.bottomAnchor, constant: 4).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        subLabel.sizeToFit()
        
        self.view.addSubview(starLabel)
        self.view.addSubview(stars)
        starLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starLabel.rightAnchor.constraint(equalTo: stars.leftAnchor, constant: -2).isActive = true
        starLabel.sizeToFit()
        
        stars.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        stars.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    var bookedImageHeight: CGFloat = 300
    
    func setupImage() {
        
        switch device {
        case .iphone8:
            bookedImageHeight = 280
        case .iphoneX:
            bookedImageHeight = 300
        }
        
        self.view.addSubview(spacesPicker)
        spacesPicker.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 20).isActive = true
        spacesPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        spacesPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        spacesPicker.heightAnchor.constraint(equalToConstant: bookedImageHeight).isActive = true

    }
    
    var selectionCenterAnchor: NSLayoutConstraint!
    
    func setupOptions() {
        
        self.view.addSubview(overviewButton)
        overviewButton.topAnchor.constraint(equalTo: spacesPicker.bottomAnchor, constant: 12).isActive = true
        overviewButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        overviewButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        overviewButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        
        self.view.addSubview(paymentButton)
        paymentButton.topAnchor.constraint(equalTo: spacesPicker.bottomAnchor, constant: 12).isActive = true
        paymentButton.leftAnchor.constraint(equalTo: overviewButton.rightAnchor).isActive = true
        paymentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        paymentButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        
        self.view.addSubview(reviewsButton)
        reviewsButton.topAnchor.constraint(equalTo: spacesPicker.bottomAnchor, constant: 12).isActive = true
        reviewsButton.leftAnchor.constraint(equalTo: paymentButton.rightAnchor).isActive = true
        reviewsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reviewsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionCenterAnchor = selectionLine.centerXAnchor.constraint(equalTo: overviewButton.centerXAnchor)
            selectionCenterAnchor.isActive = true
        selectionLine.topAnchor.constraint(equalTo: overviewButton.bottomAnchor, constant: 2).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}


// Populate spaces collectionView
extension BookingImageViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
