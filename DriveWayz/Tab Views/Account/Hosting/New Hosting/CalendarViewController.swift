//
//  CalendarViewController
//  SwiftCalendar
//
//  Created by Sameer Poudel on 6/11/18.
//  Copyright © 2018 Sameer Poudel. All rights reserved.
//

import UIKit

protocol CalendarCallBack {
    func didSelectDate(date: Date)
}

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var numberOfMonths: Int = 3
    
    lazy var calendar: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.register(CalendarCell.self, forCellWithReuseIdentifier: "cell")
        view.register(CalendarHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        view.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 200, right: 0)
        
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
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.font = Fonts.SSPLightH4
        label.text = "Tap specific days or days of the week to block out availability on the calendar"
        label.numberOfLines = 2
        
        return label
    }()
    
    var showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.addTarget(self, action: #selector(showMorePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var delegate: CalendarCallBack? = nil
    var selectedIndex: IndexPath? = nil
    var selectedDate = Date()
    var selectedIndeces: [IndexPath] = []
    var selectedDay: [IndexPath] = []
    
    var selectedSundays: [String] = []
    var selectedMondays: [String] = []
    var selectedTuesdays: [String] = []
    var selectedWednesdays: [String] = []
    var selectedThursdays: [String] = []
    var selectedFridays: [String] = []
    var selectedSaturdays: [String] = []
    
    var verticalConstraint: NSLayoutConstraint? = nil
    var heightConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        setupViews()
        setupCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.reloadData()
    }
    
    var showMoreTopAnchor: NSLayoutConstraint!
    var showMoreHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {

        self.view.addSubview(wrapper)
        wrapper.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        wrapper.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        wrapper.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        wrapper.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(calendar)
        calendar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        calendar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        calendar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        calendar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        calendar.addSubview(showMoreButton)
        showMoreButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        showMoreButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        showMoreHeightAnchor = showMoreButton.heightAnchor.constraint(equalToConstant: 40)
            showMoreHeightAnchor.isActive = true
        showMoreTopAnchor = showMoreButton.topAnchor.constraint(equalTo: calendar.topAnchor, constant: calendar.frame.size.width / 7 * 24)
            showMoreTopAnchor.isActive = true
        
        calendar.addSubview(scheduleLabel)
        scheduleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        scheduleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        scheduleLabel.topAnchor.constraint(equalTo: calendar.topAnchor, constant: -40).isActive = true
        scheduleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
    
    func setupCalendar() {
        let numberOfCellsPerRow: CGFloat = 7
        if let flowLayout = calendar.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - 16 - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            flowLayout.headerReferenceSize = CGSize(width: self.calendar.frame.size.width, height: 70)
        }
        
        self.view.layoutIfNeeded()
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: wrapper, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: wrapper, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.size.width)
        
        verticalConstraint = NSLayoutConstraint(item: wrapper, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: self.view.frame.size.height)
        
        view.addConstraints([horizontalConstraint, widthConstraint, verticalConstraint!])
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.25, animations: {
                self.verticalConstraint!.constant = 60
                self.heightConstraint = NSLayoutConstraint(item: self.wrapper, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant:  0)
                self.view.addConstraints([self.heightConstraint!])
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func scrollToIndex() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            if self.selectedIndex != nil {
                self.calendar.scrollToItem(at: self.selectedIndex!, at: .centeredVertically, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 7), height: CGFloat(collectionView.frame.size.width / 7))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.showMoreTopAnchor.constant = calendar.frame.size.width / 7 * 7.5 * CGFloat(numberOfMonths) + 30
        if numberOfMonths > 11 {
            self.showMoreTopAnchor.constant = self.showMoreTopAnchor.constant - 60
        }
        self.view.layoutIfNeeded()
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
            cell.topView.isHidden = false
            cell.leftView.isHidden = false
            cell.rightView.isHidden = false
            cell.bottomView.isHidden = false
            cell.bottomView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: cell.frame.width, height: 0.5)
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
                calendarDay.layer.borderColor = Theme.WHITE.cgColor
                calendarDay.layer.borderWidth = 1
            } else {
                calendarDay.layer.borderColor = UIColor.clear.cgColor
                calendarDay.layer.borderWidth = 0
            }
        }
        if self.selectedIndeces.contains(indexPath) {
            cell.cellView.isHidden = false
            cell.cellLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        } else {
            cell.cellView.isHidden = true
            cell.cellLabel.textColor = Theme.WHITE
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
                                selectedCell.cellLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
                                self.selectedIndeces.append(index)
                                let nextCalendarDay = selectedCell.cellLabel
                                self.addDayOfWeek(indexPath: index, calendarDay: nextCalendarDay)
                            }
                        }
                        i = i + 7
                    }
                    cell.cellView.isHidden = true
                    cell.cellLabel.textColor = Theme.WHITE
                } else {
                    self.selectedDay = self.selectedIndeces.filter { $0 != indexPath }
                    var i = indexPath.row
                    while i < 47 {
                        let index = IndexPath(row: i, section: indexPath.section)
                        if let selectedCell = collectionView.cellForItem(at: index) as? CalendarCell {
                            selectedCell.cellView.isHidden = true
                            selectedCell.cellLabel.textColor = Theme.WHITE
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
                        cell.cellLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
                        print(indexPath)
                        self.selectedIndeces.append(indexPath)
                        self.addDayOfWeek(indexPath: indexPath, calendarDay: calendarDay)
                    } else {
                        cell.cellView.isHidden = true
                        cell.cellLabel.textColor = Theme.WHITE
                        self.selectedIndeces = self.selectedIndeces.filter { $0 != indexPath }
                        self.removeDayOfWeek(indexPath: indexPath, calendarDay: calendarDay)
                    }
                }
            }
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

class CalendarCell: UICollectionViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var angleView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 10, width: 10, height: self.frame.height * 2))
        view.backgroundColor = Theme.DARK_GRAY
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/5)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPLightH3
        label.text = "1"
        
        return label
    }()
    
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5))
        //        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.5)

        return view
    }()
    
    lazy var leftView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0.5, width: 0.5, height: self.frame.height - 1))
        //        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.5)
        
        return view
    }()
    
    lazy var rightView: UIView = {
        let view = UIView(frame: CGRect(x: self.frame.width, y: 0.5, width: 0.5, height: self.frame.height - 1))
        //        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.5)
        
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 0.5))
        //        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.5)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(cellLabel)
        cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(cellView)
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        cellView.addSubview(angleView)
        angleView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        angleView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10).isActive = true
        angleView.centerXAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        angleView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
//        self.addSubview(topView)
//        self.addSubview(leftView)
//        self.addSubview(rightView)
        self.addSubview(bottomView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class CalendarHeaderCell: UICollectionReusableView {
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        label.text = "1"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.5)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(cellLabel)
        self.addSubview(bottomView)
        cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        cellLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Date {
    
    func getDaysInMonthFC() -> Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    func addMonthFC(month: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: month, to: self)!
    }
    
    func startOfMonthFC() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonthFC() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonthFC())!
    }
    
    func getDayOfWeekFC() -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func getHeaderTitleFC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, YYYY"
        return dateFormatter.string(from: self)
    }
    
    func getDayFC(day: Int) -> Date {
        let day = Calendar.current.date(byAdding: .day, value: day, to: self)!
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: day)!
    }
    
    func getYearOnlyFC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
    
    func getTitleDateFC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        return dateFormatter.string(from: self)
    }
}

extension UIView {
    func callRecursively(level: Int = 0, _ body: (_ subview: UIView, _ level: Int) -> Void) {
        body(self, level)
        subviews.forEach { $0.callRecursively(level: level + 1, body) }
    }
}
