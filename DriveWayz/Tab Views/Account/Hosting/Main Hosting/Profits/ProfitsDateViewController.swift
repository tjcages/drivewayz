//
//  ProfitsDateViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProfitsDateViewController: UIViewController {
    
    let containerWidth = phoneWidth - 24
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()

    var profitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dec 7-14"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var profitsAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$159.90"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPBoldH0
        label.textAlignment = .center
        
        return label
    }()
    
    var lastWeekButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: -90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveDownWeek), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    var nextWeekButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveUpWeek), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    lazy var chartController1: ProfitsChartViewController = {
        let controller = ProfitsChartViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var chartController2: ProfitsChartViewController = {
        let controller = ProfitsChartViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var chartController3: ProfitsChartViewController = {
        let controller = ProfitsChartViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var parkersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total parkers"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var parkersAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "15"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var hoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total hours"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var hoursAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "17h 30 min"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Avg. distance"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var distanceAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.45 mi"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0
        view.layer.cornerRadius = 4
        
        setupViews()
        setupValues()
    }
    
    var chart1CenterAnchor: NSLayoutConstraint!
    var chart2CenterAnchor: NSLayoutConstraint!
    var chart3CenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        container.addSubview(profitsLabel)
        profitsLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profitsLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        profitsLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        profitsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(profitsAmount)
        profitsAmount.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profitsAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        profitsAmount.topAnchor.constraint(equalTo: profitsLabel.bottomAnchor, constant: 0).isActive = true
        profitsAmount.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        container.addSubview(lastWeekButton)
        lastWeekButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 6).isActive = true
        lastWeekButton.centerYAnchor.constraint(equalTo: profitsAmount.centerYAnchor).isActive = true
        lastWeekButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        lastWeekButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        container.addSubview(nextWeekButton)
        nextWeekButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -6).isActive = true
        nextWeekButton.centerYAnchor.constraint(equalTo: profitsAmount.centerYAnchor).isActive = true
        nextWeekButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        nextWeekButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        container.addSubview(chartController1.view)
        chart1CenterAnchor = chartController1.view.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -containerWidth)
            chart1CenterAnchor.isActive = true
        chartController1.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        chartController1.view.topAnchor.constraint(equalTo: profitsAmount.bottomAnchor, constant: 32).isActive = true
        chartController1.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -100).isActive = true
        
        container.addSubview(chartController2.view)
        chart2CenterAnchor = chartController2.view.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            chart2CenterAnchor.isActive = true
        chartController2.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        chartController2.view.topAnchor.constraint(equalTo: profitsAmount.bottomAnchor, constant: 32).isActive = true
        chartController2.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -100).isActive = true
        
        container.addSubview(chartController3.view)
        chart3CenterAnchor = chartController3.view.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: containerWidth)
            chart3CenterAnchor.isActive = true
        chartController3.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        chartController3.view.topAnchor.constraint(equalTo: profitsAmount.bottomAnchor, constant: 32).isActive = true
        chartController3.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -100).isActive = true
        
    }
    
    func setupValues() {
        
        container.addSubview(line)
        line.topAnchor.constraint(equalTo: chartController1.view.bottomAnchor, constant: 24).isActive = true
        line.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        line.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(parkersLabel)
        parkersLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        parkersLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        parkersLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        parkersLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(hoursLabel)
        hoursLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        hoursLabel.widthAnchor.constraint(equalToConstant: (hoursLabel.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH5))!).isActive = true
        hoursLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        hoursLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(distanceLabel)
        distanceLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: (distanceLabel.text?.width(withConstrainedHeight: 20, font: Fonts.SSPRegularH5))!).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(parkersAmount)
        parkersAmount.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        parkersAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        parkersAmount.topAnchor.constraint(equalTo: parkersLabel.bottomAnchor, constant: 2).isActive = true
        parkersAmount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(hoursAmount)
        hoursAmount.leftAnchor.constraint(equalTo: hoursLabel.leftAnchor).isActive = true
        hoursAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        hoursAmount.topAnchor.constraint(equalTo: parkersLabel.bottomAnchor, constant: 2).isActive = true
        hoursAmount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(distanceAmount)
        distanceAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        distanceAmount.leftAnchor.constraint(equalTo: distanceLabel.leftAnchor).isActive = true
        distanceAmount.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 2).isActive = true
        distanceAmount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    @objc func moveUpWeek() {
        if chart1CenterAnchor.constant == 0 {
            self.chart1CenterAnchor.constant = -containerWidth
            self.chart2CenterAnchor.constant = 0
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.chartController3.view.isHidden = true
                self.chart3CenterAnchor.constant = self.containerWidth
                self.view.layoutIfNeeded()
                self.chartController3.view.isHidden = false
            }
        } else if chart2CenterAnchor.constant == 0 {
            self.chart2CenterAnchor.constant = -containerWidth
            self.chart3CenterAnchor.constant = 0
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.chartController1.view.isHidden = true
                self.chart1CenterAnchor.constant = self.containerWidth
                self.view.layoutIfNeeded()
                self.chartController1.view.isHidden = false
            }
        } else if chart3CenterAnchor.constant == 0 {
            self.chart3CenterAnchor.constant = -containerWidth
            self.chart1CenterAnchor.constant = 0
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.chartController2.view.isHidden = true
                self.chart2CenterAnchor.constant = self.containerWidth
                self.view.layoutIfNeeded()
                self.chartController2.view.isHidden = false
            }
        }
        delayWithSeconds(animationIn * 2) {
            self.chartController1.view.isHidden = false
            self.chartController1.view.isHidden = false
            self.chartController1.view.isHidden = false
        }
    }
    
    @objc func moveDownWeek() {
        if chart1CenterAnchor.constant == 0 {
            self.chart1CenterAnchor.constant = containerWidth
            self.chart3CenterAnchor.constant = 0
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.chartController2.view.isHidden = true
                self.chart2CenterAnchor.constant = -self.containerWidth
                self.view.layoutIfNeeded()
                self.chartController2.view.isHidden = false
            }
        } else if chart2CenterAnchor.constant == 0 {
            self.chart2CenterAnchor.constant = containerWidth
            self.chart1CenterAnchor.constant = 0
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.chartController3.view.isHidden = true
                self.chart3CenterAnchor.constant = -self.containerWidth
                self.view.layoutIfNeeded()
                self.chartController3.view.isHidden = false
            }
        } else if chart3CenterAnchor.constant == 0 {
            self.chart3CenterAnchor.constant = containerWidth
            self.chart2CenterAnchor.constant = 0
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.chartController1.view.isHidden = true
                self.chart1CenterAnchor.constant = -self.containerWidth
                self.view.layoutIfNeeded()
                self.chartController1.view.isHidden = false
            }
        }
        delayWithSeconds(animationIn * 2) {
            self.chartController1.view.isHidden = false
            self.chartController1.view.isHidden = false
            self.chartController1.view.isHidden = false
        }
    }

    func resetCharts() {
        self.chart1CenterAnchor.constant = -containerWidth
        self.chart2CenterAnchor.constant = 0
        self.chart3CenterAnchor.constant = containerWidth
        self.view.layoutIfNeeded()
        self.chartController1.view.isHidden = false
        self.chartController1.view.isHidden = false
        self.chartController1.view.isHidden = false
    }
    
}
