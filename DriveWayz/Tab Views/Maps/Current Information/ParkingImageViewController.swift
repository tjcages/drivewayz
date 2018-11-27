//
//  ParkingImageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingImageViewController: UIViewController {
    
    var numberOfSpots: CGFloat = 4
    
    let parkingView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.text = "Spot 1"
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var pageControl: UIPageControl = {
        let page = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
        page.numberOfPages = 8
        page.currentPage = 0
        page.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        page.pageIndicatorTintColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        page.currentPageIndicatorTintColor = Theme.PACIFIC_BLUE
        page.translatesAutoresizingMaskIntoConstraints = false
        page.isUserInteractionEnabled = false
        
        return page
    }()
    
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        scrollView.delegate = self

        setupViews()
    }
    
    func setData(imageURL: String) {
//        self.numberOfSpots = number
        self.setupImages()
        self.pageControl.numberOfPages = Int(self.numberOfSpots)
        scrollView.contentSize = CGSize(width: (self.view.frame.width) * self.numberOfSpots, height: self.view.frame.width)
        
        parkingImageView1.loadImageUsingCacheWithUrlString(imageURL)
    }
    
    func setupViews() {
        
        self.view.addSubview(parkingView)
        parkingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        parkingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        scrollView.leftAnchor.constraint(equalTo: parkingView.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: parkingView.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: parkingView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: parkingView.bottomAnchor).isActive = true
        
        scrollView.addSubview(parkingImageView1)
        parkingImageView1.widthAnchor.constraint(equalTo: parkingView.widthAnchor).isActive = true
        parkingImageView1.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        parkingImageView1.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView1.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        parkingView.bottomAnchor.constraint(equalTo: parkingImageView1.bottomAnchor, constant: 70).isActive = true
        
        parkingView.addSubview(blackView)
        blackView.centerXAnchor.constraint(equalTo: parkingView.centerXAnchor).isActive = true
        blackView.topAnchor.constraint(equalTo: parkingImageView1.bottomAnchor).isActive = true
        blackView.widthAnchor.constraint(equalTo: parkingView.widthAnchor).isActive = true
        blackView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        parkingView.addSubview(spotLabel)
        spotLabel.leftAnchor.constraint(equalTo: parkingView.leftAnchor, constant: 20).isActive = true
        spotLabel.rightAnchor.constraint(equalTo: parkingView.rightAnchor, constant: -20).isActive = true
        spotLabel.topAnchor.constraint(equalTo: blackView.bottomAnchor, constant: 10).isActive = true
        spotLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        parkingView.addSubview(pageControl)
        pageControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: parkingView.bottomAnchor, constant: -10).isActive = true
        
    }
    
    func setupImages() {
        if numberOfSpots >= 2 {
            self.setupImage2()
        }
        if numberOfSpots >= 3 {
            self.setupImage3()
        }
        if numberOfSpots >= 4 {
            self.setupImage4()
        }
        if numberOfSpots >= 5 {
            self.setupImage5()
        }
        if numberOfSpots >= 6 {
            self.setupImage6()
        }
        if numberOfSpots >= 7 {
            self.setupImage7()
        }
        if numberOfSpots >= 8 {
            self.setupImage8()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var parkingImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var parkingImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var parkingImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var parkingImageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var parkingImageView5: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var parkingImageView6: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.5)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var parkingImageView7: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var parkingImageView8: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.3)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
}


extension ParkingImageViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = Int(pageNumber)
        self.spotLabel.text = "Spot \(Int(pageNumber+1))"
    }
}


extension ParkingImageViewController {
    
    func setupImage2() {
        scrollView.addSubview(parkingImageView2)
        parkingImageView2.widthAnchor.constraint(equalTo: parkingImageView1.widthAnchor).isActive = true
        parkingImageView2.leftAnchor.constraint(equalTo: parkingImageView1.rightAnchor).isActive = true
        parkingImageView2.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView2.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
    func setupImage3() {
        scrollView.addSubview(parkingImageView3)
        parkingImageView3.widthAnchor.constraint(equalTo: parkingImageView1.widthAnchor).isActive = true
        parkingImageView3.leftAnchor.constraint(equalTo: parkingImageView2.rightAnchor).isActive = true
        parkingImageView3.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView3.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
    func setupImage4() {
        scrollView.addSubview(parkingImageView4)
        parkingImageView4.widthAnchor.constraint(equalTo: parkingImageView1.widthAnchor).isActive = true
        parkingImageView4.leftAnchor.constraint(equalTo: parkingImageView3.rightAnchor).isActive = true
        parkingImageView4.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView4.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
    func setupImage5() {
        scrollView.addSubview(parkingImageView5)
        parkingImageView5.widthAnchor.constraint(equalTo: parkingImageView1.widthAnchor).isActive = true
        parkingImageView5.leftAnchor.constraint(equalTo: parkingImageView4.rightAnchor).isActive = true
        parkingImageView5.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView5.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
    func setupImage6() {
        scrollView.addSubview(parkingImageView6)
        parkingImageView6.widthAnchor.constraint(equalTo: parkingImageView1.widthAnchor).isActive = true
        parkingImageView6.leftAnchor.constraint(equalTo: parkingImageView5.rightAnchor).isActive = true
        parkingImageView6.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView6.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
    func setupImage7() {
        scrollView.addSubview(parkingImageView7)
        parkingImageView7.widthAnchor.constraint(equalTo: parkingImageView1.widthAnchor).isActive = true
        parkingImageView7.leftAnchor.constraint(equalTo: parkingImageView6.rightAnchor).isActive = true
        parkingImageView7.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView7.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
    func setupImage8() {
        scrollView.addSubview(parkingImageView8)
        parkingImageView8.widthAnchor.constraint(equalTo: parkingImageView1.widthAnchor).isActive = true
        parkingImageView8.leftAnchor.constraint(equalTo: parkingImageView7.rightAnchor).isActive = true
        parkingImageView8.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parkingImageView8.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
}
