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
                UIView.animate(withDuration: animationIn) {
                    self.firstIcon.alpha = 0
                    self.firstIcon.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.secondIcon.alpha = 0
                    self.secondIcon.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
            } else if percent >= 1 && percent <= 2 {
                percent = percent - 1
                self.secondLabel.alpha = 1 - 0.6 * percent
                self.secondLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                self.thirdLabel.alpha = 0.4 + 0.6 * percent
                self.thirdLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percent, y: 0.8 + 0.2 * percent)
                self.scrollView.contentOffset.x = translation * 0.4
                UIView.animate(withDuration: animationIn) {
                    self.firstIcon.alpha = 0
                    self.firstIcon.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.secondIcon.alpha = 0
                    self.secondIcon.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
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
        label.text = "Prime Spot"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH4
        label.textAlignment = .center
        
        return label
    }()
    
    var firstIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "verificationIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.STRAWBERRY_PINK
        
        let check = UIButton(frame: CGRect(x: 2, y: 2, width: 14, height: 14))
        let origImage2 = UIImage(named: "Checkmark")
        let tintedImage2 = origImage2?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        check.setImage(tintedImage2, for: .normal)
        check.tintColor = Theme.WHITE
        button.addSubview(check)
        
        return button
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Economy"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH4
        label.textAlignment = .center
        label.alpha = 0.4
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    var secondIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "verificationIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GREEN_PIGMENT
        button.alpha = 0
        button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        let check = UIButton(frame: CGRect(x: 2, y: 2, width: 14, height: 14))
        let origImage2 = UIImage(named: "dollarIcon")
        let tintedImage2 = origImage2?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        check.setImage(tintedImage2, for: .normal)
        check.tintColor = Theme.WHITE
        button.addSubview(check)
        
        return button
    }()
    
    var thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Standard"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH4
        label.textAlignment = .center
        label.alpha = 0.4
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(firstLabel)
        scrollView.addSubview(firstIcon)
        firstLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 4).isActive = true
        firstLabel.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: phoneWidth/2 + 10).isActive = true
        firstLabel.sizeToFit()
        
        firstIcon.centerYAnchor.constraint(equalTo: firstLabel.centerYAnchor).isActive = true
        firstIcon.rightAnchor.constraint(equalTo: firstLabel.leftAnchor, constant: -6).isActive = true
        firstIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        firstIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        scrollView.addSubview(secondLabel)
        scrollView.addSubview(secondIcon)
        secondLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 4).isActive = true
        secondLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: phoneWidth * 0.4 + 10).isActive = true
        secondLabel.sizeToFit()
        
        secondIcon.centerYAnchor.constraint(equalTo: secondLabel.centerYAnchor).isActive = true
        secondIcon.rightAnchor.constraint(equalTo: secondLabel.leftAnchor, constant: -6).isActive = true
        secondIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        secondIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        scrollView.addSubview(thirdLabel)
        thirdLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 4).isActive = true
        thirdLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: phoneWidth * 0.8).isActive = true
        thirdLabel.sizeToFit()

    }

}
