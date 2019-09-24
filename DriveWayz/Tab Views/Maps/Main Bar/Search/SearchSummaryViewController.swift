//
//  SearchSummaryViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

var mainSearchTextField: Bool = true

class SearchSummaryViewController: UIViewController {
    
    var delegate: mainBarSearchDelegate?
    var selectedFromDate: Date = Date()
    var selectedTimes: String = "2 hrs 15 min"
    var rotations: Int = 1
    
    var searchBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var searchButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderColor = Theme.DARK_GRAY.cgColor
        view.layer.borderWidth = 1.2
        
        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.layer.cornerRadius = 3
        dot.layer.borderColor = Theme.DARK_GRAY.cgColor
        dot.layer.borderWidth = 1.2
        
        view.addSubview(dot)
        dot.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dot.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dot.heightAnchor.constraint(equalTo: dot.widthAnchor).isActive = true
        dot.widthAnchor.constraint(equalToConstant: 6).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Theme.DARK_GRAY
        
        view.addSubview(line)
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        line.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -0.6).isActive = true
        line.heightAnchor.constraint(equalToConstant: 6).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1.2).isActive = true
        
        return view
    }()
    
    var searchTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    var searchTextLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var fromSearchBar: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Current location"
        view.textColor = Theme.BLACK
        view.font = Fonts.SSPRegularH3
        view.clearButtonMode = .never
        
        return view
    }()
    
    var fromSearchIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "map-pin")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var fromSearchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var toSearchView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.OFF_WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        
        return view
    }()

    var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 4
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        button.alpha = 0
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        return button
    }()
    
    var calendarButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "calendarIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var calendarLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Today", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var timeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "setTimeIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var timeLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("2 hours 15 minutes", for: .normal)
        label.setTitleColor(Theme.DARK_GRAY, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var dottedLine: UIImageView = {
        let view = UIImageView()
        if let image = UIImage(named: "circleLine")?.withRenderingMode(.alwaysTemplate) {
            view.image = image
        }
        view.tintColor = lineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return view
    }()
    
    func setData() {
        let fromDate = Date()
        self.changeDates(fromDate: fromDate, totalTime: selectedTimes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        fromSearchBar.delegate = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2

        setupViews()
        setupSearch()
        setupCalendar()
        setData()
    }
    
    func setupViews() {
        
        self.view.addSubview(searchBackButton)
        searchBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        searchBackButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        searchBackButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            searchBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            searchBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        }
        
        view.addSubview(toSearchView)
        view.addSubview(searchButton)
        view.addSubview(searchTextField)
        view.addSubview(searchTextLine)
        
        view.addSubview(fromSearchView)
        view.addSubview(fromSearchBar)
        
        toSearchView.topAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -2).isActive = true
        toSearchView.leftAnchor.constraint(equalTo: fromSearchView.leftAnchor).isActive = true
        toSearchView.rightAnchor.constraint(equalTo: fromSearchView.rightAnchor).isActive = true
        toSearchView.heightAnchor.constraint(equalTo: fromSearchView.heightAnchor).isActive = true
        
        searchButton.leftAnchor.constraint(equalTo: searchBackButton.leftAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: fromSearchBar.bottomAnchor, constant: 20).isActive = true
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        searchTextField.leftAnchor.constraint(equalTo: searchButton.rightAnchor, constant: 24).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchTextLine.leftAnchor.constraint(equalTo: toSearchView.leftAnchor).isActive = true
        searchTextLine.rightAnchor.constraint(equalTo: toSearchView.rightAnchor).isActive = true
        searchTextLine.bottomAnchor.constraint(equalTo: toSearchView.bottomAnchor).isActive = true
        searchTextLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    func setupSearch() {
        
        fromSearchBar.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        fromSearchBar.leftAnchor.constraint(equalTo: searchTextField.leftAnchor).isActive = true
        fromSearchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        fromSearchBar.topAnchor.constraint(equalTo: searchBackButton.bottomAnchor, constant: 12).isActive = true
        fromSearchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fromSearchBar.addSubview(fromSearchIcon)
        fromSearchIcon.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor).isActive = true
        fromSearchIcon.centerYAnchor.constraint(equalTo: fromSearchBar.centerYAnchor).isActive = true
        fromSearchIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        fromSearchIcon.widthAnchor.constraint(equalTo: fromSearchIcon.heightAnchor).isActive = true
        
        fromSearchBar.bringSubviewToFront(fromSearchIcon)
        fromSearchView.topAnchor.constraint(equalTo: fromSearchBar.topAnchor, constant: 2).isActive = true
        fromSearchView.leftAnchor.constraint(equalTo: fromSearchBar.leftAnchor, constant: -16).isActive = true
        fromSearchView.rightAnchor.constraint(equalTo: fromSearchBar.rightAnchor, constant: 4).isActive = true
        fromSearchView.bottomAnchor.constraint(equalTo: fromSearchBar.bottomAnchor, constant: -2).isActive = true
        
        view.addSubview(deleteButton)
        deleteButton.rightAnchor.constraint(equalTo: searchTextField.rightAnchor, constant: -12).isActive = true
        deleteButton.topAnchor.constraint(equalTo: searchTextField.topAnchor, constant: 6).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: -6).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor).isActive = true

        view.addSubview(dottedLine)
        view.sendSubviewToBack(dottedLine)
        dottedLine.centerXAnchor.constraint(equalTo: fromSearchIcon.centerXAnchor, constant: 1).isActive = true
        dottedLine.topAnchor.constraint(equalTo: fromSearchIcon.bottomAnchor, constant: -4).isActive = true
        dottedLine.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: 4).isActive = true
        dottedLine.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
    }
    
    func setupCalendar() {
        
        self.view.addSubview(calendarLabel)
        self.view.addSubview(calendarButton)
        calendarLabel.leftAnchor.constraint(equalTo: calendarButton.rightAnchor, constant: 8).isActive = true
        calendarLabel.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
        calendarLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        calendarLabel.sizeToFit()
        
        calendarButton.leftAnchor.constraint(equalTo: fromSearchView.leftAnchor, constant: -2).isActive = true
        calendarButton.topAnchor.constraint(equalTo: toSearchView.bottomAnchor, constant: 12).isActive = true
        calendarButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        calendarButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(timeButton)
        timeLabel.leftAnchor.constraint(equalTo: timeButton.rightAnchor, constant: 4).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        timeLabel.sizeToFit()
        
        timeButton.leftAnchor.constraint(equalTo: calendarLabel.rightAnchor, constant: 16).isActive = true
        timeButton.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
        timeButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        timeButton.widthAnchor.constraint(equalTo: timeButton.heightAnchor).isActive = true
        
    }
    
    func changeDates(fromDate: Date, totalTime: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E d"
        let fromTime = formatter.string(from: fromDate)
        if let dateWeek = Date().dayOfWeek() {
            self.selectedFromDate = fromDate
            self.selectedTimes = totalTime
            if let dayOfTheWeekFrom = fromDate.dayOfWeek() {
                self.timeLabel.setTitle(totalTime, for: .normal)
                if dateWeek == dayOfTheWeekFrom {
                    self.calendarLabel.setTitle("Today, \(fromTime)", for: .normal)
                } else {
                    let fromDay = dayFormatter.string(from: fromDate)
                    self.calendarLabel.setTitle("\(fromDay), \(fromTime)", for: .normal)
                }
            }
        }
    }
    
    @objc func deletePressed() {
        self.searchTextField.text = ""
        UIView.animate(withDuration: animationIn) {
            self.deleteButton.alpha = 0
        }
    }
    
    @objc func backButtonPressed() {
        delegate?.closeSearch()
    }
    
    
}


extension SearchSummaryViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fromSearchBar {
            mainSearchTextField = false
            if fromSearchBar.text == "Current location" {
                fromSearchBar.text = ""
            }
            fromSearchBar.font = Fonts.SSPRegularH3
            fromSearchBar.textColor = Theme.BLACK
            delegate?.showCurrentLocation()
            
            return true
        } else {
            searchTextLine.backgroundColor = Theme.BLUE
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == fromSearchBar {
            mainSearchTextField = true
            if fromSearchBar.text == "Current location" || fromSearchBar.text == "" {
                fromSearchBar.text = "Current location"
            }
            delegate?.hideCurrentLocation()
            
            return true
        } else {
            searchTextLine.backgroundColor = lineColor
        }
        return true
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text":textField.text!])
        if let text = textField.text {
            UIView.animate(withDuration: animationIn) {
                if text == "" {
                    self.deleteButton.alpha = 0
                } else {
                    self.deleteButton.alpha = 1
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
        self.searchTextField.becomeFirstResponder()
    }
    
}
