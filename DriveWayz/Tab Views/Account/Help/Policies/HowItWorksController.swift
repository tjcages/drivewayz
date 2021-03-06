//
//  HowItWorksController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HowItWorksController: UIViewController {
    
    var worksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booking a Spot"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var worksView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var mainLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        view.alpha = 0
        
        return view
    }()
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var firstSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter your destination and we link you with the best private spots in that area."
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 2
        
        return label
    }()
    
    var firstButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SALMON.withAlphaComponent(0.1)
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let image = UIImage(named: "worksSearch")
        button.setImage(image, for: .normal)
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        view.alpha = 0
        
        return view
    }()
    
    var firstDottedLine: UIImageView = {
        let image = UIImage(named: "dottedLine")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.BLACK.withAlphaComponent(0.2)
        
        return view
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Book"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var secondSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select the closest parking space to your final destination."
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 2
        
        return label
    }()
    
    var secondButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.COOL_2_LIGHT.withAlphaComponent(0.1)
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let image = UIImage(named: "worksReserve")
        button.setImage(image, for: .normal)
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    var secondLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.2)
        view.alpha = 0
        
        return view
    }()
    
    var secondDottedLine: UIImageView = {
        let image = UIImage(named: "dottedLine")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.BLACK.withAlphaComponent(0.2)
        
        return view
    }()
    
    var thirdDottedLine: UIImageView = {
        let image = UIImage(named: "dottedLine")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.BLACK.withAlphaComponent(0.2)
        
        return view
    }()
    
    var thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Relax"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var thirdSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Never forget where you parked again and rest easy knowing your car is secure!"
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH6
        label.numberOfLines = 2
        
        return label
    }()
    
    var thirdButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LightTeal.withAlphaComponent(0.1)
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        let image = UIImage(named: "worksVehicle")
        button.setImage(image, for: .normal)
        button.layer.borderColor = Theme.WHITE.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    var fourthDottedLine: UIImageView = {
        let image = UIImage(named: "dottedLine")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.BLACK.withAlphaComponent(0.2)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        setupViews()
        setupFirst()
        setupSecond()
        setupThird()
        setupLines()
    }

    func setupViews() {
        
        view.addSubview(worksView)
        view.addSubview(worksLabel)
        worksLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        worksLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        worksLabel.sizeToFit()
        
        worksView.topAnchor.constraint(equalTo: worksLabel.bottomAnchor, constant: 12).isActive = true
        worksView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        worksView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        worksView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(mainLine)
        mainLine.topAnchor.constraint(equalTo: worksLabel.bottomAnchor, constant: 8).isActive = true
        mainLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        mainLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        mainLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupFirst() {
        
        view.addSubview(firstButton)
        firstButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        firstButton.centerYAnchor.constraint(equalTo: mainLine.bottomAnchor, constant: 50).isActive = true
        firstButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        firstButton.heightAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
        
        view.addSubview(firstLabel)
        firstLabel.topAnchor.constraint(equalTo: mainLine.bottomAnchor, constant: 16).isActive = true
        firstLabel.leftAnchor.constraint(equalTo: firstButton.rightAnchor, constant: 16).isActive = true
        firstLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        firstLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(firstSubLabel)
        firstSubLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: -6).isActive = true
        firstSubLabel.leftAnchor.constraint(equalTo: firstButton.rightAnchor, constant: 16).isActive = true
        firstSubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        firstSubLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(firstLine)
        firstLine.topAnchor.constraint(equalTo: firstSubLabel.bottomAnchor, constant: 12).isActive = true
        firstLine.leftAnchor.constraint(equalTo: firstLabel.leftAnchor).isActive = true
        firstLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupSecond() {
        
        view.addSubview(secondButton)
        secondButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        secondButton.centerYAnchor.constraint(equalTo: firstLine.bottomAnchor, constant: 50).isActive = true
        secondButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secondButton.heightAnchor.constraint(equalTo: secondButton.widthAnchor).isActive = true
        
        view.addSubview(secondLabel)
        secondLabel.topAnchor.constraint(equalTo: firstLine.bottomAnchor, constant: 16).isActive = true
        secondLabel.leftAnchor.constraint(equalTo: secondButton.rightAnchor, constant: 16).isActive = true
        secondLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        secondLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(secondSubLabel)
        secondSubLabel.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: -6).isActive = true
        secondSubLabel.leftAnchor.constraint(equalTo: secondButton.rightAnchor, constant: 16).isActive = true
        secondSubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        secondSubLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(secondLine)
        secondLine.topAnchor.constraint(equalTo: secondSubLabel.bottomAnchor, constant: 12).isActive = true
        secondLine.leftAnchor.constraint(equalTo: secondLabel.leftAnchor).isActive = true
        secondLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        secondLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupThird() {
        
        view.addSubview(thirdButton)
        thirdButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        thirdButton.centerYAnchor.constraint(equalTo: secondLine.bottomAnchor, constant: 50).isActive = true
        thirdButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        thirdButton.heightAnchor.constraint(equalTo: thirdButton.widthAnchor).isActive = true
        
        view.addSubview(thirdLabel)
        thirdLabel.topAnchor.constraint(equalTo: secondLine.bottomAnchor, constant: 16).isActive = true
        thirdLabel.leftAnchor.constraint(equalTo: thirdButton.rightAnchor, constant: 16).isActive = true
        thirdLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        thirdLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(thirdSubLabel)
        thirdSubLabel.topAnchor.constraint(equalTo: thirdLabel.bottomAnchor, constant: -6).isActive = true
        thirdSubLabel.leftAnchor.constraint(equalTo: thirdButton.rightAnchor, constant: 16).isActive = true
        thirdSubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        thirdSubLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setupLines() {
        
        view.addSubview(firstDottedLine)
        firstDottedLine.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        firstDottedLine.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 2).isActive = true
        firstDottedLine.bottomAnchor.constraint(equalTo: firstLine.centerYAnchor).isActive = true
        firstDottedLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        view.addSubview(secondDottedLine)
        secondDottedLine.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        secondDottedLine.topAnchor.constraint(equalTo: firstLine.centerYAnchor, constant: 2).isActive = true
        secondDottedLine.bottomAnchor.constraint(equalTo: secondButton.topAnchor, constant: -2).isActive = true
        secondDottedLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        view.addSubview(thirdDottedLine)
        thirdDottedLine.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        thirdDottedLine.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 2).isActive = true
        thirdDottedLine.bottomAnchor.constraint(equalTo: secondLine.centerYAnchor).isActive = true
        thirdDottedLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        view.addSubview(fourthDottedLine)
        fourthDottedLine.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        fourthDottedLine.topAnchor.constraint(equalTo: secondLine.centerYAnchor, constant: 2).isActive = true
        fourthDottedLine.bottomAnchor.constraint(equalTo: thirdButton.topAnchor, constant: -2).isActive = true
        fourthDottedLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
    }

}
