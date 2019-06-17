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
    
    var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var searchTextField: UITextField = {
        let label = UITextField()
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.backgroundColor = UIColor.clear
        
        return label
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
    
    var fromSearchIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.STRAWBERRY_PINK.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 5
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var fromSearchView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var toSearchView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var switchSearchButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "switchIcon")
        let tintedImage = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.4)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.borderColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.1).cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 45/2
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.addTarget(self, action: #selector(switchButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var calendarButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "calendarIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.8)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var calendarLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Today", for: .normal)
        label.setTitleColor(Theme.PRUSSIAN_BLUE.withAlphaComponent(0.8), for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var timeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "time")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var timeLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("2 hours 15 minutes", for: .normal)
        label.setTitleColor(Theme.PRUSSIAN_BLUE.withAlphaComponent(0.8), for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH5
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var dottedLine: UIImageView = {
        let image = UIImage(named: "dottedLine")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    func setData() {
        let fromDate = Date()
        self.changeDates(fromDate: fromDate, totalTime: selectedTimes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromSearchBar.delegate = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4

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
        
        self.view.addSubview(toSearchView)
        self.view.addSubview(searchButton)
        self.view.addSubview(searchTextField)
        self.view.addSubview(fromSearchView)
        self.view.addSubview(fromSearchBar)
        
        toSearchView.topAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -2).isActive = true
        toSearchView.leftAnchor.constraint(equalTo: fromSearchView.leftAnchor).isActive = true
        toSearchView.rightAnchor.constraint(equalTo: fromSearchView.rightAnchor).isActive = true
        toSearchView.heightAnchor.constraint(equalTo: fromSearchView.heightAnchor).isActive = true
        
        searchButton.leftAnchor.constraint(equalTo: searchBackButton.leftAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: fromSearchBar.bottomAnchor, constant: 16).isActive = true
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        searchTextField.leftAnchor.constraint(equalTo: searchButton.rightAnchor, constant: 24).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
        fromSearchIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        fromSearchIcon.widthAnchor.constraint(equalTo: fromSearchIcon.heightAnchor).isActive = true
        
        fromSearchBar.bringSubviewToFront(fromSearchIcon)
        fromSearchView.topAnchor.constraint(equalTo: fromSearchBar.topAnchor, constant: 2).isActive = true
        fromSearchView.leftAnchor.constraint(equalTo: fromSearchBar.leftAnchor, constant: -16).isActive = true
        fromSearchView.rightAnchor.constraint(equalTo: fromSearchBar.rightAnchor, constant: 4).isActive = true
        fromSearchView.bottomAnchor.constraint(equalTo: fromSearchBar.bottomAnchor, constant: -2).isActive = true
        
        self.view.addSubview(switchSearchButton)
        switchSearchButton.topAnchor.constraint(equalTo: fromSearchView.bottomAnchor, constant: -20).isActive = true
        switchSearchButton.rightAnchor.constraint(equalTo: fromSearchView.rightAnchor, constant: -12).isActive = true
        switchSearchButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        switchSearchButton.widthAnchor.constraint(equalTo: switchSearchButton.heightAnchor).isActive = true

        self.view.addSubview(dottedLine)
        self.view.sendSubviewToBack(dottedLine)
        dottedLine.centerXAnchor.constraint(equalTo: fromSearchIcon.centerXAnchor).isActive = true
        dottedLine.topAnchor.constraint(equalTo: fromSearchIcon.bottomAnchor, constant: 4).isActive = true
        dottedLine.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -4).isActive = true
        dottedLine.widthAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
    func setupCalendar() {
        
        self.view.addSubview(calendarLabel)
        self.view.addSubview(calendarButton)
        calendarLabel.leftAnchor.constraint(equalTo: calendarButton.rightAnchor, constant: 8).isActive = true
        calendarLabel.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
        calendarLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        calendarLabel.sizeToFit()
        
        calendarButton.leftAnchor.constraint(equalTo: fromSearchView.leftAnchor).isActive = true
        calendarButton.topAnchor.constraint(equalTo: toSearchView.bottomAnchor, constant: 20).isActive = true
        calendarButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        calendarButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(timeButton)
        timeLabel.leftAnchor.constraint(equalTo: timeButton.rightAnchor, constant: 4).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        timeLabel.sizeToFit()
        
        timeButton.leftAnchor.constraint(equalTo: calendarLabel.rightAnchor, constant: 16).isActive = true
        timeButton.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
        timeButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
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
    
    @objc func switchButtonPressed() {
        if let fromText = self.fromSearchBar.text, let toText = self.searchTextField.text {
            UIView.animate(withDuration: animationOut, animations: {
                self.switchSearchButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * CGFloat(self.rotations))
                self.view.layoutIfNeeded()
            }) { (success) in
                self.fromSearchBar.text = toText
                self.searchTextField.text = fromText
                if self.rotations == 1 {
                    self.fromSearchBar.becomeFirstResponder()
                    self.rotations = 2
                } else {
                    self.searchTextField.becomeFirstResponder()
                    self.rotations = 1
                }
            }
        }
    }
    
    @objc func backButtonPressed() {
        self.delegate?.mainBarWillClose()
    }
    
    
}


extension SearchSummaryViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fromSearchBar {
            mainSearchTextField = false
            if fromSearchBar.text == "Current location" {
                self.fromSearchBar.text = ""
            }
            self.fromSearchBar.font = Fonts.SSPRegularH3
            self.fromSearchBar.textColor = Theme.BLACK
            self.delegate?.showCurrentLocation()
            
            return true
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == fromSearchBar {
            mainSearchTextField = true
            if fromSearchBar.text == "Current location" || fromSearchBar.text == "" {
                self.fromSearchBar.text = "Current location"
            }
            self.delegate?.hideCurrentLocation()
            
            return true
        }
        return true
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text":textField.text!])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
        self.searchTextField.becomeFirstResponder()
    }
    
}
