//
//  DurationHoursView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class DurationHoursView: UIViewController {
    
    var delegate: handleDurationChanges?
    var selectedHours: Int = 2
    var selectedMinutes: Int = 15
    var totalSelectedTime: Double = 2.25

    var month: String = ""
    var dates: [Date] = [] {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            var text = ""
            if let first = self.dates.first {
                let firstString = formatter.string(from: first)
                text = "\(self.month.prefix(3)) \(firstString)"
                fromDay = text
                toDay = text
                if let last = self.dates.last, last != first {
                    if last.isInSameMonth(date: first) {
                        let lastString = formatter.string(from: last)
                        text += " - \(lastString)"
                        formatter.dateFormat = "MMM dd"
                        toDay = formatter.string(from: last)
                    } else {
                        formatter.dateFormat = "MMM dd"
                        let lastString = formatter.string(from: last)
                        text += " - \(lastString)"
                        toDay = lastString
                    }
                }
            }
            self.dateLabel.text = text
        }
    }
    
    var fromDay: String?
    var toDay: String?
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()

    func changeStartAndEnd(start: String, end: String) {
        let year = Date().getYearOnlyFC()
        
        var start = start + " " + year
        var end = end + " " + year
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        if let fromDay = fromDay, let toDay = toDay {
            if start.contains("Now") {
                if start.contains("AM") { start = start.replacingOccurrences(of: " AM", with: "")}
                if start.contains("PM") { start = start.replacingOccurrences(of: " PM", with: "")}
                let now = Date().round(precision: (15 * 60), rule: FloatingPointRoundingRule.up)
                let startString = formatter.string(from: now)
                start = start.replacingOccurrences(of: "Now", with: "\(startString)")
            }
            formatter.dateFormat = "MMM dd hh:mm a yyyy"
            
            start = "\(fromDay) \(start)"
            end = "\(toDay) \(end)"
            if let startDate = formatter.date(from: start), let endDate = formatter.date(from: end) {
                let difference = endDate.minutes(from: startDate)
                setHourLabel(minutes: difference)
                
                bookingFromDate = startDate
                bookingToDate = endDate
                
                if difference <= 0 {
                    hourLabel.textColor = Theme.SALMON
                    delegate?.changeMainButton(enabled: false)
                    if difference <= -720 { // 12 hours difference
                        delegate?.selectNextDay()
                    }
                } else {
                    hourLabel.textColor = Theme.BLUE
                    delegate?.changeMainButton(enabled: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(dateLabel)
        view.addSubview(hourLabel)
        
        dateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        dateLabel.sizeToFit()
        
        hourLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hourLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        hourLabel.sizeToFit()
        
    }

    func setHourLabel(minutes: Int) {
        let tuple = minutesToHoursMinutes(minutes: minutes)
        if tuple.hours == 1 {
            if tuple.leftMinutes == 0 {
                hourLabel.text = "\(tuple.hours) hr"
            } else {
                hourLabel.text = "\(tuple.hours) hr \(tuple.leftMinutes) min"
            }
        } else if tuple.hours == 0 {
            if tuple.leftMinutes == 0 {
                hourLabel.text = "00 min"
            } else {
                hourLabel.text = "\(tuple.leftMinutes) min"
            }
        } else {
            if tuple.leftMinutes == 0 {
                hourLabel.text = "\(tuple.hours) hrs"
            } else {
                hourLabel.text = "\(tuple.hours) hrs \(tuple.leftMinutes) min"
            }
        }
        selectedHours = tuple.hours
        selectedMinutes = tuple.leftMinutes
        totalSelectedTime = Double(tuple.hours) + Double(tuple.leftMinutes)/60
    }
    
}
