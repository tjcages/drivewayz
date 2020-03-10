//
//  CurrentTimeViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentTimeViewController: UIViewController {
    
    var durationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    var ariveAfterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Arive after"
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var leaveBeforeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Leave by"
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var dateFromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wed, 12 Sep"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        
        return label
    }()
    
    var dateToLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wed, 12 Sep"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        
        return label
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2:15 PM"
        label.textColor = Theme.GREEN
        label.font = Fonts.SSPSemiBoldH1
        label.textAlignment = .center
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:30 PM"
        label.textColor = Theme.GREEN
        label.font = Fonts.SSPSemiBoldH1
        label.textAlignment = .center
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to"
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    var reservationEndsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reservation ends in:"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH5
        label.textAlignment = .center
        
        return label
    }()
    
    var middleSeparator: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.6)
        label.text = ":"
        label.font = Fonts.SSPSemiBoldH1
        label.textAlignment = .center
        
        return label
    }()
    
    var hourBox: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "3"
        label.backgroundColor = Theme.WHITE
        label.layer.shadowColor = Theme.BLACK.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 0.2
        //        label.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
        label.font = Fonts.SSPBoldH0
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.clipsToBounds = false
        label.layer.cornerRadius = 4
        
        return label
    }()
    
    var minuteBox: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "14"
        label.backgroundColor = Theme.WHITE
        label.layer.shadowColor = Theme.BLACK.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 0.2
        //        label.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
        label.font = Fonts.SSPBoldH0
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.clipsToBounds = false
        label.layer.cornerRadius = 4
        
        return label
    }()
    
    var hoursLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "hours"
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        
        return label
    }()
    
    var minutesLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "minutes"
        label.textColor = Theme.BLACK.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(durationView)
        durationView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        durationView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        durationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        durationView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        durationView.addSubview(reservationEndsLabel)
        reservationEndsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        reservationEndsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        reservationEndsLabel.topAnchor.constraint(equalTo: durationView.topAnchor, constant: 18).isActive = true
        reservationEndsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        durationView.addSubview(middleSeparator)
        middleSeparator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        middleSeparator.topAnchor.constraint(equalTo: reservationEndsLabel.bottomAnchor, constant: 28).isActive = true
        middleSeparator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        middleSeparator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(hourBox)
        hourBox.rightAnchor.constraint(equalTo: middleSeparator.leftAnchor, constant: 0).isActive = true
        hourBox.centerYAnchor.constraint(equalTo: middleSeparator.centerYAnchor).isActive = true
        hourBox.heightAnchor.constraint(equalToConstant: 62).isActive = true
        hourBox.widthAnchor.constraint(equalToConstant: 62).isActive = true
        
        durationView.addSubview(minuteBox)
        minuteBox.leftAnchor.constraint(equalTo: middleSeparator.rightAnchor, constant: 0).isActive = true
        minuteBox.centerYAnchor.constraint(equalTo: middleSeparator.centerYAnchor).isActive = true
        minuteBox.heightAnchor.constraint(equalToConstant: 62).isActive = true
        minuteBox.widthAnchor.constraint(equalToConstant: 62).isActive = true
        
        durationView.addSubview(hoursLeftLabel)
        hoursLeftLabel.centerXAnchor.constraint(equalTo: hourBox.centerXAnchor).isActive = true
        hoursLeftLabel.topAnchor.constraint(equalTo: hourBox.bottomAnchor, constant: 4).isActive = true
        hoursLeftLabel.widthAnchor.constraint(equalTo: hourBox.widthAnchor).isActive = true
        hoursLeftLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(minutesLeftLabel)
        minutesLeftLabel.centerXAnchor.constraint(equalTo: minuteBox.centerXAnchor).isActive = true
        minutesLeftLabel.topAnchor.constraint(equalTo: minuteBox.bottomAnchor, constant: 4).isActive = true
        minutesLeftLabel.widthAnchor.constraint(equalTo: minuteBox.widthAnchor).isActive = true
        minutesLeftLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(ariveAfterLabel)
        durationView.addSubview(dateFromLabel)
        durationView.addSubview(fromTimeLabel)
        
        ariveAfterLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        ariveAfterLabel.centerXAnchor.constraint(equalTo: fromTimeLabel.centerXAnchor).isActive = true
        ariveAfterLabel.topAnchor.constraint(equalTo: hoursLeftLabel.bottomAnchor, constant: 16).isActive = true
        ariveAfterLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        dateFromLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        dateFromLabel.centerXAnchor.constraint(equalTo: fromTimeLabel.centerXAnchor).isActive = true
        dateFromLabel.topAnchor.constraint(equalTo: ariveAfterLabel.bottomAnchor, constant: 4).isActive = true
        dateFromLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        fromTimeLabel.leftAnchor.constraint(equalTo: durationView.leftAnchor).isActive = true
        fromTimeLabel.rightAnchor.constraint(equalTo: durationView.centerXAnchor, constant: -24).isActive = true
        fromTimeLabel.topAnchor.constraint(equalTo: dateFromLabel.bottomAnchor, constant: -2).isActive = true
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        durationView.addSubview(leaveBeforeLabel)
        durationView.addSubview(dateToLabel)
        durationView.addSubview(toTimeLabel)
        
        leaveBeforeLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        leaveBeforeLabel.centerXAnchor.constraint(equalTo: toTimeLabel.centerXAnchor).isActive = true
        leaveBeforeLabel.topAnchor.constraint(equalTo: hoursLeftLabel.bottomAnchor, constant: 16).isActive = true
        leaveBeforeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        dateToLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        dateToLabel.centerXAnchor.constraint(equalTo: toTimeLabel.centerXAnchor).isActive = true
        dateToLabel.topAnchor.constraint(equalTo: leaveBeforeLabel.bottomAnchor, constant: 4).isActive = true
        dateToLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        toTimeLabel.rightAnchor.constraint(equalTo: durationView.rightAnchor).isActive = true
        toTimeLabel.leftAnchor.constraint(equalTo: durationView.centerXAnchor, constant: 24).isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: dateToLabel.bottomAnchor, constant: -2).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        durationView.addSubview(toLabel)
        toLabel.centerYAnchor.constraint(equalTo: dateToLabel.centerYAnchor).isActive = true
        toLabel.centerXAnchor.constraint(equalTo: durationView.centerXAnchor).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

}
