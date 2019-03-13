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
        view.contentInset = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timesPicker.delegate = self
        timesPicker.dataSource = self
        
        setupViews()
        setupTimes()
    }
    
    func setupViews() {
        
        self.view.addSubview(timesPicker)
        timesPicker.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        timesPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        timesPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        timesPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupTimes() {
        if var currentDate = nextHourDate() {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:'00'"
            let calendar = Calendar.current
            while calendar.isDateInToday(currentDate) {
                self.datesArray.append(currentDate)
                let dateString = formatter.string(from: currentDate)
                currentDate = currentDate.addingTimeInterval(TimeInterval(3600))
                self.timesArray.append(dateString)
            }
            self.timesPicker.reloadData()
        }
    }
    
    func nextHourDate() -> Date? {
        let calendar = Calendar.current
        let date = Date()
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
            cell.cellView.backgroundColor = Theme.BLACK
            cell.iconLabel.textColor = Theme.WHITE
            cell.cellView.alpha = 1
        } else {
            cell.cellView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
            cell.iconLabel.textColor = Theme.BLACK
            cell.cellView.alpha = 0.8
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != self.selectedTime && self.selectedTime < self.timesArray.count {
            let index = IndexPath(row: self.selectedTime, section: 0)
            if let previousCell = collectionView.cellForItem(at: index) as? PurchaseTimes {
                previousCell.cellView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
                previousCell.iconLabel.textColor = Theme.BLACK
                previousCell.cellView.alpha = 0.8
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? PurchaseTimes {
                cell.cellView.backgroundColor = Theme.BLACK
                cell.iconLabel.textColor = Theme.WHITE
                cell.cellView.alpha = 1
                self.selectedTime = indexPath.row
                var date = self.datesArray[indexPath.row]
                if indexPath.row == 0 {
                    date = Date()
                }
                self.delegate?.changeStartDate(date: date)
                self.timesPicker.reloadData()
            }
        }
    }
    
}


class PurchaseTimes: UICollectionViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.1)
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
