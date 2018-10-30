//
//  ScheduleAvailabilityViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ScheduleAvailabilityViewController: UIViewController {
    
    var monday: Int = 1
    var tuesday: Int = 1
    var wednesday: Int = 1
    var thursday: Int = 1
    var friday: Int = 1
    var saturday: Int = 1
    var sunday: Int = 1
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "It is best to select the maximum amount of days possible to increase the amount of potential profits."
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 3
        label.textAlignment = .center
        
        return label
    }()
    
    var mondayButton: UIButton = {
        let button = UIButton()
        button.setTitle("M", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var tuesdayButton: UIButton = {
        let button = UIButton()
        button.setTitle("T", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var wednesdayButton: UIButton = {
        let button = UIButton()
        button.setTitle("W", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var thursdayButton: UIButton = {
        let button = UIButton()
        button.setTitle("T", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var fridayButton: UIButton = {
        let button = UIButton()
        button.setTitle("F", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var saturdayButton: UIButton = {
        let button = UIButton()
        button.setTitle("S", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var sundayButton: UIButton = {
        let button = UIButton()
        button.setTitle("S", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.PACIFIC_BLUE
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var daysAvailableLabel: UIButton = {
        let button = UIButton()
        button.setTitle("All the days are currently selected", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWeekdays()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWeekdays() {
        
        self.view.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        informationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let mondayView = UIView()
        let tuesdayView = UIView()
        let wednesdayView = UIView()
        let thursdayView = UIView()
        let fridayView = UIView()
        let saturdayView = UIView()
        let sundayView = UIView()
        
        let stackView = UIStackView(arrangedSubviews: [mondayView, tuesdayView, wednesdayView, thursdayView, fridayView, saturdayView, sundayView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(mondayButton)
        self.view.addSubview(tuesdayButton)
        self.view.addSubview(wednesdayButton)
        self.view.addSubview(thursdayButton)
        self.view.addSubview(fridayButton)
        self.view.addSubview(saturdayButton)
        self.view.addSubview(sundayButton)

        mondayButton.centerXAnchor.constraint(equalTo: mondayView.centerXAnchor).isActive = true
        mondayButton.centerYAnchor.constraint(equalTo: mondayView.centerYAnchor).isActive = true
        mondayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mondayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        tuesdayButton.centerXAnchor.constraint(equalTo: tuesdayView.centerXAnchor).isActive = true
        tuesdayButton.centerYAnchor.constraint(equalTo: tuesdayView.centerYAnchor).isActive = true
        tuesdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tuesdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        wednesdayButton.centerXAnchor.constraint(equalTo: wednesdayView.centerXAnchor).isActive = true
        wednesdayButton.centerYAnchor.constraint(equalTo: wednesdayView.centerYAnchor).isActive = true
        wednesdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        wednesdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        thursdayButton.centerXAnchor.constraint(equalTo: thursdayView.centerXAnchor).isActive = true
        thursdayButton.centerYAnchor.constraint(equalTo: thursdayView.centerYAnchor).isActive = true
        thursdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        thursdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        fridayButton.centerXAnchor.constraint(equalTo: fridayView.centerXAnchor).isActive = true
        fridayButton.centerYAnchor.constraint(equalTo: fridayView.centerYAnchor).isActive = true
        fridayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fridayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        saturdayButton.centerXAnchor.constraint(equalTo: saturdayView.centerXAnchor).isActive = true
        saturdayButton.centerYAnchor.constraint(equalTo: saturdayView.centerYAnchor).isActive = true
        saturdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saturdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        sundayButton.centerXAnchor.constraint(equalTo: sundayView.centerXAnchor).isActive = true
        sundayButton.centerYAnchor.constraint(equalTo: sundayView.centerYAnchor).isActive = true
        sundayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sundayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(daysAvailableLabel)
        daysAvailableLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        daysAvailableLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        daysAvailableLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        daysAvailableLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        startEmpty()
    }
    
    func startEmpty() {
        monday = 0
        self.mondayButton.backgroundColor = UIColor.clear
        self.mondayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        tuesday = 0
        self.tuesdayButton.backgroundColor = UIColor.clear
        self.tuesdayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        wednesday = 0
        self.wednesdayButton.backgroundColor = UIColor.clear
        self.wednesdayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        thursday = 0
        self.thursdayButton.backgroundColor = UIColor.clear
        self.thursdayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        friday = 0
        self.fridayButton.backgroundColor = UIColor.clear
        self.fridayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        saturday = 0
        self.saturdayButton.backgroundColor = UIColor.clear
        self.saturdayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        sunday = 0
        self.sundayButton.backgroundColor = UIColor.clear
        self.sundayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
        self.daysAvailableLabel.alpha = 1
        self.daysAvailableLabel.setTitle("None of the days are selected", for: .normal)
    }
    
    @objc func dayPressed(sender: UIButton) {
        if sender == mondayButton {
            if monday == 1 {
                monday = 0
                self.mondayButton.backgroundColor = UIColor.clear
                self.mondayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            } else {
                monday = 1
                self.mondayButton.backgroundColor = Theme.PACIFIC_BLUE
                self.mondayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == tuesdayButton {
            if tuesday == 1 {
                tuesday = 0
                self.tuesdayButton.backgroundColor = UIColor.clear
                self.tuesdayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            } else {
                tuesday = 1
                self.tuesdayButton.backgroundColor = Theme.PACIFIC_BLUE
                self.tuesdayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == wednesdayButton {
            if wednesday == 1 {
                wednesday = 0
                self.wednesdayButton.backgroundColor = UIColor.clear
                self.wednesdayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            } else {
                wednesday = 1
                self.wednesdayButton.backgroundColor = Theme.PACIFIC_BLUE
                self.wednesdayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == thursdayButton {
            if thursday == 1 {
                thursday = 0
                self.thursdayButton.backgroundColor = UIColor.clear
                self.thursdayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            } else {
                thursday = 1
                self.thursdayButton.backgroundColor = Theme.PACIFIC_BLUE
                self.thursdayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == fridayButton {
            if friday == 1 {
                friday = 0
                self.fridayButton.backgroundColor = UIColor.clear
                self.fridayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            } else {
                friday = 1
                self.fridayButton.backgroundColor = Theme.PACIFIC_BLUE
                self.fridayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == saturdayButton {
            if saturday == 1 {
                saturday = 0
                self.saturdayButton.backgroundColor = UIColor.clear
                self.saturdayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            } else {
                saturday = 1
                self.saturdayButton.backgroundColor = Theme.PACIFIC_BLUE
                self.saturdayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == sundayButton {
            if sunday == 1 {
                sunday = 0
                self.sundayButton.backgroundColor = UIColor.clear
                self.sundayButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            } else {
                sunday = 1
                self.sundayButton.backgroundColor = Theme.PACIFIC_BLUE
                self.sundayButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
        if monday == 1, tuesday == 1, wednesday == 1, thursday == 1, friday == 1, saturday == 1, sunday == 1 {
            UIView.animate(withDuration: 0.2) {
                self.daysAvailableLabel.alpha = 1
            }
            self.daysAvailableLabel.setTitle("All the days are currently selected", for: .normal)
        } else if monday == 0, tuesday == 0, wednesday == 0, thursday == 0, friday == 0, saturday == 0, sunday == 0 {
            UIView.animate(withDuration: 0.2) {
                self.daysAvailableLabel.alpha = 1
            }
            self.daysAvailableLabel.setTitle("None of the days are selected", for: .normal)
        } else {
            UIView.animate(withDuration: 0.2) {
                self.daysAvailableLabel.alpha = 0
            }
        }
    }
    
    


}
