//
//  NavigationImagesView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationImagesView: UIViewController {
    
    var parkingImages: [UIImage] = []
    var selectedParking: ParkingSpots?
    var blankImageView = UIImageView()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var spacesPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = Theme.GRAY_WHITE_4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(SpacesImage.self, forCellWithReuseIdentifier: "Cell")
        
        return view
    }()
    
    func setData(hosting: ParkingSpots) {
        checkImages(parking: hosting)
    }
    
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
        
        spacesPicker.delegate = self
        spacesPicker.dataSource = self

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(spacesPicker)
        spacesPicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spacesPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        spacesPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        spacesPicker.heightAnchor.constraint(equalToConstant: 280).isActive = true

    }

}

// Populate spaces collectionView
extension NavigationImagesView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
