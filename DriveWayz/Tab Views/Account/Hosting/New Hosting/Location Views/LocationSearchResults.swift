//
//  LocationSearchResults.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSearchResults: UITableViewController {

    var matchingItems:[GMSAutocompletePrediction] = []
    let cellId = "cellId"
    var delegate: handleChangingAddress?
    var placesClient: GMSPlacesClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Theme.BACKGROUND_GRAY

        self.placesClient = GMSPlacesClient()
        
        tableView.register(ResultsCell.self, forCellReuseIdentifier: "cellId")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTextChange(_:)),
                                               name: NSNotification.Name(rawValue: handleTextChangeNotification),
                                               object: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func handleTextChange(_ myNot: Notification) {
        if let use = myNot.userInfo {
            if let searchBarText = use["text"] as? String {
                
                let filter = GMSAutocompleteFilter()
                filter.type = .noFilter
                placesClient?.autocompleteQuery(searchBarText, bounds: nil, filter: filter, callback: { (results, error) in
                    if let error = error {
                        print("Autocomplete error \(error)")
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
    
}


extension LocationSearchResults {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchingItems.count > 4 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.alpha = 1
                })
            }
            return 4
        } else if matchingItems.count == 0 {
            UIView.animate(withDuration: animationOut, animations: {
                self.view.alpha = 0
            })
            return 0
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.alpha = 1
                })
            }
            return matchingItems.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResultsCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if matchingItems.count > indexPath.row {
            let selectedItem = matchingItems[indexPath.row]
            cell.matchingItem = selectedItem
            cell.nameTextView.text = selectedItem.attributedFullText.string
        }
        cell.nameTextView.textColor = Theme.BLACK
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ResultsCell
        if let matchingItem = cell.matchingItem {
            let placeID = matchingItem.placeID
            let street = matchingItem.attributedPrimaryText.string
            self.delegate?.handleStreetAddress(text: street)
            self.organizeAddress(placeID: placeID)
        }
        self.matchingItems = []
        self.delegate?.dismissKeyboard()
    }
    
    func organizeAddress(placeID: String) {
        placesClient!.lookUpPlaceID(placeID) { (place, error) in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                guard let components = place.addressComponents else { return }
                for component in components {
                    for type in component.types {
                        let address = component.name
                        if type == "locality" {
                            self.delegate?.handleCityAddress(text: address)
                        } else if type == "administrative_area_level_1" {
                            self.delegate?.handleStateAddress(text: address)
                        } else if type == "postal_code" {
                            self.delegate?.handleZipAddress(text: address)
                        } else if type == "country" {
                            self.delegate?.handleCountryAddress(text: address)
                        }
                    }
                }
            } else {
                print("No place details for \(placeID)")
            }
        }
    }
    
}


class ResultsCell: UITableViewCell {
    
    var fullAddress: String?
    var matchingItem: GMSAutocompletePrediction?
    
    var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "mapPinIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = Theme.BLACK
        imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return imageView
    }()
    
    var nameTextView: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.BACKGROUND_GRAY
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(pinImageView)
        addSubview(nameTextView)
        
        pinImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        pinImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pinImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        nameTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: pinImageView.rightAnchor, constant: 4).isActive = true
        nameTextView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        nameTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
