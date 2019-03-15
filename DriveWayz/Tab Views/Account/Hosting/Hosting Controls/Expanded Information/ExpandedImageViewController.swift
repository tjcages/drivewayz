//
//  ExpandedImageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ExpandedImageViewController: UIViewController {
    
    var parkingImages: [String] = []
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        
        return view
    }()
    
    lazy var firstImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var secondImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.9)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 1, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var thirdImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.8)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 2, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var fourthImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.7)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 3, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var fifthImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.6)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 4, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var sixthImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.5)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 5, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var seventhImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.4)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 6, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var eighthImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.3)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 7, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var ninethImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.2)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 8, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var tenthImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.1)
        view.contentMode = .scaleAspectFill
        view.frame = CGRect(x: scrollView.frame.width * 9, y: 0, width: self.view.frame.width, height: 200)
        view.clipsToBounds = true
        
        return view
    }()
    
    var editInformation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    func setData(hosting: ParkingSpots) {
        if let hostingImage = hosting.ParkingImages {
            if let firstImage = hostingImage["firstImage"] as? String {
                self.firstImageView.loadImageUsingCacheWithUrlString(firstImage)
                scrollView.addSubview(firstImageView)
            } else if let secondImage = hostingImage["secondImage"] as? String {
                self.secondImageView.loadImageUsingCacheWithUrlString(secondImage)
                scrollView.addSubview(secondImageView)
            } else if let thirdImage = hostingImage["thirdImage"] as? String {
                self.thirdImageView.loadImageUsingCacheWithUrlString(thirdImage)
                scrollView.addSubview(thirdImageView)
            } else if let fourthImage = hostingImage["fourthImage"] as? String {
                self.fourthImageView.loadImageUsingCacheWithUrlString(fourthImage)
                scrollView.addSubview(fourthImageView)
            } else if let fifthImage = hostingImage["fifthImage"] as? String {
                self.fifthImageView.loadImageUsingCacheWithUrlString(fifthImage)
                scrollView.addSubview(fifthImageView)
            } else if let sixthImage = hostingImage["sixthImage"] as? String {
                self.sixthImageView.loadImageUsingCacheWithUrlString(sixthImage)
                scrollView.addSubview(sixthImageView)
            } else if let seventhImage = hostingImage["seventhImage"] as? String {
                self.seventhImageView.loadImageUsingCacheWithUrlString(seventhImage)
                scrollView.addSubview(seventhImageView)
            } else if let eighthImage = hostingImage["eighthImage"] as? String {
                self.eighthImageView.loadImageUsingCacheWithUrlString(eighthImage)
                scrollView.addSubview(eighthImageView)
            } else if let ninethImage = hostingImage["ninethImage"] as? String {
                self.ninethImageView.loadImageUsingCacheWithUrlString(ninethImage)
                scrollView.addSubview(ninethImageView)
            } else if let tenthImage = hostingImage["tenthImage"] as? String {
                self.tenthImageView.loadImageUsingCacheWithUrlString(tenthImage)
                scrollView.addSubview(tenthImageView)
            }
            let width = self.view.frame.width
            scrollView.contentSize = CGSize(width: width * CGFloat(hostingImage.count), height: 200)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(scrollView)
        
        self.view.addSubview(editInformation)
        editInformation.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        editInformation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editInformation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        editInformation.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

}
