//
//  HostingReviewsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostingReviewsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    let identifier = "identifier"
    var userName: [String] = ["Carter", "Dusty", "Sam", "Jack"]
    var rating: [Int] = [4, 5, 5, 3]
    var userMessage: [String] = ["This is great and very useful!", "Hated everything about it", "Was really close to the pepsi center which was really nice", "There needs to be more parking spaces like this in the area."]
    var timestamp: [String] = ["9/17/2018", "1/24/2019", "9/17/2018", "1/24/2019"]
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        
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
        reviews.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        return reviews
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        reviewsPicker.dataSource = self
        reviewsPicker.delegate = self
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(reviewsPicker)
        reviewsPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reviewsPicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        reviewsPicker.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 24).isActive = true
        reviewsPicker.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! ReviewsCell
        if userName.count != userMessage.count || userName.count !=  timestamp.count || userName.count == 0 {
            cell.reviewLabel.text = "There have not been any reviews for this spot yet."
            cell.date.text = "Current"
            cell.stars.rating = 5
            return cell
        }
        cell.name.text = "- \(userName[indexPath.row])"
        cell.reviewLabel.text = userMessage[indexPath.row]
        cell.date.text = timestamp[indexPath.row]
        cell.stars.rating = Double(rating[indexPath.row])
        
        return cell
    }

}
