//
//  ExpandedAmenitiesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedAmenitiesViewController: UIViewController {

    var amenitiesName: [String] = ["Book a spot", "My bookings", "Vehicle", "Inbox", "Become a host", "Help"]
    var amenities: [UIImage] = [UIImage(named: "location")!, UIImage(named: "calendar")!, UIImage(named: "car")!, UIImage(named: "inbox")!, UIImage(named: "home-1")!, UIImage(named: "tool")!]
    let iconHeight: CGFloat = 135
    private let itemsPerRow: CGFloat = 3
    var sections: CGFloat = 1
    var height: CGFloat = 0
    
    var residentialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "Amenities"
        
        return label
    }()
    
    var editInformation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.PURPLE.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        
        return layout
    }()
    
    lazy var amenitiesPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        view.clipsToBounds = false
        view.register(AmenitiesCell.self, forCellWithReuseIdentifier: "Cell")
        
        return view
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amenitiesPicker.delegate = self
        amenitiesPicker.dataSource = self
        
        setupViews()
    }
    
    func setData(hosting: ParkingSpots) {
        if let amenities = hosting.parkingAmenities {
            self.amenities = []
            self.amenitiesName = []
            for i in 0..<amenities.count {
                if amenities[i] == "covered" {
                    self.amenities.append(UIImage(named: "coveredParkingIcon-1")!)
                    self.amenitiesName.append("Covered parking")
                } else if amenities[i] == "charging" {
                    self.amenities.append(UIImage(named: "chargingParkingIcon")!)
                    self.amenitiesName.append("Charging station")
                } else if amenities[i] == "stadium" {
                    self.amenities.append(UIImage(named: "stadiumParkingIcon")!)
                    self.amenitiesName.append("Stadium parking")
                } else if amenities[i] == "gated" {
                    self.amenities.append(UIImage(named: "gateParkingIcon")!)
                    self.amenitiesName.append("Gated spot")
                } else if amenities[i] == "night" {
                    self.amenities.append(UIImage(named: "nightParkingIcon")!)
                    self.amenitiesName.append("Nighttime parking")
                } else if amenities[i] == "airport" {
                    self.amenities.append(UIImage(named: "airportParkingIcon")!)
                    self.amenitiesName.append("Near Airport")
                } else if amenities[i] == "lighted" {
                    self.amenities.append(UIImage(named: "lightingParkingIcon")!)
                    self.amenitiesName.append("Lit space")
                } else if amenities[i] == "large" {
                    self.amenities.append(UIImage(named: "largeParkingIcon")!)
                    self.amenitiesName.append("Large space")
                } else if amenities[i] == "small" {
                    self.amenities.append(UIImage(named: "smallParkingIcon")!)
                    self.amenitiesName.append("Compact space")
                } else if amenities[i] == "easy" {
                    self.amenities.append(UIImage(named: "easyParkingIcon")!)
                    self.amenitiesName.append("Easy to find")
                }
            }
            self.amenitiesPicker.reloadData()
            sections = CGFloat(CGFloat(self.amenities.count)/3)
            sections.round(.up)
//            setupViews()
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(residentialLabel)
        residentialLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        residentialLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        residentialLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        residentialLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(editInformation)
        editInformation.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        editInformation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        editInformation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(amenitiesPicker)
        amenitiesPicker.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: 14).isActive = true
        amenitiesPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        amenitiesPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        amenitiesPicker.heightAnchor.constraint(equalToConstant: iconHeight * sections).isActive = true
        
        self.view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: amenitiesPicker.bottomAnchor, constant: 24).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        height = 54 + iconHeight * sections + 36
    }
    
}


extension ExpandedAmenitiesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenities.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = 12 * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! AmenitiesCell
        cell.image = amenities[indexPath.row]
        cell.iconLabel.text = amenitiesName[indexPath.row]
        
        return cell
    }
    
}
