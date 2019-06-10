//
//  PurchaseTimesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PurchaseTimesViewController: UIViewController {
    
    var delegate: handleHoursSelected?
    var timesArray: [String] = ["Now"]
    var datesArray: [Date] = [Date()]
    var selectedTime: Int = 0
    var selectedString: String = "Now"
    var beginningDate: Date = Date()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        
        return layout
    }()
    
    lazy var timesPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.register(PurchaseTimes.self, forCellWithReuseIdentifier: "Cell")
        view.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        return view
    }()
    
    func setData(isToday: Bool) {
        if isToday {
            self.timesArray = ["Now"]
            self.datesArray = [Date()]
            let formatter = DateFormatter()
            formatter.dateFormat = "h:'00'"
            let calendar = Calendar.current
            if let currentDate = Date().nearestHour() {
                var nextDate = currentDate
                while calendar.isDate(nextDate, inSameDayAs: currentDate) {
                    let dateString = formatter.string(from: nextDate)
                    self.timesArray.append(dateString)
                    self.datesArray.append(nextDate)
                    self.timesPicker.reloadData()
                    nextDate = nextDate.addingTimeInterval(3600)
                }
            }
        } else {
            self.timesArray = []
            self.datesArray = []
            let formatter = DateFormatter()
            formatter.dateFormat = "h:'00'"
            let calendar = Calendar.current
            let currentDate = Date().dateAt(hours: 0, minutes: 0)
            var nextDate = currentDate
            while calendar.isDate(nextDate, inSameDayAs: currentDate) {
                let dateString = formatter.string(from: nextDate)
                self.timesArray.append(dateString)
                self.datesArray.append(nextDate)
                self.timesPicker.reloadData()
                nextDate = nextDate.addingTimeInterval(3600)
            }
        }
        self.timesPicker.reloadData()
        let date = self.datesArray[self.selectedTime]
        self.delegate?.changeStartDate(date: date)
        delayWithSeconds(0.2) {
            let indexPath = self.timesPicker.indexPathsForSelectedItems?.first ?? IndexPath(item: 0, section: 0)
            self.timesPicker.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            self.collectionView(self.timesPicker, didSelectItemAt: indexPath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timesPicker.delegate = self
        timesPicker.dataSource = self
        
        setupViews()
        setData(isToday: true)
    }
    
    func setupViews() {
        
        self.view.addSubview(timesPicker)
        timesPicker.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        timesPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        timesPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        timesPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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


extension PurchaseTimesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let amenitiesText = timesArray[indexPath.row]
        let width = amenitiesText.width(withConstrainedHeight: 44, font: Fonts.SSPRegularH5) + 42
        
        return CGSize(width: width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! PurchaseTimes
        cell.iconLabel.text = timesArray[indexPath.row]
        if indexPath.row == self.selectedTime {
            cell.cellView.backgroundColor = Theme.STRAWBERRY_PINK
            cell.iconLabel.textColor = Theme.WHITE
            cell.cellView.alpha = 1
        } else {
            cell.cellView.backgroundColor = Theme.OFF_WHITE
            cell.iconLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
            cell.cellView.alpha = 0.8
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: self.selectedTime, section: 0)
        if let previousCell = collectionView.cellForItem(at: index) as? PurchaseTimes {
            previousCell.cellView.backgroundColor = Theme.OFF_WHITE
            previousCell.iconLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
            previousCell.cellView.alpha = 0.8
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? PurchaseTimes {
            cell.cellView.backgroundColor = Theme.STRAWBERRY_PINK
            cell.iconLabel.textColor = Theme.WHITE
            cell.cellView.alpha = 1
            if let text = cell.iconLabel.text {
                self.selectedString = text
            }
            self.selectedTime = indexPath.row
            var date = self.datesArray[indexPath.row]
            if indexPath.row == 0 {
                date = beginningDate
            }
            self.delegate?.changeStartDate(date: date)
            self.timesPicker.reloadData()
        }
    }
    
}


class PurchaseTimes: UICollectionViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.OFF_WHITE
        view.alpha = 0.8
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(cellView)
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(iconLabel)
        iconLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        iconLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        iconLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        iconLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension Date {
    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
}
