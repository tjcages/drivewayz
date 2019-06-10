//
//  BookingSliderViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingSliderViewController: UIViewController {
    
    var translation: CGFloat = 0.0 {
        didSet {
            var percent = translation/phoneWidth
            if percent >= 0 && percent <= 1 {
                self.firstLabel.alpha = 1 - 0.6 * percent
                self.firstLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                self.secondLabel.alpha = 0.4 + 0.6 * percent
                self.secondLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percent, y: 0.8 + 0.2 * percent)
                self.scrollView.contentOffset.x = translation * 0.4
            } else if percent >= 1 && percent <= 2 {
                percent = percent - 1
                self.secondLabel.alpha = 1 - 0.6 * percent
                self.secondLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                self.thirdLabel.alpha = 0.4 + 0.6 * percent
                self.thirdLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percent, y: 0.8 + 0.2 * percent)
                self.scrollView.contentOffset.x = translation * 0.4
            }
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Prime"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Economy"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        label.alpha = 0.4
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    var thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Standard"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        label.alpha = 0.4
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(firstLabel)
        firstLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 4).isActive = true
        firstLabel.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: phoneWidth/2).isActive = true
        firstLabel.sizeToFit()
        
        scrollView.addSubview(secondLabel)
        secondLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 4).isActive = true
        secondLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: phoneWidth * 0.4).isActive = true
        secondLabel.sizeToFit()
        
        scrollView.addSubview(thirdLabel)
        thirdLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 4).isActive = true
        thirdLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: phoneWidth * 0.8).isActive = true
        thirdLabel.sizeToFit()

    }

}
