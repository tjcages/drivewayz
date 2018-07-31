//
//  ParkingReviewsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class ParkingReviewsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    let identifier = "identifier"
    var userName: [String] = []
    var userImage: [String] = []
    var rating: [Int] = []
    var userMessage: [String] = []
    var timestamp: [String] = []

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
        reviews.showsHorizontalScrollIndicator = false
        reviews.showsVerticalScrollIndicator = false
        reviews.register(ReviewsCell.self, forCellWithReuseIdentifier: identifier)
        
        return reviews
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = true
        
        reviewsPicker.dataSource = self
        reviewsPicker.delegate = self
    }
    
    func setData(parkingID: String) {
        self.observeReviews(parkingID: parkingID)
    }
    
    func observeReviews(parkingID: String) {
        self.userName = []
        self.userImage = []
        self.rating = []
        self.userMessage = []
        self.timestamp = []
        let ref = Database.database().reference().child("parking").child(parkingID).child("Reviews")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [AnyObject] {
                for count in dictionary {
                    if let review = count as? [String:AnyObject] {
                        let rating = review["rating"] as? Int
                        let message = review["review"] as? String
                        if let timestamp = review["timestamp"] as? Double {
                            let date = Date(timeIntervalSince1970: timestamp)
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = NSLocale.current
                            dateFormatter.dateFormat = "MM/dd/yyyy"
                            let stringDate = dateFormatter.string(from: date)
                            
                            self.timestamp.append(stringDate)
                            self.reviewsPicker.reloadData()
                        }
                        if let fromUser = review["fromUser"] as? String {
                            let userRef = Database.database().reference().child("users").child(fromUser)
                            userRef.observeSingleEvent(of: .value, with: { (user) in
                                if let info = user.value as? [String:AnyObject] {
                                    let imageURL = info["picture"] as? String
                                    let name = info["name"] as? String
                                    var fullName = name?.split(separator: " ")
                                    let firstName: String = String(fullName![0])
                                    
                                    self.userName.append(firstName)
                                    self.userImage.append(imageURL!)
                                    self.reviewsPicker.reloadData()
                                }
                            })
                        }
                        self.rating.append(rating!)
                        self.userMessage.append(message!)
                    }
                }
            }
        }
        DispatchQueue.main.async(execute: {
            self.setupViews()
            self.reviewsPicker.reloadData()
        })
    }
    
    func setupViews() {
        
        self.view.addSubview(reviewsPicker)
        reviewsPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsPicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        reviewsPicker.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsPicker.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.userImage.reverse()
        self.rating.reverse()
        self.userMessage.reverse()
        self.timestamp.reverse()
        self.userName.reverse()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.userName.count == 0 {
            return 1
        } else {
            return self.userName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! ReviewsCell
        if userName.count == 0 {
            return cell
        }
        cell.userName.text = userName[indexPath.row]
        cell.reviewLabel.text = userMessage[indexPath.row]
        cell.date.text = timestamp[indexPath.row]
        cell.stars.rating = Double(rating[indexPath.row])
        
        if self.userImage[indexPath.row] == "" {
            let image = UIImage(named: "background4")
            cell.imageView.image = image
        } else {
            cell.imageView.loadImageUsingCacheWithUrlString(self.userImage[indexPath.row])
        }
        return cell
    }
    
    

}
