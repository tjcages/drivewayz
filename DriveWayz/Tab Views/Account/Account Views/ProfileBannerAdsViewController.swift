//
//  ProfileBannerAdsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/6/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class ProfileBannerAdsViewController: UIViewController {

    var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    var bannerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.8
        view.clipsToBounds = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        setData()
        setupViews()
    }
    
    func setData() {
        let ref = Database.database().reference().child("BannerAds")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let imageURL = dictionary["parkingReimagined"] as? String {
                    self.bannerImageView.loadImageUsingCacheWithUrlString(imageURL)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func setupViews() {
        self.view.addSubview(bannerImageView)
        bannerImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bannerImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bannerImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 15).isActive = true
        bannerImageView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        
        self.view.addSubview(bannerContainer)
        self.view.sendSubview(toBack: bannerContainer)
        bannerContainer.centerXAnchor.constraint(equalTo: bannerImageView.centerXAnchor).isActive = true
        bannerContainer.centerYAnchor.constraint(equalTo: bannerImageView.centerYAnchor).isActive = true
        bannerContainer.widthAnchor.constraint(equalTo: bannerImageView.widthAnchor).isActive = true
        bannerContainer.heightAnchor.constraint(equalTo: bannerImageView.heightAnchor).isActive = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
