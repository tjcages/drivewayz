//
//  ParkingImageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingImageViewController: UIViewController {
    
    var currentParkingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.PRIMARY_DARK_COLOR
        
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear

        setupViews()
    }
    
    func setData(imageURL: String) {
        currentParkingImageView.loadImageUsingCacheWithUrlString(imageURL)
    }
    
    func setupViews() {
        
        self.view.addSubview(currentParkingImageView)
        currentParkingImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        currentParkingImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        currentParkingImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        currentParkingImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
