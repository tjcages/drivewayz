//
//  TestReservationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleReservationCalendar {
    func setDate(date: Date?, start: Bool)
    func changeCalendarHeight(height: CGFloat)
}

class TestReservationView: UIViewController {
    
    var delegate: handleCheckoutParking?
    var mainDelegate: handleDuration?
    var canPanView: Bool = true
    
    let fromPicker = UIPickerView()
    let toPicker = UIPickerView()
    var dateFormatter = DateFormatter()
    let calendar = Calendar.current
    var timer: Timer?
    
    var fromTimes: [String] = []
    var toTimes: [String] = []
    
    var previousPercentage: CGFloat = 0
    var normalScrollHeight: CGFloat = 408
    lazy var currentBookingHeight: CGFloat = phoneHeight - normalScrollHeight
    
    var mainButtonAvailable: Bool = true
    var minimize: Bool = false
    var previousStart: String?
    var previousEnd: String?
    
    let gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.alpha = 0
        
        return view
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeFullReservation), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Reserve Spot"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        label.alpha = 0
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = Theme.WHITE
        view.isScrollEnabled = false
        
        return view
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var startLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start date"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var endLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "End date"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var startButton: IdentityButton = {
        let button = IdentityButton()
        button.setTitle("12  /  07  /  19", for: .normal)
        button.addTarget(self, action: #selector(datesPressed(sender:)), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return button
    }()
    
    var endButton: IdentityButton = {
        let button = IdentityButton()
        button.setTitle("12  /  07  /  19", for: .normal)
        button.addTarget(self, action: #selector(datesPressed(sender:)), for: .touchUpInside)
    
        return button
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()

    var startTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start time"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var startTimeButton: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLUE
        view.font = Fonts.SSPSemiBoldH2
        view.tintColor = .clear
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 4
        view.textAlignment = .center
        view.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        view.isScrollEnabled = false
        
        return view
    }()
    
    var endTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "End time"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var endTimeButton: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLUE
        view.font = Fonts.SSPSemiBoldH2
        view.tintColor = .clear
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 4
        view.textAlignment = .center
        view.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        view.isScrollEnabled = false
        
        return view
    }()
    
    lazy var calendarController: ReservationCalendarView = {
        let controller = ReservationCalendarView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        controller.calendarView.selectDates([controller.today])
        
        return controller
    }()
    
    var daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        
        return label
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.GRAY_WHITE
        button.addTarget(self, action: #selector(informationButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        startTimeButton.delegate = self
        endTimeButton.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)

        setupViews()
        setupDates()
        setupTimes()
        
        createToolbar()
        createDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observeFirstTime()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(observeCurrentTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    var scrollTopAnchor: NSLayoutConstraint!
    var gradientTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
    
        view.addSubview(dimView)
        view.addSubview(scrollView)
        
        view.addSubview(gradientContainer)
        gradientTopAnchor = gradientContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: -240)
            gradientTopAnchor.isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        gradientContainer.heightAnchor.constraint(equalToConstant: gradientHeight).isActive = true
        
        view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 48).isActive = true
        }
        
        view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
        scrollView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        scrollTopAnchor = scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: currentBookingHeight)
            scrollTopAnchor.isActive = true
        
        if device != .iphoneX {
            normalScrollHeight -= 16
            currentBookingHeight = phoneHeight - normalScrollHeight
        }
        
    }
    
    var calendarTopAnchor: NSLayoutConstraint!
    var calendarHeightAnchor: NSLayoutConstraint!
    
    func setupDates() {
        
        scrollView.addSubview(startLabel)
        scrollView.addSubview(startButton)
        
        scrollView.addSubview(arrowButton)
        scrollView.addSubview(endLabel)
        scrollView.addSubview(endButton)
        
        startLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        startLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        startLabel.sizeToFit()
        
        startButton.anchor(top: startLabel.bottomAnchor, left: startLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 45)
        
        arrowButton.anchor(top: nil, left: startButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        arrowButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true
        
        endButton.anchor(top: startButton.topAnchor, left: arrowButton.rightAnchor, bottom: startButton.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 120, height: 0)
        
        endLabel.topAnchor.constraint(equalTo: startLabel.topAnchor).isActive = true
        endLabel.leftAnchor.constraint(equalTo: endButton.leftAnchor).isActive = true
        endLabel.sizeToFit()
        
        scrollView.addSubview(calendarController.view)
        calendarController.view.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        calendarTopAnchor = calendarController.view.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 92)
            calendarTopAnchor.isActive = true
        calendarHeightAnchor = calendarController.view.heightAnchor.constraint(equalToConstant: 600)
            calendarHeightAnchor.isActive = true
        
    }
    
    var endTimeBottomAnchor: NSLayoutConstraint!
    
    func setupTimes() {
        
        scrollView.addSubview(endTimeLabel)
        scrollView.addSubview(endTimeButton)
        scrollView.addSubview(daysLabel)
        scrollView.addSubview(informationIcon)
        
        endTimeBottomAnchor = endTimeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
            endTimeBottomAnchor.isActive = true
        endTimeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        endTimeLabel.sizeToFit()
        
        endTimeButton.centerYAnchor.constraint(equalTo: endTimeLabel.centerYAnchor, constant: 0).isActive = true
        endTimeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        endTimeButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        endTimeButton.widthAnchor.constraint(equalToConstant: 112).isActive = true
        
        informationIcon.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor).isActive = true
        informationIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true
        
        daysLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        daysLabel.leftAnchor.constraint(equalTo: informationIcon.rightAnchor, constant: 4).isActive = true
        daysLabel.sizeToFit()
        
        scrollView.addSubview(startTimeLabel)
        scrollView.addSubview(startTimeButton)
        
        startTimeLabel.bottomAnchor.constraint(equalTo: endTimeLabel.topAnchor, constant: -16).isActive = true
        startTimeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        startTimeLabel.sizeToFit()
        
        startTimeButton.centerYAnchor.constraint(equalTo: startTimeLabel.centerYAnchor, constant: 0).isActive = true
        startTimeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        startTimeButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        startTimeButton.widthAnchor.constraint(equalToConstant: 112).isActive = true
        
        scrollView.addSubview(line)
        line.anchor(top: nil, left: view.leftAnchor, bottom: startTimeButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 12, paddingRight: 20, width: 0, height: 1)

    }

    @objc func datesPressed(sender: IdentityButton) {
        dismissKeyboard()
        openFullReservation()
        sender.selectedButton = true
    }
    
    @objc func selectDate(sender: IdentityButton) {
        sender.selectedButton = true
    }
    
    func unselectDates() {
        startButton.selectedButton = false
        endButton.selectedButton = false
        
        if !mainButtonAvailable {
            startButton.setTitle(previousStart, for: .normal)
            endButton.setTitle(previousEnd, for: .normal)
            calendarController.calendarView.selectDates([calendarController.today])
        }
    }
    
    func availableMainButton() {
        mainButtonAvailable = true
        mainDelegate?.availableMainButton()
    }
    
    func unavailableMainButton() {
        mainButtonAvailable = false
        mainDelegate?.unavailableMainButton()
    }

}

extension TestReservationView: handleReservationCalendar {
    
    func setDate(date: Date?, start: Bool) {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            let string = formatter.string(from: date)
            if start {
                startButton.setTitle(string, for: .normal)
                availableMainButton()
            } else {
                endButton.setTitle(string, for: .normal)
                availableMainButton()
            }
            if let start = firstDate, let end = secondDate {
                let difference = end.days(from: start) + 1
                daysLabel.text = "\(difference) full days selected"
            }
        } else {
            startButton.setTitle("", for: .normal)
            endButton.setTitle("", for: .normal)
            unavailableMainButton()
        }
    }
    
    func changeCalendarHeight(height: CGFloat) {
        scrollView.contentSize = CGSize(width: phoneWidth, height: height + 260)
        calendarHeightAnchor.constant = height
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension TestReservationView {
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        if canPanView {
            let translation = -sender.translation(in: self.view).y
            let state = sender.state
            let percentage = translation/(phoneHeight/3)
            if state == .changed {
                if percentage >= 0 && percentage <= 1 && percentage < 0.7 && previousPercentage != 1.0 {
                    changeScrollAmount(percentage: percentage)
                } else if percentage >= 0.7 && previousPercentage != 1.0 {
                    //                canScrollMainView = false
                    openFullReservation()
                    return
                } else {
                    print(translation)
                }
            } else if state == .ended {
                if previousPercentage >= 0.25 {
                    openFullReservation()
                } else {
                    closeFullReservation()
                }
            }
        } else {
            dismissKeyboard()
        }
    }
    
    func changeScrollAmount(percentage: CGFloat) {
        previousPercentage = percentage
        
        scrollTopAnchor.constant = currentBookingHeight - currentBookingHeight * percentage
        gradientTopAnchor.constant = -240 + 240 * percentage
        changeAlphaAmount(percentage: percentage)
        if percentage <= 0.6 {
//            cancelBottomAnchor.constant = cancelBottomHeight - cancelBottomHeight * (percentage/0.6)
            tabDimmingView.alpha = 0.4 + percentage
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc func openFullReservation() {
        scrollView.isScrollEnabled = true
        previousPercentage = 1.0
        scrollTopAnchor.constant = gradientHeight
        gradientTopAnchor.constant = 0
        previousStart = startButton.titleLabel?.text
        previousEnd = endButton.titleLabel?.text
        
//        delegate?.lightContentStatusBar()
        gradientContainer.alpha = 1
        mainDelegate?.changeReservation(percent: 1.0)
        UIView.animate(withDuration: animationOut, animations: {
            self.line.alpha = 0
            self.startTimeLabel.alpha = 0
            self.startTimeButton.alpha = 0
            self.endTimeLabel.alpha = 0
            self.endTimeButton.alpha = 0
            self.daysLabel.alpha = 0
            self.informationIcon.alpha = 0
            tabDimmingView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.selectDate(sender: self.startButton)
            self.calendarTopAnchor.constant = 32
            UIView.animate(withDuration: animationIn, animations: {
                self.calendarController.view.alpha = 1
                self.exitButton.alpha = 1
                self.mainLabel.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func closeFullReservation() {
        previousPercentage = 0.0
        scrollTopAnchor.constant = currentBookingHeight
        gradientTopAnchor.constant = -240
        calendarTopAnchor.constant = 92
        unselectDates()
        
//        delegate?.defaultContentStatusBar()
        mainDelegate?.changeReservation(percent: 0)
        UIView.animate(withDuration: animationOut, animations: {
            self.calendarController.view.alpha = 0
            self.gradientContainer.alpha = 0
            self.exitButton.alpha = 0
            self.mainLabel.alpha = 0
            tabDimmingView.alpha = 0.4
            self.view.layoutIfNeeded()
        }) { (success) in
            self.scrollView.isScrollEnabled = false
            if !self.minimize {
                UIView.animate(withDuration: animationIn, animations: {
                    self.line.alpha = 1
                    self.startTimeLabel.alpha = 1
                    self.startTimeButton.alpha = 1
                    self.endTimeLabel.alpha = 1
                    self.endTimeButton.alpha = 1
                })
            } else {
                UIView.animate(withDuration: animationIn) {
                    self.daysLabel.alpha = 1
                    self.informationIcon.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func changeAlphaAmount(percentage: CGFloat) {
        var percent = percentage
        if percent >= 0.0 && percent <= 0.5 {
            percent = percent * 2
            if !minimize {
                line.alpha = 1 - percent
                startTimeLabel.alpha = 1 - percent
                startTimeButton.alpha = 1 - percent
                endTimeLabel.alpha = 1 - percent
                endTimeButton.alpha = 1 - percent
            } else {
                daysLabel.alpha = 1 - percent
                informationIcon.alpha = 1 - percent
            }
            mainDelegate?.changeReservation(percent: percent)
        }
    }
    
    func minimizeController() {
        let height = normalScrollHeight - 60
        mainDelegate?.changeScrollHeight(height: height)
        currentBookingHeight = phoneHeight - height
    }
    
    func maximizeController() {
        mainDelegate?.changeScrollHeight(height: normalScrollHeight)
        currentBookingHeight = phoneHeight - normalScrollHeight
    }
    
    @objc func informationButtonPressed() {
        let controller = ReservationInformationView()
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true, completion: nil)
        UIView.animate(withDuration: animationIn) {
            tabDimmingView.alpha = 0.8
        }
    }
    
    @objc func dismissView() {
        dismissKeyboard()
        mainDelegate?.dismissView()
    }
    
}

extension TestReservationView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -40.0 {
            closeFullReservation()
            scrollView.isScrollEnabled = false
        }
    }
    
}

extension TestReservationView: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func observeFirstTime() {
        observeCurrentTime()
        fromPicker.selectRow(0, inComponent: 0, animated: true)
        pickerView(fromPicker, didSelectRow: 0, inComponent: 0)
    }
    
    @objc func observeCurrentTime() {
        if let startDay = firstDate {
            let time = Date()
            let hours = calendar.component(.hour, from: time)
            let minutes = calendar.component(.minute, from: time)
            var startTime = startDay.dateAt(hours: hours, minutes: minutes).round(precision: (15 * 60), rule: FloatingPointRoundingRule.up)
            
            fromTimes = []
            while startTime.isInSameDay(date: startDay) {
                let string = dateFormatter.string(from: startTime)
                fromTimes.append(string)
                startTime.addTimeInterval(TimeInterval(15 * 60))
            }
            fromPicker.reloadAllComponents()
        }
    }
    
    func observeToTimes() {
        if let title = startTimeButton.text, let index = fromTimes.firstIndex(of: title) {
            let range = 0...index
            var toArray = fromTimes
            toArray.removeSubrange(range)
            toTimes = toArray
            toPicker.reloadAllComponents()
            
            if toTimes.count > 9 {
                toPicker.selectRow(8, inComponent: 0, animated: true)
                pickerView(toPicker, didSelectRow: 8, inComponent: 0)
            } else {
                let index = toTimes.count - 1
                toPicker.selectRow(index, inComponent: 0, animated: true)
                pickerView(toPicker, didSelectRow: index, inComponent: 0)
            }
        }
    }
    
    func createDatePicker() {
        fromPicker.delegate = self
        fromPicker.dataSource = self
        toPicker.delegate = self
        toPicker.dataSource = self
        
        fromPicker.setValue(Theme.BLACK.lighter(), forKey: "backgroundColor")
        toPicker.setValue(Theme.BLACK.lighter(), forKey: "backgroundColor")
        
        startTimeButton.inputView = fromPicker
        endTimeButton.inputView = toPicker
        
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.GRAY_WHITE.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        startTimeButton.inputAccessoryView = toolBar
        endTimeButton.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == fromPicker {
            return fromTimes.count - 1
        } else {
            return toTimes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == fromPicker {
            if fromTimes.count > row {
                return fromTimes[row]
            }
        } else {
            if toTimes.count > row {
                return toTimes[row]
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = Theme.WHITE
        label.textAlignment = .center
        label.font = Fonts.SSPRegularH2
        if pickerView == fromPicker {
            if fromTimes.count > row {
                label.text = fromTimes[row]
            }
        } else {
            if toTimes.count > row {
                label.text = toTimes[row]
            }
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromPicker {
            if fromTimes.count > row {
                startTimeButton.text = fromTimes[row]
                observeToTimes()
            }
        } else {
            if toTimes.count > row {
                endTimeButton.text = toTimes[row]
            }
        }
    }
    
}

extension TestReservationView: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        canPanView = true
        textView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        canPanView = false
        textView.layer.borderColor = Theme.BLUE.cgColor
    }
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollTopAnchor.constant = currentBookingHeight
            endTimeBottomAnchor.constant = -8
        } else {
            let height: CGFloat = 88
            scrollTopAnchor.constant = currentBookingHeight - height
            endTimeBottomAnchor.constant = -height
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
