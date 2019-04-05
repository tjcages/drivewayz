//
//  MySpotsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/2/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MySpotsViewController: UIViewController {
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().purpleBlueColor()
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    lazy var gradientContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().purpleBlueColor()
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        view.alpha = 0
        view.clipsToBounds = true
        
        return view
    }()
    
    var whiteContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = phoneWidth*1.5
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Hosted spaces"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH0
        
        return label
    }()
    
    var mainLabelView: UILabel = {
        let label = UILabel()
        label.text = "Hosted spaces"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    var profitsContainer: MyProfitsViewController = {
        let controller = MyProfitsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var reservationsContainer: MyOngoingViewController = {
        let controller = MyOngoingViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var notificationsContainer: MyNotificationsViewController = {
        let controller = MyNotificationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        setupViews()
        setupControllers()
    }
    

    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gradientContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(whiteContainer)
        whiteContainer.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 40).isActive = true
        whiteContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 240).isActive = true
        whiteContainer.widthAnchor.constraint(equalToConstant: phoneWidth * 3.2).isActive = true
        whiteContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1300)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(gradientContainerView)
        gradientContainerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gradientContainerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        gradientContainerView.addSubview(mainLabelView)
        mainLabelView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 64).isActive = true
        mainLabelView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabelView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        switch device {
        case .iphone8:
            mainLabelView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        case .iphoneX:
            mainLabelView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 34).isActive = true
        }
        
    }
    
    func setupControllers() {
        
        scrollView.addSubview(profitsContainer.view)
        profitsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsContainer.view.heightAnchor.constraint(equalToConstant: 168).isActive = true
        switch device {
        case .iphone8:
            profitsContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 180).isActive = true
        case .iphoneX:
            profitsContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 140).isActive = true
        }
        
        scrollView.addSubview(reservationsContainer.view)
        reservationsContainer.view.topAnchor.constraint(equalTo: profitsContainer.view.bottomAnchor, constant: 12).isActive = true
        reservationsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        reservationsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        reservationsContainer.view.heightAnchor.constraint(equalToConstant: 204).isActive = true
        
        scrollView.addSubview(notificationsContainer.view)
        notificationsContainer.view.topAnchor.constraint(equalTo: reservationsContainer.view.bottomAnchor, constant: 12).isActive = true
        notificationsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        notificationsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        notificationsContainer.view.heightAnchor.constraint(equalToConstant: 302).isActive = true
        
    }

}


extension MySpotsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        UIView.animate(withDuration: animationOut) {
            if translation > 24 {
                self.gradientContainerView.alpha = 1
                self.mainLabel.alpha = 0
            } else {
                self.gradientContainerView.alpha = 0
                self.mainLabel.alpha = 1
            }
        }
    }
    
}
