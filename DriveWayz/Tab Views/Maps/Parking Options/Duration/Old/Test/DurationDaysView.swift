//
//  DurationDaysView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class DurationDaysView: UIViewController {

    var delegate: handleDurationChanges?
    var timesArray: [String] = []
    var datesArray: [Date] = []
    var selectedDays: [Int] = [] {
        didSet {
            var days: [Date] = []
            for day in selectedDays {
                let date = self.datesArray[day]
                days.append(date)
            }
            self.delegate?.changeDateRange(days: days, today: selectedDays.contains(0))
            self.timesPicker.reloadData()
        }
    }
    var selectedDate: Date = Date()
    
    func selectNextDay() {
        if var last = selectedDays.last {
            last += 1
            if timesArray.count > last, !selectedDays.contains(last) {
                let indexPath = IndexPath(row: last, section: 0)
                timesPicker.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                self.collectionView(timesPicker, didSelectItemAt: indexPath)
            }
        }
    }
    
    var selectTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select date range"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var currentMonthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    lazy var timesPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.register(DurationDays.self, forCellWithReuseIdentifier: "Cell")
        view.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        return view
    }()
    
    func setData() {
        timesArray = []
        datesArray = []
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        var currentDate = Date()
        for i in 0...6 {
            let timesString = formatter.string(from: currentDate)
            self.timesArray.append(timesString)
            self.datesArray.append(currentDate)
            if i == 0 {
                self.selectedDate = currentDate
            }
            currentDate = currentDate.tomorrow
        }
        timesPicker.reloadData()
        let indexPath = self.timesPicker.indexPathsForSelectedItems?.first ?? IndexPath(item: 0, section: 0)
        timesPicker.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        collectionView(self.timesPicker, didSelectItemAt: indexPath)
        
        let now = Date()
        formatter.dateFormat = "LLLL"
        let nameOfMonth = formatter.string(from: now)
        currentMonthLabel.text = nameOfMonth
        delegate?.changeMonth(month: nameOfMonth)
        self.selectedDays = []
        delayWithSeconds(0.1) {
            if !self.selectedDays.contains(0) {
                self.selectedDays.append(0)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timesPicker.delegate = self
        timesPicker.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(selectTimeLabel)
        view.addSubview(currentMonthLabel)
        view.addSubview(timesPicker)
        
        selectTimeLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        selectTimeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        selectTimeLabel.sizeToFit()
        
        currentMonthLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        currentMonthLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        currentMonthLabel.sizeToFit()
        
        timesPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timesPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timesPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        timesPicker.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
    }
    
    func nextHourDate(nextDays: Int) -> Date? {
        let calendar = Calendar.current
        var date = Date()
        var i = 0
        while i < nextDays {
            date = date.tomorrow
            i += 1
        }
        let minuteComponent = calendar.component(.minute, from: date)
        var components = DateComponents()
        components.minute = 60 - minuteComponent
        return calendar.date(byAdding: components, to: date)
    }
    
}


extension DurationDaysView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 82, height: 42)
        } else {
            let width = (phoneWidth - 40)/7
            
            return CGSize(width: width, height: 42)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! DurationDays
        if indexPath.row == 0 {
            cell.dateLabel.text = "Today"
        } else {
            cell.dateLabel.text = timesArray[indexPath.row]
        }
        if self.selectedDays.contains(indexPath.row) {
            cell.dateLabel.font = Fonts.SSPSemiBoldH3
            cell.dateLabel.textColor = Theme.WHITE
            cell.backgroundColor = Theme.DARK_GRAY
        } else {
            cell.dateLabel.font = Fonts.SSPSemiBoldH3
            cell.dateLabel.textColor = Theme.DARK_GRAY
            cell.backgroundColor = lineColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sorted = selectedDays.sorted()
        if !selectedDays.contains(indexPath.row) {
            // Add a new day to the array
            if let first = sorted.first {
                if (first + 1) <= indexPath.row {
                    for i in (first + 1)...indexPath.row {
                        if !selectedDays.contains(i) {
                            selectedDays.append(i)
                        }
                    }
                } else {
                    selectedDays = [indexPath.row]
                }
            } else {
                selectedDays.append(indexPath.row)
            }
        } else {
            // Remove a day from the array
            if let index = selectedDays.firstIndex(of: indexPath.row) {
                selectedDays.remove(at: index)
                var checkIndex = indexPath.row
                while let nextIndex = selectedDays.firstIndex(of: checkIndex + 1) {
                    selectedDays.remove(at: nextIndex)
                    checkIndex += 1
                }
            }
        }
//        let index = IndexPath(row: self.selectedTime, section: 0)
//        if let previousCell = collectionView.cellForItem(at: index) as? DurationDays {
//            previousCell.dateLabel.font = Fonts.SSPSemiBoldH3
//            previousCell.dateLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
//        }
//        if let cell = collectionView.cellForItem(at: indexPath) as? DurationDays {
//            cell.dateLabel.font = Fonts.SSPBoldH3
//            cell.dateLabel.textColor = Theme.BLUE
//            self.selectedTime = indexPath.row
//            var date = self.datesArray[indexPath.row]
//            self.selectedDate = date
//            if indexPath.row == 0 {
//                date = Date()
//                self.delegate?.setData(isToday: true)
//            } else {
//                self.delegate?.setData(isToday: false)
//            }
//            self.delegate?.changeStartDate(date: date)
//            self.timesPicker.reloadData()
//        }
    }
    
}


class DurationDays: UICollectionViewCell {
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.DARK_GRAY
        layer.cornerRadius = 4
        clipsToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(dateLabel)
        dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dateLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
