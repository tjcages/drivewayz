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

class MainSearchView: UIViewController {
    
    var delegate: handleInviteControllers?
    var recents: [String] = ["", ""]
    var cellHeight: CGFloat = 64
    
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
        button.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.clipsToBounds = true
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Parking near "
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "Search")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var recentsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Theme.OFF_WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(RecentsCell.self, forCellReuseIdentifier: "cellId")
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.isScrollEnabled = false
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.alpha = 0
        
        return view
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        
        return view
    }()
    
    var discountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DarkGreen.withAlphaComponent(0.9)
        button.setTitle("10% off", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        button.isUserInteractionEnabled = false
        button.titleEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        button.alpha = 0
        
        return button
    }()
    
    var leaveNowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Leave now", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    var arriveAtButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Arrive at", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    var stayUntilButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stay until", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.layer.cornerRadius = 16
        
        return button
    }()
    
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
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        recentsTableView.delegate = self
        recentsTableView.dataSource = self
        
        loadingLine.startAnimating()
        
        setData()
        
        setupViews()
        setupDuration()
        setupSearch()
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
        
        view.addSubview(discountButton)
        discountButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        discountButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        discountButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        discountButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    func setupDuration() {
        
        view.addSubview(leaveNowButton)
        view.addSubview(arriveAtButton)
        view.addSubview(stayUntilButton)
        
        leaveNowButton.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: (leaveNowButton.titleLabel?.text?.width(withConstrainedHeight: 32, font: Fonts.SSPRegularH4))! + 24, height: 32)
        
        arriveAtButton.anchor(top: leaveNowButton.topAnchor, left: leaveNowButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: (arriveAtButton.titleLabel?.text?.width(withConstrainedHeight: 32, font: Fonts.SSPRegularH4))! + 24, height: 32)
        
        stayUntilButton.anchor(top: leaveNowButton.topAnchor, left: arriveAtButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: (stayUntilButton.titleLabel?.text?.width(withConstrainedHeight: 32, font: Fonts.SSPRegularH4))! + 24, height: 32)
        
    }
    
    var recentsHeightAnchor: NSLayoutConstraint!
    
    func setupSearch() {
        
        searchView.anchor(top: leaveNowButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        
        searchView.addSubview(searchLabel)
        view.addSubview(recommendationButton)
        
        searchLabel.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        recommendationButton.leftAnchor.constraint(equalTo: searchLabel.rightAnchor, constant: 4).isActive = true
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
        recentsTableView.anchor(top: searchView.bottomAnchor, left: searchView.leftAnchor, bottom: nil, right: searchView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        recentsHeightAnchor = recentsTableView.heightAnchor.constraint(equalToConstant: 0)
            recentsHeightAnchor.isActive = true
        
    }
    
    func checkRecentSearches() {
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let first = firstRecent as! String
            recents[0] = first
            delegate?.changeRecentsHeight(number: 1)
            recentsHeightAnchor.constant = cellHeight - 1
        }
        if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
            let second = secondRecent as! String
            recents[1] = second
            delegate?.changeRecentsHeight(number: 2)
            recentsTableView.separatorStyle = .singleLine
            recentsHeightAnchor.constant = cellHeight * 2
        }
        view.layoutIfNeeded()
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
                mapTutorialController.loadingLine.endAnimating()
                if let city = placemark.subLocality {
                    self.recommendationButton.setTitle(city, for: .normal)
                    mapTutorialController.recommendationButton.setTitle(city, for: .normal)
                } else if let city = placemark.locality {
                    self.recommendationButton.setTitle(city, for: .normal)
                    mapTutorialController.recommendationButton.setTitle(city, for: .normal)
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

extension MainSearchView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
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
