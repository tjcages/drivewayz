//
//  ProfitsChartViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProfitsChartViewController: UIViewController {
    
    let halfWidth = (phoneWidth - 54)/7
    
    var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 2
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0
        view.layer.shadowOffset = .zero
        
        return view
    }()
    
    var selectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var selectionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        
        return view
    }()
    
    var datesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dec 9"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH6

        return label
    }()
    
    var profitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$49.56"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBarGraphs()
        setupSelection()
        setupButtons()
    }
    
    @objc func dateTapped(sender: UIButton) {
        self.removeAllCenterConstraints()
        UIView.animate(withDuration: animationOut) {
            if sender == self.sundayButton {
                self.selectionCenterSundayAnchor.isActive = true
                self.selectionTopSundayAnchor.isActive = true
                self.selectionContainerCenterXAnchor.constant = 20
                self.sundayLabel.alpha = 1
                self.sundayBar.alpha = 1
            } else if sender == self.mondayButton {
                self.selectionCenterMondayAnchor.isActive = true
                self.selectionTopMondayAnchor.isActive = true
                self.mondayLabel.alpha = 1
                self.mondayBar.alpha = 1
            } else if sender == self.tuesdayButton {
                self.selectionCenterTuesdayAnchor.isActive = true
                self.selectionTopTuesdayAnchor.isActive = true
                self.tuesdayLabel.alpha = 1
                self.tuesdayBar.alpha = 1
            } else if sender == self.wednesdayButton {
                self.selectionCenterWednesdayAnchor.isActive = true
                self.selectionTopWednesdayAnchor.isActive = true
                self.wednesdayLabel.alpha = 1
                self.wednesdayBar.alpha = 1
            } else if sender == self.thursdayButton {
                self.selectionCenterThursdayAnchor.isActive = true
                self.selectionTopThursdayAnchor.isActive = true
                self.thursdayLabel.alpha = 1
                self.thursdayBar.alpha = 1
            } else if sender == self.fridayButton {
                self.selectionCenterFridayAnchor.isActive = true
                self.selectionTopFridayAnchor.isActive = true
                self.fridayLabel.alpha = 1
                self.fridayBar.alpha = 1
            } else if sender == self.saturdayButton {
                self.selectionCenterSaturdayAnchor.isActive = true
                self.selectionTopSaturdayAnchor.isActive = true
                self.selectionContainerCenterXAnchor.constant = -20
                self.saturdayLabel.alpha = 1
                self.saturdayBar.alpha = 1
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func removeAllCenterConstraints() {
        self.selectionCenterSundayAnchor.isActive = false
        self.selectionTopSundayAnchor.isActive = false
        self.selectionCenterMondayAnchor.isActive = false
        self.selectionTopMondayAnchor.isActive = false
        self.selectionCenterTuesdayAnchor.isActive = false
        self.selectionTopTuesdayAnchor.isActive = false
        self.selectionCenterWednesdayAnchor.isActive = false
        self.selectionTopWednesdayAnchor.isActive = false
        self.selectionCenterThursdayAnchor.isActive = false
        self.selectionTopThursdayAnchor.isActive = false
        self.selectionCenterFridayAnchor.isActive = false
        self.selectionTopFridayAnchor.isActive = false
        self.selectionCenterSaturdayAnchor.isActive = false
        self.selectionTopSaturdayAnchor.isActive = false
        self.selectionContainerCenterXAnchor.constant = 0
        self.sundayLabel.alpha = 0.6
        self.sundayBar.alpha = 0.5
        self.mondayLabel.alpha = 0.6
        self.mondayBar.alpha = 0.5
        self.tuesdayLabel.alpha = 0.6
        self.tuesdayBar.alpha = 0.5
        self.wednesdayLabel.alpha = 0.6
        self.wednesdayBar.alpha = 0.5
        self.thursdayLabel.alpha = 0.6
        self.thursdayBar.alpha = 0.5
        self.fridayLabel.alpha = 0.6
        self.fridayBar.alpha = 0.5
        self.saturdayLabel.alpha = 0.6
        self.saturdayBar.alpha = 0.5
    }
    
    var selectionCenterSundayAnchor: NSLayoutConstraint!
    var selectionTopSundayAnchor: NSLayoutConstraint!
    var selectionCenterMondayAnchor: NSLayoutConstraint!
    var selectionTopMondayAnchor: NSLayoutConstraint!
    var selectionCenterTuesdayAnchor: NSLayoutConstraint!
    var selectionTopTuesdayAnchor: NSLayoutConstraint!
    var selectionCenterWednesdayAnchor: NSLayoutConstraint!
    var selectionTopWednesdayAnchor: NSLayoutConstraint!
    var selectionCenterThursdayAnchor: NSLayoutConstraint!
    var selectionTopThursdayAnchor: NSLayoutConstraint!
    var selectionCenterFridayAnchor: NSLayoutConstraint!
    var selectionTopFridayAnchor: NSLayoutConstraint!
    var selectionCenterSaturdayAnchor: NSLayoutConstraint!
    var selectionTopSaturdayAnchor: NSLayoutConstraint!
    
    func setupButtons() {
        
        self.view.addSubview(sundayButton)
        sundayButton.topAnchor.constraint(equalTo: sundayBar.topAnchor).isActive = true
        sundayButton.leftAnchor.constraint(equalTo: sundayBar.leftAnchor).isActive = true
        sundayButton.rightAnchor.constraint(equalTo: sundayBar.rightAnchor).isActive = true
        sundayButton.bottomAnchor.constraint(equalTo: sundayLabel.bottomAnchor).isActive = true
        
        self.view.addSubview(mondayButton)
        mondayButton.topAnchor.constraint(equalTo: mondayBar.topAnchor).isActive = true
        mondayButton.leftAnchor.constraint(equalTo: mondayBar.leftAnchor).isActive = true
        mondayButton.rightAnchor.constraint(equalTo: mondayBar.rightAnchor).isActive = true
        mondayButton.bottomAnchor.constraint(equalTo: mondayLabel.bottomAnchor).isActive = true
        
        self.view.addSubview(tuesdayButton)
        tuesdayButton.topAnchor.constraint(equalTo: tuesdayBar.topAnchor).isActive = true
        tuesdayButton.leftAnchor.constraint(equalTo: tuesdayBar.leftAnchor).isActive = true
        tuesdayButton.rightAnchor.constraint(equalTo: tuesdayBar.rightAnchor).isActive = true
        tuesdayButton.bottomAnchor.constraint(equalTo: tuesdayLabel.bottomAnchor).isActive = true
        
        self.view.addSubview(wednesdayButton)
        wednesdayButton.topAnchor.constraint(equalTo: wednesdayBar.topAnchor).isActive = true
        wednesdayButton.leftAnchor.constraint(equalTo: wednesdayBar.leftAnchor).isActive = true
        wednesdayButton.rightAnchor.constraint(equalTo: wednesdayBar.rightAnchor).isActive = true
        wednesdayButton.bottomAnchor.constraint(equalTo: wednesdayLabel.bottomAnchor).isActive = true
        
        self.view.addSubview(thursdayButton)
        thursdayButton.topAnchor.constraint(equalTo: thursdayBar.topAnchor).isActive = true
        thursdayButton.leftAnchor.constraint(equalTo: thursdayBar.leftAnchor).isActive = true
        thursdayButton.rightAnchor.constraint(equalTo: thursdayBar.rightAnchor).isActive = true
        thursdayButton.bottomAnchor.constraint(equalTo: thursdayLabel.bottomAnchor).isActive = true
        
        self.view.addSubview(fridayButton)
        fridayButton.topAnchor.constraint(equalTo: fridayBar.topAnchor).isActive = true
        fridayButton.leftAnchor.constraint(equalTo: fridayBar.leftAnchor).isActive = true
        fridayButton.rightAnchor.constraint(equalTo: fridayBar.rightAnchor).isActive = true
        fridayButton.bottomAnchor.constraint(equalTo: fridayLabel.bottomAnchor).isActive = true
        
        self.view.addSubview(saturdayButton)
        saturdayButton.topAnchor.constraint(equalTo: saturdayBar.topAnchor).isActive = true
        saturdayButton.leftAnchor.constraint(equalTo: saturdayBar.leftAnchor).isActive = true
        saturdayButton.rightAnchor.constraint(equalTo: saturdayBar.rightAnchor).isActive = true
        saturdayButton.bottomAnchor.constraint(equalTo: saturdayLabel.bottomAnchor).isActive = true
        
        selectionCenterSundayAnchor = selectedView.centerXAnchor.constraint(equalTo: sundayButton.centerXAnchor)
            selectionCenterSundayAnchor.isActive = false
        selectionTopSundayAnchor = selectedView.topAnchor.constraint(equalTo: sundayButton.topAnchor, constant: -8)
            selectionTopSundayAnchor.isActive = false
        selectionCenterMondayAnchor = selectedView.centerXAnchor.constraint(equalTo: mondayButton.centerXAnchor)
            selectionCenterMondayAnchor.isActive = false
        selectionTopMondayAnchor = selectedView.topAnchor.constraint(equalTo: mondayButton.topAnchor, constant: -8)
            selectionTopMondayAnchor.isActive = false
        selectionCenterTuesdayAnchor = selectedView.centerXAnchor.constraint(equalTo: tuesdayButton.centerXAnchor)
            selectionCenterTuesdayAnchor.isActive = true
        selectionTopTuesdayAnchor = selectedView.topAnchor.constraint(equalTo: tuesdayButton.topAnchor, constant: -8)
            selectionTopTuesdayAnchor.isActive = true
        selectionCenterWednesdayAnchor = selectedView.centerXAnchor.constraint(equalTo: wednesdayButton.centerXAnchor)
            selectionCenterWednesdayAnchor.isActive = false
        selectionTopWednesdayAnchor = selectedView.topAnchor.constraint(equalTo: wednesdayButton.topAnchor, constant: -8)
            selectionTopWednesdayAnchor.isActive = false
        selectionCenterThursdayAnchor = selectedView.centerXAnchor.constraint(equalTo: thursdayButton.centerXAnchor)
            selectionCenterThursdayAnchor.isActive = false
        selectionTopThursdayAnchor = selectedView.topAnchor.constraint(equalTo: thursdayButton.topAnchor, constant: -8)
            selectionTopThursdayAnchor.isActive = false
        selectionCenterFridayAnchor = selectedView.centerXAnchor.constraint(equalTo: fridayButton.centerXAnchor)
            selectionCenterFridayAnchor.isActive = false
        selectionTopFridayAnchor = selectedView.topAnchor.constraint(equalTo: fridayButton.topAnchor, constant: -8)
            selectionTopFridayAnchor.isActive = false
        selectionCenterSaturdayAnchor = selectedView.centerXAnchor.constraint(equalTo: saturdayButton.centerXAnchor)
            selectionCenterSaturdayAnchor.isActive = false
        selectionTopSaturdayAnchor = selectedView.topAnchor.constraint(equalTo: saturdayButton.topAnchor, constant: -8)
            selectionTopSaturdayAnchor.isActive = false
        
    }
    
    var selectionContainerCenterXAnchor: NSLayoutConstraint!
    
    func setupSelection() {
        
        self.view.addSubview(selectedView)
        self.view.sendSubviewToBack(selectedView)
        selectedView.bottomAnchor.constraint(equalTo: tuesdayLabel.bottomAnchor, constant: 4).isActive = true
        selectedView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        selectedView.addSubview(selectionContainer)
        selectionContainerCenterXAnchor = selectionContainer.centerXAnchor.constraint(equalTo: selectedView.centerXAnchor)
            selectionContainerCenterXAnchor.isActive = true
        selectionContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        selectionContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        selectionContainer.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        selectedView.addSubview(selectionLine)
        selectionLine.centerXAnchor.constraint(equalTo: selectedView.centerXAnchor).isActive = true
        selectionLine.topAnchor.constraint(equalTo: selectionContainer.bottomAnchor, constant: 4).isActive = true
        selectionLine.bottomAnchor.constraint(equalTo: selectedView.topAnchor, constant: -4).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        selectionContainer.addSubview(datesLabel)
        datesLabel.leftAnchor.constraint(equalTo: selectionContainer.leftAnchor, constant: 4).isActive = true
        datesLabel.rightAnchor.constraint(equalTo: selectionContainer.rightAnchor, constant: -4).isActive = true
        datesLabel.topAnchor.constraint(equalTo: selectionContainer.topAnchor).isActive = true
        datesLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        selectionContainer.addSubview(profitsLabel)
        profitsLabel.leftAnchor.constraint(equalTo: selectionContainer.leftAnchor, constant: 4).isActive = true
        profitsLabel.rightAnchor.constraint(equalTo: selectionContainer.rightAnchor, constant: -4).isActive = true
        profitsLabel.bottomAnchor.constraint(equalTo: selectionContainer.bottomAnchor, constant: -2).isActive = true
        profitsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }

    func setupBarGraphs() {
        
        self.view.addSubview(sundayLabel)
        sundayLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        sundayLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        sundayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        sundayLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(sundayBar)
        sundayBar.centerXAnchor.constraint(equalTo: sundayLabel.centerXAnchor).isActive = true
        sundayBar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sundayBar.bottomAnchor.constraint(equalTo: sundayLabel.topAnchor, constant: -12).isActive = true
        sundayBar.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.view.addSubview(saturdayLabel)
        saturdayLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        saturdayLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        saturdayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        saturdayLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(saturdayBar)
        saturdayBar.centerXAnchor.constraint(equalTo: saturdayLabel.centerXAnchor).isActive = true
        saturdayBar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        saturdayBar.bottomAnchor.constraint(equalTo: saturdayLabel.topAnchor, constant: -12).isActive = true
        saturdayBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(wednesdayLabel)
        wednesdayLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        wednesdayLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        wednesdayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        wednesdayLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(wednesdayBar)
        wednesdayBar.centerXAnchor.constraint(equalTo: wednesdayLabel.centerXAnchor).isActive = true
        wednesdayBar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        wednesdayBar.bottomAnchor.constraint(equalTo: wednesdayLabel.topAnchor, constant: -12).isActive = true
        wednesdayBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
     
        self.view.addSubview(mondayLabel)
        mondayLabel.centerXAnchor.constraint(equalTo: sundayLabel.centerXAnchor, constant: halfWidth).isActive = true
        mondayLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mondayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        mondayLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(mondayBar)
        mondayBar.centerXAnchor.constraint(equalTo: mondayLabel.centerXAnchor).isActive = true
        mondayBar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        mondayBar.bottomAnchor.constraint(equalTo: mondayLabel.topAnchor, constant: -12).isActive = true
        mondayBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(tuesdayLabel)
        tuesdayLabel.centerXAnchor.constraint(equalTo: mondayLabel.centerXAnchor, constant: halfWidth).isActive = true
        tuesdayLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tuesdayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        tuesdayLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(tuesdayBar)
        tuesdayBar.centerXAnchor.constraint(equalTo: tuesdayLabel.centerXAnchor).isActive = true
        tuesdayBar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        tuesdayBar.bottomAnchor.constraint(equalTo: tuesdayLabel.topAnchor, constant: -12).isActive = true
        tuesdayBar.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        self.view.addSubview(thursdayLabel)
        thursdayLabel.centerXAnchor.constraint(equalTo: wednesdayLabel.centerXAnchor, constant: halfWidth).isActive = true
        thursdayLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        thursdayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        thursdayLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(thursdayBar)
        thursdayBar.centerXAnchor.constraint(equalTo: thursdayLabel.centerXAnchor).isActive = true
        thursdayBar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        thursdayBar.bottomAnchor.constraint(equalTo: thursdayLabel.topAnchor, constant: -12).isActive = true
        thursdayBar.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        self.view.addSubview(fridayLabel)
        fridayLabel.centerXAnchor.constraint(equalTo: thursdayLabel.centerXAnchor, constant: halfWidth).isActive = true
        fridayLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        fridayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        fridayLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(fridayBar)
        fridayBar.centerXAnchor.constraint(equalTo: fridayLabel.centerXAnchor).isActive = true
        fridayBar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        fridayBar.bottomAnchor.constraint(equalTo: fridayLabel.topAnchor, constant: -12).isActive = true
        fridayBar.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
    }
    
    var sundayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dateTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var mondayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dateTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var tuesdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dateTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var wednesdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dateTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var thursdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dateTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var fridayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dateTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var saturdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(dateTapped(sender:)), for: .touchUpInside)
        
        return button
    }()

    var sundayBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0.5
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var sundayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S"
        label.textColor = Theme.DARK_GRAY
        label.alpha = 0.6
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var mondayBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0.5
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var mondayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "M"
        label.textColor = Theme.DARK_GRAY
        label.alpha = 0.6
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var tuesdayBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var tuesdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "T"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var wednesdayBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0.5
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var wednesdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "W"
        label.textColor = Theme.DARK_GRAY
        label.alpha = 0.6
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var thursdayBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0.5
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var thursdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "T"
        label.textColor = Theme.DARK_GRAY
        label.alpha = 0.6
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var fridayBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0.5
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var fridayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "F"
        label.textColor = Theme.DARK_GRAY
        label.alpha = 0.6
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    var saturdayBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.alpha = 0.5
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var saturdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S"
        label.textColor = Theme.DARK_GRAY
        label.alpha = 0.6
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
}
