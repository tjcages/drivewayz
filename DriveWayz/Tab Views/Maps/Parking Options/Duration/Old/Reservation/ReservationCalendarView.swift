//
//  ReservationCalendarView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import JTAppleCalendar

var firstDate: Date?
var secondDate: Date?

class ReservationCalendarView: UIViewController {
    
    var delegate: handleReservationCalendar?
    var cellHeight: CGFloat = 92
    let df = DateFormatter()
    let month: TimeInterval = 1.21e+6/2
    lazy var today = Date()
    let calendar = Calendar.current
    
    lazy var quickCellWidth: CGFloat = (phoneWidth - 48)/2
    var quickCellHeight: CGFloat = 50
    var mainOptions: [String] = ["This weekend", "This week", "Next weekend", "Next two weeks"]
    
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && calendarView.selectedDates.count > 1
    }
    
    lazy var calendarView: JTACMonthView = {
        let view = JTACMonthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(TestRangeSelectionViewControllerCell.self, forCellWithReuseIdentifier: "cellId")
        view.register(CalendarSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cell")
        view.isScrollEnabled = false
        view.cellSize = 50.0
        view.allowsMultipleSelection = true
        view.allowsRangedSelection = true
        view.rangeSelectionMode = .continuous
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var topContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        
        return view
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "December, 2019"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var quickLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Quick select"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()

    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        return layout
    }()
    
    lazy var collectionPicker: UICollectionView = {
        let picker = UICollectionView(frame: .zero, collectionViewLayout: layout)
        picker.backgroundColor = .clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(QuickCalendarCell.self, forCellWithReuseIdentifier: "identifier")
        picker.isScrollEnabled = false
//        picker.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        collectionPicker.delegate = self
        collectionPicker.dataSource = self

        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        setupViews()
        setupCalendar()
        setupQuick()
    }
    
    func setupViews() {
        
        view.addSubview(container)
        container.addSubview(topContainer)
        container.addSubview(dateLabel)
        
        container.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        topContainer.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 56)
        
        dateLabel.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        dateLabel.sizeToFit()
        
    }
    
    var calendarHeightAnchor: NSLayoutConstraint!
    
    func setupCalendar() {
        container.addSubview(calendarView)
        calendarView.anchor(top: topContainer.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        calendarHeightAnchor = calendarView.heightAnchor.constraint(equalToConstant: 0)
            calendarHeightAnchor.isActive = true
        
        calendarView.visibleDates() { visibleDates in
            if let date = visibleDates.monthDates.first {
                self.setupMonthLabel(date: date.date)
            }
            
            var height: CGFloat = 108
            guard let distance = self.today.totalDistance(from: self.today.endOfMonthFC(), resultIn: .day) else { return }
            if distance >= 14 {
                height += 288
                self.calendarHeightAnchor.constant = 338
            } else {
                height += 576
                self.calendarHeightAnchor.constant = 626
            }
            self.delegate?.changeCalendarHeight(height: height)
            UIView.animate(withDuration: animationIn, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setupQuick() {
        
        container.addSubview(quickLabel)
        container.addSubview(collectionPicker)
        
        quickLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16).isActive = true
        quickLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        quickLabel.sizeToFit()
        
        collectionPicker.anchor(top: quickLabel.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 32, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: quickCellHeight * 2 + 8)
        
    }
    
    func setupMonthLabel(date: Date) {
        df.dateFormat = "MMMM, yyyy"
        dateLabel.text = df.string(from: date)
    }
    
    func handleConfiguration(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? TestRangeSelectionViewControllerCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellColor(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        let date = cellState.date
        let endDate = today.addingTimeInterval(month)
        let difference = date.days(from: endDate)
        
        if cellState.dateBelongsTo == .thisMonth {
            if (!date.isInThePast && difference <= 0) || date.isInSameDay(date: today) {
                cell.label.textColor = Theme.BLACK
                cell.selectedView.alpha = 1
                cell.isUserInteractionEnabled = true
            } else {
                cell.label.textColor = Theme.GRAY_WHITE_4
                cell.selectedView.alpha = 0
                cell.isUserInteractionEnabled = false
            }
        } else {
            cell.label.textColor = .clear
            cell.selectedView.alpha = 0
            cell.isUserInteractionEnabled = false
        }
    }
    
    func handleCellSelection(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.selectedView.isHidden = !cellState.isSelected
            if cellState.isSelected {
                cell.selectedView.backgroundColor = Theme.BLUE
            }
            switch cellState.selectedPosition() {
            case .left:
                cell.selectedView.layer.cornerRadius = 4
                cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                cell.label.textColor = Theme.BLACK
                cell.selectedView.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
                cell.selectedView.layer.cornerRadius = 0
                cell.selectedView.layer.maskedCorners = []
                return
            case .right:
                cell.selectedView.layer.cornerRadius = 4
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .full:
                cell.selectedView.layer.cornerRadius = 4
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            default:
                return
            }
            if cellState.isSelected {
                cell.label.textColor = Theme.WHITE
            } else {
                cell.label.textColor = Theme.BLACK
            }
        }
    }

}


extension ReservationCalendarView: JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "cell", for: indexPath) as! CalendarSectionHeaderView
        if indexPath.section > 0 {
            header.isHidden = true
        }
        
        return header
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cellId", for: indexPath) as! TestRangeSelectionViewControllerCell
        cell.label.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if firstDate != nil {
            secondDate = date
            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
            secondDate = nil
        }
        handleConfiguration(cell: cell, cellState: cellState)
        
        let dates = calendarView.selectedDates
        if dates.count == 1 {
            delegate?.setDate(date: date, start: true)
            delegate?.setDate(date: date, start: false)
        } else {
            delegate?.setDate(date: date, start: false)
        }
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
        
        let dates = calendarView.selectedDates
        if dates.count == 0 {
            firstDate = nil
            secondDate = nil
            delegate?.setDate(date: nil, start: true)
        }
    }

    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        if calendarView.selectedDates.count > 0 {
            if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendarView.selectedDates[0] {
                firstDate = nil
                let retval = !calendarView.selectedDates.contains(date)
                calendarView.deselectAllDates()
                return retval
            }
        }
        return true
    }
    
    func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        if twoDatesAlreadySelected && cellState.selectionType != .programatic {
            firstDate = nil
            calendarView.deselectAllDates()
            return false
        }
        return true
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let endDate = today.addingTimeInterval(month)

        let parameter = ConfigurationParameters(startDate: today,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                calendar: self.calendar,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfRow,
                                                firstDayOfWeek: .sunday,
                                                hasStrictBoundaries: true)
        return parameter
    }
    
}

extension ReservationCalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = mainOptions.count
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: quickCellWidth, height: quickCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! QuickCalendarCell
        
        if mainOptions.count > indexPath.row {
            cell.mainLabel.text = mainOptions[indexPath.row]
        }
        return cell
    }
    
}

class TestRangeSelectionViewControllerCell: JTACDayCell {
    
    var cellWidth = (phoneWidth - 40)/7 {
        didSet {
            selectedHeightAnchor.constant = cellWidth
            layoutIfNeeded()
        }
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.isHidden = true
        
        return view
    }()
    
    var todayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = Theme.BLUE.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = Theme.HOST_BLUE
        view.isHidden = true
        
        return view
    }()
    
    var strikeLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        view.isHidden = true
        
        return view
    }()
    
    /// Cell view that will be customized
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    var selectedHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(todayView)
        addSubview(selectedView)
        addSubview(label)
        addSubview(strikeLine)
        
        selectedView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        selectedView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        selectedHeightAnchor = selectedView.heightAnchor.constraint(equalToConstant: cellWidth)
            selectedHeightAnchor.isActive = true
        selectedView.widthAnchor.constraint(equalTo: selectedView.heightAnchor).isActive = true

        todayView.anchor(top: selectedView.topAnchor, left: selectedView.leftAnchor, bottom: selectedView.bottomAnchor, right: selectedView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        strikeLine.heightAnchor.constraint(equalTo: selectedView.heightAnchor, constant: -16).isActive = true
        strikeLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        strikeLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        strikeLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.sizeToFit()
        
    }
    
    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

class QuickCalendarCell: UICollectionViewCell {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.BACKGROUND_GRAY
        layer.cornerRadius = 8
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CalendarSectionHeaderView: JTACMonthReusableView {
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 0
        view.distribution = UIStackView.Distribution.fillEqually
//        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        addSubview(line)
        line.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: -8, paddingBottom: 0, paddingRight: -8, width: 0, height: 1)
        
        for i in 0...6 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = Theme.GRAY_WHITE
            label.font = Fonts.SSPSemiBoldH4
            label.textAlignment = .center
            
            if i == 0 || i == 6 {
                label.text = "S"
            } else if i == 1 {
                label.text = "M"
            } else if i == 2 || i == 4 {
                label.text = "T"
            } else if i == 3 {
                label.text = "W"
            } else {
                label.text = "F"
            }
            
            stackView.addArrangedSubview(label)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
