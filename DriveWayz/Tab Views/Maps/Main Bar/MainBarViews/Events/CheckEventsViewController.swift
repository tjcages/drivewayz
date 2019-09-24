//
//  CheckEventsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/16/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class CheckEventsViewController: UIViewController {
    
    var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Check out upcoming local events"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Find the best parking options"
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var calendarButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "calendarIcon")
        button.setImage(image, for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 26
//        button.backgroundColor = Theme.WHITE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return button
    }()
    
    var upcomingLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming events"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 10
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(cellView)
        cellView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 84).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        self.view.addSubview(secondaryLabel)
        secondaryLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        secondaryLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        secondaryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        secondaryLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(calendarButton)
        calendarButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        calendarButton.widthAnchor.constraint(equalToConstant: 52).isActive = true
        calendarButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        calendarButton.heightAnchor.constraint(equalTo: calendarButton.widthAnchor).isActive = true
        
        self.view.addSubview(upcomingLabel)
        upcomingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        upcomingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        upcomingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 4).isActive = true
        upcomingLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        let background = CAGradientLayer().customColor(topColor: Theme.BLACK.withAlphaComponent(0.5), bottomColor: Theme.DARK_GRAY)
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        cellView.layer.addSublayer(background)
    }
    
    func changeToCurrentEvents() {
        UIView.animate(withDuration: animationIn) {
            self.mainLabel.alpha = 0
            self.secondaryLabel.alpha = 0
            self.calendarButton.alpha = 0
            self.upcomingLabel.alpha = 1
        }
    }
    
    func changeToBanner() {
        UIView.animate(withDuration: animationOut) {
            self.mainLabel.alpha = 1
            self.secondaryLabel.alpha = 1
            self.calendarButton.alpha = 1
            self.upcomingLabel.alpha = 0
        }
    }

}
