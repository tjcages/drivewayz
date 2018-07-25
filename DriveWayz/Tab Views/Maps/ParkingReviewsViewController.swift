//
//  ParkingReviewsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingReviewsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var Reviews: [String] = ["Hello", "World"]
    let identifier = "identifier"

    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    
    lazy var reviewsPicker: UICollectionView = {
        let reviews = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        reviews.backgroundColor = UIColor.clear
        reviews.tintColor = Theme.WHITE
        reviews.translatesAutoresizingMaskIntoConstraints = false
        reviews.register(ReviewsCell.self, forCellWithReuseIdentifier: identifier)
        
        return reviews
    }()
    
    let fiveStarControl: FiveStarRating = {
        let five = FiveStarRating(frame: CGRect(x: 0, y: 0, width: Int((5 * kStarSize)) + (4 * kSpacing), height: Int(kStarSize)))
        five.translatesAutoresizingMaskIntoConstraints = false
        
        return five
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = true
        
        reviewsPicker.dataSource = self
        reviewsPicker.delegate = self
        
        setupViews()
    }
    
    func setData(parkingID: String) {
    }
    
    func setupViews() {
        
        self.view.addSubview(reviewsPicker)
        reviewsPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsPicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        reviewsPicker.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsPicker.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
//        self.view.addSubview(fiveStarControl)
//        fiveStarControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
//        fiveStarControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        fiveStarControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        fiveStarControl.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath)
        return cell
    }
    
    

}
