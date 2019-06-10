//
//  PurchaseDaysViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/21/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PurchaseDaysViewController: UIViewController {

    var delegate: handleHoursSelected?
    var timesArray: [String] = []
    var daysArray: [String] = []
    var datesArray: [Date] = []
    var selectedTime: Int = 0
    var selectedDate: Date = Date()
    
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
        view.register(PurchaseDays.self, forCellWithReuseIdentifier: "Cell")
        view.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        return view
    }()
    
    func setData() {
        self.timesArray = []
        self.datesArray = []
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E"
        var currentDate = Date()
        for i in 0...6 {
            let timesString = formatter.string(from: currentDate)
            let datesString = dayFormatter.string(from: currentDate).uppercased()
            self.timesArray.append(timesString)
            self.daysArray.append(datesString)
            self.datesArray.append(currentDate)
            if i == 0 {
                self.selectedDate = currentDate
            }
            currentDate = currentDate.tomorrow
        }
        self.timesPicker.reloadData()
        let indexPath = self.timesPicker.indexPathsForSelectedItems?.first ?? IndexPath(item: 0, section: 0)
        self.timesPicker.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        self.collectionView(self.timesPicker, didSelectItemAt: indexPath)
        let date = self.datesArray[indexPath.row]
        self.delegate?.changeStartDate(date: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timesPicker.delegate = self
        timesPicker.dataSource = self
        
        setupViews()
        setData()
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


extension PurchaseDaysViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (phoneWidth - 60)/8
        
        return CGSize(width: width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! PurchaseDays
        cell.dateLabel.text = timesArray[indexPath.row]
        cell.dayLabel.text = daysArray[indexPath.row]
        if indexPath.row == self.selectedTime {
            cell.dateLabel.font = Fonts.SSPBoldH2
            cell.dateLabel.textColor = Theme.BLUE
            cell.dayLabel.alpha = 1
        } else {
            cell.dateLabel.font = Fonts.SSPSemiBoldH2
            cell.dateLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
            cell.dayLabel.alpha = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: self.selectedTime, section: 0)
        if let previousCell = collectionView.cellForItem(at: index) as? PurchaseDays {
            previousCell.dateLabel.font = Fonts.SSPSemiBoldH3
            previousCell.dateLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
            previousCell.dayLabel.alpha = 0
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? PurchaseDays {
            cell.dateLabel.font = Fonts.SSPBoldH3
            cell.dateLabel.textColor = Theme.BLUE
            cell.dayLabel.alpha = 1
            self.selectedTime = indexPath.row
            var date = self.datesArray[indexPath.row]
            self.selectedDate = date
            if indexPath.row == 0 {
                date = Date()
                self.delegate?.setData(isToday: true)
            } else {
                self.delegate?.setData(isToday: false)
            }
            self.delegate?.changeStartDate(date: date)
            self.timesPicker.reloadData()
        }
    }
    
}


class PurchaseDays: UICollectionViewCell {
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPBoldH2
        label.textAlignment = .center
        
        return label
    }()
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPBoldH6
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive = true
        
        self.addSubview(dayLabel)
        dayLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dayLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
