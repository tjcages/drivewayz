//
//  AvailabilityCalendarView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import JTAppleCalendar

class AvailabilityCalendarView: UIViewController {
    
    lazy var today = Date()
    let calendar = Calendar.current
    let month: TimeInterval = 2.628e+6
    let df = DateFormatter()
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && calendarView.selectedDates.count > 1
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.setBackButton()
        controller.scrollView.isHidden = true
        
        return controller
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Tap specific days or days of the week to block out availability on the calendar."
        label.numberOfLines = 2
        
        return label
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var monthContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var firstMonth: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("November", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH1
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var secondMonth: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("December", for: .normal)
        button.setTitleColor(Theme.LIGHT_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH1
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var thirdMonth: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("January", for: .normal)
        button.setTitleColor(Theme.LIGHT_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH1
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
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
        view.backgroundColor = lineColor
        
        return view
    }()
    
    lazy var calendarView: JTACMonthView = {
        let view = JTACMonthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(TestRangeSelectionViewControllerCell.self, forCellWithReuseIdentifier: "cellId")
        view.register(CalendarSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cell")
        view.cellSize = 50.0
        view.allowsMultipleSelection = true
//        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        view.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        view.scrollingMode = .stopAtEachSection
        view.allowsRangedSelection = false
        
        return view
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        line.backgroundColor = lineColor
        view.addSubview(line)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self

        setupViews()
        setupCalendar()
        setupMonths()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text != "Calendar" {
            gradientController.animateText(text: "Calendar")
        }
        UIView.animate(withDuration: animationIn) {
            self.gradientController.scrollView.alpha = 1
            self.editButton.alpha = 1
        }
    }
    
    var containerSubAnchor: NSLayoutConstraint!
    var containerTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        view.addSubview(container)
        view.addSubview(monthContainer)
        view.addSubview(calendarView)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        editButton.bottomAnchor.constraint(equalTo: gradientController.backButton.bottomAnchor).isActive = true
        editButton.sizeToFit()
        
        view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: gradientController.scrollView.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        container.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerSubAnchor = container.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 16)
            containerSubAnchor.isActive = true
        containerTopAnchor = container.topAnchor.constraint(equalTo: gradientController.gradientContainer.bottomAnchor)
            containerTopAnchor.isActive = false
        
        view.addSubview(buttonView)
        view.addSubview(mainButton)
        
        mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        buttonView.anchor(top: mainButton.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    var monthTopAnchor: NSLayoutConstraint!
    
    func setupMonths() {
        
        monthTopAnchor = monthContainer.topAnchor.constraint(equalTo: container.topAnchor)
            monthTopAnchor.priority = .defaultLow
            monthTopAnchor.isActive = true
        monthContainer.topAnchor.constraint(greaterThanOrEqualTo: gradientController.gradientContainer.bottomAnchor).isActive = true
        monthContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        monthContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        monthContainer.heightAnchor.constraint(equalToConstant: 112).isActive = true
        
        monthContainer.addSubview(firstMonth)
        monthContainer.addSubview(secondMonth)
        monthContainer.addSubview(thirdMonth)
        
        firstMonth.topAnchor.constraint(equalTo: monthContainer.topAnchor, constant: 12).isActive = true
        firstMonth.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        firstMonth.sizeToFit()
        
        secondMonth.topAnchor.constraint(equalTo: monthContainer.topAnchor, constant: 12).isActive = true
        secondMonth.leftAnchor.constraint(equalTo: firstMonth.rightAnchor, constant: 40).isActive = true
        secondMonth.sizeToFit()
        
        thirdMonth.topAnchor.constraint(equalTo: monthContainer.topAnchor, constant: 12).isActive = true
        thirdMonth.leftAnchor.constraint(equalTo: secondMonth.rightAnchor, constant: 40).isActive = true
        thirdMonth.sizeToFit()
        
        monthContainer.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: monthContainer.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 16, paddingRight: 8, width: 0, height: 20)
        
        monthContainer.addSubview(line)
        line.anchor(top: nil, left: view.leftAnchor, bottom: monthContainer.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        for i in 0...6 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = Theme.LIGHT_GRAY
            label.font = Fonts.SSPSemiBoldH4
            label.textAlignment = .center
            
            if i == 0 {
                label.text = "Sun"
            } else if i == 1 {
                label.text = "Mon"
            } else if i == 2 {
                label.text = "Tue"
            } else if i == 3 {
                label.text = "Wed"
            } else if i == 4 {
                label.text = "Thu"
            } else if i == 5 {
                label.text = "Fri"
            } else if i == 6 {
                label.text = "Sat"
            }
            
            stackView.addArrangedSubview(label)
        }
        
    }
    
    var calendarHeightAnchor: NSLayoutConstraint!
    
    func setupCalendar() {
        
        calendarView.anchor(top: monthContainer.bottomAnchor, left: view.leftAnchor, bottom: buttonView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        calendarView.visibleDates() { visibleDates in
            if let date = visibleDates.monthDates.first {
                self.setupMonthLabel(date: date.date)
            }
        }
    }
    
    func setupMonthLabel(date: Date) {
        df.dateFormat = "MMMM"
        var month = date.month
        if month == today.month {
            scrollExpanded()
        } else {
            scrollMinimized()
        }
        let monthName = df.monthSymbols[month - 1]
        firstMonth.setTitle(monthName, for: .normal)
        month += 1
        if month == 13 {
            month = 1
        }
        let monthName2 = df.monthSymbols[month - 1]
        secondMonth.setTitle(monthName2, for: .normal)
        month += 1
        if month == 13 {
            month = 1
        }
        let monthName3 = df.monthSymbols[month - 1]
        thirdMonth.setTitle(monthName3, for: .normal)
    }
    
    @objc func editPressed() {
        
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension AvailabilityCalendarView: JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 8)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "cell", for: indexPath) as! CalendarSectionHeaderView
        header.isHidden = true
        
        return header
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cellId", for: indexPath) as! TestRangeSelectionViewControllerCell
        cell.label.text = cellState.text
        cell.cellWidth = (phoneWidth - 16)/7
        cell.selectedView.isHidden = true
        cell.todayView.isHidden = true
        cell.strikeLine.isHidden = true
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
//        if firstDate != nil {
//            secondDate = date
//            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
//        } else {
//            firstDate = date
//            secondDate = nil
//        }
        handleConfiguration(cell: cell, cellState: cellState)
        
//        let dates = calendarView.selectedDates
//        if dates.count == 1 {
//            delegate?.setDate(date: date, start: true)
//            delegate?.setDate(date: date, start: false)
//        } else {
//            delegate?.setDate(date: date, start: false)
//        }
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
        
        let dates = calendarView.selectedDates
        if dates.count == 0 {
            firstDate = nil
            secondDate = nil
//            delegate?.setDate(date: nil, start: true)
        }
    }

//    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
//        if calendarView.selectedDates.count > 0 {
//            if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendarView.selectedDates[0] {
//                firstDate = nil
//                let retval = !calendarView.selectedDates.contains(date)
//                calendarView.deselectAllDates()
//                return retval
//            }
//        }
//        return true
//    }
    
//    func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
//        if twoDatesAlreadySelected && cellState.selectionType != .programatic {
//            firstDate = nil
//            calendarView.deselectAllDates()
//            return false
//        }
//        return true
//    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let endDate = today.addingTimeInterval(month * 12)

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
    
    func handleConfiguration(cell: JTACDayCell?, cellState: CellState) {
            guard let cell = cell as? TestRangeSelectionViewControllerCell else { return }
            handleCellColor(cell: cell, cellState: cellState)
            handleCellSelection(cell: cell, cellState: cellState)
    }
        
    func handleCellColor(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        let date = cellState.date
        
        if cellState.dateBelongsTo == .thisMonth {
            if date.isInSameDay(date: today) {
                cell.todayView.isHidden = false
                cell.label.textColor = Theme.DARK_GRAY
                cell.selectedView.backgroundColor = Theme.HOST_BLUE
            } else if !date.isInThePast {
                cell.label.textColor = Theme.DARK_GRAY
                cell.selectedView.alpha = 1
                cell.isUserInteractionEnabled = true
            } else {
                cell.label.textColor = Theme.LIGHT_GRAY
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
            cell.strikeLine.isHidden = !cellState.isSelected
            cell.selectedView.layer.maskedCorners = []
            if cellState.isSelected {
                cell.selectedView.backgroundColor = lineColor
            } else {
                cell.selectedView.backgroundColor = Theme.HOST_BLUE
            }
        }
    }
    
}

extension AvailabilityCalendarView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleDates = calendarView.visibleDates()
        calendar(calendarView, didScrollToDateSegmentWith: visibleDates)
    }
    
    func scrollExpanded() {
        containerSubAnchor.isActive = true
        containerTopAnchor.isActive = false
        gradientController.subLabelBottom.constant = 0
        gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gradientController.subLabel.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        containerSubAnchor.isActive = false
        containerTopAnchor.isActive = true
        gradientController.subLabelBottom.constant = gradientController.subHeight
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.gradientController.subLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
