//
//  ParkingReviewsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingReviewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(fiveStarControl)
        fiveStarControl.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4).isActive = true
        fiveStarControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    let fiveStarControl: FiveStarRating = {
        let five = FiveStarRating(frame: CGRect(x: 0, y: 0, width: Int((5 * kStarSize)) + (4 * kSpacing), height: Int(kStarSize)))
        five.translatesAutoresizingMaskIntoConstraints = false
        
        return five
    }()

}
