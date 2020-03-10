//
//  HostCalendarViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostCalendarViewController: UIViewController {
    
    var calendarDelegate: handleCalendarHeight?
    var numberOfMonths: Int = 3
    var height: CGFloat = 0.0 {
        didSet {
            self.calendarHeightAnchor.constant = self.height
            self.calendarDelegate?.changeCalendarHeight(amount: self.height + 190)
            self.view.layoutIfNeeded()
        }
    }
    
    lazy var calendar: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.register(CalendarCell.self, forCellWithReuseIdentifier: "cell")
        view.register(CalendarHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        view.isScrollEnabled = false
        
        return view
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }()
    
    var wrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.4)
        button.layer.cornerRadius = 18
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(showMorePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var delegate: CalendarCallBack? = nil
    var selectedIndex: IndexPath? = nil
    var selectedDate = Date()
    var selectedIndeces: [IndexPath] = [] {
        didSet {
            if shouldMonitorPrevious == true {
                if timer != nil {
                    self.timer?.invalidate()
                }
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(savePreviousDates), userInfo: nil, repeats: false)
            }
        }
    }
    
    var previousSelected: [IndexPath] = []
    var timer: Timer?
    var shouldMonitorPrevious: Bool = true
    var selectedDay: [IndexPath] = []
    
    @objc func savePreviousDates() {
        self.shouldMonitorPrevious = false
        self.previousSelected = self.selectedIndeces
    }
    
    var selectedSundays: [String] = []
    var selectedMondays: [String] = []
    var selectedTuesdays: [String] = []
    var selectedWednesdays: [String] = []
    var selectedThursdays: [String] = []
    var selectedFridays: [String] = []
    var selectedSaturdays: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        setupViews()
        setupCalendar()
        setupPreviousAvailability()
        monitorCalendarChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.reloadData()
    }
    
    var calendarHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(wrapper)
        self.view.addSubview(calendar)
        
        wrapper.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        wrapper.bottomAnchor.constraint(equalTo: calendar.bottomAnchor).isActive = true
        wrapper.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        wrapper.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        calendar.topAnchor.constraint(equalTo: wrapper.topAnchor).isActive = true
        calendarHeightAnchor = calendar.heightAnchor.constraint(equalToConstant: 800)
            calendarHeightAnchor.isActive = true
        calendar.leftAnchor.constraint(equalTo: wrapper.leftAnchor).isActive = true
        calendar.rightAnchor.constraint(equalTo: wrapper.rightAnchor).isActive = true
        
        self.view.addSubview(showMoreButton)
        showMoreButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        showMoreButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        showMoreButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        showMoreButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 16).isActive = true
        
    }
    
    @objc func showMorePressed(sender: UIButton) {
        if sender.titleLabel?.text == "Show more" {
            self.numberOfMonths = 12
            sender.setTitle("Show less", for: .normal)
        } else {
            self.numberOfMonths = 3
            sender.setTitle("Show more", for: .normal)
        }
        calendar.reloadData()
    }
    
    func monitorCalendarChanges() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
        ref.observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            let hostRef = Database.database().reference().child("ParkingSpots").child(key).child("UnavailableDays")
            hostRef.observe(.childChanged, with: { (snapshot) in
                self.setupPreviousAvailability()
            })
        }
    }
    
    func setupCalendar() {
        let numberOfCellsPerRow: CGFloat = 7
        if let flowLayout = calendar.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (phoneWidth - 16 - max(0, numberOfCellsPerRow - 1) * horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            flowLayout.headerReferenceSize = CGSize(width: phoneWidth - 16, height: 70)
        }
        
        self.view.layoutIfNeeded()
    }
    
    func setupPreviousAvailability() {
        self.selectedIndeces = []
        self.shouldMonitorPrevious = true
        if let userID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
            ref.observeSingleEvent(of: .childAdded) { (snapshot) in
                if let value = snapshot.value as? String {
                    let hostRef = Database.database().reference().child("ParkingSpots").child(value).child("UnavailableDays")
                    hostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String:Any] {
                            if let mondayRef = dictionary["Monday"] as? [String] {
                                for day in mondayRef {
                                    if !self.selectedMondays.contains(day) {
                                        self.selectedMondays.append(day)
                                    }
                                    self.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let tuesdayRef = dictionary["Tuesday"] as? [String] {
                                for day in tuesdayRef {
                                    if !self.selectedTuesdays.contains(day) {
                                        self.selectedTuesdays.append(day)
                                    }
                                    self.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let wednesdayRef = dictionary["Wednesday"] as? [String] {
                                for day in wednesdayRef {
                                    if !self.selectedWednesdays.contains(day) {
                                        self.selectedWednesdays.append(day)
                                    }
                                    self.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let thursdayRef = dictionary["Thursday"] as? [String] {
                                for day in thursdayRef {
                                    if !self.selectedThursdays.contains(day) {
                                        self.selectedThursdays.append(day)
                                    }
                                    self.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let fridayRef = dictionary["Friday"] as? [String] {
                                for day in fridayRef {
                                    if !self.selectedFridays.contains(day) {
                                        self.selectedFridays.append(day)
                                    }
                                    self.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let saturdayRef = dictionary["Saturday"] as? [String] {
                                for day in saturdayRef {
                                    if !self.selectedSaturdays.contains(day) {
                                        self.selectedSaturdays.append(day)
                                    }
                                    self.pullDatesFromDatabase(dateString: day)
                                }
                            }
                            if let sundayRef = dictionary["Sunday"] as? [String] {
                                for day in sundayRef {
                                    if !self.selectedSundays.contains(day) {
                                        self.selectedSundays.append(day)
                                    }
                                    self.pullDatesFromDatabase(dateString: day)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
}


extension HostCalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func scrollToIndex() {
        delayWithSeconds(0.1) {
            if self.selectedIndex != nil {
                self.calendar.scrollToItem(at: self.selectedIndex!, at: .centeredVertically, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.height = CGFloat(collectionView.frame.size.width / 7) * 7.8 * CGFloat(self.numberOfMonths) - CGFloat(16 * self.numberOfMonths)
        if self.numberOfMonths != 3 {
            self.height = self.height - 42
        }
        return CGSize(width: CGFloat(collectionView.frame.size.width / 7), height: CGFloat(collectionView.frame.size.width / 7))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfMonths
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CalendarHeaderCell
        let title = headerView.cellLabel
        title.text = Date().addMonthFC(month: indexPath.section).getHeaderTitleFC()
        return headerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Date().addMonthFC(month: section).getDaysInMonthFC()+Date().addMonthFC(month: section).startOfMonthFC().getDayOfWeekFC()!+6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCell
        let calendarDay = cell.cellLabel
        calendarDay.layer.borderColor = UIColor.clear.cgColor
        calendarDay.layer.borderWidth = 0
        if indexPath.row+1 >= Date().addMonthFC(month: indexPath.section).startOfMonthFC().getDayOfWeekFC()!+7 {
            calendarDay.text = "\((indexPath.row+1)-(Date().addMonthFC(month: indexPath.section).startOfMonthFC().getDayOfWeekFC()!+6))"
            cell.cellLabel.textColor = Theme.BLACK
            cell.topView.isHidden = false
            cell.leftView.isHidden = false
            cell.rightView.isHidden = false
            cell.bottomView.isHidden = false
            cell.bottomView.frame = CGRect(x: 0, y: cell.frame.height - 1, width: cell.frame.width, height: 1)
        } else {
            if(indexPath.row < 7){
                var dayname = ""
                switch (indexPath.row){
                case 0:
                    dayname = "S"
                    break
                case 1:
                    dayname = "M"
                    break
                case 2:
                    dayname = "T"
                    break
                case 3:
                    dayname = "W"
                    break
                case 4:
                    dayname = "T"
                    break
                case 5:
                    dayname = "F"
                    break
                case 6:
                    dayname = "S"
                    break
                default:
                    break
                }
                calendarDay.text = dayname
                cell.cellLabel.textColor = Theme.BLACK.withAlphaComponent(0.4)
                cell.topView.isHidden = false
                cell.leftView.isHidden = true
                cell.rightView.isHidden = true
                cell.bottomView.isHidden = false
                cell.bottomView.frame = CGRect(x: 0, y: cell.frame.height - 1, width: cell.frame.width, height: 1)
            } else {
                calendarDay.text = ""
                cell.topView.isHidden = true
                cell.leftView.isHidden = true
                cell.rightView.isHidden = true
                cell.bottomView.isHidden = true
            }
        }
        cell.cellView.isHidden = true
        if (selectedIndex != nil) {
            if(selectedIndex == indexPath){
                cell.cellView.isHidden = false
                self.scrollToIndex()
            }
        } else if Int(calendarDay.text!) != nil {
            if(Date().addMonthFC(month: indexPath.section).startOfMonthFC().getDayFC(day: Int(calendarDay.text!)!-1) == selectedDate.getDayFC(day: 0)){
                calendarDay.layer.borderColor = Theme.BLACK.cgColor
                calendarDay.layer.borderWidth = 1
            } else {
                calendarDay.layer.borderColor = UIColor.clear.cgColor
                calendarDay.layer.borderWidth = 0
            }
        }
        if self.selectedIndeces.contains(indexPath) {
            cell.cellView.isHidden = false
            cell.cellLabel.textColor = Theme.BLACK.withAlphaComponent(0.4)
        } else {
            cell.cellView.isHidden = true
            cell.cellLabel.textColor = Theme.BLACK
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell {
            let calendarDay = cell.cellLabel
            if (indexPath.row < 7) {
                if !self.selectedDay.contains(indexPath) {
                    self.selectedDay.append(indexPath)
                    var i = indexPath.row
                    while i < 47 {
                        let index = IndexPath(row: i, section: indexPath.section)
                        if let selectedCell = collectionView.cellForItem(at: index) as? CalendarCell {
                            if index != indexPath && selectedCell.cellLabel.text != "" {
                                selectedCell.cellView.isHidden = false
                                selectedCell.cellLabel.textColor = Theme.BLACK.withAlphaComponent(0.4)
                                self.selectedIndeces.append(index)
                                let nextCalendarDay = selectedCell.cellLabel
                                self.addDayOfWeek(indexPath: index, calendarDay: nextCalendarDay)
                            }
                        }
                        i = i + 7
                    }
                    cell.cellView.isHidden = true
                    cell.cellLabel.textColor = Theme.BLACK
                } else {
                    self.selectedDay = self.selectedIndeces.filter { $0 != indexPath }
                    var i = indexPath.row
                    while i < 47 {
                        let index = IndexPath(row: i, section: indexPath.section)
                        if let selectedCell = collectionView.cellForItem(at: index) as? CalendarCell {
                            selectedCell.cellView.isHidden = true
                            selectedCell.cellLabel.textColor = Theme.BLACK
                            self.selectedIndeces = self.selectedIndeces.filter { $0 != index }
                            let nextCalendarDay = selectedCell.cellLabel
                            self.removeDayOfWeek(indexPath: index, calendarDay: nextCalendarDay)
                        }
                        i = i + 7
                    }
                }
            } else {
                if Int(calendarDay.text!) != nil{
                    if cell.cellView.isHidden == true {
                        cell.cellView.isHidden = false
                        cell.cellLabel.textColor = Theme.BLACK.withAlphaComponent(0.4)
                        self.selectedIndeces.append(indexPath)
                        self.addDayOfWeek(indexPath: indexPath, calendarDay: calendarDay)
                    } else {
                        cell.cellView.isHidden = true
                        cell.cellLabel.textColor = Theme.BLACK
                        self.selectedIndeces = self.selectedIndeces.filter { $0 != indexPath }
                        self.removeDayOfWeek(indexPath: indexPath, calendarDay: calendarDay)
                    }
                }
            }
        }
        if self.previousSelected.containsSameElements(as: self.selectedIndeces) {
            self.calendarDelegate?.hideSaveButton()
        } else {
            self.calendarDelegate?.bringSaveButton()
        }
    }
    
    func addDayOfWeek(indexPath: IndexPath, calendarDay: UILabel) {
        if let text = calendarDay.text, text != "", text != "S", text != "M", text != "T", text != "W", text != "F" {
            let sDate =  Date().addMonthFC(month: indexPath.section).startOfMonthFC().getDayFC(day: Int(text)!-1)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let stringDate = formatter.string(from: sDate)
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: sDate)
            if weekDay == 1 {
                self.selectedSundays.append(stringDate)
            } else if weekDay == 2 {
                self.selectedMondays.append(stringDate)
            } else if weekDay == 3 {
                self.selectedTuesdays.append(stringDate)
            } else if weekDay == 4 {
                self.selectedWednesdays.append(stringDate)
            } else if weekDay == 5 {
                self.selectedThursdays.append(stringDate)
            } else if weekDay == 6 {
                self.selectedFridays.append(stringDate)
            } else if weekDay == 7 {
                self.selectedSaturdays.append(stringDate)
            }
        }
    }
    
    func pullDatesFromDatabase(dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            let thisMonth = Date().month
            var printMonth = thisMonth - date.month
            if printMonth <= 0 {
                printMonth = abs(printMonth)
                let startDay = date.startOfMonthFC().getDayOfWeekFC()
                let printDay = date.days(from: date.startOfMonthFC()) + 6 + startDay!
                let indexPath = IndexPath(row: printDay, section: printMonth)
                if !self.selectedIndeces.contains(indexPath) {
                    self.selectedIndeces.append(indexPath)
                }
                self.calendar.reloadData()
            } else {
                printMonth = date.month + 12 - thisMonth
                let startDay = date.startOfMonthFC().getDayOfWeekFC()
                let printDay = date.days(from: date.startOfMonthFC()) + 6 + startDay!
                let indexPath = IndexPath(row: printDay, section: printMonth)
                if !self.selectedIndeces.contains(indexPath) {
                    self.selectedIndeces.append(indexPath)
                }
                self.calendar.reloadData()
            }
        }
    }
    
    func removeDayOfWeek(indexPath: IndexPath, calendarDay: UILabel) {
        if let text = calendarDay.text, text != "", text != "S", text != "M", text != "T", text != "W", text != "F" {
            let sDate =  Date().addMonthFC(month: indexPath.section).startOfMonthFC().getDayFC(day: Int(text)!-1)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let stringDate = formatter.string(from: sDate)
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: sDate)
            if weekDay == 1 {
                self.selectedSundays = self.selectedSundays.filter { $0 != stringDate }
            } else if weekDay == 2 {
                self.selectedMondays = self.selectedMondays.filter { $0 != stringDate }
            } else if weekDay == 3 {
                self.selectedTuesdays = self.selectedTuesdays.filter { $0 != stringDate }
            } else if weekDay == 4 {
                self.selectedWednesdays = self.selectedWednesdays.filter { $0 != stringDate }
            } else if weekDay == 5 {
                self.selectedThursdays = self.selectedThursdays.filter { $0 != stringDate }
            } else if weekDay == 6 {
                self.selectedFridays = self.selectedFridays.filter { $0 != stringDate }
            } else if weekDay == 7 {
                self.selectedSaturdays = self.selectedSaturdays.filter { $0 != stringDate }
            }
        }
    }
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func organizeSelectedDays() {
        self.selectedSundays = uniq(source: self.selectedSundays).sorted()
        self.selectedMondays = uniq(source: self.selectedMondays).sorted()
        self.selectedTuesdays = uniq(source: self.selectedTuesdays).sorted()
        self.selectedWednesdays = uniq(source: self.selectedWednesdays).sorted()
        self.selectedThursdays = uniq(source: self.selectedThursdays).sorted()
        self.selectedFridays = uniq(source: self.selectedFridays).sorted()
        self.selectedSaturdays = uniq(source: self.selectedSaturdays).sorted()
    }
    
}
