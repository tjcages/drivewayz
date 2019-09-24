//
//  TestSearchViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class TestSearchViewController: UIViewController {
    
    var delegate: handleInviteControllers?
    var recents: [String] = ["", ""]
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Good morning, Tyler"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Where are you headed?"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var recommendationButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(Theme.BLUE.withAlphaComponent(0.8), for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var searchView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.clipsToBounds = true
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Parking near "
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        button.layer.cornerRadius = 18
        let origImage = UIImage(named: "Search")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var recentsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(RecentsCell.self, forCellReuseIdentifier: "cellId")
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.isScrollEnabled = false
        view.alpha = 0
        view.separatorStyle = .none
        
        return view
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    var durationView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = Theme.GREEN_PIGMENT
//        view.layer.cornerRadius = 4
//        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//
//        return view
//    }()
//
//    var calendarButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(named: "calendarTimeIcon")
//        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        button.setImage(tintedImage, for: .normal)
//        button.tintColor = Theme.WHITE
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
//        button.isUserInteractionEnabled = false
//
//        return button
//    }()
//
//    var calendarLabel: UIButton = {
//        let label = UIButton()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.setTitle("Schedule your stay", for: .normal)
//        label.setTitleColor(Theme.WHITE, for: .normal)
//        label.titleLabel?.font = Fonts.SSPRegularH5
//        label.contentHorizontalAlignment = .left
//        label.isUserInteractionEnabled = false
//
//        return label
//    }()
//
//    var timeButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(named: "setTimeIcon")
//        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        button.setImage(tintedImage, for: .normal)
//        button.tintColor = Theme.WHITE
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
//
//        return button
//    }()
//
//    var timeLabel: UIButton = {
//        let label = UIButton()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.setTitle("2 hours 15 minutes", for: .normal)
//        label.setTitleColor(Theme.WHITE, for: .normal)
//        label.titleLabel?.font = Fonts.SSPRegularH5
//        label.contentHorizontalAlignment = .left
//
//        return label
//    }()
    
    func setData() {
        let time = Date()
        let greeting = check(time: time)
        
        let name = UserDefaults.standard.string(forKey: "userName") ?? ""
        let nameArray = name.split(separator: " ")
        if nameArray.count > 0 {
            let userName = String(nameArray[0])
            if name != "" {
                greetingLabel.text = "Good \(greeting), \(userName)"
            } else {
                greetingLabel.text = "Good \(greeting)"
            }
        } else {
            greetingLabel.text = "Good \(greeting)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        recentsTableView.delegate = self
        recentsTableView.dataSource = self
        
        loadingLine.startAnimating()
        
        setData()
        setupViews()
//        setupCalendar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkRecentSearches()
    }
    
    func setupViews() {
        
        view.addSubview(greetingLabel)
        view.addSubview(mainLabel)
        view.addSubview(searchView)

        greetingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        greetingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        greetingLabel.sizeToFit()
        
        mainLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 0).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        searchView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        
        searchView.addSubview(searchLabel)
        view.addSubview(recommendationButton)
        
        searchLabel.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        recommendationButton.leftAnchor.constraint(equalTo: searchLabel.rightAnchor, constant: 0).isActive = true
        recommendationButton.centerYAnchor.constraint(equalTo: searchLabel.centerYAnchor).isActive = true
        recommendationButton.sizeToFit()
        
        searchView.addSubview(searchButton)
        searchButton.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: -12).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 10).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        
        searchView.addSubview(loadingLine)
        loadingLine.anchor(top: nil, left: searchView.leftAnchor, bottom: searchView.bottomAnchor, right: searchView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 3)
        
        view.addSubview(recentsTableView)
        recentsTableView.anchor(top: searchView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 144)
        
    }
    
//    func setupCalendar() {
//
//        view.addSubview(durationView)
//        view.addSubview(calendarLabel)
//        view.addSubview(calendarButton)
//        calendarLabel.leftAnchor.constraint(equalTo: calendarButton.rightAnchor, constant: 8).isActive = true
//        calendarLabel.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
//        calendarLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        calendarLabel.sizeToFit()
//
//        calendarButton.leftAnchor.constraint(equalTo: durationView.leftAnchor, constant: 8).isActive = true
//        calendarButton.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 4).isActive = true
//        calendarButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        calendarButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
//
//        view.addSubview(timeLabel)
//        view.addSubview(timeButton)
//        timeLabel.leftAnchor.constraint(equalTo: timeButton.rightAnchor, constant: 4).isActive = true
//        timeLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
//        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        timeLabel.sizeToFit()
//
//        timeButton.leftAnchor.constraint(equalTo: calendarLabel.rightAnchor, constant: 16).isActive = true
//        timeButton.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
//        timeButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        timeButton.widthAnchor.constraint(equalTo: timeButton.heightAnchor).isActive = true
//
//        durationView.leftAnchor.constraint(equalTo: searchView.leftAnchor).isActive = true
//        durationView.rightAnchor.constraint(equalTo: searchView.rightAnchor).isActive = true
//        durationView.topAnchor.constraint(equalTo: calendarButton.topAnchor, constant: -4).isActive = true
//        durationView.bottomAnchor.constraint(equalTo: calendarButton.bottomAnchor, constant: 4).isActive = true
//        
//    }
    
    func checkRecentSearches() {
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let first = firstRecent as! String
            recents[0] = first
            delegate?.changeRecentsHeight(height: 72)
        }
        if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
            let second = secondRecent as! String
            recents[1] = second
            delegate?.changeRecentsHeight(height: 144)
            recentsTableView.separatorStyle = .singleLine
        }
        recentsTableView.reloadData()
    }
    
    func determineCity(location: CLLocation) {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                self.loadingLine.endAnimating()
                if let city = placemark.subLocality {
                    self.recommendationButton.setTitle(city, for: .normal)
                } else if let city = placemark.locality {
                    self.recommendationButton.setTitle(city, for: .normal)
                }
            }
        })
    }
    
    func check(time: Date) -> String {
        let hour = Calendar.current.component(.hour, from: time)
        
        switch hour {
        case 6..<12: return "morning"
        case 12..<17: return "afternoon"
        default: return "evening"
        }
    }

}

extension TestSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! RecentsCell
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        }
        cell.selectionStyle = .none
        
        if indexPath.row < recents.count {
            var recent = recents[indexPath.row]
            var subRecent = recent
            if let dotRange = recent.range(of: ",") {
                recent.removeSubrange(dotRange.lowerBound..<recent.endIndex)
                subRecent.removeSubrange(subRecent.startIndex..<dotRange.upperBound)
                cell.mainLabel.text = recent
                cell.subLabel.text = String(subRecent.dropFirst())
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < recents.count {
            let recent = recents[indexPath.row]
            self.delegate?.searchRecentsPressed(address: recent)
        }
    }
    
}
