//
//  ExpandedReviewsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedReviewsViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var reservationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reviews"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var reviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var reviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There have not been any reviews for this spot yet"
        label.numberOfLines = 2
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.DARK_GRAY
        let background = CAGradientLayer().customColor(topColor: Theme.DARK_GRAY.withAlphaComponent(0.5), bottomColor: Theme.DARK_GRAY)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6

        setupViews()
    }
    
    func setupViews() {
     
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(reservationLabel)
        reservationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36).isActive = true
        reservationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        reservationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        reservationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(reviewView)
        reviewView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 85).isActive = true
        reviewView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        reviewView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        reviewView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        reviewView.addSubview(reviewLabel)
        reviewLabel.leftAnchor.constraint(equalTo: reviewView.leftAnchor, constant: 24).isActive = true
        reviewLabel.rightAnchor.constraint(equalTo: reviewView.rightAnchor, constant: -24).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: reviewView.topAnchor, constant: 20).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: reviewView.bottomAnchor, constant: -20).isActive = true 
        
    }

}
