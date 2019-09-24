//
//  MapSearchViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class MapSearchViewController: UIViewController {
    
    var recentItems: [String: String] = [:]
    var matchingItems:[GMSAutocompletePrediction] = []
    var delegate: controlSaveLocation?
    var placesClient: GMSPlacesClient?
    
    var background: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(LocationRecentsCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0)
        view.separatorStyle = .none
        
        return view
    }()
    
    var currentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    var currentImageView: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "locationArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return button
    }()
    
    var currentLabel: UILabel = {
        let label = UILabel()
        label.text = "Current location"
        label.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.8)
        
        self.placesClient = GMSPlacesClient()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTextChange(_:)),
                                               name: NSNotification.Name(rawValue: handleTextChangeNotification),
                                               object: nil)
        
        setupViews()
        setupCurrent()
    }
    
    var tableTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(background)
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(tableView)
        tableTopAnchor = tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
            tableTopAnchor.isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupCurrent() {
        
        self.view.addSubview(currentView)
        currentView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        currentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(currentLocationPressed))
        currentView.addGestureRecognizer(tap)
        
        currentView.addSubview(currentImageView)
        currentImageView.centerYAnchor.constraint(equalTo: currentView.centerYAnchor, constant: 18).isActive = true
        currentImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        currentImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        currentImageView.widthAnchor.constraint(equalTo: currentImageView.heightAnchor).isActive = true
        
        currentView.addSubview(currentLabel)
        currentLabel.centerYAnchor.constraint(equalTo: currentImageView.centerYAnchor).isActive = true
        currentLabel.leftAnchor.constraint(equalTo: currentImageView.rightAnchor, constant: 12).isActive = true
        currentLabel.rightAnchor.constraint(equalTo: currentView.rightAnchor, constant: -24).isActive = true
        currentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func currentLocationPressed() {
        mainSearchTextField = false
//        delegate?.zoomToSearchLocation(address: "Current location")
    }
    
    func bringCurrentLocation() {
        tableTopAnchor.constant = 50
        UIView.animate(withDuration: animationOut) {
            self.currentView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideCurrentLocation() {
        tableTopAnchor.constant = 0
        UIView.animate(withDuration: animationOut) {
            self.currentView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleTextChange(_ myNot: Notification) {
        recentItems = [:]
        if let use = myNot.userInfo {
            if let searchBarText = use["text"] as? String {
                if searchBarText == "" {
                    matchingItems = []
                    return
                }
                let filter = GMSAutocompleteFilter()
                filter.type = .noFilter
                placesClient?.autocompleteQuery(searchBarText, bounds: nil, filter: filter, callback: { (results, error) in
                    if error != nil {
                        self.matchingItems = []
                        print(error?.localizedDescription as Any)
                        return
                    }
                    if let results = results {
                        self.matchingItems = results
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func saveNewTerms(address: String) {
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let first = firstRecent as! String
            if first != address {
                if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
                    let second = secondRecent as! String
                    if second == address {
                        userDefaults.setValue(address, forKey: "firstSavedRecentTerm")
                        userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                    } else {
                        userDefaults.setValue(address, forKey: "firstSavedRecentTerm")
                        userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                    }
                } else {
                    userDefaults.setValue(address, forKey: "firstSavedRecentTerm")
                    userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                }
            }
        } else {
            userDefaults.setValue(address, forKey: "firstSavedRecentTerm")
        }
        userDefaults.synchronize()
    }
    
    func checkRecentSearches() {
        self.recentItems = [:]
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let first = firstRecent as! String
            self.recentItems.updateValue(first, forKey: "Recent")
        } else {
            self.recentItems.updateValue("nil", forKey: "Home")
        }
        if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
            let second = secondRecent as! String
            self.recentItems.updateValue(second, forKey: "Recent1")
        } else {
            self.recentItems.updateValue("nil", forKey: "Work")
        }
        self.tableView.reloadData()
    }
    
}


extension MapSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < recentItems.count {
            return 70
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count + recentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2 && recentItems.count > 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationRecentsCell
            cell.pinImageView.backgroundColor = lineColor
            cell.pinImageView.tintColor = Theme.DARK_GRAY
            if let selectedItem = recentItems["Recent"], indexPath.row == 0 {
                cell.titleTextView.text = "Recent"
                cell.nameTextView.text = selectedItem
                let image = UIImage(named: "parking_history")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.pinImageView.setImage(tintedImage, for: .normal)
                cell.titleTextView.text = "Recent"
//                cell.pinImageView.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                cell.distanceLabel.alpha = 0
            } else if let selectedItem = recentItems["Recent1"] {
                cell.titleTextView.text = "Recent"
                cell.nameTextView.text = selectedItem
                let image = UIImage(named: "parking_history")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.pinImageView.setImage(tintedImage, for: .normal)
                cell.titleTextView.text = "Recent"
//                cell.pinImageView.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                cell.distanceLabel.alpha = 0
            } else if var selectedItem = recentItems["Home"] {
                cell.titleTextView.text = "Home"
                if selectedItem == "nil" { selectedItem = "Set home" }
                cell.nameTextView.text = selectedItem
                let image = UIImage(named: "parking")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.pinImageView.tintColor = Theme.WHITE
                cell.pinImageView.setImage(tintedImage, for: .normal)
                cell.titleTextView.text = "Home"
                cell.pinImageView.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                cell.pinImageView.backgroundColor = Theme.STRAWBERRY_PINK
                cell.distanceLabel.alpha = 0
            } else if var selectedItem = recentItems["Work"] {
                cell.titleTextView.text = "Work"
                if selectedItem == "nil" { selectedItem = "Set home" }
                cell.nameTextView.text = selectedItem
                let image = UIImage(named: "parking")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.pinImageView.tintColor = Theme.WHITE
                cell.pinImageView.setImage(tintedImage, for: .normal)
                cell.titleTextView.text = "Home"
                cell.pinImageView.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                cell.pinImageView.backgroundColor = Theme.STRAWBERRY_PINK
                cell.distanceLabel.alpha = 0
            }
            cell.alpha = 1
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationRecentsCell
            if indexPath.row < matchingItems.count {
                let selectedItem = matchingItems[indexPath.row - recentItems.count]
                cell.titleTextView.text = selectedItem.attributedPrimaryText.string
                cell.nameTextView.text = selectedItem.attributedSecondaryText?.string
                cell.specificAddress = selectedItem.attributedFullText.string
                let image = UIImage(named: "parkingSpaceIcon")
                let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.pinImageView.setImage(tintedImage, for: .normal)
                cell.pinImageView.tintColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
                cell.pinImageView.backgroundColor = UIColor.clear
                cell.pinImageView.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
                
                if let currentLocation = userMostRecentLocation {
                    
                    let placeID = selectedItem.placeID
                    let placesClient = GMSPlacesClient.shared()
                    placesClient.lookUpPlaceID(placeID) { (place, error) in
                        if let error = error {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        guard let place = place else {
                            print("No place details for \(placeID)")
                            return
                        }
                        
                        let searchedLatitude = place.coordinate.latitude
                        let searchedLongitude = place.coordinate.longitude
                        let searchedCoordinate = CLLocationCoordinate2D(latitude: searchedLatitude, longitude: searchedLongitude)
                        let distance = currentLocation.distance(to: searchedCoordinate)
                        let miles = distance/1609.34 //miles
                        if miles <= 50 {
                            let distanceString = String(format: "%.1f mi", miles)
                            cell.distanceLabel.text = distanceString
                            cell.distanceLabel.alpha = 1
                        } else {
                            cell.distanceLabel.alpha = 0
                        }
                    }
                }
            }
            cell.alpha = 1
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? LocationRecentsCell {
            if cell.distanceLabel.alpha == 1 {
                guard let address = cell.specificAddress else { return }
                self.delegate?.zoomToSearchLocation(address: address)
                self.saveNewTerms(address: address)
                self.matchingItems = []
                self.recentItems = [:]
            } else {
                guard let address = cell.nameTextView.text else { return }
                if cell.titleTextView.text == "Home" {
                    cell.backgroundColor = Theme.BLUE.withAlphaComponent(0.4)
                } else {
                    cell.backgroundColor = UIColor.clear
                    self.delegate?.zoomToSearchLocation(address: address)
                    self.saveNewTerms(address: address)
                    self.matchingItems = []
                    self.recentItems = [:]
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -80 {
            self.delegate?.closeSearch()
        }
    }
    
}



class LocationRecentsCell: UITableViewCell {
    
    var fullAddress: String?
    var specificAddress: String?
    
    var pinImageView: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "parking_history")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.layer.cornerRadius = 35/2
//        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var titleTextView: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        
        return label
    }()
    
    var nameTextView: UILabel = {
        let label = UILabel()
        label.text = "Set home"
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "2.6 miles"
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        alpha = 0

        addSubview(pinImageView)
        addSubview(titleTextView)
        addSubview(nameTextView)
        addSubview(distanceLabel)
        
        pinImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        pinImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        pinImageView.widthAnchor.constraint(equalTo: pinImageView.heightAnchor).isActive = true
        
        titleTextView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 4).isActive = true
        titleTextView.leftAnchor.constraint(equalTo: pinImageView.rightAnchor, constant: 12).isActive = true
        titleTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleTextView.rightAnchor.constraint(equalTo: distanceLabel.leftAnchor, constant: -4).isActive = true
        
        nameTextView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -2).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: pinImageView.rightAnchor, constant: 12).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -72).isActive = true
        
        distanceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: titleTextView.centerYAnchor).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        distanceLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
