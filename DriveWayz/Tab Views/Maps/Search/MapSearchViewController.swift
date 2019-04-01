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
        view.register(LocationResultsCell.self, forCellReuseIdentifier: "cellId")
        view.register(LocationRecentsCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.5)
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placesClient = GMSPlacesClient()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTextChange(_:)),
                                               name: NSNotification.Name(rawValue: handleTextChangeNotification),
                                               object: nil)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(background)
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    @objc func handleTextChange(_ myNot: Notification) {
        self.recentItems = [:]
        if let use = myNot.userInfo {
            if let searchBarText = use["text"] as? String {
                if searchBarText == "" {
                    self.matchingItems = []
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
            if let selectedItem = recentItems["Recent"], indexPath.row == 0 {
                cell.titleTextView.text = "Recent"
                cell.nameTextView.text = selectedItem
                let image = UIImage(named: "time")
                cell.pinImageView.image = image
                cell.pinImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell.titleTextView.text = "Recent"
            } else if let selectedItem = recentItems["Recent1"] {
                cell.titleTextView.text = "Recent"
                cell.nameTextView.text = selectedItem
                let image = UIImage(named: "time")
                cell.pinImageView.image = image
                cell.pinImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell.titleTextView.text = "Recent"
            } else if var selectedItem = recentItems["Home"] {
                cell.titleTextView.text = "Home"
                if selectedItem == "nil" { selectedItem = "Set home" }
                cell.nameTextView.text = selectedItem
                let image = UIImage(named: "parking")
                cell.pinImageView.image = image
                cell.pinImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                cell.titleTextView.text = "Home"
            } else if var selectedItem = recentItems["Work"] {
                cell.titleTextView.text = "Work"
                if selectedItem == "nil" { selectedItem = "Set home" }
                cell.nameTextView.text = selectedItem
                let image = UIImage(named: "parking")
                cell.pinImageView.image = image
                cell.pinImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                cell.titleTextView.text = "Home"
            }
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! LocationResultsCell
            if indexPath.row < matchingItems.count {
                let selectedItem = matchingItems[indexPath.row - recentItems.count]
                cell.nameTextView.text = selectedItem.attributedFullText.string
                cell.specificAddress = selectedItem.attributedFullText.string
            }
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? LocationResultsCell {
            guard let address = cell.specificAddress else { return }
            self.delegate?.zoomToSearchLocation(address: address)
            self.saveNewTerms(address: address)
            self.matchingItems = []
            self.recentItems = [:]
        } else if let cell = tableView.cellForRow(at: indexPath) as? LocationRecentsCell {
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


class LocationResultsCell: UITableViewCell {
    
    var fullAddress: String?
    var specificAddress: String?
    
    var fromSearchIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0.7
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    var nameTextView: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK.withAlphaComponent(0.5)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(fromSearchIcon)
        addSubview(nameTextView)
        
        fromSearchIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        fromSearchIcon.centerYAnchor.constraint(equalTo: nameTextView.centerYAnchor).isActive = true
        fromSearchIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        fromSearchIcon.widthAnchor.constraint(equalTo: fromSearchIcon.heightAnchor).isActive = true
        
        nameTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: fromSearchIcon.rightAnchor, constant: 24).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class LocationRecentsCell: UITableViewCell {
    
    var fullAddress: String?
    var specificAddress: String?
    
    var fromSearchIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0.7
        view.layer.cornerRadius = 5
        view.alpha = 0
        
        return view
    }()
    
    var pinImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "time")
        imageView.image = image
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.BLACK
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var titleTextView: UILabel = {
        let view = UILabel()
        view.text = "Home"
        view.font = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var nameTextView: UILabel = {
        let view = UILabel()
        view.text = "Set home"
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK.withAlphaComponent(0.5)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(fromSearchIcon)
        addSubview(pinImageView)
        addSubview(titleTextView)
        addSubview(nameTextView)
        
        fromSearchIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        fromSearchIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        fromSearchIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        fromSearchIcon.widthAnchor.constraint(equalTo: fromSearchIcon.heightAnchor).isActive = true
        
        pinImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        pinImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pinImageView.widthAnchor.constraint(equalTo: pinImageView.heightAnchor).isActive = true
        
        titleTextView.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleTextView.leftAnchor.constraint(equalTo: fromSearchIcon.rightAnchor, constant: 24).isActive = true
        titleTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        
        nameTextView.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: fromSearchIcon.rightAnchor, constant: 24).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
