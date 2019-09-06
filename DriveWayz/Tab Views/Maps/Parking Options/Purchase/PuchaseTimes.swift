//
//  PuchaseTimes.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import UIKit

extension DurationViewController {
    
    func updateTimes(hours: Int, minutes: Int) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "h:mm"
        let apFormatter = DateFormatter()
        apFormatter.dateFormat = "a"
//        var dates: [Date] = []
//
//        let today = Date()
//        if let todayString = today.dayOfWeek() {
//            if todayString == "Monday" {
//                if let dateArray = self.parking?.mondayAvailable {
//                    dates = dateArray
//                }
//            } else if todayString == "Tuesday" {
//                if let dateArray = self.parking?.tuesdayAvailable {
//                    dates = dateArray
//                }
//            } else if todayString == "Wednesday" {
//                if let dateArray = self.parking?.wednesdayAvailable {
//                    dates = dateArray
//                }
//            } else if todayString == "Thursday" {
//                if let dateArray = self.parking?.thursdayAvailable {
//                    dates = dateArray
//                }
//            } else if todayString == "Friday" {
//                if let dateArray = self.parking?.fridayAvailable {
//                    dates = dateArray
//                }
//            } else if todayString == "Saturday" {
//                if let dateArray = self.parking?.saturdayAvailable {
//                    dates = dateArray
//                }
//            } else if todayString == "Sunday" {
//                if let dateArray = self.parking?.sundayAvailable {
//                    dates = dateArray
//                }
//            }
//        }
        
//        if dates.isEmpty {
//            delayWithSeconds(0.1) {
//                let indexPath = IndexPath(row: 1, section: 0)
//                if self.currentTimesController.timesArray.count > 1 {
//                    self.currentTimesController.timesPicker.selectItem(at: indexPath, animated: false, scrollPosition: .left)
//                    self.currentTimesController.collectionView(self.currentTimesController.timesPicker, didSelectItemAt: indexPath)
//                }
//                if self.currentTimesController.timesArray.count > 0 {
//                    delayWithSeconds(0.1, completion: {
//                        let indexPath2 = IndexPath(row: 0, section: 0)
//                        self.currentTimesController.timesPicker.selectItem(at: indexPath2, animated: false, scrollPosition: .left)
//                        self.currentTimesController.collectionView(self.currentTimesController.timesPicker, didSelectItemAt: indexPath2)
//                    })
//                }
//            }
//        }

//        if let fromAvailable = dates.first {
//            if fromAvailable <= self.fromDate {
//                self.confirmDurationButton.isUserInteractionEnabled = true
//                UIView.animate(withDuration: animationIn) {
//                    self.confirmDurationButton.backgroundColor = Theme.STRAWBERRY_PINK
//                }
//                print("available")
//            } else {
//                self.confirmDurationButton.isUserInteractionEnabled = false
//                UIView.animate(withDuration: animationIn) {
//                    self.confirmDurationButton.backgroundColor = Theme.DARK_GRAY.lighter(by: 40)
//                }
//                print("unavailable")
//                return
//            }
//        }

//        let startString = formatter.string(from: self.fromDate)
        let APm = apFormatter.string(from: self.fromDate)
        if APm == "AM" {
            self.amPm = "AM"
            self.amButton.backgroundColor = Theme.BLUE
            self.pmButton.backgroundColor = UIColor.clear
            self.amButton.setTitleColor(Theme.WHITE, for: .normal)
            self.pmButton.setTitleColor(Theme.BLACK, for: .normal)
        } else {
            self.amPm = "PM"
            self.amButton.backgroundColor = UIColor.clear
            self.pmButton.backgroundColor = Theme.BLUE
            self.amButton.setTitleColor(Theme.BLACK, for: .normal)
            self.pmButton.setTitleColor(Theme.WHITE, for: .normal)
        }
//        let calendar = Calendar.current
//        if let toDateHour = calendar.date(byAdding: .hour, value: hours, to: self.fromDate) {
//            if let toDate = calendar.date(byAdding: .minute, value: minutes, to: toDateHour) {
//                let toHour = calendar.component(.minute, from: toDate)
//                let nextDiff = toHour.roundedUp(toMultipleOf: 5) - toHour
//                if let nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: toDate) {
//                    if let toAvailable = dates.last {
//                        if toAvailable >= nextDate{
//                            self.confirmDurationButton.isUserInteractionEnabled = true
//                            UIView.animate(withDuration: animationIn) {
//                                self.confirmDurationButton.backgroundColor = Theme.STRAWBERRY_PINK
//                            }
//                            print("available")
//                        } else {
//                            self.confirmDurationButton.isUserInteractionEnabled = false
//                            UIView.animate(withDuration: animationIn) {
//                                self.confirmDurationButton.backgroundColor = Theme.DARK_GRAY.lighter(by: 40)
//                            }
//                            let minutes = Int((toAvailable.timeIntervalSince1970 - self.fromDate.timeIntervalSince1970)/60)
//                            let mins = minutes.roundedUp(toMultipleOf: 5) - 15
//                            if mins > 0 {
//                                self.sliderView.initializeTime(minutes: mins)
//                                print("unavailable")
//                                return
//                            } else {
//                                self.confirmDurationButton.isUserInteractionEnabled = false
//                                UIView.animate(withDuration: animationIn) {
//                                    self.confirmDurationButton.backgroundColor = Theme.DARK_GRAY.lighter(by: 40)
//                                }
//                            }
//                        }
//                    }
//
//                    let toTime = formatter.string(from: nextDate)
//                    self.toDate = nextDate
//                    self.totalSelectedTime = Double(Double(self.selectedHours) + Double(self.selectedMinutes) / 60.0)
//                }
//            }
//        }
    }
    
    func changeStartDate(date: Date) {
        self.fromDate = date
        let apFormatter = DateFormatter()
        apFormatter.dateFormat = "a"
        self.amPm = apFormatter.string(from: date)
        self.updateTimes(hours: self.selectedHours, minutes: self.selectedMinutes)
    }
    
}

func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
    return (minutes / 60, (minutes % 60))
}

