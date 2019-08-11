//
//  ExpandedAmenitiesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedAmenitiesViewController: UIViewController {

    var amenitiesName: [String] = []
    var amenities: [UIImage] = []
    let iconHeight: CGFloat = 135
    private let itemsPerRow: CGFloat = 3
    var sections: CGFloat = 1
    
    var residentialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "AMENITIES"
        
        return label
    }()
    
    var editInformation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        return layout
    }()
    
    lazy var amenitiesPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
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
    }
    
    func setData(hosting: ParkingSpots) {
        if let amenities = hosting.parkingAmenities {
            self.amenities = []
            self.amenitiesName = []
            for i in 0..<amenities.count {
                if amenities[i] == "Covered parking" {
                    self.amenities.append(UIImage(named: "newHostCovered")!)
                    self.amenitiesName.append("Covered parking")
                } else if amenities[i] == "Charging station" {
                    self.amenities.append(UIImage(named: "newHostCharging")!)
                    self.amenitiesName.append("Charging station")
                } else if amenities[i] == "Stadium parking" {
                    self.amenities.append(UIImage(named: "newHostStadium")!)
                    self.amenitiesName.append("Stadium parking")
                } else if amenities[i] == "Beach parking" {
                    self.amenities.append(UIImage(named: "newHostBeach")!)
                    self.amenitiesName.append("Beach parking")
                } else if amenities[i] == "Gated spot" {
                    self.amenities.append(UIImage(named: "newHostGate")!)
                    self.amenitiesName.append("Gated spot")
                } else if amenities[i] == "Nighttime parking" {
                    self.amenities.append(UIImage(named: "newHostNight")!)
                    self.amenitiesName.append("Nighttime parking")
                } else if amenities[i] == "Near Airport" {
                    self.amenities.append(UIImage(named: "newHostAirport")!)
                    self.amenitiesName.append("Near Airport")
                } else if amenities[i] == "Lit space" {
                    self.amenities.append(UIImage(named: "newHostLight")!)
                    self.amenitiesName.append("Lit space")
                } else if amenities[i] == "Large space" {
                    self.amenities.append(UIImage(named: "newHostLarge")!)
                    self.amenitiesName.append("Large space")
                } else if amenities[i] == "Compact space" {
                    self.amenities.append(UIImage(named: "newHostSmall")!)
                    self.amenitiesName.append("Compact space")
                } else if amenities[i] == "Easy to find" {
                    self.amenities.append(UIImage(named: "newHostEasy")!)
                    self.amenitiesName.append("Easy to find")
                }
            }
            sections = CGFloat(CGFloat(self.amenities.count)/3)
            sections.round(.up)
            setupViews()
            self.amenitiesPicker.reloadData()
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(residentialLabel)
        residentialLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        residentialLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        residentialLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        residentialLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(editInformation)
        editInformation.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        editInformation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        editInformation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(amenitiesPicker)
        amenitiesPicker.topAnchor.constraint(equalTo: residentialLabel.bottomAnchor, constant: 4).isActive = true
        amenitiesPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        amenitiesPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        amenitiesPicker.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
        
        self.view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: amenitiesPicker.bottomAnchor, constant: 20).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
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
