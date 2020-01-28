//
//  BookingReviewsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingReviewsViewController: UIViewController {
    
    let identifier = "identifier"
    var reviews: [Reviews] = [] {
        didSet {
            self.reviewsReversed = []
            for arrayIndex in stride(from: self.reviews.count - 1, through: 0, by: -1) {
                self.reviewsReversed.append(self.reviews[arrayIndex])
            }
        }
    }
    var reviewsReversed: [Reviews] = []
    var noteTimestamps: [TimeInterval] = []
    
    var bookingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.text = "Total bookings"
        
        return label
    }()
    
    var bookingsValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.text = "30"
        label.textAlignment = .right
        
        return label
    }()
    
    var bookingsLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var reviewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        return layout
    }()
    
    lazy var reviewPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: reviewLayout)
        picker.backgroundColor = UIColor.clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsVerticalScrollIndicator = false
        picker.register(ReviewsCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
//        picker.isPagingEnabled = true
        
        return picker
    }()
    
    func setData(parking: ParkingSpots) {
        if let parkingID = parking.parkingID {
            self.reviews = []
            self.noteTimestamps = []
            let ref = Database.database().reference().child("ParkingSpots").child(parkingID).child("Reviews")
            ref.observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let review = Reviews(dictionary: dictionary)
                    guard let timestamp = review.timestamp else { return }
                    if !self.noteTimestamps.contains(timestamp) {
                        self.reviews.append(review)
                        self.noteTimestamps.append(timestamp)
                        self.reviewPicker.reloadData()
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewPicker.delegate = self
        reviewPicker.dataSource = self

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(bookingsLabel)
        bookingsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        bookingsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        bookingsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        bookingsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(bookingsValue)
        bookingsValue.topAnchor.constraint(equalTo: bookingsLabel.bottomAnchor).isActive = true
        bookingsValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        bookingsValue.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bookingsValue.sizeToFit()
        
        self.view.addSubview(bookingsLine)
        bookingsLine.centerYAnchor.constraint(equalTo: bookingsValue.centerYAnchor).isActive = true
        bookingsLine.rightAnchor.constraint(equalTo: bookingsValue.leftAnchor, constant: -16).isActive = true
        bookingsLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        bookingsLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(reviewPicker)
        reviewPicker.topAnchor.constraint(equalTo: bookingsValue.bottomAnchor, constant: 24).isActive = true
        reviewPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        reviewPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        reviewPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
    }

}


extension BookingReviewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 3/4, height: collectionView.bounds.height - 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! ReviewsCell
        
        if self.reviews.count > indexPath.row {
            let review = self.reviewsReversed[indexPath.row]
            if let date = review.date, let image = review.notificationImage, let title = review.title, let rating = review.rating, let name = review.name {
                cell.date.text = date
                cell.title = title
                cell.starImageView.image = image
                cell.stars.rating = Double(rating)
                
                let nameArray = name.split(separator: " ")
                if let firstName = nameArray.first {
                    cell.nameLabel.text = "- \(String(firstName))"
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
}
