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
        let monday = UIButton()
        monday.setTitle("M", for: .normal)
        monday.setTitleColor(Theme.WHITE, for: .normal)
        monday.backgroundColor = Theme.PRIMARY_COLOR
        monday.clipsToBounds = true
        monday.layer.cornerRadius = 20
        monday.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        monday.translatesAutoresizingMaskIntoConstraints = false
        
        return monday
    }()
    
    var tuesdayButton: UIButton = {
        let tuesday = UIButton()
        tuesday.setTitle("T", for: .normal)
        tuesday.setTitleColor(Theme.WHITE, for: .normal)
        tuesday.backgroundColor = Theme.PRIMARY_COLOR
        tuesday.clipsToBounds = true
        tuesday.layer.cornerRadius = 20
        tuesday.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        tuesday.translatesAutoresizingMaskIntoConstraints = false
        
        return tuesday
    }()
    
    var wednesdayButton: UIButton = {
        let wednesday = UIButton()
        wednesday.setTitle("W", for: .normal)
        wednesday.setTitleColor(Theme.WHITE, for: .normal)
        wednesday.backgroundColor = Theme.PRIMARY_COLOR
        wednesday.clipsToBounds = true
        wednesday.layer.cornerRadius = 20
        wednesday.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        wednesday.translatesAutoresizingMaskIntoConstraints = false
        
        return wednesday
    }()
    
    var thursdayButton: UIButton = {
        let thursday = UIButton()
        thursday.setTitle("T", for: .normal)
        thursday.setTitleColor(Theme.WHITE, for: .normal)
        thursday.backgroundColor = Theme.PRIMARY_COLOR
        thursday.clipsToBounds = true
        thursday.layer.cornerRadius = 20
        thursday.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        thursday.translatesAutoresizingMaskIntoConstraints = false
        
        return thursday
    }()
    
    var fridayButton: UIButton = {
        let friday = UIButton()
        friday.setTitle("F", for: .normal)
        friday.setTitleColor(Theme.WHITE, for: .normal)
        friday.backgroundColor = Theme.PRIMARY_COLOR
        friday.clipsToBounds = true
        friday.layer.cornerRadius = 20
        friday.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        friday.translatesAutoresizingMaskIntoConstraints = false
        
        return friday
    }()
    
    var saturdayButton: UIButton = {
        let saturday = UIButton()
        saturday.setTitle("S", for: .normal)
        saturday.setTitleColor(Theme.WHITE, for: .normal)
        saturday.backgroundColor = Theme.PRIMARY_COLOR
        saturday.clipsToBounds = true
        saturday.layer.cornerRadius = 20
        saturday.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        saturday.translatesAutoresizingMaskIntoConstraints = false
        
        return saturday
    }()
    
    var sundayButton: UIButton = {
        let sunday = UIButton()
        sunday.setTitle("S", for: .normal)
        sunday.setTitleColor(Theme.WHITE, for: .normal)
        sunday.backgroundColor = Theme.PRIMARY_COLOR
        sunday.clipsToBounds = true
        sunday.layer.cornerRadius = 20
        sunday.addTarget(self, action: #selector(dayPressed(sender:)), for: .touchUpInside)
        sunday.translatesAutoresizingMaskIntoConstraints = false
        
        return sunday
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
    }
    
    @objc func dayPressed(sender: UIButton) {
        if sender == mondayButton {
            if monday == 1 {
                monday = 0
                self.mondayButton.backgroundColor = UIColor.clear
                self.mondayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            } else {
                monday = 1
                self.mondayButton.backgroundColor = Theme.PRIMARY_COLOR
                self.mondayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == tuesdayButton {
            if tuesday == 1 {
                tuesday = 0
                self.tuesdayButton.backgroundColor = UIColor.clear
                self.tuesdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            } else {
                tuesday = 1
                self.tuesdayButton.backgroundColor = Theme.PRIMARY_COLOR
                self.tuesdayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == wednesdayButton {
            if wednesday == 1 {
                wednesday = 0
                self.wednesdayButton.backgroundColor = UIColor.clear
                self.wednesdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            } else {
                wednesday = 1
                self.wednesdayButton.backgroundColor = Theme.PRIMARY_COLOR
                self.wednesdayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == thursdayButton {
            if thursday == 1 {
                thursday = 0
                self.thursdayButton.backgroundColor = UIColor.clear
                self.thursdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            } else {
                thursday = 1
                self.thursdayButton.backgroundColor = Theme.PRIMARY_COLOR
                self.thursdayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == fridayButton {
            if friday == 1 {
                friday = 0
                self.fridayButton.backgroundColor = UIColor.clear
                self.fridayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            } else {
                friday = 1
                self.fridayButton.backgroundColor = Theme.PRIMARY_COLOR
                self.fridayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == saturdayButton {
            if saturday == 1 {
                saturday = 0
                self.saturdayButton.backgroundColor = UIColor.clear
                self.saturdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            } else {
                saturday = 1
                self.saturdayButton.backgroundColor = Theme.PRIMARY_COLOR
                self.saturdayButton.setTitleColor(UIColor.white, for: .normal)
            }
        } else if sender == sundayButton {
            if sunday == 1 {
                sunday = 0
                self.sundayButton.backgroundColor = UIColor.clear
                self.sundayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            } else {
                sunday = 1
                self.sundayButton.backgroundColor = Theme.PRIMARY_COLOR
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
