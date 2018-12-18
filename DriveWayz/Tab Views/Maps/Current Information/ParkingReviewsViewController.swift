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
        layout.minimumLineSpacing = 12
        
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
        self.view.backgroundColor = Theme.WHITE
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
        self.reviewsPicker.reloadData()
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
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = cellWidth
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        return index
    }
    
    private var indexOfCellBeforeDragging = 0
    lazy var cellWidth: CGFloat = self.view.frame.width-100
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        // Calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.3
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < self.userName.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = cellWidth * CGFloat(snapToIndex)
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.userName.count == 0 {
            return 4
        } else {
            return self.userName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! ReviewsCell
        if userName.count != userMessage.count || userName.count != userImage.count || userName.count !=  timestamp.count || userName.count == 0 {
            cell.reviewLabel.text = "There have not been any reviews for this spot yet."
            cell.date.text = "Current"
            cell.stars.rating = 5
            return cell
        }
        cell.reviewLabel.text = userMessage[indexPath.row]
        cell.date.text = timestamp[indexPath.row]
        cell.stars.rating = Double(rating[indexPath.row])

        return cell
    }

}
