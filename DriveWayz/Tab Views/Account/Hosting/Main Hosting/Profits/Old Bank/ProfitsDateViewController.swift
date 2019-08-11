//
//  ProfitsDateViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/10/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleProfitCharts {
    func setProfits(amount: Double)
    func setDates(dateString: String)
    
    func disableNextWeek()
    func enableNextWeek()
    func disableLastWeek()
    func enableLastWeek()
}

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
        label.text = ""
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var profitsAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
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
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveDownWeek), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        return button
    }()
    
    var nextWeekButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveUpWeek), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    lazy var chartController: ProfitsChartViewController = {
        let controller = ProfitsChartViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
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
        label.text = "Total bookings"
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var parkersAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var hoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total time"
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var hoursAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Avg. distance"
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var distanceAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var gradientBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BLUE, bottomColor: Theme.LIGHT_BLUE)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 100)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
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
    
    var chartCenterAnchor: NSLayoutConstraint!
    
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
        
        container.addSubview(chartController.view)
        chartCenterAnchor = chartController.view.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            chartCenterAnchor.isActive = true
        chartController.view.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        chartController.view.topAnchor.constraint(equalTo: profitsAmount.bottomAnchor, constant: 32).isActive = true
        chartController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -100).isActive = true
        
    }
    
    func setupValues() {
        
        container.addSubview(line)
        line.topAnchor.constraint(equalTo: chartController.view.bottomAnchor, constant: 24).isActive = true
        line.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        line.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        container.addSubview(gradientBackground)
        gradientBackground.topAnchor.constraint(equalTo: line.topAnchor).isActive = true
        gradientBackground.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        gradientBackground.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        gradientBackground.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
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
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveUpWeek))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveDownWeek))
        rightSwipe.direction = .right
        chartController.view.addGestureRecognizer(leftSwipe)
        chartController.view.addGestureRecognizer(rightSwipe)
        
    }
    
    @objc func moveUpWeek() {
        if nextWeekButton.alpha == 1 {
            let index = self.chartController.previousIndex - 13
            self.chartCenterAnchor.constant = -phoneWidth
            UIView.animate(withDuration: animationIn, animations: {
                self.chartController.selectedView.alpha = 0
                self.chartController.view.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.chartController.setupCharts(index: index)
                self.chartCenterAnchor.constant = 0
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: animationIn, animations: {
                    self.chartController.view.alpha = 1
                })
            }
        }
    }
    
    @objc func moveDownWeek() {
        if lastWeekButton.alpha == 1 {
            let index = self.chartController.previousIndex + 1
            self.chartCenterAnchor.constant = phoneWidth
            UIView.animate(withDuration: animationIn, animations: {
                self.chartController.selectedView.alpha = 0
                self.chartController.view.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.chartController.setupCharts(index: index)
                self.chartCenterAnchor.constant = 0
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: animationIn, animations: {
                    self.chartController.view.alpha = 1
                })
            }
        }
    }
    
}


extension ProfitsDateViewController: handleProfitCharts {
    
    func setProfits(amount: Double) {
        self.profitsAmount.text = String(format:"$%.02f", amount)
    }
    
    func setDates(dateString: String) {
        self.profitsLabel.text = dateString
    }
    
    func disableNextWeek() {
        self.nextWeekButton.isUserInteractionEnabled = false
        self.nextWeekButton.alpha = 0
    }
    
    func enableNextWeek() {
        self.nextWeekButton.isUserInteractionEnabled = true
        self.nextWeekButton.alpha = 1
    }
    
    func disableLastWeek() {
        self.lastWeekButton.isUserInteractionEnabled = false
        self.lastWeekButton.alpha = 0
    }
    
    func enableLastWeek() {
        self.lastWeekButton.isUserInteractionEnabled = true
        self.lastWeekButton.alpha = 1
    }
    
}
