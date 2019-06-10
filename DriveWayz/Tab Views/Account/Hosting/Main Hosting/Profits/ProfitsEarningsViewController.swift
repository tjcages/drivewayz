//
//  ProfitsEarningsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProfitsEarningsViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var earningsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earnings"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var totalProfitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total profits"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var feesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Payment fees"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var drivewayzLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz fees"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var earningsAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$1959.90"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .right
        
        return label
    }()
    
    var totalProfitsAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$2230.00"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var feesAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$69.80"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var drivewayzAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$206.40"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var firstLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var secondLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var thirdLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var fourthLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(earningsLabel)
        earningsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        earningsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        earningsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        earningsLabel.sizeToFit()
        
        self.view.addSubview(earningsAmount)
        earningsAmount.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        earningsAmount.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        earningsAmount.heightAnchor.constraint(equalToConstant: 25).isActive = true
        earningsAmount.sizeToFit()
        
        self.view.addSubview(totalProfitsLabel)
        totalProfitsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        totalProfitsLabel.topAnchor.constraint(equalTo: earningsLabel.bottomAnchor, constant: 4).isActive = true
        totalProfitsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        totalProfitsLabel.sizeToFit()
        
        self.view.addSubview(totalProfitsAmount)
        totalProfitsAmount.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        totalProfitsAmount.topAnchor.constraint(equalTo: earningsLabel.bottomAnchor, constant: 4).isActive = true
        totalProfitsAmount.heightAnchor.constraint(equalToConstant: 25).isActive = true
        totalProfitsLabel.sizeToFit()
        
        self.view.addSubview(feesLabel)
        feesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        feesLabel.topAnchor.constraint(equalTo: totalProfitsLabel.bottomAnchor, constant: 4).isActive = true
        feesLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        feesLabel.sizeToFit()
        
        self.view.addSubview(feesAmount)
        feesAmount.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        feesAmount.topAnchor.constraint(equalTo: totalProfitsLabel.bottomAnchor, constant: 4).isActive = true
        feesAmount.heightAnchor.constraint(equalToConstant: 25).isActive = true
        feesAmount.sizeToFit()
        
        self.view.addSubview(drivewayzLabel)
        drivewayzLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        drivewayzLabel.topAnchor.constraint(equalTo: feesLabel.bottomAnchor, constant: 4).isActive = true
        drivewayzLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        drivewayzLabel.sizeToFit()
        
        self.view.addSubview(drivewayzAmount)
        drivewayzAmount.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        drivewayzAmount.topAnchor.constraint(equalTo: feesLabel.bottomAnchor, constant: 4).isActive = true
        drivewayzAmount.heightAnchor.constraint(equalToConstant: 25).isActive = true
        drivewayzAmount.sizeToFit()
        
        self.view.addSubview(firstLine)
        firstLine.leftAnchor.constraint(equalTo: earningsLabel.rightAnchor, constant: 4).isActive = true
        firstLine.rightAnchor.constraint(equalTo: earningsAmount.leftAnchor, constant: -4).isActive = true
        firstLine.bottomAnchor.constraint(equalTo: earningsLabel.bottomAnchor, constant: -6).isActive = true
        firstLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(secondLine)
        secondLine.leftAnchor.constraint(equalTo: totalProfitsLabel.rightAnchor, constant: 4).isActive = true
        secondLine.rightAnchor.constraint(equalTo: totalProfitsAmount.leftAnchor, constant: -4).isActive = true
        secondLine.bottomAnchor.constraint(equalTo: totalProfitsLabel.bottomAnchor, constant: -6).isActive = true
        secondLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(thirdLine)
        thirdLine.leftAnchor.constraint(equalTo: feesLabel.rightAnchor, constant: 4).isActive = true
        thirdLine.rightAnchor.constraint(equalTo: feesAmount.leftAnchor, constant: -4).isActive = true
        thirdLine.bottomAnchor.constraint(equalTo: feesLabel.bottomAnchor, constant: -6).isActive = true
        thirdLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(fourthLine)
        fourthLine.leftAnchor.constraint(equalTo: drivewayzLabel.rightAnchor, constant: 4).isActive = true
        fourthLine.rightAnchor.constraint(equalTo: drivewayzAmount.leftAnchor, constant: -4).isActive = true
        fourthLine.bottomAnchor.constraint(equalTo: drivewayzLabel.bottomAnchor, constant: -6).isActive = true
        fourthLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
}
