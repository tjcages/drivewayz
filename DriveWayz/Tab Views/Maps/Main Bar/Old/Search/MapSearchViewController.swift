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
    
    var recentId: [String] = []
    var recentItems: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var matchingItems:[GMSAutocompletePrediction] = []
//    var delegate: controlSaveLocation?
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
        
        view.backgroundColor = Theme.WHITE
        
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
        recentItems = []
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
    
    func saveNewTerms(placeId: String) {
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let first = firstRecent as! String
            if first != placeId {
                if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
                    let second = secondRecent as! String
                    if second == placeId {
                        userDefaults.setValue(placeId, forKey: "firstSavedRecentTerm")
                        userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                    } else {
                        userDefaults.setValue(placeId, forKey: "firstSavedRecentTerm")
                        userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                    }
                } else {
                    userDefaults.setValue(placeId, forKey: "firstSavedRecentTerm")
                    userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                }
            }
        } else {
            userDefaults.setValue(placeId, forKey: "firstSavedRecentTerm")
        }
        userDefaults.synchronize()
    }
    
    func checkRecentSearches() {
        recentItems = []
        recentId = []
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let saved = firstRecent as! String
            
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(saved) { (place, error) in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                guard let place = place else {
                    print("No place details for \(saved)")
                    return
                }
                if let address = place.name {
                    self.recentId.append(saved)
                    self.recentItems.append(address)
                } else if let address = place.formattedAddress {
                    self.recentId.append(saved)
                    self.recentItems.append(address)
                }
            }
        }
        if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
            let saved = secondRecent as! String
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(saved) { (place, error) in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                guard let place = place else {
                    print("No place details for \(saved)")
                    return
                }
                if let address = place.name {
                    self.recentItems.append(address)
                    self.recentId.append(saved)
                } else if let address = place.formattedAddress {
                    self.recentItems.append(address)
                    self.recentId.append(saved)
                }
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationRecentsCell
        cell.selectionStyle = .none
        if indexPath.row < 2 && recentItems.count > indexPath.row && recentId.count > indexPath.row {
            cell.setRecent()
            if let selectedItem = recentItems.first, let placeID = recentId.first, indexPath.row == 0 {
                cell.nameTextView.text = selectedItem
                cell.placeID = placeID
            } else if let selectedItem = recentItems.last, let placeID = recentId.last {
                cell.nameTextView.text = selectedItem
                cell.placeID = placeID
            }
            
            return cell
        } else {
            cell.setNormal()
            if matchingItems.count > indexPath.row {
                let selectedItem = matchingItems[indexPath.row - recentItems.count]
                cell.titleTextView.text = selectedItem.attributedPrimaryText.string
                cell.nameTextView.text = selectedItem.attributedSecondaryText?.string
                cell.specificAddress = selectedItem.attributedFullText.string
                cell.placeID = selectedItem.placeID
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LocationRecentsCell
        if let placeId = cell.placeID {
//            delegate?.zoomToSearchLocation(placeId: placeId)
            saveNewTerms(placeId: placeId)
            
            matchingItems = []
            recentItems = []
        }
//
//
//        guard let address = cell.specificAddress else { return }
//        if let placeID = cell.placeID {
////            self.
//        } else {
//            self.delegate?.zoomToSearchLocation(address: address, coordinate: nil)
//            self.saveNewTerms(placeId: placeID)
//            self.matchingItems = []
//            self.recentItems = []
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -80 {
//            self.delegate?.closeSearch()
        }
    }
    
}



class LocationRecentsCell: UITableViewCell {
    
    var specificAddress: String?
    var placeID: String?
    var coordinate: CLLocationCoordinate2D?
    
    var pinImageView: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "parking_history")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 35/2
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return button
    }()
    
    var titleTextView: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        
        return label
    }()
    
    var nameTextView: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        alpha = 0

        addSubview(pinImageView)
        addSubview(titleTextView)
        addSubview(nameTextView)
        
        pinImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        pinImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        pinImageView.widthAnchor.constraint(equalTo: pinImageView.heightAnchor).isActive = true
        
        titleTextView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 4).isActive = true
        titleTextView.leftAnchor.constraint(equalTo: pinImageView.rightAnchor, constant: 12).isActive = true
        titleTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        nameTextView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -2).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: pinImageView.rightAnchor, constant: 12).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -72).isActive = true
        
    }
    
    func setRecent() {
        titleTextView.text = "Recent"
        let image = UIImage(named: "parking_history")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        pinImageView.setImage(image, for: .normal)
        pinImageView.backgroundColor = Theme.LINE_GRAY
    }
    
    func setNormal() {
        let image = UIImage(named: "parkingSpaceIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        pinImageView.setImage(image, for: .normal)
        pinImageView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
